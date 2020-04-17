({
	doConstructor : function(component, event, helper) {
		helper.getOptionsServer(component);
	},
    
    controledFieldValueChanger : function(component, event, helper) {
        component.set("v.SelectedDependendValue",'');
        helper.controledFieldValueChangerExecute(component, event );
    },
    
    /*doInit1 :function(component, event, helper) {
		console.log(component.get('v.SelectedDependendValue'));
        console.log(component.get('v.SelectedControllingValue'));
	},*/
})