$fn = 180;
fn_o = 16;
eps = 0.01;
tol = 0.2;

// M3
m3_l=10;
m3_d=3;
m3_nd=6.0;
m3_nh=2.3;
m3_hd=5.5;
m3_hh=2;

// main shape parameters
wt = 3;
r_o = 140;
r_i = r_o-wt;
h=70+45-42;


// additional parameters
// border height
bh = 5;
// border thickness
bt = 3;

module border_hole()
{
    difference()
    {
        cylinder(r=r_o, h=bh);
        translate([0,0,-eps])
            cylinder(r=r_i,h=bh+2*eps);
    }
}

module inner_cutter(_h=2*h)
{
    difference()
    {
        _r = r_i+m3_l/2-bt-tol;
        // only one cylinder needed
        cylinder(r=_r,h=_h);
        
        // first quadrant cut
        translate([-2*_r,0,-eps])
            cube([4*_r,2*_r,_h+2*eps]);
        
        // second and third quadran cut
        translate([-2*_r,-2*_r,-eps])
            cube([2*_r,4*_r,_h+2*eps]);
       
    }
}

module outer_cutter(_h=2*h)
{
    difference()
    {
        _r = r_i+m3_l-bt;
            
        // outer cylinder
        cylinder(r=_r+1,h=_h);
        
        // inner hole
        translate([0,0,-eps])
            cylinder(r=_r-m3_l/2,h=_h+2*eps);
        
        // first quadrant cut
        translate([-2*_r,0,-eps])
            cube([4*_r,2*_r,_h+2*eps]);
        
        // second and third quadran cut
        translate([-2*_r,-2*_r,-eps])
            cube([2*_r,4*_r,_h+2*eps]);
        
    }
}

module bolt_hole()
{
    // head
    cylinder(h=m3_hh,d=m3_hd);
    
    // thread
    cylinder(h=m3_hh+m3_l,d=m3_d);
    
    // nut
    translate([0,0,m3_hh+m3_l-3])
        cylinder(d=m3_nd,h=m3_l,$fn=6);
}


module segment()
{
    difference()
    {
        // main shape
        cylinder(r=r_o+bt+1,h=h+2*bh,$fn=fn_o);
        
        // inner cut
        translate([0,0,-eps])
            cylinder(r=r_i-bt, h=h+2*bh+2*eps);
        
        // lower hole
        translate([0,0,-eps])
            border_hole();
        
        // upper hole
        translate([0,0,h+bh+eps])
            border_hole();
        
        a = 5;
        
        // cutting only a segment
        rotate([0,0,a])
            translate([-2*r_o,0,-eps])
                cube([4*r_o, 4*r_o, 2*h]);
        rotate([0,0,0])
            translate([-4*r_o,-2*r_o,-eps])
                cube([4*r_o, 4*r_o, 2*h]);
        
        rotate([0,0,90])
            translate([0,0,-eps])
                outer_cutter();
                
        rotate([0,0,-90+a])
            translate([0,0,-eps])
                inner_cutter();
                
        // holes for the nuts and 
        rotate([0,0,+a/2])
        {
            translate([0,-r_o-bt-2,2*bh])
                rotate([-90,0,0])
                    bolt_hole();
            translate([0,-r_o-bt-2,h])
                rotate([-90,0,0])
                    bolt_hole();
        }
        
        rotate([0,0,+a/2])
        {
            translate([+r_o+bt+2,0,2*bh])
                rotate([-90,0,90])
                    bolt_hole();
            translate([+r_o+bt+2,0,h])
                rotate([-90,0,90])
                    bolt_hole();
        }
        
        // cut for parts
        /*
        rotate([0,0,0-3*(90/4)])
            translate([-2*r_o,0,-eps])
                cube([4*r_o, 4*r_o, 2*h]);
        rotate([0,0,0])
            translate([-4*r_o,-2*r_o,-eps])
                cube([4*r_o, 4*r_o, 2*h]);
        */
    }
}

segment();