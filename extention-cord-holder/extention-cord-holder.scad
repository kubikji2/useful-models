eps = 0.01;
$fn = 90;

// extention coord parameters
ec_x = 54;
// '-> witdh
ec_y = 265;
// '-> length
ec_z = 38;
// '-> height

// hole in xy plane for power cable connectors
ec_hxy = 42;
// hole in xz plane for power cable
ec_hxz = 30;

// general parameters
// wall thickness
wt = 5;

// furniture parameters
// stump width
f_w = 20;
// stump depth
f_h = 13;

// screw hole parameters
sh_d = 3.5;
sh_D = 6.8;

// general dimensions
_x = ec_x + 2*wt;
_y = 200 + wt;
_z = ec_z + 2*wt;

// furniture interface
module furniture_interface()
{
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


// sleeve for coord
module coord_sleeve()
{

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
    
}

// final module
module coord_holder(double=false)
{
    // interface for connecting to the furniture
    furniture_interface();
    
    // single sleeve
    coord_sleeve();
    
    // if double, add second sleeve
    if(double)
    {
        _t = [_x-wt,0,0];
        translate(_t)
            coord_sleeve(); 
    }
}

coord_holder(true);