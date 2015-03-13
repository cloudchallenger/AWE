/*
 (c) 2013 Appirio, Inc.
 Description        : Handler Class for AWE
 July 24, 2013     : Peter Babalis (Appirio)
*/
public with sharing class LeadAWEtriggerHandler {
    
public static void afterInsert( List<Lead> newList){
  Set<Id> Ids = new Set<Id>();
    String sobjName='Lead';
    for(Lead a : newList){
         Ids.add(a.Id);
    }
    
    Boolean evaluate =  AW_AdvanceWorkflowExecutionEngine.EvaluationRunningFor.contains(sobjName)?false:true;
    Integer batchThreshold =2;
    integer j=0;
    Set<Id> bufferIds = new Set<Id>();
    
  for (Id bufId : Ids) {
  	
           j=j+1;
           if (j > batchThreshold ) {  
            	bufferIds.add(bufId);
           	     j=0;
          // 	AW_AdvanceWorkflowExecutionEngine.startRulesProcessing(bufferIds,sobjName,Trigger.isInsert);    
                bufferIds = new Set<Id>();
                system.debug('Buffer Ids '+ bufferIds);
            } 
  }
     
    if (Ids.size()>0 &&  evaluate ){
        AW_AdvanceWorkflowExecutionEngine.startRulesProcessing(Ids,sobjName,Trigger.isInsert);    
    
    }  
  
  }
 /*
 
 global class AccountBatch implements Database.batchable<sObject>{ 
    //maintain count of active assets on accounts
    public String query='Select Id, Name From Account';
    
    global database.querylocator start(Database.BatchableContext BC){
      if (Test.isRunningTest()){
            query += ' limit 200';
        }
      return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<SObject> scope){
       
        if (scope.size() > 0){
            for(Account s : (List<Account>)scope){
                s.Name = s.Name + 'test';
            }
            try{
                update scope;
            } catch (Exception e){}
        }
    }
    
    global void finish(Database.BatchableContext BC){}
        //Schedule the next batch job to run for 24 hours later:}

}
 */  
 public static void afterUpdate(List<Lead> newList,Map<Id,Lead> oldMap){
   Set<Id> Ids = new Set<Id>();
     String sobjName='Lead';
     for(Lead a : newList){
         Ids.add(a.Id);
    }
    
      system.debug('--->LeadAWEtriggerHandler ids ' +Ids);
      Boolean evaluate = AW_AdvanceWorkflowExecutionEngine.EvaluationRunningFor.contains(sobjName)?false:true;
       if (Ids.size()>0 && evaluate  ){
            AW_AdvanceWorkflowExecutionEngine.oldListMap = oldMap;
            AW_AdvanceWorkflowExecutionEngine.startRulesProcessing(Ids,sobjName,Trigger.isInsert);    
       }   
  
 }
    
  
}