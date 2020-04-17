({
	getField : function(component) {
        var objField = component.get("v.field");
        var objID = component.get("v.recordId");
        var technique = component.get("v.selecttechnique");
		
	},
    getDetails : function(component) {
        var objField = component.get("v.field");
        var objID = component.get("v.recordId");
        var technique = component.get("v.selecttechnique");
        
        var action = component.get("c.getFields");
        action.setParams({ 
            "objID": objID,
            "objField": objField
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.selectedField", response.getReturnValue());
                this.getCode(component,response.getReturnValue(), technique);
            }
        });
        $A.enqueueAction(action);
    },
    getCode : function(component, returnValue, technique) {        
        var value = returnValue;
        var btype = technique;
        var renderer = "css";
        
        var quietZone = false;
        
        var settings = {
          output:renderer,
          bgColor: "#FFFFFF",
          color: "#000000",
          barWidth: "1",
          barHeight: "35",
          moduleSize: "5",
          posX: "10",
          posY: "20",
          addQuietZone: "1"
        };
        
        if ($("#rectangular").is(':checked') || $("#rectangular").attr('checked')){
            value = {code:value, rect: true};
        }
        
        if (renderer == 'canvas'){
            //confirm("In Convas");
        } else {
          $("#canvasTarget").hide();
          $("#multibarcode").html("");
          $("#barcodeTarget").html("").show();
          $("#barcodeTarget").barcode(value, btype, settings);
          
          $("#multibarcode").append("<div class='subbarcode' style='float:left;margin-top:5px;height:90px;'><div class='productdetails' style='width: 84%; font-weight: bold;margin-left: 8px;background-color: #FFFFFF; color: #000000;font-size: 8px;text-align: center;vertical-align: bottom;vertical-align: bottom;text-overflow: ellipsis;white-space: nowrap;overflow: hidden;margin-top:5px;'></div>"+$("#barcodeTarget").html()+"</div>");
          $("#barcodeTarget").hide();
          $("#multibarcode").show();
        }
        var codeval = $("#multibarcode").html();
        var parentId = component.get("v.recordId");
        var objField = component.get("v.selectedField");
        var technique = component.get("v.selecttechnique");
        
        var action = component.get("c.saveTheFile");
        action.setParams({ 
            "codeval": codeval,
            "parentId": parentId,
            "technique": technique,
            "objField": objField
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                if(response.getReturnValue() != ''){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "type": "success",
                        "message": response.getReturnValue()
                    });
                    toastEvent.fire();
                }
            }
        });
        $A.enqueueAction(action);
    },
})