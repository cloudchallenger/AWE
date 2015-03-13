/**
 * Test Class for AW_ApexLogsController
 */
@isTest
private class AW_ApexLogsController_Test {
	@isTest
    static void testSearch() {
       Apex_Log__c apexLog = new Apex_Log__c(start_dtm__c = DateTime.now().addMinutes(-10) , 
        						class_name__c = 'AW_RuleActionsController', Exception_Type__c = 'Error', Log_Type__c = 'DEBUG' , Message__c = 'Debug : This is my apex Log', method_name__c = 'All');
       insert apexLog;
       AW_ApexLogsController apexLogController = new AW_ApexLogsController();
       apexLogController.apexLogger.ownerId = userInfo.getUserID();
       apexLogController.apexLogger.start_dtm__c = DateTime.now().addMinutes(-15);
       apexLogController.search();
       System.assert(apexLogController.apexLoggerResults.size() > 0 , 'Actual Apex Log Size :' +apexLogController.apexLoggerResults.size());
    }
    
    @isTest
    static void testPagination() {
       List<Apex_Log__c> apexLogs = new List<Apex_Log__c>();
       for(Integer i = 0; i < 30; i++){
       		apexLogs.add(new Apex_Log__c(start_dtm__c = DateTime.now().addMinutes(-10 + i) , 
        						class_name__c = 'AW_RuleActionsController', Exception_Type__c = 'Error', Log_Type__c = 'DEBUG' , Message__c = 'Debug : This is my apex Log' + i , method_name__c = 'All'));
       }
       insert apexLogs;
       AW_ApexLogsController apexLogController = new AW_ApexLogsController();
     
       apexLogController.apexLogger.start_dtm__c = DateTime.now().addMinutes(-30);
       apexLogController.apexLogger.stop_dtm__c = DateTime.now().addMinutes(60);
       apexLogController.search();
       System.assert(apexLogController.apexLoggerResults.size() > 0 , 'Actual Apex Log Size :' +apexLogController.apexLoggerResults.size());
       System.assert(apexLogController.hasNext);
       apexLogController.next();
       System.assert(apexLogController.pageNumber > 0);
       System.assert(apexLogController.pageSize > 0);
       System.assert(apexLogController.hasPrevious);
       apexLogController.previous();
    }
}