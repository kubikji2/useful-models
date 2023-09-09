include<shelf-constants.scad>
include<../solidpp/solidpp.scad>


module __base_interface()
{
    difference()
    {
        _size = [s_w, s_o, s_h];
        _size_o = _size + 2*[s_wt,0,s_wt];
        _size_i = _size + 2*[0, s_o, 0];
        cubepp(_size_o,align="y");
        cubepp(_size_i, align="");
    } 
}


// corner piece
module corner()
{
    _t = s_h;
    translate([0,_t/2,0])
        __base_interface();
    
    rotate([90,0,0])
        translate([0,_t/2,0])
            __base_interface();
    
    // join pieces
    translate([0, s_h/2, s_h/2])
    {
        _a = s_h+s_wt;
        _size = [s_w+2*s_wt, _a, _a];
        render(1)
            transform_to_spp(_size, align="", pos="yz")
                cut([180-45, 360-45], zet="x")
                    cubepp(_size,align="");
    }
    
}

// t junction module
module t_juncion(left_interface=false, right_interface=false)
{
    _t = s_h;
    translate([0,_t/2,0])
        __base_interface();
    
    rotate([90,0,0])
        translate([0,_t/2,0])
            __base_interface();
    
    rotate([-90,0,0])
        translate([0,_t/2,0])
            __base_interface();

    // join pieces
    difference()
    {
        _a = s_h + s_wt;
        _size = [s_w+2*s_wt, _a, s_h];
        translate([0, s_h/2, s_h/2])
            cubepp(_size, align="YZ");

        if(right_interface)
        {
            transform_to_spp(_size, align="", pos="X")
                cubepp([i_l,s_h,s_h], align="X");
        }

        if(left_interface)
        {
            transform_to_spp(_size, align="", pos="x")
                cubepp([i_l,s_h,s_h], align="x");
        }
    }
}

//t_juncion();


// x junciton
module x_juncion(left_interface=false, right_interface=false)
{
    _t = s_h;

    for(i=[0:3])
    {
        rotate([i*90,0,0])
            translate([0,_t/2,0])
                __base_interface();
    }

    // join pieces
    _a = s_h + s_wt;
    _size = [s_w+2*s_wt, s_h, s_h];
    difference()
    {
        cubepp(_size, align="");
        
        if(right_interface)
        {
            transform_to_spp(_size, align="", pos="X")
                cubepp([i_l,s_h,s_h], align="X");
        }

        if(left_interface)
        {
            transform_to_spp(_size, align="", pos="x")
                cubepp([i_l,s_h,s_h], align="x");
        }
    }
}

//x_juncion();

