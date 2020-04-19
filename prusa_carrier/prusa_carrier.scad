eps = 0.01;
$fn = 90;

// Prusa frame praters
// frame height
f_h = 41;
// frame thickness
f_t = 6.5;

// handle parameter
// handle lenght
h_l = 85;
// handle diameter
h_d = f_h+7;

// stoppers paramters
s_p = 10;
s_D = h_d + s_p;
s_l = s_p;

module handle()
{
    difference()
    {
        // handle
        scale([1,0.75,1])
        union()
        {
            cylinder(d=s_D, h=s_l);
            translate([0,0,s_l]) cylinder(d1=s_D, d2=h_d, h=s_l);
            translate([0,0,2*s_l]) cylinder(d=h_d, h=h_l);
            translate([0,0,2*s_l+h_l]) cylinder(d1=h_d, d2=s_D, h=s_l);
            translate([0,0,3*s_l+h_l]) cylinder(d=s_D, h=s_l);
        }
        
        // frame cut
        _c_l = h_l+4*s_l;
        #translate([-h_d/2-s_p-eps,-f_t/2,-eps]) cube([f_h+eps+s_p,f_t,_c_l+2*eps]);
        
        
    }
}

handle();