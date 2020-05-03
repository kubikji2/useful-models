eps = 0.01;
$fn = 90;

// general parameters
wt = 5;

// bolt hole parameters
bh_x = 50;
bh_y = 65;
bh_d = 3.5;
bh_D = 15;

// bolt parameters
b_h = 2.4+0.25;
b_d = 5.8;

// PSU parameters
psu_x = 100;
psu_y = bh_y+bh_D/2+wt;
psu_z = 49;

// screw hole parameters
sh_d = 3.5;
sh_D = 6.8;

module bolt_holder()
{
    _D = bh_D+2*wt;
    difference()
    {
        union()
        {
            cylinder(d=bh_D,h=wt);
            translate([0,0,wt])
                cylinder(d=_D,h=2*wt); 
        }
        
        // bolt hole
        translate([0,0,-eps])cylinder(d=b_d,h=b_h+eps);
        
        // grapping part
        translate([-_D/2-eps,wt/2,2*wt])
            cube([_D+2*eps,_D,wt+eps]);
        translate([-_D/2-eps,-_D-wt/2,2*wt])
            cube([_D+2*eps,_D,wt+eps]);
    }
}

//bolt_holder();


module psu_holder()
{
    _x = 2*wt+psu_x;
    _y = wt+psu_y;
    _z = wt+psu_z;
    _d = sh_d+2*wt;
    difference()
    {
        union()
        {
            // main block
            cube([_x,_y,_z]);
                       
            // screw hole plate
            hull()
            {
                translate([-_d/2,_d/2,psu_z])
                    cylinder(d=_d,h=wt);
                translate([-_d/2,_y-_d/2,psu_z])
                    cylinder(d=_d,h=wt);
                translate([-_d/2,0,psu_z])
                    cube([_d/2,_y,wt]);
            }
        }
        
        // cut for the PSU
        translate([wt,wt,-eps])
            cube([psu_x,psu_y+eps,psu_z+eps]);
        
        // cut for bolt holder
        translate([bh_x+wt,bh_y+wt,psu_z-eps])
            cylinder(h=wt+2*eps,d=bh_D+0.5);
        
        // screw holes
        // closer hole
        positions = [   [-_d/2,_d/2,psu_z-eps],
                        [-_d/2,_y-_d/2,psu_z-eps]];
        for(i=[0:len(positions)-1])
        {
            translate(positions[i])
            {
                cylinder(d=sh_d,h=wt);
                _o = sh_D/2-sh_d/2;
                translate([0,0,wt-_o+eps])
                    cylinder(d1=sh_d,d2=sh_D,h=_o+2*eps);
            }
        }
    }
}

psu_holder();