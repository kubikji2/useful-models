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


// corer piece
module corner()
{
    _t = s_h;
    translate([0,_t/2,0])
        __base_interface();
    
    rotate([90,0,0])
        translate([0,_t/2,0])
            __base_interface();
    
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
