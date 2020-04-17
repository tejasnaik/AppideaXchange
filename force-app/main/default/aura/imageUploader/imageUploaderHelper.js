({
    MAX_FILE_SIZE: 002 000 000,
    //To save the image when selecting it from file explorer
    save : function(component) {
        var fileInput = document.getElementById("file");
    	var file = fileInput.files[0];
        
    	//Validations
        if (!file) return;
        if (!file.type.match(/(image.*)/)) {
  			return alert('Image file format not supported');
		}

        if (file.size > this.MAX_FILE_SIZE) {
    		alert('File size cannot exceed: ' + this.MAX_FILE_SIZE + ' bytes.\n' + 'Selected file size: ' + file.size);
    	    return;
        }

        var fr = new FileReader();
        var self = this;

		//Read th image
       	fr.onload = function() {
            var dataURL = fr.result;
            component.set("v.pictureSource", dataURL);
            var base64Mark = 'base64,';
            var dataStart = dataURL.indexOf(base64Mark) + base64Mark.length;
            dataURL = dataURL.substring(dataStart);
            
            self.upload(component, file, dataURL);
        };
        fr.readAsDataURL(file);
    },
    
    //To save the image when Draged and Droped
    saveOnDragDrop : function(component, helper, file) {
        //Validations
        if (!file) return;
        if (!file.type.match(/(image.*)/)) {
  			return alert('Image file format not supported');
		}

        if (file.size > this.MAX_FILE_SIZE) {
            alert('File size cannot exceed: ' + this.MAX_FILE_SIZE + ' bytes.\n' +
    		  'Selected file size: ' + file.size);
    	    return;
        }

        var fr = new FileReader();
        var self = this;

		//Read th image
       	fr.onload = function() {
            var dataURL = fr.result;
            component.set("v.pictureSource", dataURL);
            var base64Mark = 'base64,';
            var dataStart = dataURL.indexOf(base64Mark) + base64Mark.length;
            dataURL = dataURL.substring(dataStart);
            
            self.upload(component, file, dataURL);
        };
        fr.readAsDataURL(file);
    },
     
    //To upload the image into Salesforce as an attachment object
    upload: function(component, file, base64Data) {
        var action = component.get("c.saveAttachment"); 
        action.setParams({
            imageId: component.get("v.recordId"),
            fileName: file.name,
            base64Data: encodeURIComponent(base64Data), 
            contentType: file.type
        });
        $A.enqueueAction(action); 
    }
})