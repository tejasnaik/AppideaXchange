({
	afterScriptsLoaded : function(component, event, helper) {
        var ratingsComponent = component.find('Rating');
        $(ratingsComponent.getElement()).barrating({
            theme: component.get('v.theme'),
            initialRating: component.get('v.initialRating'),
            readonly: component.get('v.readOnly'),
            reverse: component.get('v.reverse'),
            onSelect : function(value, text) {
                window.setTimeout(
                    $A.getCallback(function() {
                        if (component.isValid()) {
                            helper.updateRating(component, event, helper, value, text);
                        }
                    }), 100
                );
            }
        });
        
        $A.util.removeClass(ratingsComponent, 'slds-hide');
	}
})