

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
m3_nd=6.25+tol;
m3_nh=2.3;
m3_hd=5.5+tol;
m3_hh=2;

// screw
m3_shd = 7.0+tol;
m3_sd = 3.5;
m3_sl = 20;

m3_off = 5;

// plexiglass holder parameters
pg_t = 3;
pg_wt = 2;

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
    cylinder(d1=m3_shd,d2=m3_sd,h=_h/2);
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

// module creating sube with top/buttom sloped side
module ss_cube(size,sh)
{
    // main cube parameters
    A = size.x;
    B = size.y;
    C = size.z;
    
    // small cube creating slope parameter
    a = A - 2*abs(sh);
    b = B - 2*abs(sh);
    c = abs(sh);
    t = sh > 0 ? [sh,sh,C] : [-sh,-sh,sh];
    
    render(1)
    hull()
    {
        cube([A,B,C]);
        translate(t)
            cube([a,b,c]);
    }    
}

module ses_cube(size,sh)
{
    render(3)
    difference()
    {
        ss_cube(size, sh);
        a = size.x - 2*abs(sh);
        b = size.y - 2*abs(sh);

        c = abs(sh);
        t = sh > 0 ? [sh,sh,size.z+sh] : [-sh,-sh,2*sh];
        translate(t)
            ss_cube([a,b,c],-sh);
    }
    
}

// plexiglass holder
module pg_holder()
{
    difference()
    {
        render(1)
        hull()
        {
            // horizontal part
            cube([c_h,pg_t+2*pg_wt,pg_wt]);
            // vertical part
            cube([pg_wt,pg_t+2*pg_wt,c_h]);
        }
        translate([pg_wt,pg_wt,pg_wt])
            cube([c_h,pg_t,c_h]);
    }
    
}

// basic shape of the connector
module connector_base(off=0)
{
    // main geometry
    render(1)
    hull()
    {
        translate([-c_a/2-c_wt,-c_a/2-c_wt,0])
            rc_cube([c_a+c_wt,c_a+c_wt,c_h/2+c_wh],5);
        translate([-c_a/2,-c_a/2,off*5])
            cube([c_a-5,c_a-5,c_h/2+c_wh]);
    }
}

module bolt_holes()
{
    pos = [ [-c_a/2+m3_off,-c_a/2+m3_off,0],
            [-c_a/2+m3_off,+c_a/2-m3_off,0],
            [+c_a/2-m3_off,+c_a/2-m3_off],
            [+c_a/2-m3_off,-c_a/2+m3_off]];
    
    for(p=pos)
    {
        translate(p)
            bn_hole();
    }
}


module screw_holes(off=0)
{
    // '-> positions
    s_pos = [   [+c_a/2-c_wt-m3_shd,-c_a/2-c_wt-eps,off+m3_shd],
                [-c_a/2+m3_shd,-c_a/2-c_wt-eps,off-m3_shd+c_wh],
                [-c_a/2-c_wt-eps,-c_a/2+m3_shd,off+m3_shd],
                [-c_a/2-c_wt-eps,+c_a/2-c_wt-m3_shd,off-m3_shd+c_wh]];
    
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


module upper_upper_connector()
{
    difference()
    {
        // basic shape and the plexiglass hooks
        union()
        {
            // connector base
            connector_base(1);
            
            // plexiglass hooks
            translate([c_a/2-pg_wt,-c_a/2-pg_wt,c_h/2])
                difference()
                {
                    rotate([0,90,0])
                        pg_holder();
                    _a = c_h;
                    translate([-eps,-eps,-_a-eps])
                        cube([_a,_a,_a/2+eps]);
                }
                
            // plexiglass hooks
            translate([-c_a/2+2*pg_wt,c_a/2-pg_wt,c_h/2])
                difference()
                {
                    rotate([0,90,90])
                        pg_holder();
                    _a = c_h;
                    translate([eps-_a,-eps,-_a-eps])
                        cube([_a,_a,_a/2+eps]);
                }
        }
        
        // cut for the table leg
        translate([-c_a/2,-c_a/2,c_h/2])
            ses_cube([c_a+eps,c_a+eps,2*c_wh+eps],-3);
        
        
        // main hole cut
        translate([0,0,-c_h/2+eps])
            huge_screw_hole();
        
        
        // holes for the bolts and nuts
        bolt_holes();
        
        // holes for the screws
        screw_holes(c_h/2);
    }
    

}

module upper_lower_connector()
{
    difference()
    {
        // basic shape and the plexiglass hooks
        union()
        {
            
            // connector base
            connector_base(-1);
            
            // plexiglass hooks
            translate([c_a/2-pg_wt,-c_a/2-pg_wt,c_wh+c_h])
                difference()
                {
                    rotate([0,90,0])
                        pg_holder();
                    _a = c_h+2*eps;
                    translate([-eps,-eps,-_a+c_h/2+eps])
                        cube([_a,_a,_a/2+eps]);
                }
                
            // plexiglass hooks
            translate([-c_a/2+2*pg_wt,c_a/2-pg_wt,c_wh+c_h])
                difference()
                {
                    rotate([0,90,90])
                        pg_holder();
                    _a = c_h+2*eps;
                    translate([eps-_a,-eps,-_a+c_h/2+eps])
                        cube([_a,_a,_a/2+eps]);
                }
        }
        
        // cut for the table leg
        translate([-c_a/2,-c_a/2,-c_wh-eps])
            ses_cube([c_a+eps,c_a+eps,2*c_wh+eps],3);
        
        // main hole cut
        translate([0,0,c_wh-eps])
            huge_screw_hole();
        
        
        // holes for the bolts and nuts
        translate([0,0,c_wh+c_h/2])
            bolt_holes();
        
        // holes for the screws
        screw_holes();
    }
    
    
}

upper_lower_connector();

translate([100,0,0])
    upper_upper_connector();