include<../solidpp/solidpp.scad>

// soap size customizer
soap_size = "big"; // ["small", "big"]

// soap dimensions, including sufficient margins
small_soap_w = 35;
// '-> soap width
small_soap_h = 10; 
// '-> soap height
small_soap_l = 55;
// '-> soap length


// bigger soap
big_soap_w = 55;
// '-> soap width
big_soap_h = 32; 
// '-> soap height
big_soap_l = 92;
// '-> soap length

// case paramters -> 'case_'
case_wt = 2;
// '-> wall thickness
case_bt = 2;
// '-> bottom thickness
case_free_clearance = 0.2;
// '-> clearance for 3D printed parts freely moving
case_thigh_clearance = 0.1;
// '-> clearamce for 3D printed parts tightly fitted
case_teeth_h = 4;
// '-> teeth height
case_teeth_w = 3;
// '-> teeth_with
case_cr = 5;
// '-> corner diameter

// magnets parameters
magnet_d = 4;
// '-> magnet diameter
magnet_h = 0.8;
// '-> magnet height
magnet_off = 1;
// '-> magnet offset

// fn
$fn = $preview ? 30 : 60;
// eps
eps = 0.01;

// argument processing
soap_l = soap_size == "big" ? big_soap_l : small_soap_l;
soap_w = soap_size == "big" ? big_soap_w : small_soap_w;
soap_h = soap_size == "big" ? big_soap_h : small_soap_h;


// modules

// single tooth
module tooth(teeth_w, teeth_l)
{
    points = [  [0,0],
                [teeth_w, 0],
                [teeth_w, teeth_w],
                [0, teeth_w + case_teeth_h]];
    translate([0, teeth_l/2, 0])
        rotate([90, 0, 0])
            linear_extrude(teeth_l)
                polygon(points);
}


// teeth for the water to run away
module teeth(soap_w=soap_w, soap_h=soap_h, soap_l=soap_l)
{
    // computing number of teeth
    _n = floor(soap_l/(2*case_teeth_w));
    // computing the hole increment
    _comp = (soap_l - _n*(2*case_teeth_w))/_n;

    // multiplying tooth
    translate([-soap_l/2,0,0])
    for(i=[0:_n-1])
    {
        _t = [i*(2*case_teeth_w+_comp),0,0];
        translate(_t)
            tooth(teeth_w=case_teeth_w, teeth_l=soap_w);
    }
}


// holes for the magnets
module magnet_holes(soap_w=soap_w, soap_h=soap_h, soap_l=soap_l)
{
    _t = [soap_l/2 + case_wt, soap_w/2 - magnet_d/2 - magnet_off - case_wt, magnet_off];

    mirrorpp([1,0,0], true)
        mirrorpp([0,1,0], true)
            translate(_t)
                cylinderpp(h=2*(magnet_h+2*case_thigh_clearance+case_free_clearance), d=magnet_d+2*case_thigh_clearance, zet="x");
}


// case cover
module cover(soap_w=soap_w, soap_h=soap_h, soap_l=soap_l)
{
    _x = soap_l + 4*case_wt;
    _y = soap_w + 4*case_wt;
    _z = soap_h + case_teeth_h + case_bt - case_free_clearance;
    _size_o = [_x, _y, _z];
    _mod_list_o = [round_edges(r=case_cr)];
    _size_i = _size_o - 2*[case_bt-case_free_clearance, case_bt-case_free_clearance,0];
    _mod_list_i = [round_edges(r=case_cr-case_wt-case_free_clearance)];
    translate([0,0,case_bt+case_free_clearance])
        difference()
        {
            
            // outer shell
            cubepp(_size_o, mod_list=_mod_list_o, align="z");
            
            // inner hole
            translate([0,0,-case_bt+case_free_clearance])
                cubepp(_size_i, mod_list=_mod_list_i, align="z");

            // magnet holes
            translate([0,0, magnet_off-case_free_clearance])
                magnet_holes(soap_w, soap_h, soap_l);
            
            // hole for the fingers
            translate([0,0,case_teeth_h])
                cylinderpp(d=_x/2, h=_y+2*eps, zet="y", align="Z");
        }
}

cover();


// case bottom
module bottom(soap_w=soap_w, soap_h=soap_h, soap_l=soap_l)
{
    _x = soap_l + 4*case_wt;
    _y = soap_w + 4*case_wt;
    _z = soap_h/2 + case_teeth_h;
    // inner part size and mods
    _size = [_x - 2*case_wt - 2*case_free_clearance, _y - 2*case_wt - 2*case_free_clearance, _z];
    _mod_list = [round_edges(r=case_cr-case_wt-2*case_free_clearance)];

    // bottom part size and mods
    _z_b = case_bt-case_free_clearance;
    _size_b = [_x, _y, _z_b];
    _mod_list_b = [round_edges(r=case_cr)];

    // soap size
    _size_soap = [soap_l, soap_w, soap_h+case_teeth_h+case_bt];
    _mod_list_soap = case_cr-2*case_wt > 0 ? [round_edges(r=case_cr-2*case_wt)] : [];


    difference()
    {
        union()
        {
            // baseplate
            cubepp(_size_b, mod_list=_mod_list_b, align="z");
            // inner module
            translate([0,0,_z_b])
                cubepp(_size, mod_list=_mod_list, align="z");
        }

        // magnet holes
        translate([0,0, case_bt+magnet_off])
            magnet_holes(soap_w, soap_h, soap_l);

        // inner hole
        translate([0,0,-eps])
            cubepp(_size_soap, mod_list=_mod_list_soap, align="z");
    }

    // adding teeth
    teeth();

}

bottom();
