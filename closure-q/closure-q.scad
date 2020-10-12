

$fn = 90;
tol = 0.2;
eps = 0.01;

// connector properties
c_a = 51;
c_wt = 5;
c_wh = 25;
c_h = 22;

module rc_cube(size,r)
{
    a = size.x;
    b = size.y;
    c = size.z;
    
    pos = [ [r,r,0],
            [r,b-r,0],
            [a-r,b-r,0],
            [a-r,r,0]];
    
    // corners
    for(p=pos)
    {
        translate(p)
            cylinder(r=r,h=c);
    }
    
    // inner fill
    translate([r,0,0])
        cube([a-2*r,b,c]);
    translate([0,r,0])
        cube([a,b-2*r,c]);
    

}

module connector_base()
{
    difference()
    {
        rc_cube([c_a+2*c_wt,c_a+2*c_wt,c_h/2+c_wh],2);
    }
}

connector_base();