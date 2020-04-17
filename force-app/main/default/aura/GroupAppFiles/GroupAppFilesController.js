({
    //To set file info and URL
    runInit : function(component, event, helper) {
        var action = component.get("c.getFile"); 
        action.setParams({
            appID : component.get("v.appId"),
            iconFiles : component.get("v.files")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var fileMap = [];
                var fileList = [];
                var fileMap = response.getReturnValue();
                for(var Key in fileMap){
                    var doctype;
                    var fileType = [];
                    fileType = fileMap[Key].split("#");
                    if(fileType[1] == 'TEXT'){
                        doctype = 'doctype:txt';
                    }
                    else if(fileType[1] == 'LOG'){
                        doctype = 'doctype:txt';
                    }
                        else if(fileType[1] == 'PDF'){
                            doctype = 'doctype:pdf';
                        }
                            else if(fileType[1] == 'PNG'){
                                doctype = 'doctype:image';
                            }
                                else if(fileType[1] == 'JPG'){
                                    doctype = 'doctype:image';
                                }
                                    else if(fileType[1] == 'WORD_X'){
                                        doctype = 'doctype:word';
                                    }
                                        else if(fileType[1] == 'WORD'){
                                            doctype = 'doctype:word';
                                        }
                                            else if(fileType[1] == 'POWER_POINT_X'){
                                                doctype = 'doctype:ppt';
                                            }
                                                else if(fileType[1] == 'POWER_POINT'){
                                                    doctype = 'doctype:ppt';
                                                }
                                                    else if(fileType[1] == 'EXCEL_X'){
                                                        doctype = 'doctype:excel';
                                                    }
                                                        else if(fileType[1] == 'EXCEL'){
                                                            doctype = 'doctype:excel';
                                                        }
                                                            else{
                                                                doctype = 'doctype:attachment';
                                                            }
                    fileList.push({url:Key,title:fileType[0],type:doctype});
                }
                if(fileList==''){
                    component.set("v.show",false);
                }
                else{
                    component.set("v.iconFiles",fileList);
                    component.set("v.show",true);
                }
            }else{
                console.log('state>>'+state);
            } 
        });           
        $A.enqueueAction(action); 
    }
})