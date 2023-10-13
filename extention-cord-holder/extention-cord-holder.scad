
include<../solidpp/solidpp.scad>

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
_y = 205 + wt;
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


// hook parameters
shaft_d = 35;
// '-> shaft diameter
h_wt = 2;
// '-> wall thickness
h_h = 30;
// '-> height
h_g = 150;
// '-> guage
h_off = 7 + wt;

// hook to the shaft
module shaft_hook(is_up = true)
{
    _D = shaft_d + 2*h_wt;
    _h = h_h;
    _d = shaft_d;
    _a = is_up ? "Z" : "z";

    difference()
    {
        hull()
        {
            // outer shell
            cylinderpp(d=_D, h=_h, align=_a);
                
            // connection to the adapter holder
            translate([h_off,0,0])
                transform_to_spp([_d,_d,_h], align=_a,pos="X")
                    cubepp([h_wt, 3*_d/4, _h], align="X");

            children();

        }

            
     
        translate([0,0,(is_up ? 1 : -1)*h_h/2])
        {
            // shaft hole
            //translate([h_off,0,0])
                cylinderpp(d=_d, h=2*_h, align=_a);

            // assembly shaft hole
            _hole_d = 3*_d/4; //shaft_d-2*length;
            cubepp([_hole_d, _d , 2*_h], align=str(_a,"Y"));
        }
    }

}

// final module
module coord_holder(double=false, has_hooks=false)
{
    // interface for connecting to the furniture
    if (!has_hooks)
    {
        furniture_interface();
    }
    else
    {
        // bottom hook
        shaft_hook(false)
            if(double)
                rotate([0,0,180])
                    shaft_hook(false);
        
        // top hook
        translate([0,0,h_g+h_h])
            shaft_hook(false)
                if(double)
                    rotate([0,0,180])
                        shaft_hook(false);

    }

    _t1 = has_hooks ? [-_x/2,0,0] : [0,0,0];
    _r = has_hooks ? [90,0,90] : [0,0,0];
    _t2 = has_hooks ? [shaft_d/2 + h_off - wt, 0, 0] : [0,0,0];

    // single sleeve
    translate(_t2)
        rotate(_r)
            translate(_t1)
                coord_sleeve();
    
    // if double, add second sleeve
    if(double)
    {
        _t1_off = _t1 + (has_hooks ? [_x,0,0] : [_z-wt,0,0]);
        _r_off = has_hooks ? [90,0,-90] : [0,0,0];
        _t2_off = has_hooks ? [-shaft_d/2 - h_off + wt, _x, 0] : [0,0,0];
        translate(_t2_off)
            rotate(_r_off)
                translate(_t1_off)
                    coord_sleeve(); 
    }
}

coord_holder(true, true);