include <variables.scad>


module center() 
{
	difference() {
    	difference() 
	    {
	        union() 
	        {
	            difference() {
                
                    difference() 
                    {
                        cubie();
                        translate([CUBIE,0,0])
                            icore();
        
                    }
                    
                    
                    /*translate([0,0,0])
                    scale([0.8,0.8,0.8])
                    difference() 
                    {
                        cubie();
                        translate([CUBIE,0,0])
                            icore();
        
                    }*/
                }                
                
	            rotate([0,90,0])
	                cylinder(CUBIE,r1=INNER,r2=INNER,center=true);
	            if (WITH_RAFT)
	                raft();
	        }
	
	        rotate([0,90,0]) 
	        {
                difference() {
                    cylinder(CUBIE+0.5,r=3,center=true);
                    translate([3-0.5+2.5,0,0]) cube([5,8,CUBIE+0.5],center=true);
                }
                /*union() 
	            {
	                cylinder(CUBIE+0.5,r1=SCREW_BODY+GAP,r2=SCREW_BODY+GAP,center=true);
	
	                translate([0,0,CUBIE/2-1/2-3])
	                    cylinder(1.5,r1=SPRING+GAP,r2=SCREW_BODY+GAP,center=true);
	
	
	                translate([0,0,CUBIE/2-1/2-9.5])
	                    cylinder(1,r1=SCREW_HEAD+GAP,r2=SPRING+GAP,center=true);
	
	
	                translate([0,0,-4.25/2])
	                    cylinder(CUBIE-4.25,r1=SPRING+GAP,r2=SPRING+GAP,center=true);
	
	                translate([0,0,-10.5/2])
	                    cylinder(CUBIE-10,r1=SCREW_HEAD+GAP,r2=SCREW_HEAD+GAP,center=true); 
	            }*/
	        }
	    }
		translate([-CUBIE/2 + tile_height-0.01,0])
		rotate(v=[0,1,0], a=90)
		tile(tile_length*1.05, tile_height);		
	}
}
center();
