include<../solidpp/solidpp.scad>

// Raup's Colier
// http://tolaemon.com/raupscoiler/#
S = 2;   // "eccentricity"
D = 0.3; // relative size radius decrement per revolution
T = 1.2; // relative translation per revolution
W = 10; // initial size in [mm] 

R = 3; // number of revolutions
dr = 36; // number of steps in one revolution
shell_thickness = 0.5; // thickness of the shell

// support constants;
angle_increment = 360 / dr;


for (i=[0:R*dr])
{
    
    // scale factor for first and second cylinder
    _sf1 = (1-D*(i/dr));
    _sf2= (1-D*((i+1)/dr));
    _z_off1 = T*(W/2)*D*(i/dr);
    _z_off2 = T*(W/2)*D*((i+1)/dr);

    render(10)
    rotate([0,0,i*angle_increment])
    difference()
    {
        
        hull()
        {   
            translate([0,0,_z_off1])
                cylinderpp([(W*_sf1)/S,  0.1, (W*_sf1)], zet="y", align="x");
                //cylinderpp(d=W*_sf1-2, h=0.1, zet="y", align="x");

            rotate([0,0,angle_increment])
                translate([0,0,_z_off2])
                    cylinderpp([(W*_sf2)/S,  0.1, (W*_sf2)], zet="y", align="x");
                    //cylinderpp(d=W*_sf2, h=0.1, zet="y", align="x");

        }
        
        if(((W*_sf2)/S-2*shell_thickness) > 0)
        {
            hull()
            {   
                translate([shell_thickness, 0, _z_off1])
                    cylinderpp([(W*_sf1)/S-2*shell_thickness, 0.11, (W*_sf1)-2*shell_thickness], zet="y", align="x");
                    //cylinderpp(d=W*_sf1-2*shell_thickness, h=0.11, zet="y", align="x");
                
                rotate([0,0,angle_increment])
                    translate([shell_thickness, 0, _z_off2])
                        cylinderpp([(W*_sf2)/S-2*shell_thickness, 0.11, (W*_sf2)-2*shell_thickness], zet="y", align="x");
                        //cylinderpp(d=W*_sf2-2*shell_thickness, h=0.11, zet="y", align="x");
                }
        }
        
    }

}