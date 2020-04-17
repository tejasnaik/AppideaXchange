({
    doConstructor:function(component, event, helper) {
        if(component.get("v.PicklistOptionType") == 'STANDARDFIELD'){
            helper.getOptionsServer(component);
        }else if(component.get("v.PicklistOptionType") =='PARENTLIST'){
            var dataValue = { 'optionList':	component.get("v.ParentOptionsList")};
            helper.doIntilitze(component,dataValue);
        }
        //helper.doIntilitze(component);
    },
    
    handleClick :function(component, event, helper) {
        var mainDiv = component.find('main-div');
        $A.util.addClass(mainDiv, 'slds-is-open');
        var mainDiv = component.find('main-div2');
        $A.util.addClass(mainDiv, 'customClass'); 
    },
    
    handleMouseEnter: function(component, event, helper) {
        component.set("v.dropdownOver",true);
    },
    
    handleMouseLeave: function(component, event, helper) {
        component.set("v.dropdownOver",false);
        var mainDiv = component.find('main-div');
        $A.util.removeClass(mainDiv, 'slds-is-open');
        var mainDiv = component.find('main-div2');
        $A.util.removeClass(mainDiv, 'customClass'); 
    },
    
    handleMouseOutButton :function(component, event, helper) {
          window.setTimeout(
            $A.getCallback(function() {
                if (component.isValid()) {
                    //if dropdown over, user has hovered over the dropdown, so don't close.
                    if (component.get("v.dropdownOver")) {
                        return;
                    }
                    var mainDiv = component.find('main-div');
                    $A.util.removeClass(mainDiv, 'slds-is-open');
                    var mainDiv = component.find('main-div2');
                    $A.util.removeClass(mainDiv, 'customClass'); 
                }
            }), 200
        );
        
    },
    
    handleSelection:function(component, event, helper) {
        var item = event.currentTarget;
        var isMulti = component.get("v.isMultiPicklist");
        // console.log('--isMulti--'+isMulti);
        var selectedValueArray = new Array();
        var optionValueArray = new Array();
        var options = component.get("v.OrignalOptions");
            if (item && item.dataset) {
            var value1 = item.dataset.value;
            var selected = item.dataset.selected;
                for(var i=0;i<options.length;i++){
                    if(options[i].value ==value1 ){
                        options[i].isSelected = (options[i].isSelected=='true' || options[i].isSelected==true)?false:true;
                    }else{
                        if(!isMulti){
                            options[i].isSelected = false;
                        }
                    }
                    if(options[i].isSelected)
                    	selectedValueArray.push(options[i].value);    
                }
          
                //console.log(selectedValueArray);
          if(selectedValueArray.length==0) {
              component.set("v.selectedOption",'');
              //component.set("v.selectedOptions",[]);
          }
          else 
          {
            if(isMulti){
                component.set("v.selectedOption",selectedValueArray.join(';'));
            	//component.set("v.selectedOptions",selectedValueArray);
            }else{
                component.set("v.selectedOption",selectedValueArray[0]);
            }
          }   
          helper.checkSelectedValue(component,options);  
        }
    }
    
    
})