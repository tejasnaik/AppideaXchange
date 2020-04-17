({
    doInit : function(cmp, event, helper) {
        helper.setSimpleAddress(cmp);
        if(cmp.get("v.ShowMapOnload")){
            var d =  cmp.get("v.SimpleAddress");
            //console.log(d);
            helper.setSandardAddress(cmp,d);
            if(cmp.get("v.isCorrdinationWay")){
                if(d.latitude != null && d.longitude !=null && d.latitude != NaN && d.longitude !=NaN)
                {
                    cmp.set("v.isShowingMap",true);
                    helper.populateMap(cmp,event);
                }
            }else{
                helper.findCoordination(cmp);
            }
        }
    },
    
    showAddressPanel:function(cmp, event, helper){
        cmp.set("v.HideAddressPannel",!cmp.get("v.HideAddressPannel"));
    },
    goWithController :function(cmp, event, helper) {
        //console.log(event);
        console.log(event.currentTarget.checked);
        cmp.set("v.isCorrdinationWay",event.currentTarget.checked);
    },
    showMap :function(cmp, event, helper){
        var d =  cmp.get("v.SimpleAddress");
        //console.log(d);
        helper.setSandardAddress(cmp,d);
        if(cmp.get("v.isCorrdinationWay")){
            if(d.latitude != null && d.longitude !=null && d.latitude != NaN && d.longitude !=NaN)
            {
                cmp.set("v.isShowingMap",true);
                helper.populateMap(cmp,event);
            }
        }else{
            helper.findCoordination(cmp);
        }
    },
    
    showSpinner : function (component, event, helper) {
        var spinner = component.find('spinner');
        $A.util.removeClass(spinner,'slds-hide');
        $A.util.addClass(spinner,'slds-show');
    },
    
    hideSpinner : function (component, event, helper) {
        var spinner = component.find('spinner');
        $A.util.removeClass(spinner,'slds-show');
        $A.util.addClass(spinner,'slds-hide');
    }
})