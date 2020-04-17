({
    executer : function(cmp) {
        this.ratingBYPerson(cmp);           
        var ele = cmp.find('StarInputfieldId').getElement();
                    $(ele).rating({
                        displayOnly: true, 
                        step: 0.5,
                        starCaptions: function (val) {
                        },
                        starCaptionClasses: function (val) {
                            if (val < 3) {
                                return 'label label-danger';
                            } else {
                                return 'label label-success';
                            }
                        },
                        hoverOnClear: false
                    });
    },
    
    ratingBYPerson : function(component){ 
    	var rec = component.get("v.records");
        var NField = component.get("v.RatingNumberField");
        var userField = component.get("v.RatingUserField");
        if(rec != null && rec.length >0){
             console.log(rec.length);
            var userMap = new Map();
            userMap.set('star5', 0);
            userMap.set('star4', 0);
            userMap.set('star3', 0);
            userMap.set('star2', 0);
            userMap.set('star1', 0);
            var userList = [];
            for(var i=0;i<rec.length;i++){
                if(rec[i][NField] != null && rec[i][NField] != undefined){
                   var t = userMap.get('star'+rec[i][NField]);
                    var tt = t + 1;
                    userMap.set('star'+rec[i][NField],tt);
                }
            }
            var jsonData = [];
            var sn = 1;
            for (var [key, value] of userMap) {
                var pre = {
                    "S_NO":sn,
                    "StarName":key.replace('star',''),
                    "NumberOfPerson":value,
                    "percentage":((value/rec.length)*100).toFixed(2)
                };
                sn++;
                jsonData.push(pre);
            }
			component.set("v.DataToAllUserRating",jsonData);
        }

    },
    
})