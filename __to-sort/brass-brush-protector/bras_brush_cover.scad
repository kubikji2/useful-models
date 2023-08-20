// general parameters
$fn = 90;
eps = 0.01;
tol = 0.25;

// brush parameter
b_W = 13+tol;
b_w = 9+tol;
b_t = 6.2+tol;
b_h = 21;
b_l = 40;

w_t = 2;

module brush_cover()
{
    x = b_W + 2*w_t;
    y = b_l+w_t;
    z = b_h+2*w_t;
    difference()
    {
        // base block
        cube([x,y,z]);
        
        // brush "hair" cut
        translate([w_t+(b_W-b_w)/2, w_t, w_t+b_t-eps])
            cube([b_w,b_l+eps,b_h-b_t+eps]);
        
        // solit part cat
        translate([w_t,w_t,w_t]) cube([b_W,b_l+eps,b_t+eps]);
    }
}

brush_cover();