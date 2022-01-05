eps = 0.01;
$fn = 90;
tol = 0.2;

// branches
wt = 5;
// carriage diametee
c_d = 8;
c_y = 80;
c_yo = 20;
c_yoo = 2;
c_h = 20;
c_zo = 2;
c_l = 170;

module carriage_hook(off)
{
    _a = c_d+2*wt;
    _b = c_y+c_yo+2*wt+off;
    _c = c_d+c_zo+wt;
    
    difference()
    {
        
        translate([-_a/2,0,0])
            cube([_a,_b,_c]);
        // carriage lock
        translate([0,c_y,c_d/2])
            rotate([90,0,0])
                cylinder(h=c_y+2*eps,d=c_d);
        // carriage border for better grip
        translate([-c_d/2,-eps,-eps])
            cube([c_d,c_y+2*eps,c_d/2]);
        // carriage end cutoff
        translate([-c_d/2-wt-eps, c_y-eps, -eps])
            cube([c_d+2*wt+2*eps, c_yo+2*eps-wt, c_d+c_zo]);
        // 
        //translate([-c_d/2-wt-eps, c_y-eps, -eps])
        //    cube([c_d+2*wt+2*eps, c_yo+2*eps-wt, c_d+c_zo]);
        
        // hook connector
        translate([-c_d/2-wt-eps,(c_y+c_yo)/2-tol,_c-wt-tol])
            cube([c_d+2*wt+2*eps,2*wt+2*tol,wt+tol+eps]);
    }
    
    // front border
    translate([-c_d/2-wt,0,c_d+wt+c_zo])
        cube([c_d+2*wt,wt,c_h]);
    // back border
    translate([-c_d/2-wt,_b-wt,c_d+wt+c_zo])
        cube([c_d+2*wt,wt,c_h]);
}

module left_hook()
{
    carriage_hook(2);
}

module right_hook()
{
    carriage_hook(0);
}



module power_source_travel_holder()
{
    left_hook();
    
    translate([c_l,0,0])
        right_hook();
    
    // connector
    _l = 4*wt + c_d + c_l;
    translate([-2*wt-c_d/2,(c_y+c_yo)/2,c_d+c_zo])
        union()
        {
            // main part
            cube([_l,2*wt,wt]);
            
            translate([0,-wt,-wt])
            {
                // left borders
                cube([wt-tol,4*wt,2*wt]);
                translate([3*wt+c_d+tol,0,0])
                    cube([wt-tol,4*wt,2*wt]);
                
                // right borders
                translate([c_l,0,0])
                    cube([wt-tol,4*wt,2*wt]);
                translate([3*wt+c_d+tol+c_l,0,0])
                    cube([wt-tol,4*wt,2*wt]);
            }
            
        }
        
}

power_source_travel_holder();
