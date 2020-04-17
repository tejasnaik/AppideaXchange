({
    MAX_FILE_SIZE: 4500000, /* 6 000 000 * 3/4 to account for base64 */
    CHUNK_SIZE: 450000, /* Use a multiple of 4 */
    
    save : function(component) {
    	var fileInput = component.find('FileControl').getElement();
        var file = fileInput.files[0];
     	var fr = new FileReader();
        var self = this;
        fr.onload = $A.getCallback(function() {
            var fileContents = fr.result;
            var base64Mark = 'base64,';
            var dataStart = fileContents.indexOf(base64Mark) + base64Mark.length;
            
            fileContents = fileContents.substring(dataStart);
            self.upload(component, file, fileContents);
            component.set('v.isUploading', true);
        });
        
        fr.readAsDataURL(file);
    },
    upload: function(component, file, fileContents) {
        var fromPos = 0;
        var toPos = Math.min(fileContents.length, fromPos + this.CHUNK_SIZE);
		
       	// start with the initial chunk
        this.uploadChunk(component, file, fileContents, fromPos, toPos, '');   
    },
    uploadChunk : function(component, file, fileContents, fromPos, toPos, attachId) {
        var action = component.get('c.saveTheChunk'); 
        var chunk = fileContents.substring(fromPos, toPos);

        action.setParams({
            parentId: component.get('v.parentId'),
            fileName: file.name,
            base64Data: encodeURIComponent(chunk), 
            contentType: file.type,
            fileId: attachId
        });
       
        var self = this;
        action.setCallback(this, function(a) {
            attachId = a.getReturnValue();
            
            fromPos = toPos;
            toPos = Math.min(fileContents.length, fromPos + self.CHUNK_SIZE);
            
            if (fromPos < toPos) {
            	self.uploadChunk(component, file, fileContents, fromPos, toPos, attachId);  
            } else {
                component.set('v.isUploading', false);
                component.set('v.isVisible', false);
                
                var toastEvent = $A.get('e.force:showToast');
                toastEvent.setParams({
                    'type' : 'success',
                    'message': 'Attachment has been uploaded successfully.'
                });
                toastEvent.fire();
            }
        });
            
        $A.enqueueAction(action);
    },
    humanFileSize : function(size) {
        var i = Math.floor( Math.log(size) / Math.log(1024) );
        return ( size / Math.pow(1024, i) ).toFixed(2) * 1 + ' ' + ['B', 'kB', 'MB', 'GB', 'TB'][i];
    }
})