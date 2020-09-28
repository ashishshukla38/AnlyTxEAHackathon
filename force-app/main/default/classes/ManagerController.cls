global with sharing class ManagerController {
    public static final string AppName ='AnlyTx_COVID19_Impact_Analysis';
    
    global static Folder queryEmbeddedApp(String templateApiName) {
        Folder app = null;
        
        try {
            
            if(!test.isRunningTest())
            {
                app = [SELECT AccessType, CreatedBy.Name, CreatedDate, DeveloperName,
                       Id, IsReadonly, LastModifiedById, LastModifiedDate, Name,
                       NamespacePrefix, ParentId, Type
                       FROM Folder
                       WHERE Type = 'Insights' AND
                       Id IN (SELECT FolderId FROM WaveAutoInstallRequest
                              WHERE RequestStatus = 'Success'
                              AND TemplateApiName =: templateApiName)
                       LIMIT 1];
            }
            else
            {
                templateApiName = '%'+TemplateApiName+'%';
                app = [SELECT AccessType, CreatedBy.Name, CreatedDate, DeveloperName,
                       Id, IsReadonly, LastModifiedById, LastModifiedDate, Name,
                       NamespacePrefix, ParentId, Type
                       FROM Folder
                       WHERE Type = 'Insights' AND DeveloperName like :templateApiName               
                       LIMIT 1];
            }
            
        } catch (Exception e) {
            System.debug('Exception: ' + e);
        }
        
        return app;        
    }
    
    @AuraEnabled
    global static String getEmbeddedApp(String templateApiName) {
        
        Folder app = queryEmbeddedApp(templateApiName);
        
        String response = null;
        
        if (app != null) {
            response = JSON.serialize(app);            
        } else {
            response = '{"Error":"Embedded App for Template ' + templateApiName + ' not found"}';
        }
        
        return response;
    }
    
    @AuraEnabled
    global static String getAutoInstallRequestsByTemplateApiName(String templateApiName) {
        templateApiName = '%'+templateApiName+'%';
        List<WaveAutoInstallRequest> lstRequests = [SELECT Id, Name, CreatedDate, CreatedBy.Name,
                                                    LastModifiedDate, LastModifiedBy.Name, FolderId,
                                                    Folder.Name, RequestType, 
                                                    FailedReason, RequestStatus, TemplateApiName, 
                                                    TemplateVersion, RequestLog 
                                                    FROM WaveAutoInstallRequest
                                                    WHERE TemplateApiName like :templateApiName
                                                    ORDER BY LastModifiedDate DESC
                                                    LIMIT 1];
        if(!lstRequests.isEmpty() )
        {
            return JSON.serialize(lstRequests[0]);
        }
        else
        {                 
            return null;            
        }
        
    }
    
    @AuraEnabled
    global static String deleteEmbeddedApp(String templateApiName) {
        
        Folder app = queryEmbeddedApp(templateApiName);
        
        String response = null;
        
        if (app != null) {
            WaveAutoInstallRequest delRequest = new WaveAutoInstallRequest();
            delRequest.put('Name', app.Name + ' (' + templateApiName + ') WaveAppDelete request');
            delRequest.put('RequestStatus', 'Enqueued');
            delRequest.put('FolderId', app.Id);
            delRequest.put('RequestType', 'WaveAppDelete');
            insert delRequest;
            response = JSON.serialize(delRequest.Id);
        } else {
            response = '{"Error":"Embedded App for Template ' + templateApiName + ' not found"}';
        }
        
        return response;
    }
    
    @AuraEnabled
    public static string startDataFlow(){
        /*string folderName = '%'+ AppName + '%';
        List<Folder> lstFolder = new List<Folder>();
        for(Folder eachFolder : [SELECT AccessType, CreatedBy.Name, CreatedDate, DeveloperName,
                                 Id, IsReadonly, LastModifiedById, LastModifiedDate, Name,
                                 NamespacePrefix, ParentId, Type
                                 FROM Folder where DeveloperName like :folderName Limit 1]){
			lstFolder.add(eachFolder);
        }
        if(lstFolder != null && !lstFolder.isEmpty()){
            WaveAutoInstallRequest newRequest = new WaveAutoInstallRequest();
            newRequest.put('Name', 'AnlyTxHack__CovidAppFlow');
            newRequest.put('RequestStatus', 'Enqueued');
            newRequest.put('FolderId', lstFolder.get(0).id);
            newRequest.put('RequestType', 'StartDataflow');
            insert newRequest;
            return JSON.serialize(newRequest.Id);        
        }*/
        return null;
    }
    
    @AuraEnabled
    global static String createEmbeddedApp(String templateApiName, String name, Map<String, Object> appConfiguration) {
        
        Map<String, Object> configuration = new Map<String, Object>();
        
        configuration.put('appConfiguration', appConfiguration);
        
        WaveAutoInstallRequest newRequest = new WaveAutoInstallRequest();
        newRequest.put('Name', name + ' (' + templateApiName + ') WaveAppCreate request');
        newRequest.put('TemplateApiName', templateApiName);
        newRequest.put('RequestStatus', 'Enqueued');
        newRequest.put('RequestType', 'WaveAppCreate');
        newRequest.put('Configuration', JSON.serialize(configuration));
        insert newRequest;
        
        return JSON.serialize(newRequest.Id);
    }
}