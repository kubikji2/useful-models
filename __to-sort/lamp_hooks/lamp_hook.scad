$fn = 90;
eps = 0.01;

nail_d = 2;
inner_d = 4;
outer_d = 6.5;

difference(){
    union(){
        cylinder(d=outer_d+2, h=2);
        translate([0,0,2]) cylinder(d=inner_d,h=2);
        translate([0,0,4]) cylinder(d=outer_d,h=2);

    }
    translate([0,0,-eps]) cylinder(d=nail_d,h = 7++2*eps);
    
}