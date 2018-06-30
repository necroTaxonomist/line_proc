
ArrayList<Polygon> pgons = new ArrayList<Polygon>();
Polygon curGon = null;
float resDist = 20.0f;
float smallDist = .005f;

void setup()
{
    size(750,750);
    frameRate(30);
}

void draw()
{
    for (Polygon p : pgons)
    {
        p.draw();
    }
}

void mousePressed()
{
    curGon = new Polygon(false, new Coord(mouseX, mouseY));
    pgons.add(curGon);
}

void mouseDragged()
{
    if (curGon != null)
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
    if (curGon != null)
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
    }
    curGon = null;
}