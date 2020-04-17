({
	afterScriptsLoaded : function(component, event, helper) {
        var imageSliderComponent = component.find('ImageSlider');
        $(imageSliderComponent.getElement()).slick({
            accessibility : true,
            autoplay : true,
            dots: true,
            infinite: true,
            speed: 300,
            slidesToShow: 1,
            adaptiveHeight: true
        });
        
        $A.util.removeClass(component, 'slds-hide');
	}
})