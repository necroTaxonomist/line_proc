

class AutoBezier extends Bezier
{
    private Coord[] points;
    
    public AutoBezier(int _res, Polygon p)
    {
        super(_res);
        
        // Set the transformations
        Coord tl = scaleCoord(p.getFront(), -1);
        float rot = -p.getFront().angleTo(p.getBack());
        
        // Create a local copy of the source polygon
        // and transform it
        p = new Polygon(p);
        p.tl(tl);
        p.rotate(rot);
        
        // Create four control points
        points = new Coord[4];
        
        // Endpoints (transformed)
        points[0] = new Coord(p.getFront());  // should be (0,0)
        points[3] = new Coord(p.getBack());
        
        // Find the side that the curve is one
        int side = 1;
        int mid = p.size() / 2;
        if (p.getVert(mid) != null && p.getVert(mid).y < 0)
            side = -1;
        p.scale(new Coord(1, side));
        
        // Find the furthest y value
        float h = 0;
        h = (float)testMax(p.yFunc(), 0, p.size() - 1, 1);
        
        // Initial midpoints (transformed)
        points[1] = tlCoord(points[0], 0, h);
        points[2] = tlCoord(points[3], 0, h);
        
        // Add points to bezier
        pushBackAll(points);
        
        // Find the proper height
        HeightTest ht = new HeightTest(this);
        testIncBinarySearch(ht, h, 0, 2 * h, 10);
        
        // Find the furthest right value
        float r = 0;
        r = (float)testMax(p.xFunc(), 0, p.size() - 1, 1);
        
        // Find the furthest left value
        float l = 0;
        l = (float)testMin(p.xFunc(), 0, p.size() - 1, 1);
        
        for (int i = 0; i < 2; ++i)
        {
            // Find the proper right side
            if (r > points[3].x)
            {
                // If past the end point, the proper right side is the max x
                WidthMaxTest wt = new WidthMaxTest(this, 2);
                testIncBinarySearch(wt, r, points[3].x, 2 * r, 20);
            }
            else
            {
                // Else, match the right side up with the point halfway to the height
                float targetY = h / 2;
                
                float midX = p.xOfY(h, 3, null);
                
                float targetX = p.xOfY(targetY, 3, null, midX, 1);
                
                WidthPointTest wpt = new WidthPointTest(this, 2, targetY, midX);
                testIncBinarySearch(wpt, targetX, l, points[3].x, 20);
            }
            
            // Find the proper left side
            if (l < 0)
            {
                // If past the end point, the proper left side is the min x
                WidthMaxTest wt = new WidthMaxTest(this, 1);
                testIncBinarySearch(wt, l, 4 * l, 0, 20);
            }
            else
            {
                // Else, match the left side up with the point halfway to the height
                float targetY = h / 2;
                
                float midX = p.xOfY(h, 3, null);
                
                float targetX = p.xOfY(targetY, 3, null, midX, -1);
                
                WidthPointTest wpt = new WidthPointTest(this, 1, targetY, midX);
                testIncBinarySearch(wpt, targetX, 0, r, 20);
            }
        }
        
        
        
        // Reset transformations
        scale(new Coord(1, side));
        rotate(-rot);
        tl(scaleCoord(tl, -1));
        recalc();
    }
    
    private class HeightTest implements Testable
    {
        AutoBezier ab;
        
        public HeightTest(AutoBezier _ab)
        {
            ab = _ab;
        }
        
        // Get the max y when using a given height
        public double f(double x)
        {
            // Set height to new value
            ab.points[1].y = (float)x;
            ab.points[2].y = (float)x;
            recalc();
            
            float h = 0;
            h = (float)testMax(ab.yFunc(), 0, ab.getRes(), 1);
            
            return h;
        }
    }
    
    private class WidthMaxTest implements Testable
    {
        AutoBezier ab;
        int index;
        int sign;
        
        public WidthMaxTest(AutoBezier _ab, int _index)
        {
            ab = _ab;
            index = _index;
            
            if (index <= 1)
                sign = -1;
            else
                sign = 1;
        }
        
        // Get the max x when using a given position
        // for a corner
        public double f(double x)
        {
            // Set height to new value
            ab.points[index].x = (float)x;
            recalc();
            
            float w = 0;
            if (sign == 1)
                w = (float)testMax(ab.xFunc(), 0, ab.getRes(), 1);
            else
                w = (float)testMin(ab.xFunc(), 0, ab.getRes(), 1);
            
            return w;
        }
    }
    
    private class WidthPointTest implements Testable
    {
        AutoBezier ab;
        int index;
        int sign;
        float y;
        float mid;
        
        public WidthPointTest(AutoBezier _ab, int _index, float _y, float _mid)
        {
            ab = _ab;
            index = _index;
            y = _y;
            mid = _mid;
            
            if (index <= 1)
                sign = -1;
            else
                sign = 1;
        }
        
        // Get the x at a particular y
        // on one side of mid
        // for the given position of the corner
        public double f(double x)
        {
            // Set height to new value
            ab.points[index].x = (float)x;
            recalc();
            
            float w = ab.xOfY(y, 3, null, mid, sign);
            
            return w;
        }
    }
}