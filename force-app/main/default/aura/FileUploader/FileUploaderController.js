/* fileUploadController2.js is identical */
({  
    save : function(component, event, helper) {
        if(component.get('v.isUploading')) return;
        
        var fileControl = component.find('FileControl');
        var fileEl = fileControl.getElement();
        
        component.set('v.hasError', false);
        component.set('v.errorMessage', '');
        
        if(!fileEl.files.length) {
            component.set('v.hasError', true);
            component.set('v.errorMessage', 'Please select file to upload.');
            return;
        }
        
        if(!component.get('v.hasError')) {
            helper.save(component);   
        }
    },
    onFileControlChange : function(component, event, helper) {
        if(event.currentTarget.files[0]) {
            var file = event.currentTarget.files[0];
            component.set('v.hasError', false);
            component.set('v.errorMessage', '');
            
            if (file.size > helper.MAX_FILE_SIZE) {
                var errorMessage = 'File size cannot exceed ' + helper.humanFileSize(helper.MAX_FILE_SIZE) + '.\n' + 'Selected file size: ' + helper.humanFileSize(file.size);
                component.set('v.hasError', true);
                component.set('v.errorMessage', errorMessage);
                return;
            }
            
            component.set('v.fileName', file.name);
            component.set('v.fileModifiedDate', file.lastModifiedDate);
            component.set('v.fileSize', helper.humanFileSize(file.size));
        } else {
            component.set('v.fileName', '');
            component.set('v.fileModifiedDate', '');
            component.set('v.fileSize', '');
        }
    },
    onClose : function(component, event, helper) {
        if(component.get('v.isUploading')) return;
        
        component.set('v.hasError', false);
        component.set('v.errorMessage', '');
        component.set('v.fileName', '');
        component.set('v.fileModifiedDate', '');
        component.set('v.fileSize', '');
    	component.set('v.isVisible', false);
    }
})