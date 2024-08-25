var normalizeString = function(content){
     return content.replace(/r9newline/g, '\n').replace(/r9apostrophe/g, "'");
}
var R9TransitionChainHandler = function(){
    var This = this; 
	
    this._staytimeoutHandler = null;   
    this._transtimeoutHandler = null; 	
    this.chain = new Array(); 
    this.currentStep = 0;
    this.isRunning = false;
	
    this.nextStep = function(){
        This.currentStep = This.currentStep +1;
        if (This.currentStep == This.chain.length)
        {
		   This.currentStep = This.chain.length -1; 
            This.stop();
			//This.processCurrentStepRev();
        }else
        {
            This.processCurrentStep();
        }
    };
    this.processCurrentStep = function(){
	    This.chain[This.currentStep].func.setup();
	    if ( This.chain[This.currentStep].func.blockanimation  ){
	    	 window.PageBus.publish( 'r9.core.animation.stop', { 'messageid' : -1 });
	    	 return;
	    } 
        This._staytimeoutHandler = window.setTimeout(function(){
            This.chain[This.currentStep].func.play();
			    This._transtimeoutHandler = window.setTimeout(function(){
                    This.nextStep();
               },This.chain[This.currentStep].transtime); 
        },This.chain[This.currentStep].staytime);
    };
	this.resumeCurrentStep = function(){
        This._staytimeoutHandler = window.setTimeout(function(){
            This.chain[This.currentStep].func.resume();
			    This._transtimeoutHandler = window.setTimeout(function(){
                    This.nextStep();
               },This.chain[This.currentStep].transtime); 
        },This.chain[This.currentStep].staytime);
    };
	this.revStep = function(){
        This.currentStep = This.currentStep -1;
        if (This.currentStep <  0)
        {    
		    This.currentStep = 0; 
            This.stop();
			//This.processCurrentStep();
        }else
        {
            This.processCurrentStepRev();
        }
    };
	this.processCurrentStepRev = function(){
	    This._staytimeoutHandler = window.setTimeout(function(){
            This.chain[This.currentStep].func.reverse();
			    This._transtimeoutHandler = window.setTimeout(function(){
                    This.revStep();
               },This.chain[This.currentStep].transtime); 
        },This.chain[This.currentStep].staytime); 
    };
	this.reset =function(){
        if (This.chain.length == 0)
        {
            return;
        }
        This.stop();
        This.currentStep = 0; 
    };
    this.start =function(){
        if (This.chain.length == 0)
        {
            return;
        }
        if (This.isRunning == true)
        {
            return;
        }
        This.isRunning = true; 
        This.processCurrentStep();
    };
	 this.resume =function(){
        if (This.chain.length == 0)
        {
            return;
        }
        if (This.isRunning == true)
        {
            return;
        }
        This.isRunning = true; 
        This.resumeCurrentStep();
    };
	this.reverse =function(){
	    if (This.chain.length == 0)
        {
            return;
        } 
	    This.stop(); 
        This.isRunning = true; 
        This.processCurrentStepRev();
    };
    this.stop = function(){
        This.isRunning = false;
        window.clearTimeout(This._staytimeoutHandler)
		window.clearTimeout(This._transtimeoutHandler)
    };
    this.add = function(_function,  _staytime, _transtime){
        This.chain[This.chain.length] = {func : _function, transtime : _transtime, staytime : _staytime};
    };
	
	
	this.distroy = function(){
	     this.stop();
         This.chain = [];
	};
	
	this.showMessage = function(dnclayer, messageid, message, stagewidth, stageheight, duration){
	     window.PageBus.publish( 'r9.core.animation.stop', { 'messageid' : messageid });
	   var messagedialog = new Kinetic.Label({
       x: stagewidth / 2, 
       y:  stageheight / 2  ,
       opacity: 1
     });
     
     messagedialog.add(new Kinetic.Tag({
        fill: 'black',
       pointerDirection: 'down',
       pointerWidth: 10,
       pointerHeight: 10,
       lineJoin: 'round',
       shadowColor: 'black',
       shadowBlur: 5,
       shadowOffset: {x:5,y:10},
       shadowOpacity: 0.5
     }));
     
     messagedialog.add(new Kinetic.Text({
       text:  normalizeString(message),
       fontFamily: 'Calibri',
       fontSize: 18,
       padding: 5,
       fill: 'white' 
     }));
	   
	  
	  dnclayer.add( messagedialog );
	  
	  if (duration > 0 ){
	  
		 var tween =  new Kinetic.Tween({
			  node:    messagedialog, 
			 opacity :  0,  
			 easing: Kinetic.Easings['Linear'], 
			 duration: duration,
			 onFinish: function() { 
					 messagedialog.remove();
					 window.PageBus.publish( 'r9.core.animation.resume', { 'messageid' : messageid });
				}
			}) ;
		  tween.play();
		  
	  } else {
	    messagedialog.on('tap', function() {  
  	       			 messagedialog.remove();
					 window.PageBus.publish( 'r9.core.animation.resume', { 'messageid' : messageid });
      });  
		messagedialog.on('click', function() {  
  	      			 messagedialog.remove();
					 window.PageBus.publish( 'r9.core.animation.resume', { 'messageid' : messageid });
       });  
		
	 
	   var tween =  new Kinetic.Tween({
         node:    messagedialog, 
        opacity :  1,  
        easing: Kinetic.Easings['Linear'], 
        duration: duration,
		 onFinish: function() { 
				 
           }
       }) ;
	  tween.play();
	  }
	  
	};
	
	this.showDialog = function(dnclayer, messageid, title, message1, message2, message3, follow, stagewidth, stageheight, duration){
	     window.PageBus.publish( 'r9.core.animation.stop', { 'messageid' : messageid });
	     var fontsize = stagewidth > 500 ? 18 :15;
	   var dialog = new Kinetic.R9Dialog({
       x: stagewidth / 2, 
       y:  stageheight / 2  ,
       opacity: 1,
		title: title,
		message1: message1,
		message2: message2,
		message3: message3,
		fontSize : fontsize
     }); 
	  
     dialog.on('tap', function() {  
  	       dialog.remove();
		   This.showMessage(dnclayer, messageid,  follow, stagewidth, stageheight, duration);
       });  
		  dialog.on('click', function() {  
  	       dialog.remove();
		   This.showMessage(dnclayer, messageid,  follow, stagewidth, stageheight, duration);
       });  
		
	   
	  dnclayer.add( dialog );
	 
	   var tween =  new Kinetic.Tween({
         node:    dialog, 
        opacity :  1,  
        easing: Kinetic.Easings['Linear'], 
        duration: duration,
		 onFinish: function() { 
				 
           }
       }) ;
	  tween.play();
	 
	};
	
	
	this.showDialog2 = function(dnclayer, messageid, title, message1, follow1, message2, follow2, message3, follow3, stagewidth, stageheight, duration){
	     window.PageBus.publish( 'r9.core.animation.stop', { 'messageid' : messageid });
	     var fontsize = stagewidth > 500 ? 18 :15;
        var _x = 300 ;// stagewidth / 2 ;
        var _y = 300; //stageheight / 2 ;
	     
	     var titleView = new Kinetic.Label({
             x: _x,
             y: _y,
             draggable: false
             });

 
	     titleView.add(new Kinetic.Tag({ 
	         fill: '#bbb', 
	         stroke: '#999',
	         shadowColor: 'black', 
	         shadowBlur: 10, 
	         shadowOffset: [10, 10], 
	         shadowOpacity: 0.2, 
	         lineJoin: 'round', 
	         pointerDirection: 'up', 
	         pointerWidth: 20, 
	         pointerHeight: 20, 
	         cornerRadius: 5 
         }))

         titleView.add(new Kinetic.Text({
	          text: title,
	          fontSize: fontsize,
	          lineHeight: 1.2,
	          padding: 10,
	          fill: 'green'
          }));
	     

	     contentlay.add( titleView );
	     
	     _y += 90;
        _x -= 100;
	     
	     var label1 = new Kinetic.Label({
             x: _x,
             y: _y,
             draggable: false
             });

// add a tag to the label 
	     label1.add(new Kinetic.Tag({ 
	         fill: '#bbb', 
	         stroke: '#990',
	         shadowColor: 'black', 
	         shadowBlur: 10, 
	         shadowOffset: [10, 10], 
	         shadowOpacity: 0.2, 
	         lineJoin: 'round', 
	         pointerDirection: 'left',
	         pointerWidth: 20, 
	         pointerHeight: 20, 
	         cornerRadius: 5 
         }))

         label1.add(new Kinetic.Text({
	          text: message1,
	          fontSize: fontsize,
	          lineHeight: 1.2,
	          padding: 10,
	          fill: 'black'
          }));
	     label1.on('click tap', function() {
	    	 titleView.remove();
	    	 label1.remove();
	    	 label2.remove();
	    	 label3.remove();
	    	 if ( follow1 )
	    	     This.showMessage(dnclayer, messageid,  follow1, stagewidth, stageheight, duration);
	     });

	     contentlay.add( label1 );
	     
        _y += 50;
	     
	     var label2 = new Kinetic.Label({
             x: _x,
             y: _y,
             draggable: false
             }); 
	     
	     label2.add(new Kinetic.Tag({ 
	         fill: '#bbb', 
	         stroke: '#990',
	         shadowColor: 'black', 
	         shadowBlur: 10, 
	         shadowOffset: [10, 10], 
	         shadowOpacity: 0.2, 
	         lineJoin: 'round', 
	         pointerDirection: 'left',
	         pointerWidth: 20, 
	         pointerHeight: 20, 
	         cornerRadius: 5 
         }))

         label2.add(new Kinetic.Text({
	          text: message2,
	          fontSize: fontsize,
	          lineHeight: 1.2,
	          padding: 10,
	          fill: 'black'
          }));
	     label2.on('click tap', function() {
	    	 titleView.remove();
	    	 label1.remove();
	    	 label2.remove();
	    	 label3.remove();
	    	 if ( follow2 )
	    	     This.showMessage(dnclayer, messageid,  follow2, stagewidth, stageheight, duration);
	     });

	     contentlay.add( label2 );
	     
         _y += 50;
	     
	     var label3 = new Kinetic.Label({
             x: _x,
             y: _y,
             draggable: false
             });
  
	     label3.add(new Kinetic.Tag({ 
	         fill: '#bbb', 
	         stroke: '#990',
	         shadowColor: 'black', 
	         shadowBlur: 10, 
	         shadowOffset: [10, 10], 
	         shadowOpacity: 0.2, 
	         lineJoin: 'round', 
	         pointerDirection: 'left',
	         pointerWidth: 20, 
	         pointerHeight: 20, 
	         cornerRadius: 5 
         }))

         label3.add(new Kinetic.Text({
	          text: message3,
	          fontSize: fontsize,
	          lineHeight: 1.2,
	          padding: 10,
	          fill: 'black'
          }));
	     label3.on('click tap', function() {
	    	 titleView.remove();
	    	 label1.remove();
	    	 label2.remove();
	    	 label3.remove();
	    	 if ( follow3 )
	    	     This.showMessage(dnclayer, messageid,  follow3, stagewidth, stageheight, duration);
	     });

	     contentlay.add( label3 );
	       
	 
		   var tween =  new Kinetic.Tween({
	        node:    titleView, 
	       opacity :  1,  
	       easing: Kinetic.Easings['Linear'], 
	       duration: duration,
			 onFinish: function() {  
	          }
	      }) ;
		  tween.play();
		  
		  var tween1 =  new Kinetic.Tween({
		        node:    label1, 
		       opacity :  1,  
		       easing: Kinetic.Easings['Linear'], 
		       duration: duration,
				 onFinish: function() {  
		          }
		      }) ;
			  tween1.play();
			  
			  var tween2 =  new Kinetic.Tween({
			        node:    label2, 
			       opacity :  1,  
			       easing: Kinetic.Easings['Linear'], 
			       duration: duration,
					 onFinish: function() {  
			          }
			      }) ;
				  tween2.play();
				  
				  var tween3 =  new Kinetic.Tween({
				        node:    label3, 
				       opacity :  1,  
				       easing: Kinetic.Easings['Linear'], 
				       duration: duration,
						 onFinish: function() {  
				          }
				      }) ;
					  tween3.play();
	 
	};
}
