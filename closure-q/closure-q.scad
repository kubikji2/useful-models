

$fn = 90;
tol = 0.2;
eps = 0.01;

// connector properties
c_a = 51;
c_wt = 5;
c_wh = 25;
c_h = 22;

// M3
// bolt and nuts parameters
m3_l=13;
m3_d=3;
m3_nd=6.0;
m3_nh=2.3;
m3_hd=5.5;
m3_hh=2;

// screw
m3_shd = 7.0;
m3_sl = 20;

m3_off = 5;

// hole for the m3 nuts and bolt
module bn_hole()
{
    // nuts
    translate([0,0,-1.5*m3_l+eps])
        cylinder(d=m3_nd, h=m3_l, $fn=6);
    // bolt body
    translate([0,0,-0.5*m3_l])
        cylinder(d=m3_d, h=m3_l);
    // bolt head
    translate([0,0,0.5*m3_l-eps])
        cylinder(d=m3_hd, h=m3_l);
}

// hole for the 3mm screws
module s_hole()
{
    // head
    _h = m3_shd-m3_d;
    cylinder(d1=m3_shd,d2=m3_d,h=_h/2);
    // body
    cylinder(d=m3_d,h=m3_sl);
}

// hole for the huge screw
module huge_screw_hole()
{
    // body
    cylinder(d=7, h=c_h);
    // head
    cylinder(d=14,h=3);
}

// round corner cube module
module rc_cube(size,r)
{
    a = size.x;
    b = size.y;
    c = size.z;
    
    pos = [ [r,r,0],
            [r,b-r,0],
            [a-r,b-r,0],
            [a-r,r,0]];
    
    // corners
    for(p=pos)
    {
        translate(p)
            cylinder(r=r,h=c);
    }
    
    // inner fill
    translate([r,0,0])
        cube([a-2*r,b,c]);
    translate([0,r,0])
        cube([a,b-2*r,c]);
}


module connector_base()
{
    // main geometry
        translate([-c_a/2-c_wt,-c_a/2-c_wt,0])
            rc_cube([c_a+c_wt,c_a+c_wt,c_h/2+c_wh],5);
}


module upper_upper_connector()
{
    difference()
    {
        // connector base
        connector_base();
        
        // cut for the table leg
        translate([-c_a/2,-c_a/2,c_h/2])
            cube([c_a+eps,c_a+eps,c_wh+eps]);
        
        // main hole cut
        translate([0,0,-c_h/2+eps])
            huge_screw_hole();
        
        
        // holes for the bolts and nuts
        pos = [ [-c_a/2+m3_off,-c_a/2+m3_off,0],
                [-c_a/2+m3_off,+c_a/2-m3_off,0],
                [+c_a/2-m3_off,+c_a/2-m3_off],
                [+c_a/2-m3_off,-c_a/2+m3_off]];
        
        for(p=pos)
        {
            translate(p)
                bn_hole();
        }
        
        // holes for the screws
        // '-> positions
        s_pos = [   [+c_a/2-c_wt-m3_shd,-c_a/2-c_wt-eps,c_h/2+m3_shd],
                    [-c_a/2+m3_shd,-c_a/2-c_wt-eps,c_h/2-m3_shd+c_wh],
                    [-c_a/2-c_wt-eps,-c_a/2+m3_shd,c_h/2+m3_shd],
                    [-c_a/2-c_wt-eps,+c_a/2-c_wt-m3_shd,c_h/2-m3_shd+c_wh]];
        
        // '-> rotations
        s_rot = [   [-90,0,0],
                    [-90,0,0],
                    [0,90,0],
                    [0,90,0]];
        for(i=[0:3])
        {
            cp = s_pos[i];
            cr = s_rot[i];
            translate(cp)
                rotate(cr)
                    s_hole();
        }
        
        
    }
}

upper_upper_connector();