// basic parameters
$fn = 90;
eps = 0.01;
// free movement tolerance
f_tol = 0.3;
// tight/no movement tolerance
t_tol = 0.1;



// pipette tips parameters
// pipette tips stopping diameters, e.g. diameter of small flat annulus
pt_sd = 5;
// pippete tips upper diameter, e.g. maximal diameter of the whole pipette tip
pt_ud = 7.5;
// pippete tips height
pt_h = 15;
// pipette tips upper height, e.g. distance from the flat annulus to the top of the pipette
pt_uh = 28;

// comb carriage parameter
// comb carriage height, e.g. distance from the bottom to the lower part of the carriage
cc_h = 2;
// comb carriage thickness
cc_t = 3;

// grid paramaters parameters
n_rows = 8;
n_cols = 12;
// height of the grid
g_h = 2*cc_h+cc_t;
// distance between centers
g_l = 9;

// comb paramters
// comb width
c_w = g_l-pt_sd;

// border parameteres
// wall thiskness
w_t = 2;
// additional border height, e.g. additional distance from the top most part of pipette tips.
b_h = 6;

// door parameters
// door reinforcement in y axis
drf_y = 5;


module ptsr()
{
    x = n_cols*g_l + 2*w_t;
    // TODO add more reinforcement to the door area
    y = w_t +2*(n_rows*g_l) + drf_y;
    z = g_h + pt_uh + b_h;
    off = pt_ud;
    
    difference()
    {
        // main shape
        cube([x,y,z]);
        
        
        // main cut
        translate([w_t, w_t, z+eps])
        hull()
        {
            _x = x-2*w_t;
            _y = 2*(n_rows*g_l);
            _z = pt_uh-pt_h+b_h+2*eps;
            points = [  [0,off,-_z],
                        [0,0,0],
                        [0,_y-off,-_z],
                        [0,_y,0]];
            for(i=[0:len(points)-1])
            {
                translate(points[i])
                   rotate([0,90,0]) cylinder(h=_x,d=eps); 
            }
        }
        
        // cut for tips to fall in
        for(i=[0:n_cols-1])
        {
            // lower cut for the pipette tips
            _x = w_t+g_l/2 + i*g_l;
            _y = w_t+g_l/2;
            translate([_x,0,-eps]) hull()
            {
                translate([0,_y,0])
                    cylinder(d=pt_sd,h=g_h+2*eps);
                translate([0,y+4*w_t+2*f_tol,0])
                    cylinder(d=pt_sd,h=g_h+2*eps);
            }
            
            // upper cut for the pipette tips
            translate([_x,0,g_h]) hull()
            {
                translate([0,_y,0])
                    cylinder(d=pt_ud,h=pt_uh+2*eps);
                translate([0,y+4*w_t+2*f_tol,0])
                    cylinder(d=pt_ud,h=pt_uh+2*eps);
            }
            // cut for border
            translate([_x,_y,g_h])
                cylinder(h=pt_uh+b_h,d=pt_ud);
        }
        
        // cut holes for the comb
        translate([-eps, y,cc_h])
        {
            for(i=[1:n_rows-1])
            {
                _y = -i*g_l-c_w/2;
                translate([0,_y-f_tol,-f_tol])
                    cube([x+2*eps,c_w+2*f_tol,cc_t+2*f_tol]);
            }
        }
        
    }
    
    // brim cheater
    translate([0,y-2*w_t,0]) cube([x,2*w_t,0.21]);
       

    
    /*    
    // hinges
    translate([0,y-w_t,z]) hinge();
    translate([x-h_h,y-w_t,z]) hinge();
    */
    // pipet tips
    /*
    for(i=[0:n_rows-1])
    {
        %translate([w_t+g_l/2,y-ft_ud/2-i*g_l,0])
        {
            cylinder(h=10,d=ft_ud);
            translate([0,0,-5]) cylinder(h=10,d=ft_sd);
        }
    }
    */
}

ptsr();

module comb()
{
    
    // comb parameters
    _c_d = 10;
    _x = (n_rows-1)*g_l+_c_d + ft_sd;
    _y = 15;
    _z = g_l-ft_sd;
    
    // middle part
    round_cube(x=_x,y=_y,z=_z, d=_c_d);
    
    // comb teeth
    for(i=[0:n_rows-2])
    {
        // tooth body
        _x_o = ft_sd + _c_d/2 + i*g_l;
        _y_o = _y;
        _x = g_l-ft_sd;
        _y = (n_cols+i)*g_l+2*w_t+2*(g_l-ft_sd);
        _z = _x;
        translate([_x_o,_y_o,0]) cube([_x,_y,_z]);
                    
        // enamel
        translate([_x_o,_y_o+_y,0])
        hull()
        {
            cylinder(d=0.01,h=_z);
            translate([_x,0,0]) cylinder(d=0.01,h=_z);
            translate([_x,2*_x,0]) cylinder(d=0.01,h=_z);
        }
            
    }
    
}



