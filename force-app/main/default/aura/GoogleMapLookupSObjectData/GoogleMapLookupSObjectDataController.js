({
    select: function(cmp, event, helper) {
        var objectId = helper.resolveId(event.currentTarget.id);
        var matches=cmp.get("v.matches");
        for (var i=0; i<matches.length; i++){
			if(matches[i].objRecords.Id==objectId){
                var objectLabel=matches[i].objRecords.Name;
            }
        }
        var appEvent = $A.get("e.c:LookupDataSet");
        
        appEvent.setParams({ "SobjectId" : objectId,
                           	 "SobjectLabel" : objectLabel,
                             "fieldName" : cmp.get("v.fieldName"),
                           });
		appEvent.fire();

        
    },
})