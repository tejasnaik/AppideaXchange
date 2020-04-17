({
	lookupSearch : function(component, event, helper) {
		var searchAction = component.get('c.lookupSearch');
        searchAction.setParams({
            objectName : component.get('v.object'),
            keyword : component.get('v.keyword')
        });
        
        searchAction.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS') {
                var records = JSON.parse(response.getReturnValue());
                component.set('v.data', records);
            } else {
                console.log(response.getError());
            }
        });
        
        $A.enqueueAction(searchAction);
	},
    close : function(component){
        component.set('v.isOpen',false);
    }
})