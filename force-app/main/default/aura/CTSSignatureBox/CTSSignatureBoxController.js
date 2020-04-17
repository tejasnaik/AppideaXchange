({
    enableSign: function ( component, event, helper ) {
        if(component.get( 'v.recordId') == null || component.get( 'v.recordId') == undefined){
            var errmsg = component.get("v.errorMessage");
            helper.showToast(errmsg, 'info','Information');
            return;
        }else{ 
        	component.set( 'v.EnableSignScreen', true );
        }
    },
    
    doInit: function ( component, event, helper ) {
	},
    
    close: function ( component, event, helper ) {
        helper.clear( component );
        component.set( 'v.EnableSignScreen', false );
        component.set("v.Message","Sign Here.");
		
	},
    sign: function ( component, event, helper ) {
        var t = component.get("v.isCaptured");
        if(t){
	        helper.sign( component );
        }else{
        	var pngUrl =  document.querySelectorAll('[id="signatureCanvasId"]')[0].toDataURL();
        	var base64Data = pngUrl.substring( pngUrl.indexOf( 'base64,' ) + 'base64,'.length );
        	component.set("v.CaptureImg",pngUrl);
            component.set("v.isCaptured",true);
            component.set("v.Message","Sign Captured.");
            
        }
	},
    clear: function ( component, event, helper ) {
        
        var t = component.get("v.isCaptured");
        if(!t){
	        helper.clear( component );
            component.set("v.Message","Sign Here.");
        }else{
            component.set("v.CaptureImg",'');
            component.set("v.isCaptured",false);
            component.set("v.Message","Edit Your Sign");
        }
        
	},
    mousedown: function ( component, event, helper ) {
        //console.log( '>>> mousedown' );
       // console.log( '>>> mousedown event = ', event );
        component.set( 'v.paint', true );
        helper.addClick( component, event.offsetX, event.offsetY );
		helper.redraw( component );
	},
    mousemove: function ( component, event, helper ) {
        //console.log( '>>> mousemove' );
        component.get( 'v.paint' );
        if ( component.get( 'v.paint' ) == true ) {
            helper.addClick( component, event.offsetX, event.offsetY, true );
            helper.redraw( component );
        }
	},
    mouseup: function ( component, event, helper ) {
        //console.log( '>>> mouseup' );
        component.set( 'v.paint', false );
	},
    mouseleave: function ( component, event, helper ) {
        //console.log( '>>> mouseleave' );
        component.set( 'v.paint', false );
	},

    touchstart: function ( component, event, helper ) {
        //console.log( '>>> touchstart' );
		component.set( 'v.paint', true );
        console.log(event);
        console.log(event.touches[0]);
        var x = Math.round( event.touches[ 0 ].clientX - event.touches[ 0 ].target.getBoundingClientRect().left );
        var y = Math.round( event.touches[ 0 ].clientY - event.touches[ 0 ].target.getBoundingClientRect().top );
        helper.addClick( component, x, y );
		helper.redraw( component );
  	},
    touchmove: function ( component, event, helper ) {
        //event.stopPropagation();
        event.preventDefault();
        //console.log( '>>> touchmove' );
		//component.get( 'v.paint' );
		var x = Math.round( event.touches[ 0 ].clientX - event.touches[ 0 ].target.getBoundingClientRect().left );
        var y = Math.round( event.touches[ 0 ].clientY - event.touches[ 0 ].target.getBoundingClientRect().top );
        if ( component.get( 'v.paint' ) == true ) {
            helper.addClick( component, x, y, true );
            helper.redraw( component );
        }
  	},
    touchend: function ( component, event, helper ) {
        //console.log( '>>> touchend' );
		component.set( 'v.paint', false );
  	},
    touchcancel: function ( component, event, helper ) {
       // console.log( '>>> touchcancel' );
		component.set( 'v.paint', false );
  	},
     showSpinner : function (component, event, helper) {
        var spinner = component.find('spinner');
        $A.util.removeClass(spinner,'slds-hide');
        $A.util.addClass(spinner,'slds-show');
    },
    
   hideSpinner : function (component, event, helper) {
        var spinner = component.find('spinner');
        $A.util.removeClass(spinner,'slds-show');
        $A.util.addClass(spinner,'slds-hide');
   },
    
    
    
})