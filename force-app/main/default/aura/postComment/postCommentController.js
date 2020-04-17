({
	doInit : function(component, event, helper) {
        component.set('v.comments', []);
		helper.getIdeaComments(component, event, helper);
	},
    onSubmit : function(component, event, helper) {
        var description = component.get('v.description');
        if(!description) {
            component.set('v.errorMessage', 'Please enter your comment.');
        } else {
            component.set('v.errorMessage', '');
            helper.submitIdeaComment(component, event, helper);   
        }
	},
    onClose : function(component, event, helper) {
		component.set('v.isVisible', false);
        helper.reset(component, event, helper);
	},
    openFileUploader : function(component, event, helper) {
        component.find('FileUploader').set('v.isVisible', true);
    }
})