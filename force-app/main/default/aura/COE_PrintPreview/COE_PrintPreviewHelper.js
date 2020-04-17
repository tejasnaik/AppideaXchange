({
    // To open printable view web page 
    getViewURL : function(component, event) {
        window.open(component.get("v.viewURL") , '_blank');
    }
})