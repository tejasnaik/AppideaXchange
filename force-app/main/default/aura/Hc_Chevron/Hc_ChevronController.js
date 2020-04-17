({
	doInt : function(component, event, helper) {
		var c = component.get("v.cList");
        if(!c){
            var tarray = [];
            tarray.push('Select 1');
            tarray.push('Select 2');
            tarray.push('Select 3');
            var temp = {
                currentStage : 'Select 1',
                currentStageIndex : '1',
                stages : tarray
            };
            console.log(JSON.stringify(temp));
            component.set("v.cList",temp);
        }
	}
})