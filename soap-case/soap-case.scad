include<../solidpp/solidpp.scad>

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
case_teeth_h = 2;
// '-> teeth height
case_cr = 5;
// '-> corner diameter

// magnets parameters
magnet_d = 5;
// '-> magnet diameter
magnet_h = 1.7;
// '-> magnet height

$fn = $preview ? 30 : 60;


module tooth()
{

}


module magnets()
{
    _t = [0,0,0];

    mirrorpp([1,0,0], true)
        mirrorpp([0,1,0], true)
            translate(_t)
                cylinderpp(h=magnet_h+case_thigh_clearance, d=magnet_d+2*case_thigh_clearance);
}

module cover(soap_w=small_soap_w, soap_h=small_soap_h, soap_l=small_soap_l)
{
    _x = soap_l + 4*case_wt;
    _y = soap_w + 4*case_wt;
    _z = soap_h + case_bt - case_free_clearance;
    _size_o = [_x, _y, _z];
    _mod_list_o = [round_edges(r=case_cr)];
    _size_i = _size_o - 2*[case_bt+case_free_clearance, case_bt+case_free_clearance,0];
    _mod_list_i = [round_edges(r=case_cr-case_wt-case_free_clearance)];
    translate([0,0,case_bt+case_free_clearance])
        difference()
        {
            cubepp(_size_o, mod_list=_mod_list_o, align="z");
            translate([0,0,-case_bt+case_free_clearance])
                cubepp(_size_i, mod_list=_mod_list_i, align="z");       
        }
}

cover();

module bottom(soap_w=small_soap_w, soap_h=small_soap_h, soap_l=small_soap_l)
{
    
}