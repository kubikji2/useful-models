eps = 0.01;
z_tol = 0.5;

// wood piece parameters
wp_x = 16.1;
wp_y = 3.2;

// holder parameters
// wall thickness
wt = 3;
// cut depth
cd = wt+wp_x+wt+z_tol;
// hook hight
hh = 3;
// border width
//bw = 255;

// variable parameteres
// number of levels
nl = 1;

module end_holder(right=0)
{
    difference()
    {
        // main shape
        cube([wt+wp_x+wp_y+wt,cd,wt+wp_y+wt]);
        
        // cut for the wood piece
        translate(right==1 ? [-eps,wt,wt] : [wt,wt,wt])
            cube([wp_x+wp_y+wt+eps,wp_x,wp_y]);
    }
}

module front_level(right=0)
{
    difference()
    {
        union()
        {
            // horizontal block
            cube([wt+wp_x+wp_y+wt, cd, wt+wp_y]);
            // vertical block
            translate(right==1 ? [wp_x,0,0] : [0,0,0])
                cube([wt+wp_y+wt, cd, wt+wp_x+wt]);
        }
        
        // horizontal wooden piece cut
        translate([wt,wt,wt])
            cube([wp_x+wp_y,cd+eps,wp_y+eps]);
        
        // vertical wooden piece cut
        translate(right==1 ? [wt+wp_x,wt,wt] : [wt,wt,wt])
            cube([wp_y,cd+eps,wp_x]);
        
        // hook cut
        translate(  right==1 ?
                    [wt+wp_x-wp_y-eps,-eps,wt+wp_y] : 
                    [wt+wp_y-eps,-eps,wt+wp_y])
            cube([wt+2*eps,cd+2*eps,wp_x-hh-wt]);
    }
}

module front_piece()
{   
    
    _z = wt+wp_x+wt;
    
    // borders
    for(i=[0:nl-1])
    {
        translate([0,0,i*_z])
            front_level();
        translate([50-wp_x+wt,0,i*_z])
            front_level(right=1);
    }
    
    translate([0,0,-wt-wp_y])
        end_holder();
    
    translate([0,0,nl*_z-wt])
        end_holder();
    
    translate([50+wt-wp_x,0,-wt-wp_y])
        end_holder(right=1);
    
    translate([50+wt-wp_x,0,nl*_z-wt])
        end_holder(right=1);
    
}

front_piece();

module back_level(right=0)
{
    difference()
    {
        union()
        {
            cube([wt+wp_x+wp_y+wt, cd, wt+wp_y+wt]);
            translate(right==1 ? [wp_x,0,0] : [0,0,0])
                cube([wt+wp_y+wt, cd, wt+wp_x+wt]);
            translate([0,cd-wt,0])
                cube([wt+wp_x+wp_y+wt, wt, wt+wp_x+wt]);
        }
        
        // horizontal wooden piece cut
        translate([wt,-eps,wt])
            cube([wp_x+wp_y,cd-wt+eps,wp_y+eps]);
        
        // vertical wooden piece cut
        translate(right== 1 ? [wt+wp_x,-eps,wt] : [wt,-eps,wt])
            cube([wp_y,cd-wt+eps,wp_x]);
    }
}

//translate([50,0,0])
//    back_level(right=1);

module back_piece()
{   
    
    _z = wt+wp_x+wt;
    
    // borders
    for(i=[0:nl-1])
    {
        translate([0,0,i*_z])
            back_level(right=0);
        translate([50-wp_x+wt,0,i*_z])
            back_level(right=1);
    }
    
    translate([0,0,-wt-wp_y])
        end_holder();
    
    translate([0,0,nl*_z-wt])
        end_holder();
    
    translate([50+wt-wp_x,0,-wt-wp_y])
        end_holder(right=1);
    
    translate([50+wt-wp_x,0,nl*_z-wt])
        end_holder(right=1);
    
}
translate([0,50,0])
    back_piece();
