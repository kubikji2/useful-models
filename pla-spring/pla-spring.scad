eps = 0.01;
$fn = 45;
tol = 0.2;

// filament diameter
f_d = 1.75+tol;

// spring parameters
// inner space diameter
d = 10;
// height
h = 40;
// number of rotations around
r = 10;

module spring()
{
    n_samples = 10*h;
    dh = h/n_samples;
    da = (360*r)/n_samples;
    for(i=[0:n_samples])
    {
        _h = i*dh;
        _a = i*da;
        __h = _h+dh;
        __a = _a+da;
        _d = d + f_d/2;
        hull()
        {
            translate([0,0,_h])
                rotate([0,0,_a])
                    translate([_d/2,0,0])
                        sphere(d=f_d);
            translate([0,0,__h])
                rotate([0,0,__a])
                    translate([_d/2,0,0])
                        sphere(d=f_d);
        }
    }   
}

module spring_mold()
{
    difference()
    {
        cylinder(d=d+f_d,h=h);
        spring();
    }
}

spring_mold();