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
RJ45_present=true; // set to false if generating for DIN-only hub

wall_thickness=2;
topbottom_thickness=3;

DIN_Height=topbottom_thickness+PCB_StandOff+(PCB_Height/2)+1;

//box spec
screw_offset=PCB_ScrewOffset+wall_thickness;
box_width=PCB_Width+(2*wall_thickness);
box_depth=PCB_Depth+(2*wall_thickness);
box_height=(2*topbottom_thickness)+PCB_StandOff+PCB_Height;

// Acorn Owl

module render_dot(x,y,radius,spacing,height) {
  translate([x*spacing*1.3,y*spacing*-1.3,0]) cylinder(h=height,r=radius, $fn=facets);
};

module render_row(row_num,dot_array,radius,spacing,height) {
    for (a=dot_array) {
            render_dot(a,row_num,radius,spacing,height);
    };
};

// render the Owl...

module render_owl(radius,spacing,height) {
    render_row(1,[1,3,5,7,9,11,13,15,17],radius,spacing,height);
    render_row(2,[2,8,10,16],radius,spacing,height);
    render_row(3,[1,5,9,13,17],radius,spacing,height);
    render_row(4,[4,6,12,14],radius,spacing,height);
    render_row(5,[1,5,13,17],radius,spacing,height);
    render_row(6,[2,8,10,16],radius,spacing,height);
    render_row(7,[1,3,9,15,17],radius,spacing,height);
    render_row(8,[2,4,14],radius,spacing,height);
    render_row(9,[1,3,5,7,9,11,13,17],radius,spacing,height);
    render_row(10,[2,4,6,8],radius,spacing,height);
    render_row(11,[1,3,5,7,9,17],radius,spacing,height);
    render_row(12,[2,4,6,8],radius,spacing,height);
    render_row(13,[3,5,7,9,17],radius,spacing,height);
    render_row(14,[4,6,8,10],radius,spacing,height);
    render_row(15,[5,7,9,11,17],radius,spacing,height);
    render_row(16,[6,8,10,12],radius,spacing,height);
    render_row(17,[7,9,11,13,17],radius,spacing,height);
    render_row(18,[8,12,14],radius,spacing,height);
    render_row(19,[7,11,15,17],radius,spacing,height);
    render_row(20,[2,4,6,8,10,16],radius,spacing,height);
    render_row(21,[17],radius,spacing,height);
};

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
            
            //generate box
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
        }; 
        
        // create screw holes in standoffs
        translate([screw_offset,screw_offset,screwhole_offset])
            cylinder(h = standoff_height+(base_thickness+2), r = 1, $fn = facets);
        translate([screw_offset,depth-screw_offset,screwhole_offset]) 
            cylinder(h = standoff_height+(base_thickness+2), r = 1, $fn = facets);
        translate([width-screw_offset,depth-screw_offset,screwhole_offset])
            cylinder(h = standoff_height+(base_thickness+2), r = 1, $fn = facets);
        translate([width-screw_offset,screw_offset,screwhole_offset])
            cylinder(h = standoff_height+(base_thickness+2), r = 1, $fn = facets);
    };
}

module create_ports(RJ45) {
    
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
        create_ports(RJ45_present);
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
    difference() {
        union() {
            cube([box_width-2,box_depth-2,3+1.5]);
            difference() {
                translate([0,box_depth/2-1,1.5])
                    rotate([0,90,0])
                        cylinder(h=box_width-2,r=3,center = false, $fn = facets);
            };
        };
        translate([3,3,-3]) {
            cube([box_width-8,box_depth-8,3.5]);
        };
        translate([3,60,3.5]){
            render_owl(0.8,1,3);
        };
        translate([(box_width/2),15,3.5]){
            linear_extrude(3.5) {
                text("Econet Hub", size = 10, font = "Segoe UI Black", halign = "center", valign = "center", $fn = facets);
            };
        };
        translate([-1,box_depth/2-1,1.5])
            rotate([0,90,0])
                cylinder(h=box_width+10,r=1,center = false, $fn = facets);
    };    
};

module generate_side_screw_mounts() {
    difference() {
        union(){        
            translate([(box_width/2)-10,-9,0])
                cube([20,box_depth+20,topbottom_thickness]);
            translate([(box_width/2),-9,0])
                cylinder(h=topbottom_thickness+1,r=10,center=false,$fn=facets);    
            translate([(box_width/2),box_depth+9,0])
                cylinder(h=topbottom_thickness+1,r=10,center=false,$fn=facets);   
        }; 
        translate([(box_width/2),-9,-5])
            cylinder(h=topbottom_thickness+20,r=2,center=false,$fn=facets);    
        translate([(box_width/2),box_depth+9,-5])
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
        translate([-9,box_depth/2,-5])
            cylinder(h=topbottom_thickness+20,r=2,center=false,$fn=facets);    
        translate([(box_width+9),box_depth/2,-5])
            cylinder(h=topbottom_thickness+20,r=2,center=false,$fn=facets);   
    };

};

// Comment out what you don't want to generate //

union(){
    generate_Econet_Enclosure();
    generate_end_screw_mounts();
    generate_side_screw_mounts();
};

translate([1,1,box_height-1.5+20])
union(){
    generate_Econet_Lid();
};