trigger Account_aInsertaUpdate on Account (after insert, after update) {

   
    Set<Id> Ids=new Set<Id>();
    String sobjName='Account';
    
    
    //add all the accountids in the set
    for (Account a:trigger.new){
        Ids.add(a.Id);
    }//for 

    
      
    Boolean evaluate =  AW_AdvanceWorkflowExecutionEngine.EvaluationRunningFor.contains(sobjName)?false:true;
       if (evaluate){       
           if(Trigger.isUpdate)
               // AWE.AW_AdvanceWorkflowExecutionEngine.oldListMap = Trigger.oldMap;
               // AWE.AW_AdvanceWorkflowExecutionEngine.startRulesProcessing(Ids,sobjName,Trigger.isInsert);    
                AW_AdvanceWorkflowExecutionEngine.oldListMap = Trigger.oldMap;
                AW_AdvanceWorkflowExecutionEngine.startRulesProcessing(Ids,sobjName,Trigger.isInsert);    
        
    }   
 }