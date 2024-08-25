function Point(x, y){
    this.x = x || 0;
    this.y = y || 0;
};
Point.prototype.x = null;
Point.prototype.y = null;
Point.prototype.add = function(v){
    return new Point(this.x + v.x, this.y + v.y);
};
Point.prototype.clone = function(){
    return new Point(this.x, this.y);
};
Point.prototype.degreesTo = function(v){
    var dx = this.x - v.x;
    var dy = this.y - v.y;
    var angle = Math.atan2(dy, dx); // radians
    return angle * (180 / Math.PI); // degrees
};
Point.prototype.distance = function(v){
    var x = this.x - v.x;
    var y = this.y - v.y;
    return Math.sqrt(x * x + y * y);
};
Point.prototype.equals = function(toCompare){
    return this.x == toCompare.x && this.y == toCompare.y;
};
Point.prototype.interpolate = function(v, f){
    return new Point((this.x + v.x) * f, (this.y + v.y) * f);
};
Point.prototype.length = function(){
    return Math.sqrt(this.x * this.x + this.y * this.y);
};
Point.prototype.normalize = function(thickness){
    var l = this.length();
    this.x = this.x / l * thickness;
    this.y = this.y / l * thickness;
};
Point.prototype.orbit = function(origin, arcWidth, arcHeight, degrees){
    var radians = degrees * (Math.PI / 180);
    this.x = origin.x + arcWidth * Math.cos(radians);
    this.y = origin.y + arcHeight * Math.sin(radians);
};
Point.prototype.offset = function(dx, dy){
    this.x += dx;
    this.y += dy;
};
Point.prototype.subtract = function(v){
    return new Point(this.x - v.x, this.y - v.y);
};
Point.prototype.toString = function(){
    return "(x=" + this.x + ", y=" + this.y + ")";
};
 
Point.interpolate = function(pt1, pt2, f){
    return new Point((pt1.x + pt2.x) * f, (pt1.y + pt2.y) * f);
};
Point.polar = function(len, angle){
    return new Point(len * Math.cos(angle), len * Math.sin(angle));
};
Point.distance = function(pt1, pt2){
    var x = pt1.x - pt2.x;
    var y = pt1.y - pt2.y;
    return Math.sqrt(x * x + y * y);
};

Point.toRadians = function( angle ){
    return  angle*(Math.PI/180) ; 
};

Point.toDegrees = function( radian ){
    return radian *(180/Math.PI) ; 
};

Point.calcPoint = function(  point,   angle,   dist){
    var x = point.x + Math.sin(Point.toRadians(angle))*dist;
    var y = point.y + Math.cos(Point.toRadians(angle))*dist;
    return new Point(x, y);
};

Point.calcAngle = function(  point1,   point2){
    return Point.toDegrees(Math.atan2(point2.x-point1.x,point2.y-point1.y));
    
};
 

function R9Rect(x, y, width, height){
    this.x = x || 0;
    this.y = y || 0;
	this.width = width || 0;
	this.height = height || 0;
};
R9Rect.prototype.x = null;
R9Rect.prototype.y = null; 
R9Rect.prototype.width = null; 
R9Rect.prototype.height = null; 
R9Rect.prototype.clone = function(){
    return new R9Rect(this.x, this.y, this.width, this.height);
};
R9Rect.prototype.contains = function(x, y){
   return this.x < x && this.x + this.width > x 
            && this.y < y && this.y + this.height > y;   
};


