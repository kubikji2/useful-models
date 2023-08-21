include <../solidpp/solidpp.scad>

// clearance
clrn = 0.2;

// Photon parameters 'pht'
pht_bolt_d = 6;
// '-> bolt diameter
pht_bolt_off = 9;
// '-> bolt offset from the end
pht_hole_ai = 23;
// '-> hole inner side
pht_hole_ao = 25;
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
rail_h = 55 + pht_hole_ao;
// '-> contact rail height
interaface_l = 40 + pht_hole_max_d;
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
        translate([0,-0.001,(rail_h-pht_hole_ao)/2 + pht_hole_ao])
            cylinderpp(d=cw_bolt_d+2*clrn, h=wt+2*clrn, zet="y", align="y");
    }

    _xl = pht_hole_ao - 2*clrn;
    _yl = interaface_l-pht_hole_max_d;
    _zl = pht_hole_ao - 2*clrn;
    _size_l = [_xl, _yl, _zl];
    _mod_list_l = [round_edges(r=pht_hole_r, axes="xz")];

    _xi = pht_hole_ai - 2*clrn;
    _yi = pht_hole_max_d;
    _zi = pht_hole_ai - 2*clrn;
    _size_i = [_xi, _yi, _zi];
    _mod_list_i = [round_corners(r=pht_hole_r)];

    // photon interface
    translate([0,pht_hole_r,0])
    difference()
    {
        // main body
        hull()
        {
            translate([0,-interaface_l,(pht_hole_ao-pht_hole_ai)/2])
            {
                cubepp(_size_i, mod_list=_mod_list_i, align="yz");
                //cubepp([10,9,25], align="yz");
            }
            
            cubepp(_size_l, mod_list=_mod_list_l, align="Yz");
        }
        
        // bolt hole
        transform_to_spp(size=[_xl,interaface_l,_zl], align="zY", pos="yZ")
            translate([0,pht_bolt_off,0.001])
                cylinderpp(d=pht_bolt_d+2*clrn, h=pht_bolt_d, align="Z");
    }

    // reinforcement
    _r = min(interaface_l-2*pht_bolt_off, (rail_h - pht_bolt_off-cw_bolt_d)/2 - pht_bolt_off);
    translate([0,0,pht_hole_ao-2*clrn])
        difference()
        {   
            __size = [pht_hole_ao-2*pht_hole_r, _r, _r];
            __align = "Yz"; 
            cubepp(__size, align=__align);
            transform_to_spp(size = __size, align = __align, pos = "yZ")
                cylinderpp(r=_r, h=_r, zet="x", align="");

        }

}

interface();