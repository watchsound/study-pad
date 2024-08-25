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
		message3: message3 ,
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
}
