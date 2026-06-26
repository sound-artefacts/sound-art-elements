(
	(	{~points = ~az.collect({ |az, i|Spherical(1, az, ~el[i]);})}.value;);

	(	{var n=1.neg,neighbors;
		~neighbors=[];
		(128).do{n=n+1;
		~center = Spherical(1, ~azc.[n], ~elc.[n] );
~threshold = 	pi/100;
	neighbors = ~points.select { |pt|
		Quaternion(0,pt.x,pt.y,pt.z).distance(Quaternion(0,~center.x,~center.y,~center.z)) < ~threshold};
			~neighbors=~neighbors.add(neighbors);
}}.value;);

	~thetaArray = ~neighbors.flatten.collect(_.theta);
~phiArray   = ~neighbors.flatten.collect(_.phi);


		)