class Polygon
{
    private ArrayList<Coord> vert;
    private boolean closed;
    
    public Polygon(boolean _closed, Coord ... _vert)
    {
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
    
    public Coord getFirst()
    {
        return getVert(0);
    }
    
    public Coord getLast()
    {
        return getVert(vert.size()-1);
    }
    
    public void draw()
    {
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
        Coord f = getFirst();
        Coord l = getLast();
        
        if (mergeDist > 0 && f != null && f != l)
        {
            float endDist = f.dist(l);
        }
        
        closed = true;
    }
}