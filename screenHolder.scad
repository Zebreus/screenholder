// An alternative bracket for a defender carholder 202

holderHeight = 40;
holderLength = 100;
thickness = 2.5;
ballRadius = 10.5;
beamSize = (ballRadius+thickness)*2;
beamHoleLength = 40;
holeRadius = 8.5;
ballCylinderLength = 5;

module mirror_copy(plane, center = [0,0,0]){
    children();
    translate(center)
    mirror(plane)
    translate(-center)
    children();
}

module rotate_copy(angle, axis, center = [0,0,0]){
    children();
    translate(center)
    mirror(plane)
    translate(-center)
    children();
}

module fixedMount(width = 34, length = 46) {
    widthDistance = 23.4;
    lengthDistance = 36.1;
    holderDepth = 5;
    holderWidth = 5;
    holderLength = 5.5;
    holderRadius = 0.55;
    fixedMountAngle = -37;
    
    cube([width,length,thickness]);
    
    translate([width/2,length/2,thickness])
    mirror_copy([1,0,0])
    mirror_copy([0,1,0])
    translate([(-widthDistance)/2,(-lengthDistance)/2,0]){
        cube([thickness,holderLength,holderDepth]);
        translate([0,0,holderDepth-thickness])
        translate([thickness,0,0])
        rotate(fixedMountAngle,[0,1,0])
        cube([holderWidth-thickness, holderLength, thickness]);
        translate([thickness,holderLength/2,0])
        cylinder($fa=0.1, $fs= 0.1, h=holderDepth, r=holderRadius);
   }
}

module fixedMountMount(width = 34, length = 46) {
    mountHeight = holderHeight - thickness;
    
    translate([-(width-beamSize)/2,-(length-beamSize)/2,0]){
        difference(){
        cube([width, length, mountHeight]);
            
            mirror_copy([1,0,0],[width/2,0,0])
            translate([width-(width-beamSize)/2,0,0])
            rotate(asin(((width-beamSize)/2) / mountHeight), [0,1,0])
            cube([width, length, mountHeight*2]);
            
            mirror_copy([0,1,0],[0,length/2,0])
            translate([0,length-(length-beamSize)/2,0])
            rotate(asin(((length-beamSize)/2) / mountHeight), [-1,0,0])
            cube([width, length, mountHeight*2]);
        }
        translate([0,0,mountHeight])
        fixedMount(width, length);
    }
}

module ballMount(ballRadius = 10.5, extraHeight = 4){
    
    difference(){
    cylinder(extraHeight, r=ballRadius+thickness);
    cylinder(extraHeight, r=ballRadius);
    }
    
    translate([0,0,extraHeight])
    difference(){
        sphere(r = ballRadius+thickness);
        sphere(r= ballRadius);

        translate(-[(ballRadius+thickness),(ballRadius+thickness),(ballRadius+thickness)*2])
        cube([(ballRadius+thickness)*2,(ballRadius+thickness)*2,(ballRadius+thickness)*2]);
        cylinder(h=ballRadius+thickness, r=holeRadius);
        
        translate([-(ballRadius+thickness),-(ballRadius+thickness),ballRadius*sin(acos(holeRadius/ballRadius))])
        cube([(ballRadius+thickness)*2,(ballRadius+thickness)*2,(ballRadius+thickness)*2]); 
    }
}

module ballMountMount(){
    beamExtraStability = thickness;
    beamLength = holderLength-ballCylinderLength;
    
    translate([0,ballCylinderLength,0])
    difference(){
    cube([beamSize,beamLength,beamSize]);
        translate([thickness, beamExtraStability, beamSize/2])
        cube([ballRadius*2,beamHoleLength,beamSize/2+1]);
        
        translate([beamSize/2, 0, beamSize/2])
        rotate(-90,[1,0,0])
        cylinder(h = beamHoleLength+beamExtraStability, r = ballRadius);
    }
    
    translate([beamSize/2, ballCylinderLength, beamSize/2])
    rotate(90,[1,0,0])
    ballMount(extraHeight = ballCylinderLength);
}

module screenHolder(){
    
    ballMountMount();
    translate([0,holderLength-beamSize,0])
    fixedMountMount();
}

$fa = $preview ? 12 : 3 ;
$fs = $preview ? 1 : 0.1 ;

screenHolder();