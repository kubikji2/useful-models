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
// height of the foot interface part
ft_h = 22;
// additional foot height for the insulation and cable management
ft_ho = 6;
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
hh_ib = 16+8;
// bottom hinge outer height
hh_ob = hh_ib + z_tol;
// top hinge inner height
hh_it = 16;
// top hinge outer height
hh_ot = hh_it + z_tol;

// hinge diameters
h_id = 9;
h_od = h_id + 0.5;
h_iD = h_id + 6;
h_oD = h_od + 6;

// hinge frames lenght
hf_lu = 50;

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



// module creating cube with top/buttom sloped side
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
module pg_holder(bt=pg_wt)
{
    difference()
    {
        render(1)
        hull()
        {
            // horizontal part
            translate([0,0,pg_wt-bt])
                cube([c_h,pg_t+2*pg_wt,bt]);
            // vertical part
            translate([-(bt)+pg_wt,0,-bt+pg_wt])
                cube([bt,pg_t+2*pg_wt,c_h+bt-pg_wt]);
        }
        translate([pg_wt,pg_wt,pg_wt])
            cube([c_h,pg_t,c_h]);
    }
    
}


// basic shape of the connector
module connector_base(off=0,cut=0)
{
    // base part
    translate([-c_a/2-c_wt,-c_a/2-c_wt,(off==-1 ? -off : 0 )*c_wh])
        rc_cube([c_a+c_wt,c_a+c_wt,c_h/2],5);
    // main geometry
    render(1)
    hull()
    {
        _xo = (cut==-1 ? (cut)*h_oD : 0);
        _yo = -(cut==+1 ? (cut)*h_oD : 0);
        translate([-c_a/2-c_wt,-c_a/2-c_wt,0])
            rc_cube([c_a+c_wt+_xo,c_a+c_wt+_yo,c_h/2+c_wh],5);
        translate([-c_a/2,-c_a/2,off*5])
            cube([c_a-5+_xo,c_a-5+_yo,c_h/2+c_wh]);
    }
}


module bolt_holes(generate=[1,1,1,1])
{
    pos = [ [-c_a/2+m3_off,-c_a/2+m3_off,0],
            [-c_a/2+m3_off,+c_a/2-m3_off,0],
            [+c_a/2-m3_off,+c_a/2-m3_off],
            [+c_a/2-m3_off,-c_a/2+m3_off]];
    
    for(i=[0:3])
    {
        p=pos[i];
        if(generate[i]==1)
        {
            translate(p)
                bn_hole();
        }
    }
}

module screw_holes(off=0)
{
    // '-> positions
    s_pos = [   [+c_a/2-c_wt-m3_shd,-c_a/2-c_wt-eps,off+m3_shd],
                [-c_a/2+m3_shd,-c_a/2-c_wt-eps,off-m3_shd+c_wh],
                [-c_a/2-c_wt-eps,-c_a/2+m3_shd,off+m3_shd],
                [-c_a/2-c_wt-eps,+c_a/2-c_wt-m3_shd,off-m3_shd+c_wh],
                [c_a/2+c_wt+eps,+c_a/2-c_wt-m3_shd,off+m3_shd],
                [c_a/2-c_wt-m3_shd,+c_a/2+c_wt+eps,off-m3_shd+c_wh]];
    
    // '-> rotations
    s_rot = [   [-90,0,0],
                [-90,0,0],
                [0,90,0],
                [0,90,0],
                [0,-90,0],
                [90,0,0]];
    
    for(i=[0:5])
    {
        cp = s_pos[i];
        cr = s_rot[i];
        translate(cp)
            rotate(cr)
                s_hole();
    }  
    
}


// main hinge 
module outer_hinge(h,right=0,bolt_offset=0)
{
    // main hinge axle
    difference()
    {
        
        union()
        {
            rotate([0,0,0*90])
            {
                cylinder(d=h_oD,h=h);
                    
                cube([h_oD/2,h_oD/2,h]);
                translate([-h_oD/2,-h_oD/2,0])
                    cube([h_oD/2,h_oD/2,h]);
            }
            
            // cutting off the outer support wall
            rotate([0,0,(-right)*90])
            {
                translate([-h_oD/2,-h_oD/2-c_wt,0])
                    cube([h_oD+eps,c_wt+h_oD/2,h]);
                translate([-h_oD/2,-h_oD/2-c_wt-eps,0-(c_h-h)/2-eps])
                    cube([h_oD,c_wt+eps,c_h+2*eps]);
            }
        }
        translate([0,0,-eps])
            cylinder(d=h_id,h=h+2*eps);
    }
    
    // bolt reinforcement
    translate([0,0,h-ft_h+m3_l/2+z_tol+m3_nh+bolt_offset])
        rotate([180,0,0])
            bn_hole();
}


module outer_hinge_simple(h,right=0)
{
    // main hinge axle
    difference()
    {
        
        union()
        {
            // I am sorry, but this make not much sense
            rotate([0,0,180-right*90])
            {
                cylinder(d=h_oD,h=h);
                
                cube([h_oD/2,h_oD/2,h]);
                translate([-h_oD/2,-h_oD/2,0])
                    cube([h_oD/2,h_oD/2,h]);
                translate([-h_oD/2,-h_oD/4,0])
                cube([3*h_oD/4,3*h_oD/4,h]);
            }
        }
        translate([0,0,-eps])
            cylinder(d=h_id,h=h+2*eps);
    }
    
    // bolt reinforcement
    translate([0,0,h-ft_h+m3_l/2+z_tol+m3_nh])
        rotate([180,0,0])
            bn_hole();
}

/********************
* UPPER CONNECTOTRS *
********************/
// REGULAR UPPER CONNECTORS (BACK)
module upper_upper_connector()
{
    difference()
    {
        // basic shape and the plexiglass hooks
        union()
        {
            // connector base
            connector_base(1);
            
            // additional support
            leg_inner_support(upper=1);
            
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

module leg_inner_support(upper=0)
{
    cut = 1;
    translate([5,5,0])
    render(1)
    hull()
    {
        _xo = h_oD;
        _yo = h_oD;
        translate([-c_wt,-c_wt,0])
            rc_cube([c_a/2+c_wt,c_a/2+c_wt,(upper == 0) ? c_h/2+c_wh : c_h/2],5);
        translate([0,0,(upper == 0) ? -5 : 0])
            cube([c_a/2-5,c_a/2-5,(upper == 0) ? c_h/2+c_wh : c_h/2]);
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
            
            // additional support
            leg_inner_support();
            
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

// LEFT FRONT CONNECTOR
module left_upper_upper_connector()
{
    difference()
    {
        // basic shape and the plexiglass hooks
        union()
        {
            // connector base
            connector_base(off=1,cut=-1);
            
            // additional support
            leg_inner_support(upper=1);
            
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
        
        render(2)
        difference()
        {
            // cut for the table leg
            translate([-c_a/2,-c_a/2,c_h/2])
                ses_cube([c_a+eps,c_a+eps,2*c_wh+eps],-3);
            
            // hinge reinforcement
            hr = h_oD+2;
            translate([c_a/2-hr,-c_a/2,0])
                cube([hr,hr,c_h/2]);
        }
        
        // main hole cut
        translate([0,0,-c_h/2+eps])
            huge_screw_hole(hhd_t);
        
        
        // holes for the bolts and nuts
        bolt_holes([1,1,1,0]);
        
        // holes for the screws
        screw_holes(c_h/2);
        
        // hinge cut
        translate([c_a/2-h_oD/2,-c_a/2+h_oD/2,-c_h/2+(c_h-hh_ot)/2])
            outer_hinge(h=hh_ot,right=0,bolt_offset=(c_h-m3_l)/2);
    }

}


module left_upper_lower_connector()
{
    difference()
    {
        // basic shape and the plexiglass hooks
        union()
        {
            
            // connector base
            connector_base(off=-1,cut=-1);
            
            // additional leg support
            leg_inner_support();
                                   
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
        render(2)
        difference()
        {
            translate([-c_a/2,-c_a/2,-c_wh-eps])
                ses_cube([c_a+eps,c_a+eps,2*c_wh+eps],3);
            // hinge reinforcement
            hr = h_oD+2;
            translate([c_a/2-hr,-c_a/2,c_wh])
                cube([hr,hr,c_h/2]);
        }
        
        // main hole cut
        translate([0,0,c_wh-eps])
            huge_screw_hole(hhd_t);
        
        
        // holes for the bolts and nuts
        translate([0,0,c_wh+c_h/2])
            bolt_holes([1,1,1,0]);
        
        // holes for the screws
        screw_holes();
        
        // hinge cut
        translate([c_a/2-h_oD/2,-c_a/2+h_oD/2,c_wh+(c_h-hh_ot)/2])
            outer_hinge(h=hh_ot,right=0,bolt_offset=(c_h-m3_l)/2);
        
    }
    
}


// RIGHT FRONT CONNECTOR
module right_upper_upper_connector()
{
    difference()
    {
        // basic shape and the plexiglass hooks
        union()
        {
            // connector base
            connector_base(off=1,cut=1);
            
            // additional support
            leg_inner_support(upper=1);
                         
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
        }
        
        render(2)
        difference()
        {
            // cut for the table leg
            translate([-c_a/2,-c_a/2,c_h/2])
                ses_cube([c_a+eps,c_a+eps,2*c_wh+eps],-3);
            
            // hinge reinforcement
            hr = h_oD+2;
            translate([-c_a/2,c_a/2-hr,0])
                cube([hr,hr,c_h/2]);
        }
        
        // main hole cut
        translate([0,0,-c_h/2+eps])
            huge_screw_hole(hhd_t);
        
        
        // holes for the bolts and nuts
        bolt_holes([1,0,1,1]);
        
        // holes for the screws
        screw_holes(c_h/2);
        
        // hinge cut
        translate([-c_a/2+h_oD/2,c_a/2-h_oD/2,-c_h/2+(c_h-hh_ot)/2])
            outer_hinge(h=hh_ot,right=1,bolt_offset=(c_h-m3_l)/2);
    }

}



module right_upper_lower_connector()
{
    difference()
    {
        // basic shape and the plexiglass hooks
        union()
        {
            
            // connector base
            connector_base(off=-1,cut=1);
            
            // additional leg support
            leg_inner_support();
                                   
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
            
        }
        
        // cut for the table leg
        render(2)
        difference()
        {
            translate([-c_a/2,-c_a/2,-c_wh-eps])
                ses_cube([c_a+eps,c_a+eps,2*c_wh+eps],3);
            // hinge reinforcement
            hr = h_oD+2;
            translate([-c_a/2,c_a/2-hr,c_wh])
                cube([hr,hr,c_h/2]);
        }
        
        // main hole cut
        translate([0,0,c_wh-eps])
            huge_screw_hole(hhd_t);
        
        
        // holes for the bolts and nuts
        translate([0,0,c_wh+c_h/2])
            bolt_holes([1,0,1,1]);
        
        // holes for the screws
        screw_holes();
        
        // hinge cut
        translate([-c_a/2+h_oD/2,c_a/2-h_oD/2,c_wh+(c_h-hh_ot)/2])
            outer_hinge(h=hh_ot,right=1,bolt_offset=(c_h-m3_l)/2);
        
    }
    
}


// back left
/*
translate([0,100,0])
    rotate([0,0,-90])
        upper_lower_connector();
*/
/*
translate([0,100,50])
    rotate([0,0,-90])
        upper_upper_connector();
*/

// back right
/*
translate([100,100,0])
    rotate([0,0,180])
        upper_lower_connector();
*/
/*
translate([100,100,50])
    rotate([0,0,180])
        upper_upper_connector();

*/

// front left
/*
translate([0,0,50])
    left_upper_upper_connector();

*/
/*
left_upper_lower_connector();
*/

// front right
/*
translate([100,0,50])
    rotate([0,0,90])
        right_upper_upper_connector();
*/
/*
translate([100,0,0])
    rotate([0,0,90])
        right_upper_lower_connector();
*/

module door_hinge(_h,right=0)
{
    // additional plexiglass door offset
    _off = 1.25;
    difference()
    {
        union()
        {
            // basic hinge
            cylinder(h=_h,d=h_iD);
            
            // support frame
            translate(right ? [0,h_iD/2-2*pg_wt-pg_t,0] : [0,-h_iD/2,0])
                cube([h_iD/2+hf_lu,pg_t+2*pg_wt,_h]);
            
            // resting piece
            translate(right ? [0,-h_iD/2,0] : [0,0,0])
                cube([h_iD/2,h_iD/2,_h]);
            
            // support ending
            translate(right ? [hf_lu+h_iD/2-pg_wt,h_iD/2-2*pg_wt-pg_t,0] : [hf_lu+h_iD/2-pg_wt,-h_iD/2,0])
            render(1)
            hull()
            {
                // horizontal part
                translate([0,0,_h-pg_wt])
                    cube([_h,pg_t+2*pg_wt,pg_wt]);
                // vertical part
                cube([pg_wt,pg_t+2*pg_wt,_h]);
            }

            
        }
        
        // hinge axis hole
        translate([0,0,-eps])
            cylinder(h=_h+2*eps,d=h_od);
        
        // plexiglass hole
        translate(right ? [h_iD/2+pg_wt+_off,h_iD/2-pg_wt-pg_t,-pg_wt] : [h_iD/2+pg_wt+_off,-h_iD/2+pg_wt,-pg_wt])
            cube([hf_lu+_h,pg_t,_h]);
    }
}

module upper_hinge(right=0)
{
    door_hinge(_h=hh_it,right=right);
}

module lower_hinge(right=0)
{
    door_hinge(_h=hh_ib, right=right);
}

/*
translate([0,-20,0])
    translate([c_a/2-h_oD/2,-c_a/2+h_oD/2,c_h+5+1])
        upper_hinge();
translate([0,-40,0])
    translate([c_a/2-h_oD/2,-c_a/2+h_oD/2,c_h+5+1])
        upper_hinge(right=1);
*/

/*
translate([100,-20,0])
    translate([c_a/2-h_oD/2,-c_a/2+h_oD/2,c_h+5+1])
        lower_hinge();


translate([100,-40,0])
    translate([c_a/2-h_oD/2,-c_a/2+h_oD/2,c_h+5+1])
        lower_hinge(right=1);
*/
///////////////////////
// BASIC FOOT MODULE //
///////////////////////
// paremeters
// '-> hinge_cut: 0 for no cut, -1 for left, 1 for right
module lower_upper_connector(hinge_cut=0)
{
    difference()
    {
        union()
        {
            // main body
            translate([-c_a/2,-c_a/2,0])
                rc_cube([c_a,c_a,ft_h+ft_ho],5);
            
            // outer leg connector
            _lc_xo = hinge_cut == 1 ? h_oD+c_wt : 0;
            _lc_yo = hinge_cut == 0 ? c_wt : 0;
            _lc_z = c_h/2+c_wh;
            render(0)
            translate([-c_wt-c_a/2+_lc_xo,-c_wt-c_a/2+_lc_yo,+ft_h/2+ft_ho])
            hull()
            {
                
                _lc_a = (hinge_cut>=0) ? (hinge_cut == 0 ? c_a : c_a-h_oD) : c_a-h_oD ;
                
                // main support for leg
                rc_cube([_lc_a+c_wt,c_a+c_wt,_lc_z],5);
                
                // fancy sloped edges
                 
                translate([c_wt,c_wt,-5])
                    cube([_lc_a-c_wt,c_a-c_wt,_lc_z+10]);
            }
            
            // inner leg connector
            _ilc_xo = hinge_cut == 1 ? -c_a/2-c_wt : 0;
            _ilc_yo = hinge_cut == 0 ? -c_a/2-c_wt : 0;
            translate([c_wt+_ilc_xo,c_wt+_ilc_yo,ft_h/2+ft_ho])
            render(0)
            hull()
            {
                _xo = h_oD;
                _yo = h_oD;
                translate([-c_wt,-c_wt,0])
                    rc_cube([c_a/2+c_wt,c_a/2+c_wt,_lc_z],5);
                translate([0,0,-c_wt])
                    cube([c_a/2-5,c_a/2-5,_lc_z+10]);
            }
            
            
        
        }
        
        // conical cut
        translate([0,0,-eps])
            cylinder(d1=ft_Do,d2=ft_do,h=ft_cho+2*eps);
        
        // cut for the screw to slide in
        translate([0,0,ft_cho])
            huge_screw_hole(hhd_m);
        
        // screw cut
        _a = hinge_cut == 0 ? -90 : (hinge_cut == 1 ? 90 : 0);
        rotate([0,0,_a])
        translate([0,0,ft_h+ft_ho])
            screw_holes();        
    }
}

module lower_leg_cut(hinge_cut=0)
{
    // leg cut
    translate([0,0,ft_h+ft_ho])
    render(2)
    difference()
    {
        translate([-c_a/2,-c_a/2-eps,-eps])
            ses_cube([c_a+eps,c_a+2*eps,2*c_wh+eps],-3);
        // hinge reinforcement
        hr = h_oD+2;
        _hrt = hinge_cut == 0 ?
                [0,0,-2*hr] : (hinge_cut == 1 ?
                                [-c_a/2,-c_a/2,-c_h/2] :
                                [c_a/2-hr,-c_a/2,-c_h/2] );
        translate(_hrt)
            cube([hr,hr,c_h/2]);
    }
}

// module for back table leg foots,
module lower_upper_back_connector()
{
    difference()
    {
        union()
        {
            // basic shape
            lower_upper_connector();
            
            // first plexiglass holders
            translate([c_a/2-pg_wt,c_a/2-2*pg_wt-pg_t,ft_ho])
                pg_holder(pg_wt+ft_ho);
            
            // second plexiglass holders
            translate([-c_a/2,-c_a/2+pg_wt,ft_ho])
                rotate([0,0,-90])
                    pg_holder(pg_wt+ft_ho);
        }
        
        lower_leg_cut();
    
    }
}

module lower_upper_front_left_connector()
{
    difference()
    {
        render(5)
        union()
        {
            difference()
            {
                // main shape
                lower_upper_connector(-1);
                
                // hinge hole
                translate([c_a/2-h_oD/2+eps,-c_a/2+h_oD/2-eps,ft_h+ft_ho-hh_ob+eps])
                    outer_hinge_simple(h=hh_ob);
                
            }
            
            // left plexiglass holder
            translate([-c_a/2+2*pg_wt+pg_t,c_a/2-pg_wt,ft_ho])
                rotate([0,0,90])
                    pg_holder(pg_wt+ft_ho);
        }
        
        lower_leg_cut(-1);
    }
}

module lower_upper_front_right_connector()
{
    difference()
    {
        render(5)
        union()
        {
            difference()
            {
                // main shape
                lower_upper_connector(1);
                
                // hinge hole
                translate([-c_a/2+h_oD/2-eps,-c_a/2+h_oD/2-eps,ft_h+ft_ho-hh_ob+eps])
                    outer_hinge_simple(h=hh_ob,right=1);
                
            }
            
            // left plexiglass holder
            translate([c_a/2,c_a/2-pg_wt,ft_ho])
                rotate([0,0,90])
                    pg_holder(pg_wt+ft_ho);
        }
        
        lower_leg_cut(1);
    }
}

// middle connectors
/*
translate([0,300,0])
    lower_upper_back_connector();
*/

/*
translate([100,300,0])
    lowest_part();
*/

/*
translate([0,200,0])
    lower_upper_front_left_connector();
*/
/*
translate([100,200,0])
    lower_upper_front_right_connector();
*/

// module for the lowest part screwed to the table bellow
module lowest_part()
{
    difference()
    {
        // main body
        union()
        {
            translate([-c_a/2,-c_a/2,0])
                rc_cube([c_a,c_a,ft_t],2);
            translate([0,0,ft_t])
                cylinder(d1=ft_Di,d2=ft_di,h=ft_chi);
        }
        
        // hole for the screw
        translate([0,0,eps+c_h-(c_h-ft_chi-ft_t)])
            rotate([180,0,0])
                huge_screw_hole(hhd_b);
        
    }
}
