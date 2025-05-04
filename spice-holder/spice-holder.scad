include<../solidpp/solidpp.scad>

// drawer parameters
drawer_width = 124-0.5; // 122 including some covers
drawer_depth = 62.5;

// narrowing on the beginning
drawer_narrow_width = 122-0.5;
drawer_narrow_length = 40;

// spice jars parameters
spice_jar_d = 42;
spice_jar_clearance = 0.5;

// variable parameters
wt = 3;
top_thickness = 6;
spice_jar_spacing = 5;

horizontal_space = drawer_width - 2*spice_jar_d-2*spice_jar_spacing;
horizontal_guage = horizontal_space + spice_jar_d;
vertical_step = sqrt((spice_jar_d+spice_jar_spacing)*(spice_jar_d+spice_jar_spacing)-(horizontal_space/2+spice_jar_d/2)*(horizontal_space/2+spice_jar_d/2));

skew_angle = atan2(vertical_step, horizontal_guage/2);
//echo(skew_angle);
//echo(sin(skew_angle));

holder_height = 40;
holders_clearance = 0.25;
// /holder_wt = 2;

$fn=$preview ? 36: 72;

//echo(vertical_step);

module spice_jar_voroni(clearance=0)
{

    _a = spice_jar_d+spice_jar_spacing+clearance;
    intersection()
    {
           
        rotate([0,0,skew_angle])
            cubepp([3*spice_jar_d,
                    _a,
                    3*holder_height],
                    align="");
        
        rotate([0,0,-skew_angle])
            cubepp([3*spice_jar_d,
                    _a,
                    3*holder_height],
                    align="");
        
        cubepp([2*vertical_step+clearance,3*spice_jar_d,3*holder_height], align="");

    }
}


translate([spice_jar_d/2+spice_jar_spacing,0,0])
%for(i=[0:2])
{
    translate([2*i*vertical_step, 0, 0])
    {
        mirrorpp([0,1,0], true)
            translate([0,horizontal_guage/2,0])
            {
                cylinderpp(d=spice_jar_d,h=drawer_depth);

                //spice_jar_voroni();
            }

        translate([vertical_step,0,0])
        {
            cylinderpp(d=spice_jar_d,h=drawer_depth);

            spice_jar_voroni();

        }

    }
}

module jar_holder_segment(is_first=false, is_last=false)
{
    // main body
    difference()
    {
        body_x = 2*vertical_step+spice_jar_spacing+spice_jar_d/2 + (is_first ? - holders_clearance : 0);
        cubepp([body_x, drawer_width, holder_height],
                align="zx");

        // cut out middle
        //_mx = !is_first && !is_last ? body_x-2*wt :
        //        (is_first && is_last ? body_x-2*wt : body_x);
        _mx = 3*body_x;
        //_ma = is_first == is_last ? "xz" : "xz";
        _ma = "xz";
        //_mo = is_first == is_last ? wt :
        //        (is_first && !is_last ? -wt : wt);
        _mo = 0;

        translate([_mo,0,wt])
            cubepp([_mx, drawer_width-2*wt, holder_height-wt-top_thickness], align=_ma);

        // add hole of spices
        translate([spice_jar_d/2+spice_jar_spacing,0,wt])
        {
            mirrorpp([0,1,0], true)
                translate([0,horizontal_guage/2,0])
                    cylinderpp( d=spice_jar_d+2*spice_jar_clearance,
                                h=drawer_depth);

            translate([vertical_step,0,0])
                cylinderpp( d=spice_jar_d+2*spice_jar_clearance,
                            h=drawer_depth);
            translate([vertical_step,0,0])
                %spice_jar_voroni();
        }
        
        // if not last cut back
        if (! is_last)
        {
            mirrorpp([0,1,0], true)
            translate([body_x,drawer_width/2,0])
                cubepp([vertical_step+holders_clearance,
                        spice_jar_d/2+spice_jar_spacing,
                        3*holder_height],
                        align="YX");

            mirrorpp([0,1,0], true)
                translate([body_x,horizontal_guage/2,0])
                {
                    spice_jar_voroni(2*holders_clearance);
                    //spice_jar_voroni();
                }
            
        }

        // if not first, cut base
        if (! is_first)
        {
            translate([spice_jar_d/2+spice_jar_spacing-vertical_step,0,0])
                spice_jar_voroni(2*holders_clearance);
        } 
        else
        {
            // TODO add cuts to narrow it down
            _t = (drawer_width-drawer_narrow_width)/2;
            echo(_t);
            mirrorpp([0,1,0], true)
                translate([0,drawer_narrow_width/2,0])
                    cubepp([drawer_narrow_length,_t,holder_height], align="xyz");

        }
    }
}

jar_holder_segment();