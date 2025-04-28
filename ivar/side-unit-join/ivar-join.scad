include<../../deez-nuts/deez-nuts.scad>
include<../../solidpp/solidpp.scad>


// parameters
ivar_clearance = 0.1;
ivar_leg_w = 43.5;
ivar_leg_d = 31.5;
ivar_leg_hole_diameter = 6.3;
ivar_leg_hole_depth = 28;
ivar_leg_hole_gauge_w = 19.1+ivar_leg_hole_diameter;
ivar_leg_hole_gauge_h = 25.6+ivar_leg_hole_diameter;

// define fasteners
// hole fillers
hole_filling_fastener_diameter = 3;
hole_filling_bolt_standard = "DIN84A";
hole_filling_bolt_l = 30;
hole_filling_bolt_descriptor = str("M", hole_filling_fastener_diameter, "x", hole_filling_bolt_l);
hole_filling_nut_standard = "DIN934";

// part fastener
part_joining_fastener_diameter = 3;
part_joining_bolt_standard = "DIN84A";
part_joining_bolt_l = 20;
part_joining_bolt_descriptor = str("M", part_joining_fastener_diameter, "x", part_joining_bolt_l);
part_joining_nut_standard = "DIN934";

// part dimensions
join_wt = 4;
join_w = ivar_leg_w + 2*(join_wt+ivar_clearance);
join_d = ivar_leg_d + join_wt;
join_h = ivar_leg_hole_gauge_h + ivar_leg_hole_diameter+2*join_wt;
join_bevel_r = join_wt;

// hole filling interface
hfi_bt = 3;
hfi_wt = 1;
hfi_clearance = 0.2;

// part joining interface
pji_bt = 4;
pji_wt = 1;
pji_rf = 4;
pji_bevel = 2;

module test()
{

    difference()
    {
        cubepp([ivar_leg_w+2*join_wt, join_h, join_wt], align="z");
    
        mirrorpp([1,0,0], true)
            mirrorpp([0,1,0], true)
                translate([ivar_leg_hole_gauge_w/2, ivar_leg_hole_gauge_h/2,0])
                    cylinderpp(h=3*join_wt, d=ivar_leg_hole_diameter, align="");
    }
    
    mirrorpp([0,1,0], true)
        translate([0, join_h/2, 0])
            cubepp([ivar_leg_w + 2*join_wt, join_wt, 3*join_wt], align="Yz");

}

//test();

module ivar_interface_holes(clearance=0.2)
{
    mirrorpp([1,0,0], true)
        mirrorpp([0,1,0], true)
            translate([ivar_leg_hole_gauge_w/2, ivar_leg_hole_gauge_h/2,0])
                cylinderpp(h=3*join_wt, d=ivar_leg_hole_diameter+2*clearance, align="");
}

module basic_shape()
{
    // main shape with cut corners
    render(10)
    difference()
    {
        cubepp([join_w, join_h, join_d], align="Z", mod_list=[bevel_edges(join_bevel_r, axes="xz")]);

        translate([0,0,-join_wt+ivar_clearance])
            cubepp([ivar_leg_w+2*ivar_clearance, join_h, ivar_leg_d+join_wt], align="Z");
    }
}

module hole_filling_interface()
{

    translate([0,0,join_wt-hfi_bt])
    difference()
    {
        union()
        {
        // bottom interface
        cylinderpp( d1=ivar_leg_hole_diameter+2*(hfi_bt+hfi_wt), 
                    d2=ivar_leg_hole_diameter+2*(hfi_wt),
                    h=hfi_bt+get_bolt_head_height(descriptor=hole_filling_bolt_descriptor, standard=hole_filling_bolt_standard),
                    align="z");
        
        // top brim
        /*
        translate([0,0,hfi_bt])
            cylinderpp(d=ivar_leg_hole_diameter+2*hfi_wt,
                        h=get_bolt_head_height(descriptor=hole_filling_bolt_descriptor, standard=hole_filling_bolt_standard));
        */
        }

        // hole for the bolt
        translate([0,0,hfi_bt])
            bolt_hole(  standard=hole_filling_bolt_standard,
                        descriptor=hole_filling_bolt_descriptor,
                        clearance=0.2,
                        align="m");
    }

}


module hole_filling_peg()
{
    difference()
    {
        // peg
        cylinderpp(d=ivar_leg_hole_diameter-2*ivar_clearance, h=hole_filling_bolt_l-hfi_bt-get_nut_height(d=hole_filling_fastener_diameter,standard=hole_filling_nut_standard));

        // bolt hole
        bolt_hole(  standard=hole_filling_bolt_standard,
                    descriptor=hole_filling_bolt_descriptor,
                    clearance=0.2);
        
        // nut hole -- abandoned as there is not enough space
        /*  
        nut_hole(   d=hole_filling_fastener_diameter,
                    standard=hole_filling_nut_standard);
        */
    }

}

//hole_filling_peg();

module part_joining_interface(has_nut=false)
{
    // main body
    difference()
    {
        hull()
        {
            // side
            cubepp([    join_wt,
                        get_bolt_head_diameter(
                            descriptor=hole_filling_bolt_descriptor, standard=hole_filling_bolt_standard)+2*pji_rf,
                        get_bolt_head_diameter(
                            descriptor=hole_filling_bolt_descriptor, standard=hole_filling_bolt_standard)+2*pji_wt+pji_bt,   
                        ],
                        align="Xz",
                        mod_list = [bevel_edges(pji_bevel, axes="yz")]);

            // normal
            translate([-join_wt, 0, 0])
                cubepp([    get_bolt_head_diameter(
                                descriptor=hole_filling_bolt_descriptor, standard=hole_filling_bolt_standard)+2*pji_wt+join_wt,
                            get_bolt_head_diameter(
                                descriptor=hole_filling_bolt_descriptor, standard=hole_filling_bolt_standard)+2*pji_rf,
                            pji_bt
                            ],
                            align="xz",
                            mod_list = [bevel_edges(pji_bevel, axes="xy")]);

        }

        // bolt/nut hole
        translate([pji_wt+get_bolt_head_diameter(
                            descriptor=hole_filling_bolt_descriptor, standard=hole_filling_bolt_standard)/2,0,0])
        {
            _align = has_nut ? "b" : "m";
            _off = has_nut ? 0 : pji_bt; 
            translate([0,0,_off])
                bolt_hole(  standard=part_joining_bolt_standard,
                            descriptor=part_joining_bolt_descriptor,
                            clearance=0.2,
                            align=_align,
                            hh_off=part_joining_bolt_l);
            if (has_nut)
            {
                translate([0,0,pji_bt])
                    rotate([180,0,0])
                        nut_hole(   d=part_joining_fastener_diameter,
                                    standard=part_joining_nut_standard,
                                    s_off=part_joining_bolt_l,
                                    clearance=0.1,
                                    align="t");
            }
        }

    }
}


module ivar_leg_join(is_back=false)
{

    // add interface for the ivar
    difference()
    {
        basic_shape();
        ivar_interface_holes();
    }

    // add hole filling interface
    mirrorpp([1,0,0], true)
        mirrorpp([0,1,0], true)
            translate([ivar_leg_hole_gauge_w/2, ivar_leg_hole_gauge_h/2,-join_wt])
                hole_filling_interface();


    // add joining interface\\

    _pji_y_off = get_bolt_head_diameter(
        descriptor=hole_filling_bolt_descriptor,
        standard=hole_filling_bolt_standard)/2+pji_rf;
    //_pji_z_off = (part_joining_bolt_l-get_nut_height(d=part_joining_fastener_diameter,standard=part_joining_nut_standard))/2;
    
    mirrorpp([1,0,0], true)
        translate([join_w/2,join_h/2-_pji_y_off,-join_d+join_bevel_r])
            part_joining_interface(is_back);

    mirrorpp([1,0,0], true)
        translate([join_w/2,-(join_h/2-_pji_y_off),-join_d+join_bevel_r])
            part_joining_interface(is_back);
}


ivar_leg_join();
