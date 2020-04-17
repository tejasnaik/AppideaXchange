({
	afterRender : function( component, helper ) {
        this.superAfterRender();
        
        window.onscroll = function(event) {
            if ( window.scrollY >= document.body.scrollHeight - window.outerHeight - 100 ) {
                window.setTimeout(
                    $A.getCallback(function() {
                        if (component.isValid() && !component.get('v.isLoading')) {
                            var iLimit = component.get('v.limit');
                            var ideaCount = component.get('v.ideaCount');
                            var ideaList = component.get('v.ideas');
                            iLimit += iLimit;
                            component.set('v.limit', iLimit);
                            if(ideaList.length < ideaCount) {
                                $A.util.removeClass(component.find('LoadinMoreText'), 'slds-hide');
                            	helper.fetchIdeaList(component, event, helper);    
                            }
                        }
                    })
                );
            }
        };
    }
})