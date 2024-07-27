// we are using soliddp
include<../../solidpp/solidpp.scad>

// we are using deez nuts
include<../../deez-nuts/deez-nuts.scad>

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

// fan cables
fan_cable_w = 2.6;
// '-> cables width
fan_cable_t = 1.3;
// '-> cables thickness

// fan mesh-like cover
fan_cover_t = 1;
// '-> fan cover thickness
fan_cover_mnt_d = 8.5;
// '-> fan cover mountpoints diameter

clearance = 0.2;
// '-> used clearance

$fn = $preview ? 30 : 120;

front_wt = 2;
// '-> front wall thickness
mount_wt = 3;
// '-> mount wall thickness
other_wt = 2;
// '-> other wall thickness
middle_wt = 3;

// define mount screws
screw_d = 3;
// '-> screw diameter
screw_l = 20;
// '-> screw length (not that relevant)
screw_descriptor = str("M", screw_d, "x", screw_l);
// '-> screw descriptor
screw_standard = "LUXPZ";
// '-> screw standard

screw_mount_offset = 10;
// '-> screw mount plate offset, the screws are in the middle

// define connecting bolts
bolt_l = 30;
// '-> bolt length
bolt_d = 3;
// '-> bolt diameter
bolt_standard = "DIN84A";
// '-> bolt standart -- flat head
bolt_descriptor = str("M", bolt_d, "x", bolt_l);
// '-> bolt descriptor
nut_diameter = bolt_d;
// '-> nut diameter
nut_standard = "DIN562";
// '-> nut standart -- square to increase magnetic force

// magnet parameters
mag_d = 10;
// '-> magnet diameter
mag_t = 1;
// '-> magnet thickness

// filter params
filter_t = 7;
// '-> filter thickness
filter_wt = 2;
// '-> filter wall thickness
filter_frame_thickess = 3;
// '-> filter part bottom frame thickness


// main part params
body_a = fan_a + 2*filter_wt + 2*other_wt;
// '-> body square side length (x and z axis)
body_t = fan_h + filter_t + 2*other_wt + middle_wt + front_wt;
// '-> body thickness (y axis)


// fan bolt and nut hole
module fan_bolt_and_nut_hole()
{
    // bolt
    bolt_hole(  descriptor = bolt_descriptor,
                standard = bolt_standard,
                clearance = clearance);
    // visual bolt
    /*
    color("silver") 
        % bolt( descriptor = bolt_descriptor,
                standard = bolt_standard,
                visual=true);
    */
    // nut
    translate([0,0,clearance])    
    rotate([180,0,0])
    {
        nut_hole(   d = nut_diameter,
                    standard = nut_standard,
                    clearance = clearance,
                    h_clearance = 10,
                    align="t");
        /*
        // visual nut
        color("dimgray") 
        % nut(  d=nut_diameter,
                standard=nut_standard,
                align="t",
                visual=true);
        */
    }
}


// mounting interfece to the closure ceiling
module mounting_interface()
{
    difference()
    {
        // baseplate
        cubepp( [body_a + 2*screw_mount_offset, body_t, mount_wt],
                mod_list = [round_edges(d=7,axes="xy")],
                align="z");

        // screw holes
        mirrorpp([1,0,0], true)
            mirrorpp([0,1,0], true)
                translate([body_a/2+screw_mount_offset/2,body_t/2-screw_mount_offset/2, 1])
                    rotate([180,0,0])
                        screw_hole(descriptor = screw_descriptor, standard = screw_standard, align="m", hh_off=mount_wt);

    }
}


// main body module
module body_selector(is_fan_body=false)
{
    difference()
    {
        union()
        {
            cubepp([body_a,body_t,body_a], align="y");

            // top mounting interface
            translate([0,body_t/2,body_a/2]) 
                mounting_interface();
        }

        // add airflow hole
        cylinderpp(d=fan_a-2*fan_t, h=3*body_t, align="", zet="y");

        // add fan body hole
        translate([0, front_wt-clearance, 0])
            cubepp([fan_a+2*clearance, fan_h + 2*clearance, fan_a+2*clearance], align="y"); 

        // add fan fastener holes
        translate([0,front_wt-fan_cover_t,0])
            mirrorpp([1,0,0], true)
                mirrorpp([0,0,1], true)
                    translate([fan_a/2-fan_bolt_off, bolt_l, fan_a/2-fan_bolt_off])
                        rotate([90,0,0])
                            fan_bolt_and_nut_hole();
        
        // add hole for the fan cover
        translate([0,front_wt/2,0])
            mirrorpp([1,0,0], true)
            hull()
            {
                _d = fan_cover_mnt_d;
                mirrorpp([1,0,1], true)
                    translate([fan_a/2-fan_bolt_off, 0, fan_a/2-fan_bolt_off])
                        cylinderpp(d=_d, h=2*front_wt, zet="y", align="m");
            }

        // add hole for the filter
        translate([0,fan_h+front_wt+middle_wt,0])
            cubepp([fan_a+filter_wt+2*clearance, fan_h, fan_a+filter_wt+2*clearance], align="y"); 
        
        translate([0,fan_h+front_wt+middle_wt+other_wt+filter_t/2-clearance,0])
            cubepp([fan_a+2*filter_wt+2*clearance, fan_h, fan_a+2*filter_wt+2*clearance], align="y"); 

        // cable hole
        translate([fan_a/2, other_wt+fan_h/2, fan_a/2]) 
            cubepp( [3*(other_wt+filter_wt), fan_cable_w+2*clearance, fan_cable_t+2*clearance],
                    align="Z",
                    mod_list=[round_edges(d=fan_cable_t, axes="yz")]);        

        // add splitting cut
        //%translate([0,fan_h/2+other_wt,0])
        //    cubepp([2*fan_a, clearance, 2*fan_a], align="");
        
        if(is_fan_body)
        {
            translate([0,fan_h/2+other_wt-clearance/2,0])
                cubepp([2*fan_a, 2*(body_t+2*screw_mount_offset), 2*fan_a], align="y");
        }
        else
        {
            translate([0,fan_h/2+other_wt+clearance/2,0])
                cubepp([2*fan_a, 2*(body_t+2*screw_mount_offset), 2*fan_a], align="Y");
        }

        // filter piece visualization
        /*
        %color("skyblue")
            translate([0,fan_h+other_wt+middle_wt,0])
                render(10)
                    filter_holder();
        */
    }

}


// fan body part
module fan_body()
{
    body_selector(is_fan_body=true);
}


// filter body part
module filter_body()
{
    body_selector(is_fan_body=false);
}


// filter 
module filter_holder()
{
    difference()
    {
        
        // main shape
        union()
        {
            cubepp([fan_a + filter_wt, filter_t/2+other_wt, fan_a+filter_wt], align="y");

            translate([0,filter_t/2+filter_wt,0])
                cubepp([fan_a + 2*filter_wt, filter_t/2+other_wt, fan_a+2*filter_wt], align="y");

        }

        // air flow
        cylinderpp(d=fan_a-2*fan_t, h=3*(filter_t+2*other_wt), align="", zet="y");

        // filter hole
        translate([0,filter_wt,0])
            cubepp([fan_a, filter_t, fan_a], align="y");

        // magnet holes
        mirrorpp([1,0,0], true)
            mirrorpp([0,0,1], true)
                translate([fan_a/2-fan_bolt_off, -clearance, fan_a/2-fan_bolt_off]) 
                    cylinderpp(d=mag_d+2*clearance, h=mag_t+2*clearance, zet="y", align="y"); 

        //
        /*
        translate([0,filter_t+other_wt,0]) 
        difference()
        {
            cubepp([fan_a, 2*other_wt, fan_a], align="y");
            cylinderpp(d=fan_a-2*fan_t+6,h=2*other_wt, zet="y", align="");
        }
        */


        // holes for the filter support frame
        translate([0,filter_t+3*other_wt,0]) 
            rotate([90,0,0])
                linear_extrude(3*other_wt)
                {
                    // roounding edges
                    offset(filter_frame_thickess)
                        offset(-filter_frame_thickess)
                            difference()
                            { 
                                squarepp([fan_a-2*filter_frame_thickess, fan_a-2*filter_frame_thickess], align="");
                                circlepp(d=fan_a-2*fan_t+6);
                            }

                }
    }
    
}


// support enforcers
module filter_support_enforcers()
{
    intersection()
    {
        cylinderpp(d=fan_a+2*filter_frame_thickess,h=2*other_wt+filter_t, zet="y", align="y");
        union()
        for(i=[0:7])
        {
            rotate([0, 45/2*i,0]) 
                cubepp([2*fan_a, (2*other_wt+filter_t), 5], align="y");
        }

    }
}


/*
module test_body()
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
*/
//body();