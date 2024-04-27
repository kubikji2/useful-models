module arch_text(text=" test ", r=10, t=2,
                font="Arial Unicode MS:style=Regular",
                size=5, inv=false)
{
    // TODO add vertical alignement handling
    
    // angle incremenet
    d_a = 180/(len(text)-1);
    r_i = inv ? 180 : 0;

    for(i=[0:len(text)])
    {
        idx = inv ? len(text)-i-1 : i;
        c = text[idx];
        r_z = 180-d_a*i;
        linear_extrude(t)
        {
            // rotate on the arch
            rotate([0,0,r_z]) translate([r,0,0])
                // rotate bottom to the center
                rotate([0,r_i,-90])
                    text(text=c,font=font,size=size,
                    halign="center");
        }
        
    }
    
}

arch_text(inv=true);

module inv_arch_text(text=" zkouška ", r=10, t=2,
                font="Arial Unicode MS:style=Regular",
                size=5, inv=false)
{
    // TODO add vertical alignement handling
    
    // angle incremenet
    d_a = 180/(len(text)-1);
    r_i = inv ? 180 : 0;

    for(i=[0:len(text)])
    {
        idx = inv ? len(text)-i-1 : i;
        c = text[idx];
        r_z = d_a*i;
        linear_extrude(t)
        {
            // rotate on the arch
            rotate([0,0,r_z]) translate([-r-size,0,0])
                // rotate bottom to the center
                rotate([0,r_i,-90])
                    text(text=c,font=font,size=size,
                    halign="center");
        }
        
    }
    
}
inv_arch_text(inv=true);