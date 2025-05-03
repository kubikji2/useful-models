include<../../deez-nuts/deez-nuts.scad>
include<../../solidpp/solidpp.scad>

ivar_clearance = 0.1;
ivar_leg_w = 43.5;
ivar_leg_d = 31.5;


bt = 3;
wt = 2;

h = 20;

difference()
{
    _x = ivar_leg_w + 2*wt;
    _y = ivar_leg_d + 2*wt;
    _z = h + bt;
    // base shape
    cubepp([_x,_y,_z], mod_list = [round_edges(bt)]);

    // cut 
    translate([wt-ivar_clearance,wt-ivar_clearance,bt])
        cubepp([ivar_leg_w + 2*ivar_clearance, ivar_leg_d + 2*ivar_clearance, _z]);

}