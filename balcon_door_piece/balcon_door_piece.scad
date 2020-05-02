eps = 0.01;
$fn = 90;

// x parameters
x = 17.5;
x_l_l = 2;
x_l_r = 2.3;
x_m_r = 1;
x_u_l = x_l_l;
// y is just one
y = 41.1;

// z parameters
z_l = 0.4;
z_m = 0.8;
z_u = 1;

// triangle parameteres
t_r = 0.5;
t_x = 5-2*t_r;
t_y = 16-2*t_r;
t_z = 9.6-z_l+z_m-z_u;


// holes parameters
// small holes
sh_d = 4.4;
sh_D = 7.4;
// big holes
bh_d = 10.5;
bh_D = 13;
bh_t = 0.9;
b_xo = 1.5;


module door_piece()
{

    difference()
    {
        union()
        {
            // lower cube
            translate([x_l_l,0,0])
                cube([x-x_l_l-x_l_r,y,z_l]);
            
            // middle cube
            translate([0,0,z_l])
                cube([x-x_m_r,y,z_m]);
            
            // upper cube
            translate([x_u_l,0,z_l+z_m])
               cube([x-x_u_l,y,z_u]);
            
            // upper slope
            _a = 0.1;
            translate([0,0,z_l+z_m]) hull()
            {
                translate([0,0,-eps]) cube([x_u_l,y,eps]);
                translate([x_u_l,0,0]) cube([eps,y,z_u]);
            }
            
            // lower triangle
            translate([x-t_r,t_r,z_l+z_m+z_u]) hull()
            {
                // lower corner
                cylinder(r=t_r, h=t_z);
                // upper corner
                translate([0,t_y,0])
                    cylinder(r=t_r, h=t_z);
                // immer corner
                translate([-t_x,t_y,0])
                    cylinder(d=t_r, h=t_z);
            }
            
            // upper triangle
            translate([x-t_r,y-t_r,z_l+z_m+z_u]) hull()
            {
                // lower corner
                cylinder(r=t_r, h=t_z);
                // upper corner
                translate([0,-t_y,0])
                    cylinder(r=t_r, h=t_z);
                // immer corner
                translate([-t_x,-t_y,0])
                    cylinder(d=t_r, h=t_z);
            }
                
        }
    }
}

door_piece();