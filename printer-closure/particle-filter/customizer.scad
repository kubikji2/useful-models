include<filter.scad>



part_name = "filter"; //["body-filter", "body-fan", "filter", "filter-support-blocker"]


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
