@IsTest(SeeAllData=true)
private class ManagerControllerTest {

    static String developerName = 'AnlyTx_COVID19_Impact_Analysis';
    static String templateApiName =   developerName;
    
   static testMethod void positiveTests() {
        
        System.debug('Calling ManagerController.queryEmbeddedApp with templateApiName: ' + templateApiName);
        
        Folder app = ManagerController.queryEmbeddedApp(templateApiName);
        
        System.debug('app: ' + app);  
        System.debug('Calling ManagerController.getEmbeddedApp with templateApiName: ' + templateApiName);
        
        String appJson = ManagerController.getEmbeddedApp(templateApiName);
 
        System.debug('appJson: ' + appJson);
        
       app = (Folder) JSON.deserializeStrict(appJson, Folder.class);
 
        System.debug('app: ' + app);
        
        
        System.assertEquals(app.DeveloperName, developerName);
        
 
        
        System.debug('Calling ManagerController.getAutoInstallRequestsByTemplateApiName with templateApiName: ' + templateApiName);
        
        String requestJson = ManagerController.getAutoInstallRequestsByTemplateApiName(templateApiName);
        
        System.debug('requestJson: ' + requestJson);
        
        if(requestJson !=null)
        {
        WaveAutoInstallRequest request = (WaveAutoInstallRequest) JSON.deserializeStrict(requestJson, WaveAutoInstallRequest.class);
        
        System.debug('request: ' + request);
        
        System.assertEquals(request.TemplateApiName, templateApiName);
        //System.assertEquals(request.DeveloperName, developerName);
        }
        
    }
     
    static testMethod void negativeTests() {
        String badTemplateApiName = 'bad__Non_Existent_Template';
 
        System.debug('Calling ManagerController.createEmbeddedApp with badTemplateApiName: ' + badTemplateApiName);
 
        
        String name = 'Negative test - bad templateApiName';
        
        Map<String, Object> appConfiguration = new Map<String, Object>();
        
        String id = ManagerController.createEmbeddedApp(badTemplateApiName, name, appConfiguration);
 
        System.debug('id: ' + id);
        
        System.assertNotEquals(null, id);
        
        
        System.debug('Calling ManagerController.deleteEmbeddedApp with badTemplateApiName: ' + badTemplateApiName);
        
        String resp = ManagerController.deleteEmbeddedApp(badTemplateApiName);
        
        System.debug('resp: ' + resp);   
        //system.assert(resp.contains('Error'));
        //System.assertEquals(resp, '{"Error":"Embedded App for Template ' + badTemplateApiName + ' not found"}');
        resp = ManagerController.startDataFlow();
    }
}