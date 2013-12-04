package openlib.geom;

	/**
    * http://en.nicoptere.net/
    * @author nicoptere
    */
        
	import flash.geom.Point;

	class Spline 
	{
			static public var _precision:Float = .1;
			
			/**
			 * calculates the cubic spline passing through the handles
			 * @param       handles a Array<Point> of the key Points to smooth
			 * @param       loop wether the curve should loop default false
			 * @param       precision a Float between Float.MIN_VALUE (extremely precise ) & 1 (coarse) default is 0.1 I recomend not to go under 0.01
			 * @return an array of smoothed Points
			 */
			public static function getCubicPath(handles:Array<Point>, loop:Bool = false, precision:Float =.1 ):Array<Point>
			{
				
					//curve's smoothness 
					_precision = precision;
			
					if ( loop ) {
							handles.shift();
							handles.pop();
					}
					
					//output values
					var tmp:Array<Point> = new Array<Point>();
			
					var i:Int = 0;
			
					var p0:Point = new Point(0,0);
					var p1:Point = new Point(0,0);
					var p2:Point = new Point(0,0);
							
					while(i < handles.length) {
			
							//p0
							if(i == 0) {
									if ( loop == true ) {
											p0.x = (handles[handles.length - 1].x + handles[i].x)/2;
											p0.y = (handles[handles.length - 1].y + handles[i].y)/2;
									} else {
											p0.x = handles[i].x;
											p0.y = handles[i].y;
									}
							} else {
									p0.x = ( handles[i - 1].x + handles[i].x ) / 2;
									p0.y = ( handles[i - 1].y + handles[i].y ) / 2;
							}
							//p1
							p1.x = handles[i].x;
							p1.y = handles[i].y;
			
							//p2    
							if( i == handles.length - 1 ) {
									if (loop == true) {
											p2.x = (handles[i].x + handles[0].x) / 2;
											p2.y = (handles[i].y + handles[0].y) / 2;
									} else {
											p2.x = handles[i].x;
											p2.y = handles[i].y;
									}
							} else {
									p2.x = (handles[i + 1].x + handles[ i ].x ) / 2;
									p2.y = (handles[i + 1].y + handles[ i ].y ) / 2;
							}
							
							var t:Float;
							var t2:Float;
							var t3:Float;
							var t4:Float;
							var X:Float;
							var Y:Float;
			
							var j:Float = 0;
							while(j < 1) {
									t  = 1 - j;
									t2 = t * t;
									t3 = 2 * j * t;
									t4 = j * j;
									
									X = t2 * p0.x + t3 * p1.x + t4 * p2.x;
									Y = t2 * p0.y + t3 * p1.y + t4 * p2.y;
			
									tmp.push( new Point( X, Y ) );
									j += _precision;
							}
							i++;
					}
					return tmp;
			}
			
			public static function getQuadraticBezier(t:Float, p0:Point, p1:Point, p2:Point, p3:Point): Point
			{
					var X:Float = p0.x * Math.pow((1 - t), 3); 
					X += 3 * p1.x * t * Math.pow((1 - t), 2);
					X += 3 * p2.x * ( t * t ) * (1 - t);
					X += p3.x * ( t*t*t );
					
					var Y:Float = p0.y * Math.pow((1 - t), 3); 
					Y += 3 * p1.y * t * Math.pow((1 - t), 2);
					Y += 3 * p2.y * ( t * t ) * ( 1 - t);
					Y += p3.y * ( t*t*t );
					
					return new Point( X, Y );
			}
			
			
			public static function getCubicBezier(t:Float, p0:Point, p1:Point, p2:Point): Point
			{
					var X:Float = p0.x * ( (1 - t) * (1 - t) ); 
					X += 2 * t * ( 1 - t ) * p1.x;
					X += p2.x * ( t * t );
					
					var Y:Float = p0.y * ( (1 - t) * (1 - t) ); 
					Y += 2 * t * ( 1 - t ) * p1.y;
					Y += p2.y * ( t * t );
					
					return new Point( X, Y );
			}
	}