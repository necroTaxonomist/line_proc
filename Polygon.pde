class Polygon
{
    private ArrayList<Coord> vert;
    private boolean closed;
    
    public Polygon(boolean _closed, Coord ... _vert)
    {
        vert = new ArrayList<Coord>();
        closed = _closed;
        
        for (Coord v : _vert)
        {
            vert.add(v);
        }
    }
    
    public Polygon(Polygon p)
    {
        vert = new ArrayList<Coord>();
        closed = p.closed;
        
        for (Coord v : p.vert)
        {
            vert.add(new Coord(v));
        }
    }
    
    public Coord getVert(int index)
    {
        if (index < 0 || index >= vert.size())
            return null;
        else
            return vert.get(index);
    }
    
    public Coord getFront()
    {
        return getVert(0);
    }
    
    public Coord getBack()
    {
        return getVert(vert.size()-1);
    }
    
    public Coord pushBack(Coord v)
    {
        vert.add(v);
        return v;
    }
    
    public void pushBackAll(Coord ... verts)
    {
        for (Coord v : verts)
        {
            vert.add(v);
        }
    }
    
    public Coord popBack()
    {
        Coord v = getBack();
        if (v != null)
        {
            vert.remove(vert.size()-1);
        }
        return v;
    }
    
    public int size()
    {
        return vert.size();
    }
    
    public void draw()
    {
        if (vert.size() == 0)
            return;
        
        Coord first = null;
        Coord prev = null;
        for (Coord v : vert)
        {
            if (first == null)
                first = v;
            else if (prev != null)
                line(prev.x, prev.y, v.x, v.y);
            prev = v;
        }
        if (closed && first != null && prev != first)
        {
            line(prev.x, prev.y, first.x, first.y);
        }
    }
    
    public void close()
    {
        close(0);
    }
    public void close(float mergeDist)
    {
        Coord f = getFront();
        Coord b = getBack();
        
        if (mergeDist > 0 && f != null && f != b)
        {
            float endDist = f.dist(b);
            if (endDist <= mergeDist)
            {
                f.x = (f.x + b.x) / 2;
                f.y = (f.y + b.y) / 2;
                popBack();
            }
        }
        
        closed = true;
    }
    
    // Transformations
    public void rotate(float theta)
    {
        for (Coord v : vert)
        {
            v.rotate(theta);
        }
    }
    
    public void tl(Coord d)
    {
        for (Coord v : vert)
        {
            v.tl(d);
        }
    }
    
    public void scale(Coord s)
    {
        for (Coord v : vert)
        {
            v.scale(s);
        }
    }
    
    protected Polygon shownPolygon()
    {
        return this;
    }
    
    // Testable functions
    private class XTest implements Testable
    {
        private Polygon p;
        
        public XTest(Polygon _p)
        {
            p = _p;
        }
        
        public double f(double x)
        {
            int i = (int)x;
            return p.getVert(i).x;
        }
    }
    
    private class YTest implements Testable
    {
        private Polygon p;
        
        public YTest(Polygon _p)
        {
            p = _p;
        }
        
        public double f(double x)
        {
            int i = (int)x;
            return p.getVert(i).y;
        }
    }
    
    public Testable xFunc()
    {
        return new XTest(shownPolygon());
    }
    
    public Testable yFunc()
    {
        return new YTest(shownPolygon());
    }
    
    public float xOfY(float y, float thresh, boolean[] found, float bound, int boundSide)
    {
        float prevX = 0;
        float prevY = 0;
        boolean tested = false;
        
        for (Coord v : shownPolygon().vert)
        {
            float thisX = v.x;
            float thisY = v.y;
            
            // If this is within the allowed bounds
            if (boundSide == 0 || (boundSide > 0 && thisX > bound) || (boundSide < 0 && thisX < bound))
            {
                float foundX = 0;
                boolean isFound = false;
                
                if (Math.abs(thisY - y) < thresh)
                {
                    // If this vertex is close to the needed y
                    // use it
                    foundX = thisX;
                    isFound = true;
                }
                else if (tested && ((prevY < y && thisY > y) || (prevY > y && thisY < y)))
                {
                    // If between this vertex and the last one, the needed y was crossed
                    foundX = (thisX + prevX) / 2;
                    isFound = true;
                }
                
                if (isFound)
                {
                    if (found != null)
                        found[0] = true;
                    return foundX;
                }
            }
            
            prevX = thisX;
            prevY = thisY;
            tested = true;
        }
        
        if (found != null)
            found[0] = false;
        return 0;
    }
    public float xOfY(float y, float thresh, boolean[] found)
    {
        return xOfY(y, thresh, found, 0, 0);
    }
    
    public float yOfX(float x, float thresh, boolean[] found, float bound, int boundSide)
    {
        float prevX = 0;
        float prevY = 0;
        boolean tested = false;
        
        for (Coord v : shownPolygon().vert)
        {
            float thisX = v.x;
            float thisY = v.y;
            
            // If this is within the allowed bounds
            if (boundSide == 0 || (boundSide > 0 && thisY > bound) || (boundSide < 0 && thisY < bound))
            {
                float foundY = 0;
                boolean isFound = false;
                
                if (Math.abs(thisX - x) < thresh)
                {
                    // If this vertex is close to the needed x
                    // use it
                    foundY = thisY;
                    isFound = true;
                }
                else if (tested && ((prevX < x && thisX > x) || (prevX > x && thisX < x)))
                {
                    // If between this vertex and the last one, the needed y was crossed
                    foundY = (thisY + prevY) / 2;
                    isFound = true;
                }
                
                if (isFound)
                {
                    if (found != null)
                        found[0] = true;
                    return foundY;
                }
            }
            
            prevX = thisX;
            prevY = thisY;
            tested = true;
        }
        
        if (found != null)
            found[0] = false;
        return 0;
    }
    public float yOfX(float x, float thresh, boolean[] found)
    {
        return yOfX(x, thresh, found, 0, 0);
    }
}