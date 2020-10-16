$fn = 90;
tol = 0.2;
z_tol = 0.5;
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

// foot interface parameters
// total height of the foot interface part
ft_h = 22;
// thickness of the part screwed to the lower table
ft_t = 2;
// diameter of the inner cone base
ft_Di = 35;
// diameter of the outer cone base
ft_Do = ft_Di + 1;
// diameter of the top inner cone area
ft_di = 20;
// diameter of the top outer cone area
ft_do = ft_di + 1;
// height of the inner cone
ft_chi = 14.5;
// height of the outer cone
ft_cho = ft_chi + 0.5;

// huge hole depths
// absolute base, e.g. piece screwed to the table dest bellow
hhd_b = 5;
// middle piece on the foot of the table leg
hhd_m = 4;
// top part connected to the top desk
hhd_t = 3;

// hinge parameters
// bottom hinge inner height
hh_ib = 16;
// bottom hinge outer height
hh_ob = hh_ib + z_tol;
// top hinge inner height
hh_it = 18;
// top hinge outer height
hh_ot = hh_it + z_tol;

// hinga diameters
h_id = 9;
h_od = h_id + 0.5;
h_iD = h_id + 6;
h_oD = h_od + 6;


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
    cylinder(d=m3_sd,h=m3_sl);
}


// hole for the huge screw
module huge_screw_hole(hh)
{
    // body
    cylinder(d=7, h=c_h);
    // head
    cylinder(d=14,h=hh);
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


// main hinge 
module outer_hinge(h,right=0)
{
    // main hinge axle
    difference()
    {
        rotate([0,0,right*90])
        union()
        {
            cylinder(d=h_oD,h=h);
            //translate([])
            cube([h_oD/2,h_oD/2,h]);
            translate([-h_oD/2,-h_oD/2,0])
                cube([h_oD/2,h_oD/2,h]);
        }
        translate([0,0,-eps])
            cylinder(d=h_od,h=h+2*eps);
    }
    
    // bolt reinforcement
    translate([0,0,h-ft_h+m3_l/2+z_tol+m3_nh])
        rotate([0,0,0])
            bn_hole();
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
            translate([c_a/2-pg_wt,-c_a/2,c_h/2])
                difference()
                {
                    rotate([0,90,0])
                        pg_holder();
                    _a = c_h;
                    translate([-eps,-eps,-_a-eps])
                        cube([_a,_a,_a/2+eps]);
                }
                
            // plexiglass hooks
            translate([-c_a/2+2*pg_wt+pg_t,c_a/2-pg_wt,c_h/2])
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
            huge_screw_hole(hhd_t);
        
        
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
            translate([c_a/2-pg_wt,-c_a/2,c_wh+c_h])
                difference()
                {
                    rotate([0,90,0])
                        pg_holder();
                    _a = c_h+2*eps;
                    translate([-eps,-eps,-_a+c_h/2+eps])
                        cube([_a,_a,_a/2+eps]);
                }
                
            // plexiglass hooks
            translate([-c_a/2+2*pg_wt+pg_t,c_a/2-pg_wt,c_wh+c_h])
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
            huge_screw_hole(hhd_t);
        
        
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


///////////////////////
// BASIC FOOT MODULE //
///////////////////////
module lower_upper_connector()
{
    difference()
    {
        // main body
        translate([-c_a/2,-c_a/2,0])
            rc_cube([c_a,c_a,c_h],2);
        
        // conical cut
        translate([0,0,-eps])
            cylinder(d1=ft_Do,d2=ft_do,h=ft_cho+2*eps);
        
        // cut for the screw to slide in
        translate([0,0,ft_cho])
            huge_screw_hole(hhd_m);
    }
}

// module for back table leg foots,
// '-> carve hole for the PSU cables 
module lower_upper_back_connector()
{
    // basic shape
    lower_upper_connector();
    
    // first plexiglass holders
    translate([c_a/2-pg_wt,c_a/2-2*pg_wt-pg_t,0])
        pg_holder();
    
    // second plexiglass holders
    translate([-c_a/2,-c_a/2+pg_wt,0])
        rotate([0,0,-90])
            pg_holder();
    
}

translate([0,100,0])
    lower_upper_back_connector();

module lower_upper_front_left_connector()
{
    difference()
    {
        // main shape
        lower_upper_connector();
        
        // hinge hole
        translate([c_a/2-h_od/2,-c_a/2+h_od/2,ft_h-hh_ob+eps])
            outer_hinge(h=hh_ob);
        
    }
    
    // left plexiglass holder
    translate([-c_a/2+2*pg_wt+pg_t,c_a/2-pg_wt,0])
        rotate([0,0,90])
            pg_holder();
}

translate([200,0,0])
    lower_upper_front_left_connector();