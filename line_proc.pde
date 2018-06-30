
ArrayList<Polygon> pgons = new ArrayList<Polygon>();

Polygon curGon = null;
float resDist = 20.0f;
float smallDist = .005f;

Bezier curBez = null;
int bezRes = 20;
int bezVerts = 0;
int bezOrder = 3;

void setup()
{
    size(750,750);
    frameRate(30);
}

void draw()
{
    background(255);
    for (Polygon p : pgons)
    {
        p.draw();
    }
}

void mousePressed()
{
    if (mouseButton == LEFT)
    {
        curGon = new Polygon(false, new Coord(mouseX, mouseY));
        pgons.add(curGon);
    }
    else if (mouseButton == RIGHT)
    {
        if (bezVerts == 0)
        {
            curBez = new Bezier(bezRes, new Coord(mouseX, mouseY));
            pgons.add(curBez);
        }
        else if (curBez != null)
        {
            curBez.pushBack(new Coord(mouseX, mouseY));
        }
        bezVerts = (bezVerts + 1) % (bezOrder + 1);
    }
}

void mouseDragged()
{
    if (mouseButton == LEFT && curGon != null)
    {
        Coord b = curGon.getBack();
        if (b != null)
        {
            Coord v = new Coord(mouseX, mouseY);
            if (b.dist(v) >= resDist)
            {
                curGon.pushBack(v);
            }
        }
    }
}

void mouseReleased()
{
    if (mouseButton == LEFT && curGon != null)
    {
        Coord b = curGon.getBack();
        if (b != null)
        {
            Coord v = new Coord(mouseX, mouseY);
            if (b.dist(v) >= smallDist)
            {
                curGon.pushBack(v);
            }
        }
        
        AutoBezier ab = new AutoBezier(5, curGon);
    }
    curGon = null;
}