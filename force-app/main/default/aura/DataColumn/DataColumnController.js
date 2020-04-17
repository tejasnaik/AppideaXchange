({
	onHeaderClick : function(component, event, helper) {
        var field = component.get('v.field');
        if(component.get('v.sortDir') === 'ASC') {
            component.set('v.sortDir', 'DESC');
        } else {
            component.set('v.sortDir', 'ASC');
        }
        
        var dataTableSortEvent = component.getEvent('dataTableSortEvent');
        dataTableSortEvent.setParam('data', {
            sortDir : component.get('v.sortDir'),
            sortField : field.name,
        });
        dataTableSortEvent.fire();
	}
})