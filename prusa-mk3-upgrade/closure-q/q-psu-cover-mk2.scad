// PRUSA iteration3
// PSU Cover MK3
// GNU GPL v3
// Josef Průša <iam@josefprusa.cz> and contributors
// http://www.reprap.org/wiki/Prusa_Mendel
// http://prusamendel.org

// modification done by Jiri "Kvant" Kubik <jiri.kub@gmail.com>
// VERSION Q1
VERSION = "Q2";


include<../../deez-nuts/deez-nuts.scad>
include<../../solidpp/solidpp.scad>


//bottom thickness
bt = 2.5;
// wall thickness
wt_x = 4.2;
wt_y = 2.5;

psu_x = 97;//89.4+3+4.6;
//psu_x_translation = -3;
psu_y = 49.3;
psu_z_off = 26.5;
psu_z_used = 35;


psu_int_depth = 1.6;
psu_int_wall_reinforcement = 0.4;

//x_off = 2;
// 
cover_x = psu_x+(wt_x)+psu_int_depth;
cover_y = psu_y+2*wt_y;
cover_z = psu_z_used+bt+psu_z_off;

// socket interface
socket_w = 27.5;
socket_h = 32.9;
socket_d = 18;

socket_bolt_d = 4;
socket_bolt_x_offset = 4.5;
socket_bolt_z_offset = 1;
socket_bolt_g = socket_w+2*socket_bolt_x_offset;

module socket_hole()
{
    // left bolt hole
    translate([-socket_bolt_x_offset,0,socket_h/2-socket_bolt_z_offset])
        cylinderpp(d=socket_bolt_d, h=3*wt_y, zet="y");
    
    // right bolt hole
    translate([socket_w+socket_bolt_x_offset,0,socket_h/2-socket_bolt_z_offset])
        cylinderpp(d=socket_bolt_d, h=3*wt_y, zet="y");
    
    // body hole
    cubepp([socket_w, socket_d, socket_h], align="xyz");
}

// switch interface
switch_w = 20;
switch_h = 12.5;

module switch_hole()
{
    cubepp([switch_w, 3*wt_y, switch_h], align="xz");
}


// PSU bolts

// bolt1 -- side psu bolt 
psu_bolt1_d1 = 8.2;
psu_bolt1_d2 = 5;
psu_bolt1_y_off = 27.8;
psu_bolt1_z_off = 57;

// bolts 2 and 3
psu_bolts_d1 = 7;
psu_bolts_d2 = 4;
pus_bolts_h  = 1.5;
psu_bolts_y_off = 3;

// bolt 2
psu_bolt2_x_off = 7.6;
psu_bolt2_z_off = 53.7;

// bolt 3
psu_bolt3_x_off = 67.9;
psu_bolt3_z_off = 57;

module translate_to_bolt1()
{
    translate([cover_x,psu_bolt1_y_off,psu_bolt1_z_off])
        children();
}

module translate_to_bolt2()
{
    translate([psu_bolt2_x_off, cover_y+psu_bolts_y_off, psu_bolt2_z_off])
        rotate([0,0,180])
            children();
}

module translate_to_bolt3()
{
    translate([psu_bolt3_x_off, cover_y+psu_bolts_y_off, psu_bolt3_z_off])
        rotate([0,0,180])
            children();
}


module psu_mounting_bolt()
{
    // top hole
    cylinderpp(d=psu_bolts_d1, h=10, zet="y", align="Y");
    
    // sloped    
    cylinderpp(d2=psu_bolts_d2, d1=psu_bolts_d1, h=pus_bolts_h, zet="y", align="y");
    
    // shaft
    cylinderpp(d=psu_bolts_d2, h=10, zet="y", align="y");
    
}

// PSU interface

psu_int_t = wt_x+psu_int_wall_reinforcement-psu_int_depth;

module psu_interface()
{
    // bottom cube
    cubepp([psu_int_t, psu_y, 2]);
    
    // middle cube
    cubepp([psu_int_t, 39.3, 3]);

    // top cube
    cubepp([psu_int_t, 32.3, 18.6]);

    // slide-in interface
    translate([-psu_int_depth-0.4, 32.3, 10.8])
        cubepp([wt_x+psu_int_wall_reinforcement, 15, 3], align="xYz");
}


module psu_cover_body()
{
    
    render()
    difference()
    {
        // main body
        union()
        {
            // main shape
            cubepp([cover_x, cover_y, cover_z]);
            
            // TODO add stupid reinforcement

        }
        // cut for psu
        translate([-wt_x, wt_y, bt+psu_z_off])
            cube([cover_x, psu_y, psu_z_used]);
        
        // inner cut
        translate([wt_x+psu_int_wall_reinforcement,wt_y,bt])
            cube([cover_x-(wt_x+psu_int_wall_reinforcement)-wt_x, psu_y, psu_z_used+psu_z_off]);

        // PSU interface 
        // '-> bolt1 
        translate_to_bolt1()
        {
            // head 
            rotate([0,0,180])
                cylinderpp(d1=psu_bolt1_d1, d2=psu_bolt1_d2, h=3, zet="x", align="x");

            // shaft 
            cylinderpp(d=psu_bolt1_d2, h=3*wt_x, align="", zet="x");
        }
        // '-> bolt 2
        translate_to_bolt2()
            psu_mounting_bolt();
        // '-> bolt 3
        translate_to_bolt3()
            psu_mounting_bolt();


        // socket hole
        // TMP move down
        translate([0,0,-1])
        translate([55,0,1])
            socket_hole();

        // switch hole
        translate([18,cover_y, 14.5])
            switch_hole();

    }

    translate([psu_int_depth, wt_y, bt+psu_z_off])
        psu_interface();

    // TODO add interface for psu


    //color("blue")
    
    /*
    //color("red")
    translate([cover_x,0,0])
        cubepp([4,wt_x,100], align="Xz");
    
    //color("red")
    translate([0,0,0])
        cubepp([wt_y, wt_y, 100], align="xYz");

    //color("green")
    translate([psu_int_depth,0,0])
        cubepp([wt_x-psu_int_depth,6,100], align="xz");

    //color("magenta")
        translate([psu_int_depth,-20,0])
            cubepp([psu_x,10,100]);
    */

}

//color("red")
psu_cover_body();


///////////////////////////////////////////////////////

module CubeAdjust(Xdim, Zdim)
{
    for (x =[6:11.2:Xdim-12])
        {
        for (z =[6:11.2:Zdim-12])
            {
                translate([x,-0.2,z])cube([10,0.4,10]);
            }
        }
}

module nuttrap()
{
        rotate([0, 180, 0]) difference()
        {
        union()
                { 
                translate([-4.25,-7.5,0]) difference(){
                translate([0,0,0]) cube([8.5, 9.2, 3]);
                translate([-1,10.6,0]) rotate([45,0,0]) cube([11.5,5.7,5.7]);
                }
            }
        translate([0,0, -0.2])rotate([0,0,30]) cylinder(r=3.5,h=15-1.5, $fn=6);
  }
}

module m3_screw()
{
    translate([0,0,-0]) cylinder(r=1.5,h=12, $fn=30);
    translate([0,0,12]) cylinder(r2=2.8, r1=1.5,h=2, $fn=30);
    translate([0,0,14]) cylinder(r=2.8,h=5, $fn=30);
}

module PSU_COVER()
{
    difference()
    {
        union()
        {
            translate([0,0,-0.46])cube([95,50+15,54.25]); // Base
            //%translate([0,0,-3.5])cube([14-0.5,50+15,5]); // Back pillar 1
            //%translate([-1.6,1,51.5])cube([5,64,3]); // Back pillar 1
            //%translate([60-0.5,0,-3.5])cube([14,50+15,5]); // Back pillar 2
            translate([91+4,0,-0.46])cube([6,50+15,54.25]); // Base for bracket
            translate([-2,45.4-4.6,19])cube([2,3,15]); // nipple on the right
            
            translate([-1.6,0,0])cube([1.65,65,2]); // Frame skirt 1
            translate([-1.6,0,0])cube([1.65,30,53.78]); // Frame skirt 2
            translate([-1.6,0,51.32])cube([1.65,65,2.46]); // Frame skirt 3
        }


        //pretty corners
        /*
        translate([-11,-2,-2])rotate([0,0,-45])cube([10,10,58]);
        translate([95-3+5+1,-2,-2])rotate([0,0,-45])cube([10,10,58]);

        translate([-3,-9,-4.46])rotate([-45,0,0])cube([130,10,10]);
        translate([-3,-12,54.78])rotate([-45,0,0])cube([130,10,10]);

        translate([-3,45+15,-4.46])rotate([-45,0,0])cube([130,10,10]);
        translate([-3,48+15,54.78])rotate([-45,0,0])cube([130,10,10]);

        translate([95-3+3,70,-2])rotate([0,0,-45])cube([10,10,58]);
        translate([95,0-10,-20])rotate([0,-45,-45])cube([20,20,20]);
        translate([95,0-10,45])rotate([0,-45,-45])cube([20,20,20]);

        translate([95,60,-10])rotate([-35,-45,-45])cube([20,20,20]);
        translate([95,60,65])rotate([-55,48,-48])cube([20,20,20]);

        translate([79,-5,67.28])rotate([0,45,0])cube([20,90,20]);
        translate([79,-5,-13.96])rotate([0,45,0])cube([20,90,20]);
        */


        translate([3,3,2])cube([89.02,50.02+15,50.02-0.7]); // main cutout
        
        translate([-3,50-16.4+15,2])cube([100,16.5,50-0.7]); // insert cutout
        translate([-3,50-16.4-15.6+15,2])cube([10,100,17]); // right bottom cutout
        translate([85+2,50-16.4-17.6+15+0.9,2])cube([10,100,50-0.7]); // left bottom cutout

        translate([85+2,10,2])rotate([0,0,45]) cube([10*sqrt(2),10*sqrt(2),50-0.7]);
        translate([85+2,3,2]) cube([10,17,50-0.7]);

        translate([-3,50-16.4-17.6+15+0.9,2])cube([100,100,10]); //  bottom cutout

        // socket
        translate([5.5,0.5,0])
        {
            // socket cutout
            translate([48,1.5,40])
                cube([27.5,32.9,20]); 
            
            // socket right hole cutout
            translate([48-4.5,3+15.6+0.5,40])
                cylinder(r=2,h=50, $fn=8); 
            
            // socket left hole cutout
            translate([48-4.5+37-0.5,3+15.6+0.5,40])
                cylinder(r=2,h=50, $fn=8); 
        }
        
        // TODO -- move to the bottom 
        // switch
        translate([5.5,0.5,0])
        {
    
            // switch cutout
            // moved to the oposite side and rotated by <Q|
            translate([11,15,-10])
                cube([20,12.5,30]); 
        }

        
        //  left back mounthole cutout
        translate([7-0.5-0.5,40-1+15+0.7,-10])
            cylinder(r=2,h=50,$fn=15);
        
        translate([7-0.5-0.5,40-1+15+0.7,-3.7])
            cylinder(r2=2, r1=3.5,h=1.5,$fn=15);

        //  right back mounthole cutout
        translate([67.5-0.7-0.5,43.5-1+15+0.5,-10])
            cylinder(r=2,h=50,$fn=15);
        
        translate([67.5-0.7-0.5,43.5-1+15+0.5,-3.7])
            cylinder(r2=2, r1=3.5,h=1.5,$fn=15);

        // Left side bracket screw hole
        translate([130,32+26,55-4-25])
            rotate([0,-90,0])
                cylinder(r=2.5,h=50,$fn=35);
        
        translate([101.1,32+26,55-4-25])
            rotate([0,-90,0])
                cylinder(r2=2.5, r1=4.1,h=3,$fn=15);
        
        translate([-0.3,1,-1.2])
            CubeAdjust(102,54.25);

        // cable cut
        // improved and adjusted by <Q|
        translate([30,6.8,-10])
        {
            cylinder(r=3.5,h=50); 
            translate([9,0,0])
                cylinder(r=3.5,h=50);
            translate([0,-3.5,0])
                cube([9,7,50]);
        }
    }
}

module PSU_Y_REINFORCEMENT()
{
    difference()
    {
        union()     // base shape
        {
            translate([ 59.5, 0, -18 ]) cube([ 33, 6, 19 ]);  // reinforcement plate
            translate([ 73.5, 5, -18 ]) cube([ 5, 16, 19 ]);  // vertical_reinforcement    
        }

        union ()    // cutouts
        {
            //corner cut
            translate([ 87.5, -8, -20 ])
                rotate([ 0, 45, 0 ])
                    cube([ 10, 20, 10 ]);
            
            //corner cut
            translate([ 52.5, -8, -20 ])
                rotate([ 0, 45, 0 ])
                    cube([ 10, 20, 10 ]);
            
            //vertical reinf cutout
            translate([ 68.5, 20, -34 ])
                rotate([ 45, 0, 0 ])
                    cube([ 15, 23, 20 ]);
            
            translate([ 66.2, -0.2, -5])
                cube([23.6, 0.4, 5.6]);
            
            translate([ 68 + 1.8 +2.6, -0.2, -7.7 -5.6])
                cube([11.2, 0.4, 5.6]);
            
            //hole A
            translate([ 88, 8, -11.5 ])
                rotate([ 90, 0, 0])
                    cylinder( h = 10, r = 1.8, $fn=30 );
            
            //hole B
            translate([ 68, 8, -11.5 ])
                rotate([ 90, 0, 0 ])
                    cylinder( h = 10, r = 1.8, $fn=30 );  
            
            //hole A
            translate([ 88, 8, -9.5 ])
                rotate([ 90, 0, 0])
                    cylinder( h = 10, r = 1.8, $fn=30 );
            
            //hole B
            translate([ 68, 8, -9.5 ])
                rotate([ 90, 0, 0 ])
                    cylinder( h = 10, r = 1.8, $fn=30 );  
            
            // hole cut extension
            translate([ 86.2, -10, -11.5 ])
                cube([ 3.6, 20, 2 ]);  
            
            // hole cut extension
            translate([ 66.2, -10, -11.5 ])
                cube([ 3.6, 20, 2 ]);  
            
            
            
        }
    }
}

module psu_holder_hole()
{
    translate([0,1,0])
        cylinder( h = 10, r = 1.8, $fn=30 );
    
    translate([0,-1,0])
        cylinder( h = 10, r = 1.8, $fn=30 );
    
    //sccrew haead cut
    hc_h = 3.5-1.8;
    render(0)
    translate([0,0,10-hc_h])
    hull()
    {
        translate([0,-1,0])
            cylinder( h = hc_h, r1 = 1.8, r2=3.5, $fn=30 );
        translate([0,1,0])
            cylinder( h = hc_h, r1 = 1.8, r2=3.5, $fn=30 );
    }
    
    translate([-1.8,-1,0])
        cube([ 3.6, 2, 10 ]);   
}

module PSU_HOLDER()
{
    // basic shape
    bx = 33;
    by = 19;
    bz = 6;
    // vertical support
    vsx = 5;
    vsy = by;
    vsz = 21; 
    
    translate([-bx/2,0,0])
    difference()
    {

        // base shape
        union()     
        {
            // plate
            cube([bx, by, bz]);
            
            // vertical_reinforcement
            translate([bx/2-vsx/2,0,0])
                cube([vsx, vsy, vsz]);      
        }

        union ()    // cutouts
        {
            //corner cut
            translate([0,by-5,-1])
                rotate([0,0,45])
                    cube([10,10,20]);
            
            //corner cut
            translate([bx, by-5,-1])
                rotate([0,0,45])
                    cube([10,10,20]);
            
            //vertical reinf cutout
            translate([bx/2-7.5, by, by/2-2])
                rotate([ 45, 0, 0 ])
                    cube([ 15, 23, 20 ]);
            
            // screw holes
            hole_off = 7;
            translate([hole_off,by/2+2,-10+bz+0.01])
                psu_holder_hole();
                
            translate([bx-hole_off,by/2+2,-10+bz+0.01])
                rotate([0,0,90])
                     psu_holder_hole();
            
            // some wierd holes from the original part
            translate([hole_off/2+1.8,2,-0.2])
                cube([bx-2*hole_off+3.6, 5.6, 0.4]);
            
            translate([hole_off+1.8+1,by/2-1,-0.2])
                cube([bx-2*hole_off-3.6-2, 5.6, 0.4]);          
        }
    }
}

//PSU_HOLDER();

module psu_main(){
    difference()
    {    
        union()
        {
            PSU_COVER();
            //PSU_Y_REINFORCEMENT();
            %translate([0,0.99,50/2+10]) rotate([-90,90,0]) PSU_HOLDER();
            %translate([100,0.99,50/2+10]) rotate([-90,-90,0]) PSU_HOLDER();
            translate([85.5,4+15.6+0.5,39.1+13.5]) rotate([0,0,180]) nuttrap();
            translate([49,4+15.6+0.5,39+13.5]) rotate([0,0,180]) nuttrap();
            
            %translate([14.5,8,12.5]) rotate([0,-90,0]) m3_screw();
            %translate([85.5,8,12.5]) rotate([0,90,0]) m3_screw();
        }   
        translate([-5,-9,-30]) cube([150,10,100]);
    }       
}

//psu_main();

module upper_part()
{
    difference()
    {
        union()
        {
            psu_main();
            translate([30,3.5,49.5]) cube([15,11,2.5]);
            translate([45,3.5,1]) cube([15,11,2.5]);
            
        }
        
        translate([-25,0,-20]) cube([150,3.5,120]);
        translate([37,9,39]) rotate([0,0,0]) m3_screw();
        translate([14.5,8,12.5]) rotate([0,-90,0]) m3_screw();
        translate([85.5,8,12.5]) rotate([0,90,0]) m3_screw();
        translate([52,9,14.5]) rotate([0,180,0]) m3_screw();
        
        //version
        translate([73,7.5+1,1.5]) rotate([0,0,0]) linear_extrude(height = 0.6) 
        { text(VERSION,font = "helvetica:style=Bold", size=6, valign="center",halign="center"); }   
    }
}


module lower_part()
{
    difference()
    {
        union()
        {
            difference()
                {   
                union()
                    {
                    psu_main(); // base cover
                    translate([50,0.5,40]) cube([40,3,13.8]);
                    translate([5,0.5,4]) cube([90,4,45]);                
                
                    }
                    translate([-25,3.5,-20]) cube([150,100,120]);  // cut 
                }
            
            // frame side wall
            translate([3.1,3,5]) cube([3,10,40]);
            translate([5.1,3,7.5]) cube([3,10,10]); // moved in Q1 version
            
            // rear wall
            translate([93.9,3,5]) cube([3,10,40]);
            translate([91.1,3,7.5]) cube([3,10,10]); // moved in Q1 version
            
            // switch side wall
            translate([30,3,44.5]) cube([15,11,5]);

            // nut inserts
            translate([32,1,44]) cube([10,1,5]);
            //translate([3,1,10]) cube([5,11,10]); // moved in Q1 version
            //translate([92,1,10]) cube([5,11,10]); // moved in Q1 version
            translate([45,2,3.5]) cube([15,11,5]);
            translate([46.5,1,3.5]) cube([10,2,5]);
            
            // floor reinforcement
            difference()
                {
                    translate([5,0.5,4]) cube([90,3.5,45]);                
                    translate([53.5,-1,34]) cube([27.5,8,20]);
                }

        }

    // rear side nut
    translate([4.5,-3.4,12.2-2.5]) cube([2.3,15,5.6]); // moved in Q1 version
    translate([-4,8,12.5 ]) rotate([0,90,0]) cylinder(h=15,r=1.6, $fn=30 ); // moved in Q1 version
    translate([-2,8,25 ]) rotate([0,90,0]) cylinder(h=4,r=3.1, $fn=30 ); 
    
    // frame side nut
    translate([93,-3.4,12.2-2.5]) cube([2.3,15,5.6]); // moved in Q1 version
    translate([88,8,12.5 ]) rotate([0,90,0]) cylinder(h=15,r=1.6, $fn=30 );  // moved in Q1 version
    translate([98,8,25 ]) rotate([0,90,0]) cylinder(h=4,r=3.1, $fn=30 );

    // edges
    translate([0,15,38]) rotate([45,0,0]) cube([15,15,15]);
    translate([90,15,38]) rotate([45,0,0]) cube([15,15,15]);
    translate([0,15,-9]) rotate([45,0,0]) cube([15,15,15]);
    translate([90,15,-9]) rotate([45,0,0]) cube([15,15,15]);
    translate([25,6,38]) rotate([0,0,45]) cube([15,15,15]);
    translate([49.5,6,38]) rotate([0,0,45]) cube([15,15,15]);
    translate([41,6,3]) rotate([0,0,45]) cube([15,15,15]);
    translate([64,6,3]) rotate([0,0,45]) cube([15,15,15]);

    // switch side nut
    translate([31.5+2.8,0,47.5-2]) cube([5.6,9+2.8,2.3]);
    translate([37,9,43 ]) rotate([0,0,90]) cylinder(h=15,r=1.6, $fn=30 ); 
    
    // reinforcement side nut
    translate([52,9,-5 ]) rotate([0,0,90]) cylinder(h=15,r=1.6, $fn=30 ); 
    translate([46+2.8,0,5]) cube([5.6,9+2.8,2.3]);
    
    // cleanup
    translate([-25,-8,-20]) cube([150,10,120]);
    
    // nut edges
    translate([46+2.8,1.5,4]) rotate([45,0,0]) cube([5.6,3,3]);
    translate([31.5+2.8,1.5,44.5]) rotate([45,0,0]) cube([5.6,3,3]);
    translate([5.5,-0.5,12.2-2.5]) rotate([0,0,45]) cube([3,3,5.6]); // moved in Q1 version
    translate([94,-0.5,12.2-2.5]) rotate([0,0,45]) cube([3,3,5.6]); // moved in Q1 version
    
    
    //version
    translate([12,3.6,15]) rotate([90,-90,180]) linear_extrude(height = 0.8) 
    { text(VERSION,font = "helvetica:style=Bold", size=6, valign="center",halign="center"); }    
    }


    
    
}

//translate([2,0,0]) upper_part();

//translate([1.6,0,-3.5]) rotate([90,0,0]) upper_part();
//translate([1.6,53.8,0]) rotate([90,0,0]) upper_part();
%translate([1.6,53.8,-1]) rotate([90,0,0]) psu_main();
//translate([100,23,-2]) rotate([90,0,180]) lower_part();

