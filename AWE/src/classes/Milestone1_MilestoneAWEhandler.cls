public without sharing class Milestone1_MilestoneAWEhandler {
public static void afterInsert( List<Milestone1_Milestone__c> newList){
    
    /*
  if(trigger.isBefore == true && (trigger.isInsert == true || trigger.isUpdate == true)) {
URL currentURL = URL.getCurrentRequestUrl();
URL comparisonURL = new URL(URL.getSalesforceBaseUrl().toExternalForm() + Page.YOUR_VF_PAGE_URL.getUrl());
system.<span class="r1it7qhke5" id="r1it7qhke5_6">debug</span>('currentURL:::'+ currentURL);
system.debug('comparisonURL:::'+ comparisonURL);
boolean knownPath = currentURL.getPath() == comparisonURL.getPath();
 
if(knownPath == true) {
// Currently You comming from Custom VF Page ("YOUR_VF_PAGE_URL")
} else {
// Currently You Comming from Standard Account Page Creation.
}
}
    
    */
    // URL comparisonURL = new URL(URL.getSalesforceBaseUrl().toExternalForm() + Page.YOUR_VF_PAGE_URL.getUrl());
    //system.<span class="r1it7qhke5" id="r1it7qhke5_6">debug</span>('currentURL:::'+ currentURL);
    URL currentURL = URL.getCurrentRequestUrl();
    URL baseURL = new URL(URL.getSalesforceBaseUrl().toExternalForm());
    URL comparisonURL = new URL(URL.getSalesforceBaseUrl().toExternalForm());
    system.debug('-->currentURL:::'+ currentURL);
    system.debug('-->comparisonURL:::'+ comparisonURL);
    boolean knownPath = currentURL.getPath() == comparisonURL.getPath();
    
    Set<Id> Ids = new Set<Id>();
    String sobjName='Milestone1_Milestone__c';
    for(Milestone1_Milestone__c a : newList){
         Ids.add(a.Id);
    }
    system.debug('-->EVALUATE INSERT MILESTONE EvaluationRunningFor ' + AW_AdvanceWorkflowExecutionEngine.EvaluationRunningFor);
    system.debug('--->IDs '+Ids);
    Boolean evaluate = AW_AdvanceWorkflowExecutionEngine.EvaluationRunningFor.contains(sobjName)?false:true;
    system.debug('-->EVALUATE INSERT MILESTONE ' +evaluate);
         
   // if (Ids.size()>0 && AW_AdvanceWorkflowExecutionEngine.EvaluationIsRunning==false){
    system.debug('-->EVALUATE INSERT MILESTONE');
   if (Ids.size()>0 &&  evaluate ){
             AW_AdvanceWorkflowExecutionEngine.startRulesProcessing(Ids,sobjName,Trigger.isInsert);    
   	
    }
       
 }
 public static void afterUpdate(List<Milestone1_Milestone__c> newList,Map<Id,Milestone1_Milestone__c> oldMap){
    URL currentURL = URL.getCurrentRequestUrl();
    URL baseURL = new URL(URL.getSalesforceBaseUrl().toExternalForm());
    URL comparisonURL = new URL(URL.getSalesforceBaseUrl().toExternalForm());
    system.debug('-->currentURL:::'+ currentURL);
    system.debug('-->comparisonURL:::'+ comparisonURL);
    boolean knownPath = currentURL.getPath() == comparisonURL.getPath();
      
    Set<Id> Ids = new Set<Id>();
     String sobjName='Milestone1_Milestone__c';
     for(Milestone1_Milestone__c a : newList){
         Ids.add(a.Id);
    }
 system.debug('-->EVALUATE UPDATE MILESTONE EvaluationRunningFor ' + AW_AdvanceWorkflowExecutionEngine.EvaluationRunningFor);
  Boolean evaluate = AW_AdvanceWorkflowExecutionEngine.EvaluationRunningFor.contains(sobjName)?false:true;
 system.debug('-->EVALUATE UPDATE MILESTONE' +evaluate);
      // if (Ids.size()>0   ){
      system.debug('--->IDs '+Ids);
        if (Ids.size()>0 && evaluate  ){	
             AW_AdvanceWorkflowExecutionEngine.oldListMap = oldMap;
             AW_AdvanceWorkflowExecutionEngine.startRulesProcessing(Ids,sobjName,Trigger.isInsert);    
            }   
 }
    
 
 
}