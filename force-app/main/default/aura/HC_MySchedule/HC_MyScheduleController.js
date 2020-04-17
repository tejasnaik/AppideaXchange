({
	init : function(component, event, helper) {
        component.set('v.lstBtnByValue',Object.keys(component.get('v.mapBtnByValue')));
        helper.loadRecords(component, event, helper); 
	},
    getSchedule : function(component, event, helper) {
        component.set("v.conditionValue", component.get('v.mapBtnByValue')[event.target.id]);
        helper.loadRecords(component, event, helper); 
	},
})