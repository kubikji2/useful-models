use<round_text.scad>;

$fn = 90;
eps = 0.01;
tol = 0.25;

// test tube parameters
// handle part height
h = 15;
// wall thickness for the middle part (test tube holder)
w_T = 3;
// distance from the test tube hole bottom to the bottom of the model
H = h;
// depth of the testube hole (e.g. how deep is the test tube cub in opener)
h_i = 10;
// cone base diameter
d_i = 2;
// diameter of the test tube
d = 29.5+d_i/2;
// middle part opener diameter
D = 2*w_T+d;

%translate([0,0,H-h_i]) cylinder(d=d-1,h=18);

// lever parameters
//l_h = 18;
l_d = 20;
l_l = 60;
l_t = 3;

module test_tube_opener()
{
    difference()
    {
        // main body
        union()
        {
            // main inner part
            cylinder(d=D,h=H);
            
            // handling leverage
            minkowski()
            {
                m_d = 5;
                _D = D-m_d;
                _h = h-m_d;
                _l_d = l_d-m_d;
                sphere(d=m_d);
                
                translate([0,0,m_d/2])
                hull()
                {
                    cylinder(d=D,h=_h);
                    translate([-l_l/2,0,0])
                        cylinder(d=_l_d,h=_h);
                    translate([l_l/2,0,0])
                        cylinder(d=_l_d,h=_h);
                }
            }
        }
        // test tube hole
        translate([0, 0, H-h_i-eps])
            cylinder(h=h_i+2*eps,d=d);
        
        
        // text
        /*
        translate([0,0,-eps]) arch_text(" JIRI KUBIK ",
            size=2.25, r=7.5, t=1, inv=true,
            font="Arial:style=Bold");
        */
        /*
        translate([0,0,-eps]) inv_arch_text(" FEE CTU ",
            size=3, r=7, t=1, inv=true,
            font="Arial:style=Bold");
        */
        /*
        translate([0,0,-eps]) inv_arch_text(" FEL CVUT ",
            size=2.25, r=7.5, t=1, inv=true,
            font="Arial:style=Bold");
        */
    }
    
    // inner teeth for better friction
    translate([0,0,H-h_i])
    for(i=[1:60])
    {
        rotate([0,0,i*6]) translate([d/2,0,0])
            cylinder(d2=d_i/2,d1=d_i,h=h_i);
    }    
    
    
}

test_tube_opener();