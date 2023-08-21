include <../solidpp/solidpp.scad>

// clearance
clrn = 0.25;

// Photon parameters 'pht'
pht_bolt_d = 6;
// '-> bolt diameter
pht_bolt_off = 9;
// '-> bolt offset from the end
pht_hole_a = 23;
// '-> hole side
pht_hole_r = 3;
// '-> hole corner radius
pht_hole_max_d = 20;
// '-> max hole depth

// CW1 parameters 'cw'
cw_a = 28.2;
// '-> rail side
cw_bolt_d = 6;
// '-> bolt diameter
cw_rail_t = 10;
// '-> rail thickness

// user-defined parameters
wt = 3;
// '-> wall thickness
rail_h = 55 + pht_hole_a;
// '-> contact rail height
interaface_l = 40 + pht_bolt_off;
// '-> interface length

$fn = $preview ? 60 : 120;

module interface()
{
    _x = cw_a + 2*clrn;
    _y = cw_rail_t + 2*clrn;
    _z = rail_h + 2*clrn;
    _size = [_x,_y, _z];

    _SIZE = add_vecs(_size, [2*wt, wt, -2*clrn]);
    _align = "yz";
    _mod_list = [round_edges(r=wt)];

    // rail interface
    difference()
    {
        // main body
        cubepp(_SIZE, mod_list=_mod_list, align=_align);
        
        // rail hole
        translate([0,clrn,0])
            transform_to_spp(size=_SIZE, align=_align, pos="Y")
                cubepp(_size, align="Y");
        // bolt hole
        translate([0,-0.001,(rail_h-pht_hole_a)/2 + pht_hole_a])
            cylinderpp(d=cw_bolt_d+2*clrn, h=wt+2*clrn, zet="y", align="y");
    }
    
    _xl = pht_hole_a - 2*clrn;
    _yl = interaface_l;
    _zl = pht_hole_a - 2*clrn;
    _size_l = [_xl, _yl+pht_hole_r, _zl];
    _mod_list_l = [round_corners(r=pht_hole_r)];

    // photon interface
    translate([0,pht_hole_r,0])
    difference()
    {
        // main body
        cubepp(_size_l, mod_list=_mod_list_l, align="zY");

        // bolt hole
        transform_to_spp(size=_size_l, align="zY", pos="yZ")
            translate([0,pht_bolt_off,0.001])
                cylinderpp(d=pht_bolt_d+2*clrn, h=pht_bolt_d, align="Z");
    }

    // reinforcement
    _r = min(interaface_l-2*pht_bolt_off, (rail_h - pht_bolt_off-cw_bolt_d)/2 - pht_bolt_off);
    translate([0,0,pht_hole_a-2*clrn])
        difference()
        {   
            __size = [pht_hole_a-2*pht_hole_r, _r, _r];
            __align = "Yz"; 
            cubepp(__size, align=__align);
            transform_to_spp(size = __size, align = __align, pos = "yZ")
                cylinderpp(r=_r, h=_r, zet="x", align="");

        }

}

interface();