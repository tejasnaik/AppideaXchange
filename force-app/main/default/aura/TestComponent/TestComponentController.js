({
	onInit : function(component, event, helper) {
        var c = component.get('v.List');
        if(!c){
            var tarray = [];
            tarray.push('Select 18');
            tarray.push('Select 52');
            tarray.push('Select 2');
            tarray.push('Select 3');
            var temp = {
                currentStage : 'Select 1',
                currentStageIndex : '2',
                stages : tarray
            };
            console.log(JSON.stringify(temp));
            component.set('v.List',temp);
        }
	}
})