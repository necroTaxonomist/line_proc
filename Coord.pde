class Coord
{
    float x;
    float y;
    
    public Coord()
    {
        this(0,0);
    }
    
    public Coord(Coord c)
    {
        this(c.x,c.y);
    }
    
    public Coord(float _x, float _y)
    {
        x = _x;
        y = _y;
    }
    
    public float dist(Coord other)
    {
        return (float)Math.hypot(other.x - x, other.y - y);
    }
    public float angleTo(Coord other)
    {
        return (float)Math.atan2(other.y - y, other.x - x);
    }
    
    public void rotate(float theta)
    {
        float prevX = x;
        float prevY = y;
        
        float cos = (float)Math.cos(theta);
        float sin = (float)Math.sin(theta);
        
        x = cos*prevX - sin*prevY;
        y = sin*prevX + cos*prevY;
    }
    
    public void tl(float dx, float dy)
    {
        x += dx;
        y += dy;
    }
    public void tl(Coord c)
    {
        tl(c.x, c.y);
    }
    
    public void scale(float xs, float ys)
    {
        x *= xs;
        y *= ys;
    }
    public void scale(float s)
    {
        scale(s,s);
    }
    public void scale(Coord c)
    {
        scale(c.x, c.y);
    }
}

Coord rotateCoord(Coord c, float theta)
{
    Coord nc = new Coord(c);
    nc.rotate(theta);
    return nc;
}

Coord tlCoord(Coord c, float dx, float dy)
{
    Coord nc = new Coord(c);
    nc.tl(dx, dy);
    return nc;
}

Coord scaleCoord(Coord c, float xs, float ys)
{
    Coord nc = new Coord(c);
    nc.scale(xs, ys);
    return nc;
}
Coord scaleCoord(Coord c, float s)
{
    return scaleCoord(c, s, s);
}