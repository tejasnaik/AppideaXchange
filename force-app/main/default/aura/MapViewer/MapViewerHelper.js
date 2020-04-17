({
    mapCreater : function(component, event) 
    {
        var lat = component.get("v.latitude");
        var lng = component.get("v.longitude");
        var description = component.get("v.description");
        var accessToken = component.get("v.accessToken");
        var userId = component.get("v.userId");
        var mymap = L.map('mapId', {zoomControl: true}).setView([lat, lng], 16);
        //var mymap = L.map('mapId').setView([51.505, -0.09], 13);
        
        L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.jpg70?access_token={accessToken}', {
            maxZoom: 18,
            id: userId,
            accessToken:accessToken 
        }).addTo(mymap);
        
        console.log(">>description>>>"+description);
        // Add marker
        var marker = window.L.marker([lat, lng]);
        marker.addTo(mymap).bindPopup(description);
        
        
        
        /*var polygon = L.polygon([
            [51.509, -0.08],
            [51.503, -0.06],
            [51.51, -0.047]
        ]).addTo(mymap);
        var circle = L.circle([lat, lng]).addTo(mymap);*/
        
    },
    
    fireScriptsLoadCompleteEvent: function(component) {
        var loadCompleteEvent = component.getEvent("scriptsLoadComplete");
        loadCompleteEvent.fire();
    },
    
})