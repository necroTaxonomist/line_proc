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
    
    public Coord popBack()
    {
        Coord v = getBack();
        if (v != null)
        {
            vert.remove(vert.size()-1);
        }
        return v;
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
}