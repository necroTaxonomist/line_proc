
@FunctionalInterface
interface Testable
{
    public double f(double x);
}

// Finds the maximum value of a testable function
// over the range [lower, upper] with increments of inc
// If xPtr is not null, the x value corresponding
// to the max will be stored in it
double testMax(Testable t, double lower, double upper, double inc, double[] xPtr)
{
    double max = 0;
    boolean tested = false;
    
    for (double x = lower; x <= upper; x += inc)
    {
        double val = t.f(x);
        
        if (!tested || val > max)
        {
            max = val;
            tested = true;
            if (xPtr != null)
                xPtr[0] = x;
        }
    }
    
    return max;
}
double testMax(Testable t, double lower, double upper, double inc)
{
    return testMax(t, lower, upper, inc, null);
}

// Finds the minimum value of a testable function
// over the range [lower, upper] with increments of inc
// If xPtr is not null, the x value corresponding
// to the max will be stored in it
double testMin(Testable t, double lower, double upper, double inc, double[] xPtr)
{
    double min = 0;
    boolean tested = false;
    
    for (double x = lower; x <= upper; x += inc)
    {
        double val = t.f(x);
        
        if (!tested || val < min)
        {
            min = val;
            tested = true;
            if (xPtr != null)
                xPtr[0] = x;
        }
    }
    
    return min;
}
double testMin(Testable t, double lower, double upper, double inc)
{
    return testMin(t, lower, upper, inc, null);
}

// Returns true if this function appears to only increase over the given range
boolean testIncreasing(Testable t, double lower, double upper, double inc)
{
    double prev = 0;
    boolean tested = false;
    
    for (double x = lower; x <= upper; x += inc)
    {
        double val = t.f(x);
        
        if (tested && val < prev)
        {
            return false;
        }
        
        prev = val;
        tested = true;
    }
    
    return true;
}

// Returns true if this function appears to only decrease over the given range
boolean testDecreasing(Testable t, double lower, double upper, double inc)
{
    double prev = 0;
    boolean tested = false;
    
    for (double x = lower; x <= upper; x += inc)
    {
        double val = t.f(x);
        
        if (tested && val > prev)
        {
            return false;
        }
        
        prev = val;
        tested = true;
    }
    
    return true;
}

// Finds the x for a given function
// which produces findVal within the given range
// Only works for functions which only increase over this range
double testIncBinarySearch(Testable t, double findVal, double lower, double upper, int numSearches)
{
    double x = 0;
    
    for (int i = 0; i < numSearches; ++i)
    {
        // Middle of range
        double range = upper - lower;
        x = lower + (range / 2);
        
        // Get the value
        double val = t.f(x);
        
        if (val > findVal)
        {
            upper = x;
        }
        else if (val < findVal)
        {
            lower = x;
        }
        else
        {
            return x;
        }
    }
    
    return x;
}

// Finds the x for a given function
// which produces findVal within the given range
// Only works for functions which only decrease over this range
double testDecBinarySearch(Testable t, double findVal, double lower, double upper, int numSearches)
{
    double x = 0;
    
    for (int i = 0; i < numSearches; ++i)
    {
        // Middle of range
        double range = upper - lower;
        x = lower + (range / 2);
        
        // Get the value
        double val = t.f(x);
        
        if (val < findVal)
        {
            upper = x;
        }
        else if (val > findVal)
        {
            lower = x;
        }
        else
        {
            return x;
        }
    }
    
    return x;
}