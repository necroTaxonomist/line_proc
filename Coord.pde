class Coord
{
    float x;
    float y;
    
    public Coord()
    {
        this(0,0);
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
}