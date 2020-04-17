({
	init : function(component, event, helper) {
        helper.initComponent(component, event, helper);
	},
    createRecord : function (component, event, helper) {
        var createRecordEvent = $A.get('e.force:createRecord');
        if(createRecordEvent) {
            createRecordEvent.setParams({
                'entityApiName': component.get('v.object')
            });
            
            createRecordEvent.fire();    
        } else {
            alert('This functionality is only available in Lightning Experience.');
        }
    },
    search : function(component, event, helper) {
        if(event.getParams().keyCode == 13){
            helper.fetchRecords(component, event);
        }
    },
    handleSortEvent : function(component, event, helper) {
        var data = event.getParam('data');
        component.set('v.sortDir', data.sortDir);
        component.set('v.sortField', data.sortField);
        helper.fetchRecords(component, event);
    },
    first : function(component, event, helper) {
        var pageNumber = 0;
        var pages = component.get('v.pages');
        
        component.set('v.pageNumber', pageNumber);
        component.set('v.records', pages[pageNumber]);
    },
    previous : function(component, event, helper) {
        var pageNumber = component.get('v.pageNumber');
        var pages = component.get('v.pages');
        if(pageNumber > 0) {
            pageNumber--;
        }
        
        component.set('v.pageNumber', pageNumber);
        component.set('v.records', pages[pageNumber]);
    },
    next : function(component, event, helper) {
        var pageNumber = component.get('v.pageNumber');
        var pages = component.get('v.pages');
        if(pageNumber < pages.length - 1) {
            pageNumber++;
        }
        
        component.set('v.pageNumber', pageNumber);
        component.set('v.records', pages[pageNumber]);
    },
    last : function(component, event, helper) {
        var pages = component.get('v.pages');
        var pageNumber = pages.length - 1;
        
        component.set('v.pageNumber', pageNumber);
        component.set('v.records', pages[pageNumber]);
    }
})