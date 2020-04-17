/*
* @class : InputDataClass
* @author Original : Narayana Bondigala(573339)
* @Description : This class build HTTP request and responce data model in salesforce.
* @Change History : 
*/

public class InputDataClass {
    @AuraEnabled
    public String id{ get; set; } 
    @AuraEnabled
    public Boolean isSelected{ get; set; }
    @AuraEnabled
    public String body{ get; set; } 
    @AuraEnabled
    public String methodType{ get; set; }
    @AuraEnabled
    public String URL{ get; set; }    
    @AuraEnabled        
    public String password{ get; set; } 
    @AuraEnabled
    public String userName{ get; set; }
    @AuraEnabled
    public String type{ get; set; } 
    @AuraEnabled
    public String AUTHORIZATION{ get; set; }
    @AuraEnabled
    public String clientId{ get; set; }
    @AuraEnabled
    public String clientSecret{ get; set; }
    @AuraEnabled
    public String Securitytoken{ get; set; }
    @AuraEnabled
    public List<HeaderClass> headerList{ get; set; }
    public InputDataClass() {
        AUTHORIZATION = 'Authorization';
        headerList = new List<HeaderClass>();
    }
    /*
* @Class : HeadersClass 
* @Description : This class build customer Last invoice data model in salesforce.
*/  
    public class HeaderClass {
        @AuraEnabled
        public String key{ get; set; } 
        @AuraEnabled
        public String value{ get; set; } 
    }   
}