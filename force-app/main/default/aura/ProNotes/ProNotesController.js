({
    doInit : function(component){
        var recordId = component.get("v.recordId");
        var action = component.get("c.findAll");
        action.setParams({
            "recordId": recordId
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
       
                component.set("v.contents", a.getReturnValue()); 
                var contentListLength = a.getReturnValue().length;
                component.set("v.listSize",contentListLength);
            
        });       
        $A.enqueueAction(action);      
      
    },
    
  //Delete function to delete any note record
    deleteNote : function(component, event) {
        var recordId = component.get("v.recordId");
        var contentList = component.get("v.contents");
        var target = event.getSource();
        var id = target.get("v.value"); 
        var action = component.get("c.deleteNoteById");
        action.setParams({
            "NoteId": id,
            "recordId":recordId
        }); 
        action.setCallback(this, function(a) {
            component.set("v.contents",a.getReturnValue());
            var contentListLength = a.getReturnValue().length;
            component.set("v.listSize",contentListLength);
        });
        $A.enqueueAction(action);
    },
    
    //new button called when A new Note is to be Made
    newbutton: function(component) {
        var cmpTarget = component.find('Modalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.addClass(cmpBack,'slds-backdrop_open');
        $A.util.addClass(cmpTarget, 'slds-fade-in-open'); 
    },
    
     //For Cancel Button, Cancel function is created 
    cancel: function(component) {
        console.log('inside cancel');
        var cmpTarget = component.find('Modalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpBack,'slds-backdrop_open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
    },
    
     //For Save Button, Save function is created 
    save: function(component) {
        var noteName =  component.get('v.noteName');
        var noteBody =  component.get('v.noteBody');
        var recordId = component.get("v.recordId");
        var contentList = component.get("v.contents");        
        var action = component.get('c.saveNote');
        action.setParams({
            'noteName':noteName,
            'noteBody':noteBody,
            'recordId':recordId
        });
        action.setCallback(this, function(a) {
            component.set("v.contents", a.getReturnValue());
            var contentListLength = a.getReturnValue().length;
            component.set("v.listSize",contentListLength);
        });
        $A.enqueueAction(action);
        var cmpTarget = component.find('Modalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpBack,'slds-backdrop_open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
        component.set("v.noteName","");
        component.set("v.noteBody","");
        
    }
})