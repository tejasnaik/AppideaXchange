({
	loadData : function(component, event, helper) {
        var value = '';
        if((component.get('v.field').split('.')).length > 1)
            value = (component.get('v.records')[component.get('v.field').split('.')[0]] != undefined)?component.get('v.records')[component.get('v.field').split('.')[0]][component.get('v.field').split('.')[1]]:'';
        else
           value = component.get('v.records')[component.get('v.field').split('.')[0]]; 
        component.set('v.value',value);
        
	}
})