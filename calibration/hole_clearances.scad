include<../solidpp/solidpp.scad>

// parameters

diameter = 3;
height = 6;
min_clearance = 0;
max_clearance = 0.3;
step = 0.05;

wt = 3;

$fn = $preview ? 30 : 120;

module hole_clearance_tester(   base_diameter = diameter,
                                height = height,
                                min_clearance = min_clearance,
                                max_clearance = max_clearance,
                                step = step)
{
    n_holes = (max_clearance - min_clearance)/step + 1;

    _x = n_holes*(base_diameter+wt) + wt;
    _y = max(diameter+wt, height) + wt;
    _z = wt + diameter + wt + height;

    difference()
    {
        cube([_x,_y,_z]);

        // hortizontals holes
        for(i=[0:n_holes-1])
        {
            _t = [wt+i*(wt+base_diameter), 0, wt+base_diameter/2];
            _d = base_diameter + i*step + min_clearance;
            translate(_t)
                cylinderpp(h=2*height, d=_d, zet="y", align = "x");
        }

        // vertical holes
        for(i=[0:n_holes-1])
        {
            _t = [wt+i*(wt+base_diameter), wt,_z];
            _d = base_diameter + i*step + min_clearance;

            translate(_t)
                cylinderpp(h=2*height, d=_d, align = "xy");
        }

        // labels
        for(i=[0:n_holes-1])
        {   
            _td = 0.5;
            _t = [wt+i*(wt+base_diameter)+base_diameter/2, _td, wt+base_diameter + height/2 + ( i % 2 == 0 ? wt : 0)];
            _clrn = min_clearance + i*step;
            translate(_t)
                rotate([90,0,0])
                    linear_extrude(2*_td)
                        text(str(_clrn), halign="center", valign="center", size=diameter);
        }
    }

}

hole_clearance_tester();