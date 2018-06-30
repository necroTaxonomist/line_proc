
class Bezier extends Polygon
{
    int res;
    Polygon show;
    
    public Bezier(int _res, Coord ... _vert)
    {
        super(false, _vert);
        res = _res;
        recalc();
    }
    
    public void recalc()
    {
        show = new Polygon(false);
        
        int n = size() - 1;
        
        float[] x = new float[size()];
        float[] y = new float[size()];
        
        Coord v = getFront();
        for (int i = 0; v != null; v = getVert(++i))
        {
            x[i] = v.x;
            y[i] = v.y;
        }
        
        for (int i = 0; i <= res; ++i)
        {
            float t = (float)i / res;
            
            float vx = bezierFunc(t, n, x);
            float vy = bezierFunc(t, n, y);
            
            show.pushBack(new Coord(vx, vy));
        }
    }
    
    public Coord pushBack(Coord v)
    {
        super.pushBack(v);
        recalc();
        return v;
    }
    
    public Coord popBack()
    {
        Coord v = super.popBack();
        recalc();
        return v;
    }
    
    public void draw()
    {
        stroke(255,0,0);
        super.draw();
        
        stroke(0);
        if (show != null)
            show.draw();
    }
    
    public void close(float mergeDist)
    {
        mergeDist = 0;
        // Do nothing
    }
}

float bezierFunc(float t, int n, float[] x)
{
    float sum = 0;
    
    for (int i = 0; i <= n; ++i)
    {
        float a = comb(n, i);
        float b = x[i];
        float c = (float)Math.pow(t, i);
        float d = (float)Math.pow(1 - t, n - i);
        
        sum += a * b * c * d;
    }
    
    return sum;
}

// Cache factorial values
ArrayList<Integer> factorials = new ArrayList<Integer>();
int fact(int n)
{
    if (n < 0)
        return 0;
    else if (factorials.size() > n)
    {
        return factorials.get(n);
    }
    else
    {
        int val = 1;
        
        if (n > 0)
        {
            val = n * fact(n - 1);
        }
        
        factorials.add(val);
        return val;
    }
}

int comb(int n, int r)
{
    if (n < 0 || r < 0 || r > n)
        return 0;
    
    int num = fact(n);
    int denom = fact(r) * fact(n - r);
    
    return num / denom;
}