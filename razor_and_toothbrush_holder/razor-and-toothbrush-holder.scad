eps = 0.01;
$fn = 90;

// parameters
// base diameters
b_d = 90;
// base thickness
b_t = 2;
// base rising
b_r = 5;

// general parameters
// wall thickness
wt = 3;

// accessories dimensions
// rasor blade storage dimensions
rb_x = 47.5;
rb_y = 11.5;
rb_z = 72;
rb_h = 25;

// razor dimension
r_x = 9;
r_y = 9;
r_o = 5;
r_z = 100;

// toothbrush dimensions
tb_X = 12;
tb_x = 7;
tb_Y = 15;
tb_y = 9;
tb_z = 100;

// possible extention into separete module
module base()
{
    hull()
    {
        cylinder(d=b_d, h=b_t, $fn=8);
        translate([0,0,b_t])
            cylinder(d=rb_x+2*wt, h=b_r, $fn=8);
    }
    
}

module holder()
{
    difference()
    {
        union()
        {
            // base
            rotate([0,0,22.5]) base();
            
            // toothbrush block
            translate([tb_X/2+wt-tb_X-2*wt,tb_Y/2+wt,b_t])
            hull()
            {
                // vertical
                translate([-tb_x/2, -tb_Y/2-wt, 0])
                    cube([tb_x, tb_Y+2*wt, tb_z]);
                // horizontal
                translate([-tb_X/2-wt, -tb_y/2, 0])
                    cube([tb_X+2*wt, tb_y, tb_z]);
            }
            
            
                                   
                            
            
        }
        
        // toothbrush hole
        translate([tb_X/2+wt-tb_X-2*wt,tb_Y/2+wt,b_t-eps])
        hull()
        {
            // vertical
            translate([-tb_x/2, -tb_Y/2, 0])
                cube([tb_x, tb_Y, tb_z+2*eps]);
            // horizontal
            translate([-tb_X/2, -tb_y/2, 0])
                cube([tb_X, tb_y, tb_z+2*eps]);
        }
        
        
            
    }
}

holder();