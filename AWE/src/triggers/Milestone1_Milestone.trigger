trigger Milestone1_Milestone on Milestone1_Milestone__c (after insert, after update) {
if(Trigger.isafter){
		    if(Trigger.isInsert){
             // Call AWE  after Insert
             
             // if(MilestoneMilestoneFlowManager.AWE_INVOKE_INSERT ) {  
                  //system.debug('-->Call AWE  after Insert MilestoneMilestoneFlowManager.AWE_INVOKE_INSERT '+ MilestoneMilestoneFlowManager.AWE_INVOKE_INSERT);
                   Milestone1_MilestoneAWEhandler.afterInsert(Trigger.new);
		   //        MilestoneMilestoneFlowManager.AWE_INVOKE_INSERT=false;
         // }			
	   } 
	  
     if(Trigger.isUpdate){
           // Milestone1_Milestone_Trigger_Utility.handleMilestoneAfterTrigger(trigger.newMap);
            //shift Deadline of successor Milestones if Milestone Deadline is shifted
           // Milestone1_Milestone_Trigger_Utility.checkSuccessorDependencies(trigger.oldMap, trigger.newMap);
            //shift children Milestone dates if Milestone dates are shifted
          //  Milestone1_Milestone_Trigger_Utility.checkChildDependencies(trigger.oldMap, trigger.newMap);
            //shift Task dates if Milestone dates are shifted
         //   Milestone1_Milestone_Trigger_Utility.checkTaskDependencies(trigger.oldMap, trigger.newMap);
            //Send Email alert for MS030 and MS074 If milestone is due
         //   Milestone1_Milestone_Trigger_Utility.sendMailForMSDue(trigger.new, trigger.oldMap);
            //Send Email alert for MS030 and MS074 If milestone is due
           // if(!Milestone1_Milestone_Trigger_Utility.isGroupMSDueDateUpdated){
            //	Milestone1_Milestone_Trigger_Utility.autoUpdateDueDates(trigger.new, trigger.oldMap);
           // }
            // Call AWE  after Update
			//system.debug('-->Call AWE  after UPDATE MilestoneMilestoneFlowManager.AWE_INVOKE_UPDATE '+ MilestoneMilestoneFlowManager.AWE_INVOKE_UPDATE);
			Milestone1_MilestoneAWEhandler.afterUpdate(Trigger.new,Trigger.oldMap);  
        }  
}
}