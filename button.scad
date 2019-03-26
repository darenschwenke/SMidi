
// SMidi OpenSCAD source.
// Project Home: https://hackaday.io/project/25561
// Author: https://hackaday.io/daren
//
// Creative Commons License exists for this work. You may copy and alter the content
// of this file for private use only, and distribute it only with the associated
// Blooming Rose content. This license must be included with the file and content.
// For a copy of the current license, please visit http://creativecommons.org/licenses/by/2.0/

$fn=120;
extra=.01;

radius=25;
height=12;
top_thickness=1.0;
top_inset=4.0;
wall_thickness=0.48;
spring_thickness=0.6;

pad_thickness=1;
pad_clearance=1;

base_thickness=.8;

wire_radius=.7;
text_depth=.5;


//button();
//pad();
//base_cover();

//cross_section_view("1");
exploded_view();



module cross_section_view(top_text) {
	intersection() {
		exploded_view();
		cube([100,wall_thickness,100],center=true);
	}
}

module exploded_view() {
	button();
	translate([0,0,20]) pad();
	translate([0,0,40]) base_cover();
}

module button(top_text) {
	difference() {
		union() {
			button_center(top_text);
			pop_hinge();
			pop_spring();
			base();
		}
		//text_inlay(top_text);
	}
}

module dotstar_60() {
	union() {
		translate([0,0,.9]) cube([5.4,5.4,1.8],center=true); 
		translate([0,0,.5]) cube([5.4,6.9,1],center=true); 
		translate([0,0,.25]) cube([17.5,13,.5],center=true);
		translate([-8.25,0,-1]) rotate([90,0,0]) cylinder(r=2,h=13,center=true); 
		translate([8.25,0,-1]) rotate([90,0,0]) cylinder(r=2,h=13,center=true); 
	}
}

module button_center(top_text) {
	difference() {
		union() {
			translate([0,0,height-base_thickness-pad_thickness*4-pad_clearance-extra]) cylinder(r=radius-top_inset-wall_thickness,h=pad_thickness*2+extra*2,center=true);
			translate([0,0,height/4+height/32]) cylinder(r1=radius-top_inset*1.5,r2=radius-top_inset+wall_thickness/2,h=height/2+height/16,center=true);
		}	
		union() {
			translate([0,0,height-base_thickness-pad_thickness*4-pad_clearance]) scale([1,1,5]) translate([0,0,height/3]) cylinder(r=radius-top_inset*1.5-wall_thickness,h=height/1.5,center=true);
			translate([0,0,height/4+top_thickness-extra]) cylinder(r1=radius-top_inset*1.8-wall_thickness,r2=radius-top_inset*2.2,h=height/2,center=true);
		}
	}
}

module pop_spring() {
	difference() {
		translate([0,0,height/2+height/4-base_thickness]) { 
			cylinder(r1=radius-top_inset*1.2+spring_thickness/2-wall_thickness,r2=radius-top_inset*.6+spring_thickness/2-wall_thickness,h=height/2-base_thickness/2,center=true);
		}
		translate([0,0,height/2+height/4-base_thickness]) {
			cylinder(r1=radius-top_inset*1.2-spring_thickness/2-wall_thickness,r2=radius-top_inset*.6-spring_thickness/2-wall_thickness,h=height/2-base_thickness/2+extra*2,center=true);
		}
	}
}
	
module pop_hinge() {
	difference() {
		translate([0,0,height/4+height/32]) { 
			cylinder(r2=radius-top_inset+wall_thickness/2,r1=radius+wall_thickness/2,h=height/2+height/16,center=true);
		}
		translate([0,0,height/4+height/32]) {
			cylinder(r2=radius-top_inset-wall_thickness/2,r1=radius-wall_thickness/2,h=height/2+height/16+extra,center=true);
		}
	}
}

module pad() {
	difference() {
		intersection() {
			translate([0,0,height/3]) cylinder(r=radius-top_inset*1.5-wall_thickness,h=height/1.5,center=true);
			translate([0,0,-radius*4+pad_thickness*3]) sphere(r=radius*4,center=true,$fn=300);
		}
		translate([0,0,height/3+.25]) cylinder(r1=4.5,r2=2.3,h=height/1.5+extra,center=true);
	}
}

module base() {
	difference() {
		union() {
			difference() {
				translate([0,0,base_thickness/2]) cylinder(r=radius*1.3,h=base_thickness,center=true);
				translate([0,0,height/2]) cylinder(r=radius-wall_thickness/2,h=height+extra,center=true);
			}
			difference() {
				translate([0,0,base_thickness]) cylinder(r1=radius*1.5,r2=radius+wall_thickness,h=base_thickness*2,center=true);
				translate([0,0,height/2]) cylinder(r=radius+wall_thickness,h=height+extra,center=true);
			}
			difference() {
				translate([0,0,base_thickness*2]) cylinder(r1=radius*1.4,r2=radius,h=base_thickness*4,center=true);
				translate([0,0,height/4]) cylinder(r1=radius*1.15,r2=radius*1.07,h=height/2+extra,center=true);
			}
		}
	}
}

module base_cover() {
	difference() {

		translate([0,0,base_thickness]) cylinder(r1=radius+top_inset-base_thickness*1.5,r2=radius+top_inset-base_thickness*2.2,h=base_thickness*2,center=true);
		translate([0,0,base_thickness*2+extra]) rotate([180,0,0]) dotstar_60();
		translate([radius,0,base_thickness*2])rotate([88,0,90]) wire_path(radius+top_inset*2);
		translate([-radius,0,base_thickness*2])rotate([92,0,90]) wire_path(radius+top_inset*2);
		translate([radius+top_inset/2+extra*2,0,base_thickness*2]) rotate ([0,0,90]) wire_path(radius+top_inset*2);
		translate([radius/2+top_inset,0,height/8]) cylinder(r=.9,h=height/4,center=true);
	}
}

module wire_path(wire_length) {
	hull() {
		translate([wire_radius*4,0,0]) cylinder(r=wire_radius,h=wire_length,center=true);
		translate([-wire_radius*4,0,0]) cylinder(r=wire_radius,h=wire_length,center=true);
		
	}
}

module text_inlay(top_text) {
	translate([0,0,top_thickness-text_depth+extra]) {
		linear_extrude(text_depth+extra*2) {
			//text(font="FreeMono", text=top_text,halign="center",valign="center",size=(width-top_inset)*.9);
			rotate([0,180,0]) text(font="FreeMono:style=bold", text=top_text,halign="center",valign="center",size=(radius-top_inset));
		}
	}
}
