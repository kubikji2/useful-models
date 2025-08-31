include<../../deez-nuts/deez-nuts.scad>
include<../../solidpp/solidpp.scad>

$fn=$preview?36:144;

PSU_INT_L = 24;
PSU_INT_W = 3.8;
PSU_INT_SPACING = 3.2;
PSU_INT_GAUGE = PSU_INT_W + PSU_INT_SPACING;
PSU_SIDE_OFF = 7;
PSU_END_OFF = 9.5-PSU_INT_SPACING/2;


module psu_interface_element(   length,
                                width,
                                height,
                                bevel)
{
    hull()
    {
        translate([+length/2-width/2,0,0])
        cylinderpp(d=width, h=height, mod_list=[bevel_bases(bevel_top=bevel)]);
        
        translate([-length/2+width/2,0,0])
            cylinderpp(d=width, h=height, mod_list=[bevel_bases(bevel_top=bevel)]);
    }
}

module psu_interface(   number_of_interfaces,
                        height,
                        clearance)
{

    w = PSU_INT_W - 2*clearance;
    l = PSU_INT_L - 2*clearance;
    h = 3*height/2;
    for (i=[0:number_of_interfaces-1])
    {
        translate([0,(0.5+i)*PSU_INT_GAUGE+clearance,0])
        {
            // left
            translate([PSU_SIDE_OFF+clearance+l/2, 0, 0])
                psu_interface_element(  length=l,
                                        width=w,
                                        height=height,
                                        bevel=height/2);
            
            //translate([PSU_SIDE_OFF+clearance, 0, 0])
            //%cubepp( [l, w, height],
            //        mod_list=[round_edges(d=w)],
            //        align="xz");
        
            // middle
            translate([PSU_WIDTH/2, 0, 0])
                psu_interface_element(  length=l,
                                        width=w,
                                        height=height,
                                        bevel=height/2);
            //%translate([PSU_WIDTH/2, 0, 0])
            //    cubepp( [l, w, h],
            //            mod_list=[round_edges(d=w)],
            //            align="z");

            // right
            translate([PSU_WIDTH-PSU_SIDE_OFF-clearance-l/2, 0, 0])
                psu_interface_element(  length=l,
                                        width=w,
                                        height=height,
                                        bevel=height/2);
            //%translate([PSU_WIDTH-PSU_SIDE_OFF-clearance, 0, 0])
            //    cubepp( [l, w, h],
            //            mod_list=[round_edges(d=w)],
            //            align="Xz");
        }
    }
}

PSU_WIDTH = 100;
PSU_HEIGHT = 50;

module psu_holder(  number_of_interfaces,
                    is_end,
                    wall_thickness,
                    mounting_wall_thickness,
                    interface_height,
                    screw_offset,
                    screw_standard,
                    screw_diameter,
                    screw_length,
                    clearance=0.15)
{

    l = PSU_INT_GAUGE*number_of_interfaces + (is_end ? wall_thickness+PSU_END_OFF : 0);
    hole_l = PSU_INT_GAUGE*number_of_interfaces + (is_end ? PSU_END_OFF+clearance : 0);
    h = 2*wall_thickness + interface_height + PSU_HEIGHT;
    w = 2*wall_thickness + PSU_WIDTH;
    difference()
    {   
        // main geometry
        cubepp([w,l,h], align="yz");

        // add hole
        translate([0,0.01,wall_thickness-clearance])
            cubepp([PSU_WIDTH+2*clearance,
                    2*hole_l,
                    PSU_HEIGHT+interface_height+2*clearance],
                    align="z");
        
        if (is_end)
        {
            translate([0,0.01,2*wall_thickness-clearance])
            cubepp([PSU_WIDTH+2*clearance-2*wall_thickness,
                    3*hole_l,
                    PSU_HEIGHT+interface_height+2*clearance-2*wall_thickness-interface_height],
                    align="z");
        }

    }

    // interface
    translate([-PSU_WIDTH/2,0,wall_thickness-clearance])
    psu_interface(  number_of_interfaces=number_of_interfaces,
                    height=interface_height,
                    clearance=clearance);

    // fastener places
    screw_descriptor = str("M", screw_diameter, "x",  screw_length);
    fw = get_screw_head_diameter(descriptor=screw_descriptor,
                                standard=screw_standard);
    rr = fw/2 + screw_offset;
    mirrorpp([1,0,0], true)
    translate([w/2,0,h-mounting_wall_thickness])
    difference()
    {
        translate([-rr,0,0])
        // main shape
        cubepp([screw_offset+fw/2+2*rr, l, mounting_wall_thickness],
                mod_list=[round_edges(r=rr)]);

        // cut left rounding
        cubepp([2*rr, 3*l, 3*mounting_wall_thickness], align="X");
        
        // hole for the screws
        translate([screw_offset+fw/2,screw_offset+fw/2,0])
            rotate([0,180,0])
                screw_hole(descriptor=screw_descriptor,
                            standard=screw_standard,
                            align="t");
        
        translate([screw_offset+fw/2,l-(screw_offset+fw/2),0])
            rotate([0,180,0])
                screw_hole(descriptor=screw_descriptor,
                            standard=screw_standard,
                            align="t");
    }

    
}

psu_holder( number_of_interfaces = 3,
            is_end = true,
            wall_thickness = 3,
            mounting_wall_thickness = 4,
            interface_height = 2,
            screw_offset = 3,
            screw_standard = "LUXPZ",
            screw_diameter = 3,
            screw_length = 20);

