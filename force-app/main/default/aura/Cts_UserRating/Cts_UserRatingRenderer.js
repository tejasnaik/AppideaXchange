({
	 afterRender : function(component, helper) {
        this.superAfterRender();
         try{
        helper.executer()
         }catch(err){}
    }
})