({  
	//Load User Image
    onInit: function(component) {
        var action = component.get("c.getProfilePicture"); 
        console.log(component.get("c.getProfilePicture"));
        action.setParams({
            imageId: component.get("v.recordId"),
        });
        action.setCallback(this, function(a) {
            var attachedImage = a.getReturnValue();
            if (attachedImage && attachedImage.Id) {
	            component.set('v.pictureSource', '/servlet/servlet.FileDownload?file=' + attachedImage.Id);
            }
        });
        $A.enqueueAction(action); 
    },
    
    save : function(component, event, helper) {
        helper.save(component);
    },
    
    onDragOver: function(component, event) {
        event.preventDefault();
    },

    onDrop: function(component, event, helper) {
		event.stopPropagation();
        event.preventDefault();
        event.dataTransfer.dropEffect = 'copy';
        var files = event.dataTransfer.files;
        if (files.length>1) {
            return alert("You can only upload one profile picture");
        }
        var file = files[0];
        helper.saveOnDragDrop(component, helper, file);
	},
          
    showModal : function(component, event, helper) {
        document.getElementById("modal").style.display = "block";
    },
    
    closeModal : function(component,event, helper){
        document.getElementById("modal").style.display = "none" ;
    }

})