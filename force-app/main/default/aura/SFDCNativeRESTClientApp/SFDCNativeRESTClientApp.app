<!--
* @App : SFDCNativeRESTClientApp.
* @author Original:narayana(573339)
* @date Original: 08/18/2017
* @description : This application display Salesforce native REST client screen.
* @Change History : 
-->
<aura:application extends="force:slds" implements="force:appHostable,flexipage:availableForAllPageTypes" controller="HTTPReqtResControllerClass" >
    <aura:attribute name="SFDCNativeRESTClientList" type="SFDC_Native_REST_Client__c[]" access="public" />
    <aura:attribute name="inputReqData" type="InputDataClass" access="public" />
    <aura:attribute name="inputReqDataList" type="InputDataClass[]" access="public" />
    <aura:attribute name="inputReqDataEmptyList" type="InputDataClass[]" access="public" />
    <aura:attribute name="headerList" type="object[]" default=""/>
    <aura:attribute name="selectedType" type="String" default=""/>
    <aura:attribute name="enableBasicauth" type="String" default="NoAuth"/>
    <aura:attribute name="responseBody" type="String"/>
    <aura:handler name="init" value="{!this}" action="{!c.doInit}"/>
    <aura:handler event="aura:waiting" action="{!c.showSpinner}"/>
    <aura:handler event="aura:doneWaiting" action="{!c.hideSpinner}"/>
    <div aura:id="spinnerID" class="slds-hide">
        <div class="slds-backdrop slds-backdrop--open">
            <div role="status" class="slds-spinner slds-spinner--large slds-spinner--brand">
                <span class="slds-assistive-text">Loading...</span>
                <div class="slds-spinner__dot-a"></div>
                <div class="slds-spinner__dot-b"></div>
            </div>
        </div>
    </div>
    
    <div class="slds-media__body slds-m-around_x-small">                  
        <div class="slds-notify slds-notify_alert slds-theme_alert-texture slds-theme_info" role="alert">
            <span class="slds-text-heading_medium"><b>Salesforce Native REST Client </b></span>
        </div>
        
    </div>
    <div class="slds-m-around_x-small">
        <div class="slds-grid slds-wrap" style="width:100%">
            <div class="slds-col" style="width:24%">
                <div class="slds-scrollable--x" >
                    <article class="slds-card slds-scrollable" style="height:420px;">
                        <table class="slds-table slds-table--bordered slds-table--cell-buffer ">
                            <thead>
                                <tr >
                                    <th scope="col">
                                        <div class="slds-truncate TextAlignment" ><b>Method</b></div>
                                    </th>
                                    <th scope="col">
                                        <div class="slds-truncate TextAlignment" ><b>URL</b></div>
                                    </th>
                                </tr>
                            </thead>
                            <tbody>  
                                <aura:iteration items="{!v.inputReqDataList}" var="item" indexVar="index">
                                    <aura:renderIf isTrue="{!item.isSelected == true}">
                                        <tr style="background-color:lightskyblue;" data-record="{!item.id}" onclick="{!c.showReqDetail}" >
                                            
                                            <td data-label="Type">
                                                <div class="slds-truncate TextAlignment">{!item.methodType}</div>
                                            </td>                                
                                            
                                            <td data-label="Status">
                                                <div class="slds-truncate TextAlignment">{!item.URL}</div>
                                            </td>
                                            
                                        </tr>
                                        <aura:set attribute="else">
                                            
                                            
                                            <tr  data-record="{!item.id}" onclick="{!c.showReqDetail}" >
                                                
                                                <td data-label="Type">
                                                    <div class="slds-truncate TextAlignment">{!item.methodType}</div>
                                                </td>                                
                                                
                                                <td data-label="Status">
                                                    <div class="slds-truncate TextAlignment">{!item.URL}</div>
                                                </td>
                                                
                                            </tr>
                                        </aura:set>
                                    </aura:renderIf>
                                </aura:iteration> 
                            </tbody>
                        </table>
                    </article>
                </div> 
            </div>
            <div class="slds-col" style="width:76%">
                
                
                <div class="slds-grid slds-size--1-of-1">
                    <div class="slds-form-element__control slds-size--1-of-7">
                        <ui:inputselect class="slds-select"  aura:id="MethodId">
                            <ui:inputselectoption text="Method" label="--Method--"/>
                            <ui:inputselectoption text="GET" label="GET"/>
                            <ui:inputselectoption text="POST" label="POST" />
                            <ui:inputselectoption text="DELETE" label="DELETE"/>					                       
                        </ui:inputselect>  
                    </div>
                    <div class="slds-form-element__control slds-size--4-of-6">                    
                        <div aura:id="cardID">
                            <div class="slds-form-element">
                                <ui:inputText aura:id="urlIDValue"                                          
                                              class="slds-input"
                                              labelClass="slds-form-element__label"                                         
                                              placeholder="Enter URL"
                                              />
                            </div>
                        </div>
                    </div>               
                    <div aura:id="buttonID" class="slds-m-left--small">
                        <lightning:button label="Send" name="Send" class="slds-button slds-button--brand slds-m-bottom--x-small" aura:id="sendBtn"  onclick="{!c.fireRequest}"  ></lightning:button>                         
                    </div>
                    <div aura:id="SavebtnID" class="slds-m-left--small">
                        <lightning:button label="Save" name="Save" class="slds-button slds-button--brand slds-m-bottom--x-small" aura:id="SaveBtn"  onclick="{!c.fireRequest}"  >Save</lightning:button>                         
                    </div>                
                </div>
                
                <div class="slds-media__body slds-m-around_x-small">        
                    <table class="slds-s-top--small">
                        <tr>
                            <div class="slds-grid ">
                                <div class="slds-col ">
                                    <th scope="row" data-label="Authorization">
                                        <span class="slds-radio">								
                                            <input type="radio" id="AuthorizationID" name="RadioOptionsId" onclick="{!c.invokeAuthorization}" />	
                                            <label class="slds-radio__label" for="AuthorizationID">
                                                <span class="slds-radio--faux"></span>
                                                <aura:renderIf isTrue="{!v.selectedType == 'Authorization'}" >
                                                    
                                                    <b><u>Authorization</u> &nbsp; &nbsp;&nbsp; &nbsp;</b>
                                                    <aura:set attribute="else">
                                                        <b>Authorization &nbsp; &nbsp;&nbsp; &nbsp;</b>
                                                    </aura:set>
                                                </aura:renderIf>
                                            </label>
                                        </span>
                                    </th>                                  
                                    <th scope="row" data-label="Headers">
                                        <span class="slds-radio">								
                                            <input type="radio" id="HeadersID" name="RadioOptionsId"  onclick="{!c.invokeHeaders}" />								
                                            <label class="slds-radio__label" for="HeadersID">
                                                <span class="slds-radio--faux"></span>
                                                <aura:renderIf isTrue="{!v.selectedType == 'Headers'}" >										
                                                    <b><u>Headers</u> &nbsp; &nbsp;&nbsp; &nbsp;</b>
                                                    <aura:set attribute="else">
                                                        <b>Headers &nbsp; &nbsp;&nbsp; &nbsp;</b>
                                                    </aura:set>
                                                </aura:renderIf>
                                            </label>
                                        </span>
                                    </th> 
                                    <th scope="row" data-label="Body">
                                        <span class="slds-radio">								
                                            <input type="radio" id="BodyID" name="RadioOptionsId"  onclick="{!c.invokeBody}" />								
                                            <label class="slds-radio__label" for="BodyID">
                                                <span class="slds-radio--faux"></span>
                                                <aura:renderIf isTrue="{!v.selectedType == 'Body'}" >										
                                                    <b><u>Body</u> &nbsp; &nbsp;&nbsp; &nbsp;</b>
                                                    <aura:set attribute="else">
                                                        <b>Body &nbsp; &nbsp;&nbsp; &nbsp;</b>
                                                    </aura:set>
                                                </aura:renderIf>
                                            </label>
                                        </span>
                                    </th> 
                                </div>                          
                            </div>
                        </tr>
                    </table> 
                </div>
                
                <aura:renderIf isTrue="{!v.selectedType == 'Authorization'}">
                    <table class="slds-table slds-table--bordered slds-table--cell-buffer " >
                        <tr >
                            <div class="slds-grid slds-m-left--large">                
                                <td class="slds-size--1-of-7">                                        
                                    <label><b>Type &nbsp;&nbsp; </b></label>                                          
                                </td>
                                <td class="slds-size--2-of-7">                  
                                    <ui:inputselect class="slds-select" aura:id="TypeId" change="{!c.onTypeChange}" >
                                        <ui:inputselectoption text="NoAuth" label="No Auth"/>
                                        <ui:inputselectoption text="BasicAuth" label="Basic Auth"/>
                                        <ui:inputselectoption text="OAuth2" label="OAuth 2.0" />                        
                                    </ui:inputselect>                   
                                </td>               
                            </div>
                        </tr>
                        <aura:renderIf isTrue="{!v.enableBasicauth == 'BasicAuth'}">
                            <tr >
                                <div class="slds-grid slds-m-left--large">                
                                    <td class="slds-size--1-of-7">                                        
                                        <label><b>Username </b></label>                                         
                                    </td>
                                    <td class="slds-size--2-of-7"> 
                                        <div aura:id="cardID">
                                            <div class="slds-form-element">
                                                <ui:inputText aura:id="UsernameId"                                   
                                                              class="slds-input"
                                                              labelClass="slds-form-element__label"                                         
                                                              placeholder="Enter Username"
                                                              />
                                            </div>
                                        </div>
                                        
                                    </td>               
                                </div>
                            </tr>
                            <tr >
                                <div class="slds-grid slds-m-left--large">                
                                    <td class="slds-size--1-of-7">                                        
                                        <label><b>Password </b></label>                                         
                                    </td>
                                    <td class="slds-size--2-of-7"> 
                                        <div >
                                            <div class="slds-form-element">
                                                <ui:inputText aura:id="PasswordId"                                          
                                                              class="slds-input"
                                                              labelClass="slds-form-element__label"                                         
                                                              placeholder="Enter Password"
                                                              />
                                            </div>
                                        </div>
                                        
                                    </td>               
                                </div>
                            </tr>
                        </aura:renderIf>
                        
                        <aura:renderIf isTrue="{!v.enableBasicauth == 'OAuth2'}">
                            
                            <tr >
                                <div class="slds-grid slds-m-left--large">                
                                    <td class="slds-size--1-of-7">                                        
                                        <label><b>Username</b></label>                                         
                                    </td>
                                    <td class="slds-size--2-of-7"> 
                                        <div >
                                            <div class="slds-form-element">
                                                <ui:inputText aura:id="usernameId"                                          
                                                              class="slds-input"
                                                              labelClass="slds-form-element__label"
                                                              />
                                            </div>
                                        </div>
                                    </td>               
                                </div>
                            </tr>
                            <tr >
                                <div class="slds-grid slds-m-left--large">                
                                    <td class="slds-size--1-of-7">                                        
                                        <label><b>Password</b></label>                                         
                                    </td>
                                    <td class="slds-size--2-of-7"> 
                                        <div >
                                            <div class="slds-form-element">
                                                <ui:inputText aura:id="passwordId"                                          
                                                              class="slds-input"
                                                              labelClass="slds-form-element__label"
                                                              />
                                            </div>
                                        </div>
                                    </td>               
                                </div>
                            </tr>
                            <tr >
                                <div class="slds-grid slds-m-left--large">                
                                    <td class="slds-size--1-of-7">                                        
                                        <label><b>Security Token</b></label>                                         
                                    </td>
                                    <td class="slds-size--2-of-7"> 
                                        <div >
                                            <div class="slds-form-element">
                                                <ui:inputText aura:id="SecuritytokenId"                                          
                                                              class="slds-input"
                                                              labelClass="slds-form-element__label"
                                                              />
                                            </div>
                                        </div>
                                    </td>               
                                </div>
                            </tr>
                            <tr >
                                <div class="slds-grid slds-m-left--large">                
                                    <td class="slds-size--1-of-7">                                        
                                        <label><b>Client ID</b></label>                                         
                                    </td>
                                    <td class="slds-size--2-of-7"> 
                                        <div >
                                            <div class="slds-form-element">
                                                <ui:inputText aura:id="ClientId"                                          
                                                              class="slds-input"
                                                              labelClass="slds-form-element__label"
                                                              />
                                            </div>
                                        </div>
                                        
                                    </td>               
                                </div>
                            </tr>
                            <tr >
                                <div class="slds-grid slds-m-left--large">                
                                    <td class="slds-size--1-of-7">                                        
                                        <label><b>Client Secret</b></label>                                         
                                    </td>
                                    <td class="slds-size--2-of-7"> 
                                        <div >
                                            <div class="slds-form-element">
                                                <ui:inputText aura:id="ClientSecretId"                                          
                                                              class="slds-input"
                                                              labelClass="slds-form-element__label"
                                                              />
                                            </div>
                                        </div>
                                    </td>               
                                </div>
                            </tr>                
                            <tr >
                                <div class="slds-grid slds-m-left--large">                
                                    <td class="slds-size--1-of-7">                                        
                                        <label><b></b></label>                                         
                                    </td>
                                    <td class="slds-size--2-of-7">                  
                                        <button class="slds-button slds-button--neutral slds-m-bottom--x-small slds-size--1-of-2" aura:id="CancelRowBtn" style="border-radius: 1%;" onclick="{!c.CancelOAuth}">Cancel</button>
                                        <button class="slds-button slds-button--brand slds-m-bottom--x-small slds-size--1-of-2" aura:id="RequestRowBtn" style="border-radius: 1%;" onclick="{!c.getOAuthToken}">Request Token</button>
                                    </td>               
                                </div>
                            </tr>                
                        </aura:renderIf>
                    </table> 
                </aura:renderIf>
                <aura:renderIf isTrue="{!v.selectedType == 'Headers'}">     
                    <table class="slds-table slds-table--bordered slds-table--cell-buffer ">
                        <thead>
                            <tr >
                                <th scope="col">
                                    <div class="slds-truncate slds-text-align--center" ><b>Key</b></div>
                                </th>
                                <th scope="col">
                                    <div class="slds-truncate slds-text-align--center" ><b>Value</b></div>
                                </th>
                                <th scope="col">
                                    <div aura:id="buttonID" class="slds-m-left--small">
                                        <button class="slds-button slds-button--brand slds-m-bottom--x-small" aura:id="addRowBtn" style="border-radius: 1%;" onclick="{!c.addRow}"  >Add</button>
                                    </div> 
                                </th>
                            </tr>
                        </thead>
                        <tbody>                
                            <aura:iteration items="{!v.headerList}" var="headerData" indexVar="index">
                                <tr>
                                    <td class="slds-size--2-of-12">
                                        <div aura:id="valueID">
                                            <div class="slds-form-element">
                                                <ui:inputText value="{!headerData.key}"                                   
                                                              class="slds-input"
                                                              labelClass="slds-form-element__label"                                         
                                                              placeholder="Enter value"
                                                              />
                                            </div>
                                        </div>
                                    </td>
                                    <td class="slds-size--2-of-12">
                                        <div aura:id="valueID">
                                            <div class="slds-form-element">
                                                <ui:inputText value="{!headerData.value}"                                   
                                                              class="slds-input"
                                                              labelClass="slds-form-element__label"                                         
                                                              placeholder="Enter value"
                                                              />
                                            </div>
                                        </div>
                                    </td>
                                    <td >
                                        <button class="slds-button slds-button--neutral slds-size--1-of-1" onclick="{!c.removeRow}" data-record="{!index}" style="height:30px; width:75px;">Remove</button>                            
                                    </td>
                                </tr>
                            </aura:iteration> 
                        </tbody>
                    </table> 
                </aura:renderIf>
                <aura:renderIf isTrue="{!v.selectedType == 'Body'}">
                    <div aura:id="valueID">
                        <body style="margin: 0px; padding: 0px">
                            <div class="slds-form-element" >
                                <!-- <ui:inputText aura:id="reqBodyId"                                          
                                                              class="slds-input"
                                                              labelClass="slds-form-element__label"
                                                              /> -->
                                <ui:inputTextArea aura:id="reqBodyId" class="slds-input"
                                                  labelClass="slds-form-element__label"
                                                  rows="15"/> 
                            </div>
                        </body>
                    </div>
                </aura:renderIf>
                
                <div class="slds-hide" aura:id="responseId"> 
                    <article class="slds-card slds-col slds-scrollable">
                       
                            <div class="slds-col slds-m-around_xxx-small"><b>Response</b></div>
                            <table class="slds-table slds-table--bordered">
                                {!v.responseBody}
                             
                            </table>
                        
                    </article>
                    
                </div>
            </div>
        </div>
    </div>
</aura:application>