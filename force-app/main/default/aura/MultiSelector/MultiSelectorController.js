({
    dragStart:function(component, event, helper){
        event.dataTransfer.effectAllowed='move';
        event.dataTransfer.setData("Text", event.target.getAttribute('id'));
        //event.dataTransfer.setDragImage(event.target,0,0);
    },
    
    dragEnter :  function(component, event, helper) {
        event.preventDefault();
    },
    
    dragOver :  function(component, event, helper) {
        event.preventDefault();
    },
    
    dragDrop :  function(component, event, helper) {
        var src = event.dataTransfer.getData("Text");
        component.set("v.OptionsValueSelected",src);
        var valueToMove = src;
        helper.helperMethod(component,valueToMove,'v.OptionsValueList','v.SelectedValueList');
        helper.reSetSelector(component);
        console.log(component.get("v.SelectedValueList"));
        console.log(component.get("v.OptionsValueList"));
        
    },
    
    dragDrop2 :  function(component, event, helper) {
        var src = event.dataTransfer.getData("Text");
        component.set("v.SelectedValueSelected",src);
        var valueToreMove = src;
        helper.helperMethod(component,valueToreMove,'v.SelectedValueList','v.OptionsValueList');
        helper.reSetSelector(component);
    },
    
    refresh: function(component, event, helper) {
        
    },
    
    doInit : function(component, event, helper) {
        if(!component.get("v.goWithMyOptions"))
            helper.onInit(component);
        else
            helper.GowithMyOption(component);  
    },
    
    edit : function(component, event, helper) {
        component.set("v.isEditMode",!component.get("v.isEditMode"));
    },
    
    getValues : function(component, event) {
        var val = component.get("v.SelectedValueList");
        var ev = component.getEvent("MultiSelectedValueEvent");
        ev.setParams({"selectedValue" : val });
        ev.fire();
    },
    
    save: function(component, event, helper) {
        var recid = component.get("v.recordId");
        if(recid != null && recid != undefined) {
            helper.savePicklist(component);
        }
    },
    
    LHSSelect:function(cmp,event,helper){
        var t =event.currentTarget.getAttribute("data-value");
        cmp.set("v.OptionsValueSelected",t);
        cmp.set("v.SelectedValueSelected",'');
    },
    
    RHSSelect:function(cmp,event,helper){
        var t =event.currentTarget.getAttribute("data-value");
        cmp.set("v.SelectedValueSelected",t);
        cmp.set("v.OptionsValueSelected",'');
    },
    reMoveTOSelect:function(cmp,event,helper){
        var valueToreMove = cmp.get("v.SelectedValueSelected");
        helper.helperMethod(cmp,valueToreMove,'v.SelectedValueList','v.OptionsValueList');
        helper.reSetSelector(cmp);
    },
    MoveTOSelect : function(cmp,event,helper){
        var valueToMove = cmp.get("v.OptionsValueSelected");
        helper.helperMethod(cmp,valueToMove,'v.OptionsValueList','v.SelectedValueList');
        helper.reSetSelector(cmp);
    },
    
    
    /* This function will help to up value */
    upValue : function(cmp,event,helper){
        var valueToUp = cmp.get("v.SelectedValueSelected");
        if(valueToUp == null  || valueToUp =='' || valueToUp == undefined) return;
        
        var allVal = cmp.get("v.SelectedValueList");
        var pos;
       
        for(var i=0;i<allVal.length;i++){
            if(allVal[i] == valueToUp) pos = i;
        }
        
        if(pos ==0) return;
        
        var rel =  allVal[pos-1];     
        allVal[pos-1] = valueToUp 
        allVal[pos] = rel;        
        cmp.set("v.SelectedValueList",allVal);
    },
    
    
    /* This function will help to down value */
    downValue : function(cmp,event,helper){
        var valueToUp = cmp.get("v.SelectedValueSelected");
        if(valueToUp == null  || valueToUp =='' || valueToUp == undefined)
            return;
        
        var allVal = cmp.get("v.SelectedValueList");
        var pos;
        
        for(var i=0;i<allVal.length;i++){
            if(allVal[i] == valueToUp) pos = i;
        }
        
        if(pos ==allVal.length-1) return;
        
        var rel =  allVal[pos+1];     
        allVal[pos+1] = valueToUp 
        allVal[pos] = rel;        
        cmp.set("v.SelectedValueList",allVal);
    }
    
})