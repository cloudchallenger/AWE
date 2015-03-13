trigger Milestone1_Task_Trigger on Milestone1_Task__c ( before insert, before update,after insert,after update ) {

	if(trigger.isBefore) {
		Milestone1_Task_Trigger_Utility.handleTaskBeforeTrigger(trigger.new);  
	} 
	
	if(trigger.isAfter) {
		 if (trigger.isInsert){
         // Call AWE  after Insert
            
              Milestone1_TaskAWEhandler.afterInsert(Trigger.new);
             
    	}
		if(Trigger.isUpdate){
	        //shift Dates of successor Tasks if Task Due Date is shifted
	        Milestone1_Task_Trigger_Utility.checkSuccessorDependencies(trigger.oldMap, trigger.newMap);
		    Milestone1_TaskAWEhandler.afterUpdate(Trigger.new,Trigger.oldMap);
		}
		Milestone1_Task_Trigger_Utility.handleTaskAfterTrigger(trigger.new,trigger.old);
	} 

}