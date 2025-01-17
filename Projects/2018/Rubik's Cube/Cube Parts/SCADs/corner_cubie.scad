include <variables.scad>

HOLE_RADIUS = 1;
HOLE_HEIGHT = 20;

module full_corner_cubie() {
    difference() {    
        difference() {
            difference() {
                cubie();
                translate([0,-CUBIE/2+tile_height,0])
                rotate(v=[1,0,0],a=90)
                tile(tile_length*1.05,tile_height*100);
            }
            translate([-CUBIE/2+tile_height,0,0])
            rotate(v=[0,1,0],a=90)
            tile(tile_length*1.05,tile_height*100);
        }
        translate([0,0,CUBIE/2-tile_height])
        tile(tile_length*1.05,tile_height*100);
    }
}

module half_corner_cubie() {
    difference() {
        full_corner_cubie();
        translate([0,0,CUBIE/4])
        cube([CUBIE,CUBIE,CUBIE/2],center=true);
    }
}

module corner_cubie() {
    difference() {
        half_corner_cubie();
        union() {
            translate([CUBIE/2-5.5,CUBIE/2-5.5,0]) cylinder(r=HOLE_RADIUS, h=HOLE_HEIGHT, center=true);
            translate([-(CUBIE/2-5.5),CUBIE/2-5.5,0]) cylinder(r=HOLE_RADIUS, h=HOLE_HEIGHT, center=true);
            translate([-(CUBIE/2-5.5),-(CUBIE/2-5.5),0]) cylinder(r=HOLE_RADIUS, h=HOLE_HEIGHT, center=true);
            translate([CUBIE/2-5.5,-(CUBIE/2-5.5),0]) cylinder(r=HOLE_RADIUS, h=HOLE_HEIGHT, center=true);
        }
    }
}

corner_cubie();