

class AutoBezier extends Bezier
{
    Coord[] points;
    
    public AutoBezier(int _res, Polygon p)
    {
        super(_res);
        
        // Set the transformations
        Coord tl = scale(p.getFront(), -1);
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
        
        print("(" + rot + ")");
        print("(" + points[0].x + "," + points[0].y + ")");
        print("(" + points[3].x + "," + points[3].y + ")");
        
        // Find the side that the curve is one
        int side = 1;
        int mid = p.size() / 2;
        if (p.getVert(mid) != null && p.getVert(mid).y < 0)
            side = -1;
        
        // Find the furthest y value
        float h = 0;
        if (side == 1)
            h = (float)testMax(p.yFunc(), 0, p.size() - 1, 1);
        else
            h = (float)testMin(p.yFunc(), 0, p.size() - 1, 1);
        
        println("h=" + h);
    }
}