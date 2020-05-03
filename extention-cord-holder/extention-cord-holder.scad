eps = 0.01;
$fn = 90;

// extention coord parameters
ec_x = 54;
ec_y = 265;
ec_z = 38;
// hole in xy plane for power cable connectors
ec_hxy = 42;
// hole in xz plane for power cable
ec_hxz = 34;

// general parameters
// wall thickness
wt = 5;

// furniture parameters
// stump width
f_w = 20;
// stump depth
f_h = 13;

//
sh_d = 3.5;
sh_D = 6.8;

module coord_holder()
{
    _x = ec_x + 2*wt;
    _y = 200 + wt;
    _z = ec_z + 2*wt;
    difference()
    {
        // main body
        cube([_x,_y,_z]);
        // extention coord basich shape cut
        translate([wt,wt,wt])
            cube([ec_x, ec_y, ec_z]);
        // hole for power cable connectors
        translate([wt+(ec_x-ec_hxy)/2,-eps,wt+ec_z-eps])
            cube([ec_hxy,ec_y,wt+2*eps]);
        // hole for main power cable
        translate([wt+(ec_x-ec_hxz)/2,-eps,wt+ec_z/2])
            cube([ec_hxz,wt+2*eps,ec_z]);
        translate([wt+ec_x/2,-eps,wt+ec_z/2])
            rotate([-90,0,0])
                cylinder(d=ec_hxz,h=wt+2*eps);
    }
    
    // furniture connector
    translate([-f_w,0,f_h])
    {
        difference()
        {
            hull()
            {
                cube([f_w,_y,wt]);
                translate([f_w,0,0])
                    cube([wt,_y,f_w]);
            }
            positions = [   [f_w/2,f_w/2,0],
                            [f_w/2,_y/2,0],
                            [f_w/2,_y-f_w/2,0]];
            
            for(i=[0:len(positions)-1])
            {
                translate(positions[i])
                {
                    translate([0,0,-eps])
                        cylinder(d=sh_d,h=wt+2*eps);
                    translate([0,0,wt-eps])
                        cylinder(   d1=sh_d,d2=sh_D,
                                    h=sh_D-sh_d+2*eps);
                    translate([0,0,wt+sh_D-sh_d])
                        cylinder(d=sh_D,h=f_w);
                }
            }

            
        }
    }
}

coord_holder();
