
////////to apply quaternion rotation on movement.scd at the end after dimensional rotation oscillator of elevation apply quaternion on azimuth and elevation with rotation axis x, y or both and then put new az, el values in degrees to VBAP

sphere= Spherical(1,azimuth,elevation); ////point coordinate vector

v=Quaternion(0,sphere.x,sphere.y,sphere.z);/// vector as quaternion

	components=[0,1,0].normalizeSum.sqrt;

	i=Quaternion(0, components.[0], 0, 0);
	j=Quaternion(0, 0, components.[1], 0);
	k=Quaternion(0, 0, 0, components.[2]);


rot=(cos(angle.degrad)+(sin(angle.degrad)*(i+j+k))); ////rotation vector with angle of rotatio and ijk xyz normalized components
v1=rot*v*rot.conjugate;

//////////////////////with angle as argument, (along with Quaternion file
	axis=i+j+k;
q1=((axis*exp(Complex(0,1)*angle).imag)+exp(Complex(0,1)*angle).real); v1=q1*v1*q1.conjugate;


///////////use distance .distance between quaternions pl1 points as some kind of modulation
(
var q1,q2,dist;
q1=Quaternion(0,1,1,1); q2=Quaternion(0,0,0,0);
dist=q1.distance(q2);
dist.postln;)