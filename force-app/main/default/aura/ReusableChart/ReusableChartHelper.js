({
    createChart : function (component) {
        
        console.log('$$$$$$$$$ ClassWiseConverageChartHelper Called.');
        console.log('$$$$$$$$$ Org Name'+ component.get("v.orgname")); 
        var ready = component.get("v.ready");
        if (ready === false) {
            return;
        }
        
        var chartData = [];
        var chartLabels = [];
        var bgColor=["#28a3ef", "#2b91f2","#032e9b","#1851e0","#4068ce","#2e96f7","#101ded","#0a13a8","#046ed1","#1e79ce"];
        var action = component.get("c.GetReportData");
        action.setParams({
            
            'strReportName' :component.get("v.selectReport") ,//'skmsDashboardReporting'
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                var reportResultData = JSON.parse(response.getReturnValue()); 
                console.log('data for json:-');
                console.log(reportResultData);
                var total = 0;
                var success = 0;
                var successPercent;
                var failPercent;
                  
                
                //handling null error
                if(reportResultData.factMap['T!T'].rows!=null){
                    
                    for(var i=0; i < (reportResultData.groupingsDown.groupings.length); i++){
                        var key=reportResultData.groupingsDown.groupings[i].key;
                        
                        
                        
                        if(reportResultData.factMap[key+'!T'].aggregates[0].value==null)
                            chartData.push(0);  
                        else
                            chartData.push(reportResultData.factMap[key+'!T'].aggregates[0].value);
                        
                        chartLabels.push(reportResultData.groupingsDown.groupings[i].label);
                        
                    }
                    
                    
                }
                
                console.log('chartLabels '+chartLabels);
                console.log('chartData '+chartData);          
                var contributionChart=null; 
                var self = this;
                var canvas = document.getElementById('canvas');
                var ctx = canvas.getContext('2d'); 
                
                
                //checking chart selection and plotting accordingly
                
                if(component.get("v.typeChart")=='bar')
                {
                    document.getElementById("funnelParent").style.display="none";
                    
                    contributionChart = new Chart(ctx, {
                        type: component.get("v.typeChart"),
                        data: {
                            labels: chartLabels,
                            datasets: [{
                                label:  'Amount',
                                data: chartData,
                                backgroundColor: bgColor
                                ,
                                borderColor:   'rgba(0, 112, 210, 1)',
                                borderWidth: 1
                            }]
                        },
                        
                        options: {
                            hover: {
                                mode: "none",
                                display:false
                            },
                            scales: {
                                yAxes: [{
                                    scaleLabel: {
                                        display: true,
                                        labelString: reportResultData.reportMetadata.detailColumns[1]
                                    }
                                }],
                                xAxes: [{
                                    scaleLabel: {
                                        display: true,
                                        labelString: reportResultData.reportMetadata.detailColumns[0]
                                    }
                                }]
                            }  
                            ,
                            legend: {
                                display: component.get("v.showLegend"),
                                position: component.get("v.legendPosition"),
                                labels: {
                                    fontColor: "#000080",
                                }
                            },
                            
                        },
                        responsive:true,
                        cutoutPercentage: 75,
                        maintainAspectRatio: false
                    }); 
                }
                
                
                
                else if(component.get("v.typeChart")=='funnel')
                {
                    this.makeFunnel(component,chartData,chartLabels);
                }
                
                
                
                
                    else
                    {
                        document.getElementById("funnelParent").style.display="none";
                        contributionChart = new Chart(ctx, {
                            type:component.get("v.typeChart"),
                            data: {
                                labels: chartLabels,
                                datasets: [{
                                    label:  'Amount',
                                    data: chartData,
                                    backgroundColor: bgColor
                                    ,
                                    borderColor:   'rgba(0, 112, 210, 1)',
                                    borderWidth: 1
                                }]
                            },
                            
                            options: {
                                hover: {
                                    mode: "none",
                                    display:false
                                },
                                
                                
                                legend: {
                                    display: component.get("v.showLegend"),
                                    position: component.get("v.legendPosition"),
                                    labels: {
                                        fontColor: "#000080",
                                    }
                                },
                                
                            },
                            responsive:true,
                            cutoutPercentage: 75,
                            maintainAspectRatio: false
                        }); 
                    }
                var action2 = component.get("c.getReportId");
                action2.setParams({
                    'strName' : component.get("v.selectReport")
                });
                action2.setCallback(this, function(response){
                    if(response.getState() === 'SUCCESS'){
                        console.log('reportId '+response.getReturnValue());
                        component.set("v.reportId", response.getReturnValue());
                    }
                });
                $A.enqueueAction(action2); 
                
            }
            
            
            else
            {
                component.set("v.noData",true);
            } 
            
            
        });
        
        $A.enqueueAction(action);               
    },
    makeFunnel: function (component,chartData,chartLabels) {
        document.getElementById("funnelContainer").style.display="block";
        document.getElementById("otherCharts").style.display="none";
        var data = [];
        for(var i=0;i<chartData.length;i++)
        {
            data.push([chartLabels[i],chartData[i]]);
        }
        console.log('!@@@@@@@@chartdata to plot:'+data);
        var width = document.getElementById('funnelContainer').offsetWidth;
        var height = document.getElementById('funnelContainer').offsetHeight;
        
        var options = {
            width: width,
            height: height
        };
        
        //[['Video Views', 1500], ['Comments', 300], ['Video Responses', 150],['Releases', 1050],['SGS', 120],['skms', 100],['private', 900],['ending', 500]];
        var chart = new FunnelChart({
            data: data,
            options, 
            
        });
            chart.draw('#funnelContainer', 2);
            
            
            
        }
        })