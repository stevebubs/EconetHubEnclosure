// Simple Enlosure for Econet Hub

facets=60;

// model
PCB_Width=81;
PCB_Depth=61;
PCB_Height=21;
PCB_Thickness=2;
PCB_ScrewOffset=6.5;
PCB_StandOff=3;

DIN_Radius=9;
RJ45_Width=15;
RJ45_Height=13;

wall_thickness=2;
topbottom_thickness=3;

DIN_Height=topbottom_thickness+PCB_StandOff+(PCB_Height/2)+1;

//box spec
screw_offset=PCB_ScrewOffset+wall_thickness;
box_width=PCB_Width+(2*wall_thickness);
box_depth=PCB_Depth+(2*wall_thickness);
box_height=(2*topbottom_thickness)+PCB_StandOff+PCB_Height;

// generate an open box

module create_openbox(width,depth,height,wall,base_thickness) {
    difference() {
        cube([width,depth,height]);
        translate([wall,wall,base_thickness]) 
            cube([width-(2*wall),depth-(2*wall),height+base_thickness*2]);
    };
};

// create_enclosure with PCB screw standoffs

module create_enclosure(width,depth,height,wall_thickness,base_thickness,screw_offset,standoff_height,screwhole_offset) {

difference() {
    union() {
        create_openbox(width,depth,height,wall_thickness,base_thickness);

        //standoffs
        
        translate([screw_offset,screw_offset,0])  
            cylinder(h = standoff_height+(base_thickness), r = 4, center = false, $fn = facets);
        
        translate([screw_offset,depth-screw_offset,0])  
            cylinder(h = standoff_height+(base_thickness), r = 4, center = false, $fn = facets);
        
        translate([width-screw_offset,depth-screw_offset,0])  
            cylinder(h = standoff_height+(base_thickness), r = 4, center = false, $fn = facets);

        translate([width-screw_offset,screw_offset,0]) 
            cylinder(h = standoff_height+(base_thickness), r = 4, center = false, $fn = facets);
    } 
    
    // screw holes in standoffs
    
    {
        translate([screw_offset,screw_offset,screwhole_offset])
            cylinder(h = standoff_height+(base_thickness+2), r = 1, $fn = facets);
        
        translate([screw_offset,depth-screw_offset,screwhole_offset]) 
            cylinder(h = standoff_height+(base_thickness+2), r = 1, $fn = facets);
        
        translate([width-screw_offset,depth-screw_offset,screwhole_offset])
            cylinder(h = standoff_height+(base_thickness+2), r = 1, $fn = facets);
        translate([width-screw_offset,screw_offset,screwhole_offset])
        
            cylinder(h = standoff_height+(base_thickness+2), r = 1, $fn = facets);
        };        
    };
}

module create_holes(RJ45) {
    
    // If we don't have RJ45 ports, assuming the DIN ports are opposite each other?
    if (RJ45==false) {
        translate([(box_width/2)-10,-5,DIN_Height])
            rotate([270,0,0])
                cylinder(h=box_depth+10,r=DIN_Radius,center = false, $fn = facets);
        translate([(box_width/2)+10,-5,DIN_Height])
            rotate([270,0,0])
                cylinder(h=box_depth+10,r=DIN_Radius,center = false, $fn = facets);
    };
    
    // Create Holes for DIN & RJ45 on the sides
    if (RJ45==true) {
        translate([(box_width/2)-10,5,DIN_Height])
            rotate([270,0,0])
                cylinder(h=box_depth,r=DIN_Radius,center = false, $fn = facets);
        translate([(box_width/2)+10,5,DIN_Height])
            rotate([270,0,0])
                cylinder(h=box_depth,r=DIN_Radius,center = false, $fn = facets);
        translate([(box_width/2)-15.5,-5,topbottom_thickness+PCB_StandOff+PCB_Thickness])
            cube([RJ45_Width,20,RJ45_Height]);
        translate([(box_width/2)+4,-5,topbottom_thickness+PCB_StandOff+PCB_Thickness])
            cube([RJ45_Width,20,RJ45_Height]);
     };
     
     // Create Holes for DIN on the ends
     translate([-5,(box_depth/2)-10,DIN_Height])
        rotate([0,90,0])
            cylinder(h=box_width+10,r=DIN_Radius,center = false, $fn = facets);
     translate([-5,(box_depth/2)+10,DIN_Height])
        rotate([0,90,0])
            cylinder(h=box_width+10,r=DIN_Radius,center = false, $fn = facets);
    
};

module generate_Econet_Enclosure(){
    difference(){
        create_enclosure(box_width,box_depth,box_height+3,wall_thickness,topbottom_thickness,screw_offset,PCB_StandOff,-1);
        create_holes(true);
        translate([1,1,box_height-1.5])
            cube([box_width-2,box_depth-2,6]);
        translate([-1,box_depth/2,box_height])
            rotate([0,90,0])
                cylinder(h=box_width+2,r=1,center = false, $fn = facets);
        translate([1,box_depth/2,box_height])
            rotate([0,90,0])
                cylinder(h=box_width-2,r=5,center = false, $fn = facets);
    };
};

module generate_Econet_Lid_old() {
    create_enclosure(box_width,box_depth,wall_thickness*2,wall_thickness,topbottom_thickness,screw_offset,PCB_Height+topbottom_thickness,2);
    
};

module generate_Econet_Lid() {
    cube([box_width-2,box_depth-2,2.5]);
    create_enclosure(box_width,box_depth,wall_thickness*2,wall_thickness,topbottom_thickness,screw_offset,PCB_Height+topbottom_thickness,2);
    
};

module generate_side_screw_mounts() {
    difference() {
        union(){        
            translate([(box_width/2)-10,-10,0])
                cube([20,box_depth+20,topbottom_thickness]);
            translate([(box_width/2),-10,0])
                cylinder(h=topbottom_thickness+1,r=10,center=false,$fn=facets);    
            translate([(box_width/2),box_depth+10,0])
                cylinder(h=topbottom_thickness+1,r=10,center=false,$fn=facets);   
        }; 
        translate([(box_width/2),-10,-5])
            cylinder(h=topbottom_thickness+20,r=2,center=false,$fn=facets);    
        translate([(box_width/2),box_depth+10,-5])
            cylinder(h=topbottom_thickness+20,r=2,center=false,$fn=facets);   
    };
};

module generate_end_screw_mounts() {
    difference() {
        union(){        
            translate([-9,(box_depth/2)-10,0])
                cube([box_width+18,20,topbottom_thickness]);
            translate([-9,box_depth/2,0])
                cylinder(h=topbottom_thickness+1,r=10,center=false,$fn=facets);    
            translate([box_width+9,box_depth/2,0])
                cylinder(h=topbottom_thickness+1,r=10,center=false,$fn=facets);   
        }; 
        translate([-10,box_depth/2,-5])
            cylinder(h=topbottom_thickness+20,r=2,center=false,$fn=facets);    
        translate([(box_width+10),box_depth/2,-5])
            cylinder(h=topbottom_thickness+20,r=2,center=false,$fn=facets);   
    };

};

// Comment out what you don't want to generate //

union(){
    generate_Econet_Enclosure();
    generate_end_screw_mounts();
//    generate_side_screw_mounts();
};
/*
translate([0,0,100])
union(){
   generate_Econet_Lid();
    generate_end_screw_mounts();
    generate_side_screw_mounts();
};*/