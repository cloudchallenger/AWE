public without sharing class Milestone1_TaskAWEhandler{
        
public static void afterInsert( List<Milestone1_Task__c> newList){
     
    Set<Id> Ids = new Set<Id>();
    String sobjName='Milestone1_Task__c';
    for(Milestone1_Task__c a : newList){
         Ids.add(a.Id);
    }
    Boolean evaluate = AW_AdvanceWorkflowExecutionEngine.EvaluationRunningFor.contains(sobjName)?false:true;
   system.debug('--> EVALUATE INSERT Milestone1_Task '+ evaluate);
   // if (Ids.size()>0 && AW_AdvanceWorkflowExecutionEngine.EvaluationIsRunning==false){
   if (Ids.size()>0 && evaluate ){
             AW_AdvanceWorkflowExecutionEngine.startRulesProcessing(Ids,sobjName,Trigger.isInsert);    
   	
    }   
 }
  
 public static void afterUpdate(List<Milestone1_Task__c> newList,Map<Id,Milestone1_Task__c> oldMap){
      
    Set<Id> Ids = new Set<Id>();
     String sobjName='Milestone1_Task__c';
     for(Milestone1_Task__c a : newList){
         Ids.add(a.Id);
    }
  Boolean evaluate = AW_AdvanceWorkflowExecutionEngine.EvaluationRunningFor.contains(sobjName)?false:true;
  system.debug('--> EVALUATE UPDATE Milestone1_Task '+evaluate);
    // if (Ids.size()>0 && AW_AdvanceWorkflowExecutionEngine.EvaluationIsRunning==false){
      if (Ids.size()>0 && evaluate  ){
             AW_AdvanceWorkflowExecutionEngine.oldListMap = oldMap;
             AW_AdvanceWorkflowExecutionEngine.startRulesProcessing(Ids,sobjName,Trigger.isInsert);    
            }   
 }
    
    

}