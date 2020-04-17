({
	doInit : function(component, event, helper) {
        var ideaNew = {
            sobjectType : 'CogniAppEx__Idea__c',
            CogniAppEx__Title__c : '',
            CogniAppEx__Category__c : '',
            CogniAppEx__Description__c : '',
            CogniAppEx__Vertical__c:'',
            CogniAppEx__Cloud__c:'',
            CogniAppEx__POC__c:''
           
        };
        
        component.set('v.idea', ideaNew);
        helper.getcatagory(component);
        helper.getcloud(component);
        helper.getvertical(component);
	},
    onSubmit : function(component, event, helper) {
        var idea = component.get('v.idea');
        var poc=component.find('ideaPOCId').get('v.id'); 
        var pocKeyword =component.find('ideaPOCId').get('v.keyword');
        console.log(pocKeyword);
        if((pocKeyword!='' && pocKeyword!=null) && (poc== undefined ||poc==null||poc=='' )){
            console.log('vmsdvs');
            component.set('v.errorMessage', 'Please Select the correct POC name.');
            return;
        }
        if(poc==null||poc==''||poc==undefined){
            console.log(poc);
         	   
        }else{
             console.log(poc);
            idea.CogniAppEx__POC__c = component.find('ideaPOCId').get('v.id'); 
        }
        
        component.set('v.idea',idea);
        var data=[];
        data=component.get('v.idea');
        if(!idea.CogniAppEx__Title__c || !idea.CogniAppEx__Category__c || !idea.CogniAppEx__Description__c) {
            component.set('v.errorMessage', 'Please fill all the required fields.');
        } else {
            component.set('v.errorMessage', '');
        	helper.submitIdea(component, event, helper);    
        }
	},
    onClose : function(component, event, helper) {
		component.set('v.isVisible', false);
        helper.reset(component, event, helper);
	}
})