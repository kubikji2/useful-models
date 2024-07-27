include<filter.scad>



part_name = "filter"; //["body-filter", "body-fan", "filter", "filter-support-blocker", "all", "bolt"]


if (part_name == "body-filter")
{
    filter_body();
}
else if (part_name == "body-fan")
{
    fan_body();
}
else if (part_name == "filter")
{
    filter_holder();
}
else if (part_name == "filter-support-blocker")
{
    filter_support_enforcers();
}
else if (part_name == "all")
{
    filter_body();
    fan_body();
    /*
    translate([0,other_wt+middle_wt+fan_h+clearance,0])
    {
        filter_holder();
        %filter_support_enforcers();    
    }
    */
}
else if (part_name=="bolt")
{
    fan_bolt_and_nut_hole();
    %cylinder(h=30,d=10);
}
