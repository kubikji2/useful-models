include<../../solidpp/solidpp.scad>


// fan paramters
fan_a = 120;
// '-> fan side
fan_h = 25;
// '-> fan thicknes
fan_t = 2;
// '-> fan frame thickness
fan_corner_r = 10;
// '-> fan corner radius
fan_bolt_d = 4.5;
// '-> fan bolt diameter 
fan_bolt_off = (fan_a - 101)/2 - fan_bolt_d/2;
// '-> fan bolt center offset

clearance = 0.2;

$fn = $preview ? 30 : 60;


module body()
{

    _test_t = 2;
    difference()
    {
        _size = [fan_a,fan_a,_test_t];

        // main body
        union()
        {
            mod_list = [round_edges(r=fan_corner_r)];
            cubepp(_size, mod_list=mod_list, align="z");

            mirrorpp([1,0,0], true)
                mirrorpp([0,1,0], true)
                    transform_to_spp(_size, align="z", pos="xyZ")
                        translate([fan_bolt_off,fan_bolt_off,0])
                            cylinderpp(d=fan_bolt_d-2*clearance,h=_test_t);
        }
        // hole for the fan
        cylinderpp(d=fan_a-2*fan_t, h=3*_test_t, align="");

        // hole for the mount points
        mirrorpp([1,0,0], true)
            mirrorpp([0,1,0], true)
                transform_to_spp(_size, align="z", pos="xyZ")
                    translate([fan_bolt_off,fan_bolt_off,0])
                        cylinderpp(d=3, h=5*_test_t, align="");
    }

}

body();