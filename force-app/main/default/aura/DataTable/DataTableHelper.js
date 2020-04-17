({
    initComponent : function(component, event, helper) {
        var action = component.get('c.initComponent');
        action.setParams({
            objectType: component.get('v.object'),
            fields: component.get('v.fields').split(',')
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state == 'SUCCESS') {
                var fieldsList = JSON.parse(response.getReturnValue());
                component.set('v.fieldsList', fieldsList);

                helper.fetchRecords(component, event, helper);
            } else {
                console.log(response.getError());
            }
        })
        
        $A.enqueueAction(action);
    },
	fetchRecords : function(component, event, helper) {
        var fieldsList = component.get('v.fieldsList');
        var fields = [];
        
        for(var iIndex = 0; iIndex < fieldsList.length; iIndex++) {
            fields.push(fieldsList[iIndex].name.trim());
        }
        
		var action = component.get('c.fetchRecords');
        action.setParams({
            objectType: component.get('v.object'),
            fields: fields,
            keyword: component.get('v.keyword'),
            sortField : component.get('v.sortField'),
            sortDir : component.get('v.sortDir'),
            iLimit: component.get('v.limit')
        });
        
        var spinner = component.find('Spinner');
        $A.util.toggleClass(spinner, 'slds-hide');
        action.setCallback(this, function(response) {
            $A.util.toggleClass(spinner, 'slds-hide');
            
            var state = response.getState();
            if(state == 'SUCCESS') {
                var pageSize = component.get('v.pageSize');
                var pageNumber = component.get('v.pageNumber');
                
                var records = JSON.parse(response.getReturnValue())
                var pages = this.chunkify(records, pageSize);
                component.set('v.pages', pages);
                component.set('v.records', pages[pageNumber]);
            } else {
                console.log(response.getError());
            }
        })
        
        $A.enqueueAction(action);
	},
    chunkify : function(data, size){
        var sets = [], chunks, i = 0;
        chunks = data.length / size;
        
        while(i < chunks){
            sets[i] = data.splice(0, size);
            i++;
        }
        
        return sets;
    }
})