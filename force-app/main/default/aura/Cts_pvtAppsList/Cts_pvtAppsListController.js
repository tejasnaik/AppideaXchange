({
    doInt : function(component, event, helper) {
        var cat = component.get("v.sCategories");
        var types = component.get("v.sType");
        var lst = component.get("v.AppsList");
        var order = component.get("v.sortOrder");
        var SearchInput = component.get("v.SearchInput");
        var newList = new Array();
        
        
        
        if(lst == null || lst == undefined)
            return;
        
        for(var i = 0;i<lst.length;i++){
            var catClear = false;
            if(cat == '' || cat == undefined){
                catClear = true;
            }else{
                if(lst[i]['res']['CogniAppEx__Categories__c'] == cat )
                    catClear = true;
            }
            
            var typeClear = false;
            if(types == '' || types == undefined){
                typeClear = true;
            }else{
                if(lst[i]['res']['CogniAppEx__AppType__c'] == types ){
                    typeClear = true;
                }
            }
            var searchClear = true;
           /* if(SearchInput !=null && SearchInput != undefined && SearchInput.trim() !=''){
                if(lst[i]['res']['Name'].toLowerCase().indexOf(SearchInput.toLowerCase())>-1)
                    searchClear = true;
                else
                    searchClear = false;
            }*/
            
            if(typeClear && catClear && searchClear)
                newList.push(lst[i]);
            
        }
        
        if(order == '' || order ==''){
         //nothing   
        }else{
            newList.sort(function(a, b) {
                var nameA = a['res'].Name.toUpperCase(); // ignore upper and lowercase
                var nameB = b['res'].Name.toUpperCase(); // ignore upper and lowercase
                if (nameA < nameB)  return order=='AZ'?-1:1;
                if (nameA > nameB)  return order=='AZ'?1:-1;
                // names must be equal
                return 0;
            });
        }
        //console.log(newList);
        var newListNew = new Array();
        for(var i = 0;i<newList.length;i++){
            var listingId = newList[i];
            var expression = listingId.res.CogniAppEx__AppType__c;
                        var icontype;
                        switch(expression) {
                            case 'Components':
                                icontype = 'utility:package';        
                                break; 
                            case 'Applications':
                                icontype = 'utility:text_background_color';   
                                break;
                            case 'Frameworks':
                                icontype = 'utility:setup';
                                break;
                            default:
                                icontype = 'utility:custom_apps';
                        }
            listingId.icontype = icontype;
        }
        //console.log(newList);
        component.set("v.internalAppsList",newList);
    },
    
    moreDetail :function(component, event, helper){
        var recID = event.getSource().get("v.value");
        var compEvent = component.getEvent("detailComponentEvent");
		compEvent.setParams({"recordId" : recID });
		compEvent.fire();
    }
    
})