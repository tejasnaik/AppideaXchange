({

    addClick : function ( component, x, y, dragging ) {
        var clickX = component.get( 'v.clickX' );
        var clickY = component.get( 'v.clickY' );
        var clickDrag = component.get( 'v.clickDrag' );
        clickX.push( x );
        clickY.push( y );
        clickDrag.push( dragging );
        component.set( 'v.clickX', clickX );
        component.set( 'v.clickY', clickY );
        component.set( 'v.clickDrag', clickDrag );
    },
    redraw : function( component ) {
        var context = document.querySelectorAll('[id="signatureCanvasId"]')[0].getContext( "2d" );
        //var context = document.getElementById( 'signatureCanvasId' ).getContext( "2d" );
        var clickX = component.get( 'v.clickX' );
        var clickY = component.get( 'v.clickY' );
        var clickDrag = component.get( 'v.clickDrag' );
        
        context.clearRect( 0, 0, context.canvas.width, context.canvas.height );
  
        context.strokeStyle = "black";
        context.lineJoin = "round";
        context.lineWidth = 5;
	
        for( var i = 0; i < clickX.length; i++ ) {
            context.beginPath();
            if ( clickDrag[ i ] && i ) {
                context.moveTo( clickX[ i-1 ], clickY[ i-1 ] );
            } else {
                context.moveTo( clickX[ i ] - 1, clickY[ i ] );
            }
            context.lineTo( clickX[ i ], clickY[ i ] );
            context.closePath();
            context.stroke();
        }
    },
    clear : function( component ) {
        component.set( 'v.paint', false );
        component.set( 'v.clickX', [] );
        component.set( 'v.clickY', [] );
        component.set( 'v.clickDrag', [] );
        var context = document.getElementById( 'signatureCanvasId' ).getContext( "2d" );
        context.clearRect( 0, 0, context.canvas.width, context.canvas.height );
    },
    sign : function( component ) {
        
        var ParentId = component.get( 'v.recordId' );
        var SignatureFileName = component.get( 'v.SignatureFileName' );
        //var pngUrl = document.getElementById( 'signatureCanvasId' ).toDataURL();
        var pngUrl =  document.querySelectorAll('[id="signatureCanvasId"]')[0].toDataURL();
        var base64Data = pngUrl.substring( pngUrl.indexOf( 'base64,' ) + 'base64,'.length );
        var action = component.get( "c.signDocument" ); 
        SignatureFileName = '';
        action.setParams( {
            ParentId: ParentId,
            fileName: SignatureFileName+'_signature.png',
            base64Data: base64Data, 
            contentType: 'image/png',
            ErrorMessage:'Please provide parent record Id to save signature.'
        } );               
        action.setCallback( this, function( response ) {
            var state = response.getState();  
            console.log(state);
            if ( state === "SUCCESS" ) {
                console.log( '>>> success' + response.getReturnValue());
                var res = response.getReturnValue();           	    
                console.log( '>>> success' + res.msg);
				if(res.isSuccess == true || res.isSuccess == 'true'){
                    
                    this.showToast(res.msg,'Success','Update');
                    this.clear(component);
                    component.set( 'v.EnableSignScreen', false );
                }else{
                    this.showToast(res.msg,'error','Update');
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                console.log("Unknown erro 11r");
                //throw new Error( "Error : " + response.getError() );                
            } else {
                throw new Error( "Unknown error : signatureHelper" );
            }
        } );            
       
            $A.enqueueAction( action ); 
    },
    
    showToast : function(msg, alertType,title){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type":alertType,
            "title": title,
            "message": msg
        });
        toastEvent.fire();
    },
    
     
   
})