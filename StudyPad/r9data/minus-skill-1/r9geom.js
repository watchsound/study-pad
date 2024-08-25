(function() {
    /**
 
     * var star = new Kinetic.R9Star({
     *   startX: 100,
	 *   startY: 100,
     *   endX: 200,
	 *   endY:  200,
     *   headend: 0|1|2  startONly|endONly|bothends
     *   stroke: 'black',
     *   strokeWidth: 4
     * });
     */
    Kinetic.R9Star = function(config) {
        this.___init(config);
    };

    Kinetic.R9Star.prototype = {
        ___init: function(config) {
            // call super constructor
            Kinetic.Shape.call(this, config);
            this.className = 'R9Star';
            this.sceneFunc(this._sceneFunc);
        },
        _sceneFunc: function(context) {
            var startX = this.startX(),
                startY = this.startY(),
				endX = this.endX(),
				endY = this.endY(),
				headEnd = this.headend() ;

			var start = new Point(startX, startY);
            var end = new Point(endX, endY);
			var angle = Point.calcAngle(start,end);
           
 		 context.beginPath();
         context.moveTo(start.x, start.y);
		
         context.lineTo(end.x, end.y);

        if(headEnd ==0|| headEnd == 2) {
            var  ap1 = Point.calcPoint(start, angle + 45, 10);
			 context.moveTo(start.x, start.y);
			 context.lineTo(ap1.x, ap1.y);
            var  ap2 = Point.calcPoint(start, angle - 45, 10);
		     context.moveTo(start.x, start.y);
			 context.lineTo(ap2.x, ap2.y);
        }
        if(headEnd ==1 || headEnd == 2) {
		     var  ap1 = Point.calcPoint(end, angle - 45-90, 10);
			 context.moveTo(end.x, end.y);
			 context.lineTo(ap1.x, ap1.y);
			 
			  var  ap2 = Point.calcPoint(end, angle  + 45+90, 10);
			 context.moveTo(end.x, end.y);
			 context.lineTo(ap2.x, ap2.y); 
        }
	/*	 var linewidth =  this.strokeWitdh();
		 if ( linewidth )
		     context.lineWidth = linewidth;
		  var stroke =  this.stroke();
		  if ( stroke )
              context.strokeStyle =  stroke;
			*/ 
           context.fillStrokeShape(this);
        }
    };
    Kinetic.Util.extend(Kinetic.R9Star, Kinetic.Shape);

    // add getters setters
    Kinetic.Factory.addGetterSetter(Kinetic.R9Star, 'startX', 0);
    Kinetic.Factory.addGetterSetter(Kinetic.R9Star, 'startY', 0);
    Kinetic.Factory.addGetterSetter(Kinetic.R9Star, 'endX', 0);
    Kinetic.Factory.addGetterSetter(Kinetic.R9Star, 'endY', 0);
    Kinetic.Factory.addGetterSetter(Kinetic.R9Star, 'headend', 0);
    Kinetic.Factory.addGetterSetter(Kinetic.R9Star, 'stroke', 'black');
    Kinetic.Factory.addGetterSetter(Kinetic.R9Star, 'strokeWidth', 1);
 
     

    Kinetic.Collection.mapMethods(Kinetic.R9Star);
})();
(function() {
    /**
 
     * var star = new Kinetic.R9Coord({
     *   startX: 100,
	 *   startY: 100,
     *   endX: 200,
	 *   endY:  200,
     *   headend: 0|1|2  startONly|endONly|bothends
     *   stroke: 'black',
     *   strokeWidth: 4
     * });
     */
    Kinetic.R9Coord = function(config) {
        this.___init(config);
    };

    Kinetic.R9Coord.prototype = {
        ___init: function(config) {
            // call super constructor
            Kinetic.Shape.call(this, config);
            this.className = 'R9Coord';
            this.sceneFunc(this._sceneFunc);
        },
        _sceneFunc: function(context) {
            var startX = this.startX(),
                startY = this.startY(),
				endX = this.endX(),
				endY = this.endY(),
				headEnd = this.headend() ;

			var start = new Point(startX, startY);
            var end = new Point(endX, endY);
			var angle = Point.calcAngle(start,end);
           
 		 context.beginPath();
         context.moveTo(start.x, start.y);
		
         context.lineTo(end.x, end.y);
		 
		 var isVertical =  Math.abs( startX - endX ) < Math.abs(startY - endY) ;
         var tick_length = 5;
         var tick_dist = 10;
		 
		  if ( isVertical ){
        	var  startend = startY > endY;
        	var curX =  endX ;
        	var curY =  startend ? startY - tick_length : endY - tick_length;
        	var topY = startend ?  endY : startY;
        	while ( curY >  topY + tick_dist  &&  curY > 0){
        	 	  context.moveTo(curX, curY);
		          context.lineTo(curX - tick_length, curY);
		  		  curY = curY - tick_dist;
        	}
        } else {
        	var startend =  startX < endX;
        	var curY = startY ;
        	var curX =  startend ?  startX + tick_length :  endX + tick_length;
        	var rightX = startend ?  endX : startX;
        	while( curX < rightX - tick_dist && curX < 2000 ){
        		  context.moveTo(curX, curY);
		          context.lineTo(curX, curY - tick_length);
        		 curX = curX + tick_dist;
        	}
        }


        if(headEnd ==0|| headEnd == 2) {
            var  ap1 = Point.calcPoint(start, angle + 45, 10);
			 context.moveTo(start.x, start.y);
			 context.lineTo(ap1.x, ap1.y);
            var  ap2 = Point.calcPoint(start, angle - 45, 10);
		     context.moveTo(start.x, start.y);
			 context.lineTo(ap2.x, ap2.y);
        }
        if(headEnd ==1 || headEnd == 2) {
		     var  ap1 = Point.calcPoint(end, angle - 45-90, 10);
			 context.moveTo(end.x, end.y);
			 context.lineTo(ap1.x, ap1.y);
			 
			  var  ap2 = Point.calcPoint(end, angle  + 45+90, 10);
			 context.moveTo(end.x, end.y);
			 context.lineTo(ap2.x, ap2.y); 
        }
	/*	 var linewidth =  this.strokeWitdh();
		 if ( linewidth )
		     context.lineWidth = linewidth;
		  var stroke =  this.stroke();
		  if ( stroke )
              context.strokeStyle =  stroke;
			*/ 
            context.fillStrokeShape(this);
        }
    };
    Kinetic.Util.extend(Kinetic.R9Coord, Kinetic.Shape);

    // add getters setters
    Kinetic.Factory.addGetterSetter(Kinetic.R9Coord, 'startX', 0);
    Kinetic.Factory.addGetterSetter(Kinetic.R9Coord, 'startY', 0);
    Kinetic.Factory.addGetterSetter(Kinetic.R9Coord, 'endX', 0);
    Kinetic.Factory.addGetterSetter(Kinetic.R9Coord, 'endY', 0);
    Kinetic.Factory.addGetterSetter(Kinetic.R9Coord, 'headend', 0);
    Kinetic.Factory.addGetterSetter(Kinetic.R9Coord, 'stroke', 'black');
    Kinetic.Factory.addGetterSetter(Kinetic.R9Coord, 'strokeWidth', 1);
 
     

    Kinetic.Collection.mapMethods(Kinetic.R9Coord);
})();

(function() {
    /**
 
     * var star = new Kinetic.R9Dialog({
     *   startX: 100,
	 *   startY: 100,
     *   endX: 200,
	 *   endY:  200,
	 *   title :
     *   message1:  
     *   message2:  
     *   message3:  
     * });
     */
    Kinetic.R9Dialog = function(config) {
        this.___init(config);
    };

    Kinetic.R9Dialog.prototype = {
        ___init: function(config) {
            // call super constructor
            Kinetic.Shape.call(this, config);
            this.className = 'R9Dialog';
            this.sceneFunc(this._sceneFunc);  
        },
        _sceneFunc: function(context) {
            var startX = 0,
                startY = 0,
				title = this.title(),
				message1 = this.message1(),  
				message2 = this.message2(),  
				message3 = this.message3() ,
				fontSize = this.fontSize();

           var dx  = startX;
		   var dy  = startY;
		   var dw  = 0;
		   var dh  = 0;
		   var height = 40;
		   context._context.font =  fontSize + 'pt Calibri';
           context._context.textAlign = 'center';
          // context._context.fillStyle = '#555';	
            var metrics = context._context.measureText(title);
             var width = metrics.width;
	         dh += height;
		     if ( dw < width )
			     dw = width;
             metrics = context._context.measureText(message1);
               width = metrics.width;
              dh += height;			   
			    if ( dw < width )
			     dw = width;
		    metrics = context._context.measureText(message2);
               width = metrics.width;
	              dh += height;
			    if ( dw < width )
			     dw = width;
			  metrics = context._context.measureText(message3);
               width = metrics.width;
	             dh += height; 
			    if ( dw < width )
			     dw = width;
			    
			   
	  context.beginPath();
      context.rect(dx-20 - dw/2, dy-20, dw+40, dh+40);
     context._context.fillStyle = 'yellow';
       context.fill();
      context.lineWidth = 7;
      context._context.strokeStyle = 'black';
	   context._context.fillStyle = 'black';
     
				 
		    context.fillText(title, startX, startY);  
		   	 context.moveTo(dx-20 - dw/2, startY +  height /2 );
			 context.lineTo(dx-20 - dw/2 + dw+40, startY +   height /2);
			 startY = startY + height +  height/2 ;
            context.fillText(message1, startX, startY); 
		    startY = startY + height  ;
			context.fillText(message2, startX, startY);
		 	startY = startY + height  ;
		   context.fillText(message3, startX, startY);
			 
		 
	 
			 
             context.fillStrokeShape(this);
        }
    };
    Kinetic.Util.extend(Kinetic.R9Dialog, Kinetic.Shape);

    // add getters setters
    Kinetic.Factory.addGetterSetter(Kinetic.R9Dialog, 'x', 0);
    Kinetic.Factory.addGetterSetter(Kinetic.R9Dialog, 'y', 0);
    Kinetic.Factory.addGetterSetter(Kinetic.R9Dialog, 'stroke', 'black');
    Kinetic.Factory.addGetterSetter(Kinetic.R9Dialog, 'strokeWidth', 1);
	 Kinetic.Factory.addGetterSetter(Kinetic.R9Dialog, 'fontSize', 18);
	 Kinetic.Factory.addGetterSetter(Kinetic.R9Dialog, 'title', '');
	  Kinetic.Factory.addGetterSetter(Kinetic.R9Dialog, 'message1', '');
	   Kinetic.Factory.addGetterSetter(Kinetic.R9Dialog, 'message2', '');
	    Kinetic.Factory.addGetterSetter(Kinetic.R9Dialog, 'message3', ''); 
 
     

    Kinetic.Collection.mapMethods(Kinetic.R9Dialog);
})();