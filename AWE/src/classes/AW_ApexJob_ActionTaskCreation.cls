public with sharing class AW_ApexJob_ActionTaskCreation implements AW_RuleActionInterface{ 
    public Map<String,STring> runAction(Map<String,String> mapInputParm){
        String milestoneNo = (String)mapInputParm.get('Milestone_No');
        String siteCandidateId = (String)mapInputParm.get('Site_Candidate_Id');
        String sourceTaskNo = (String)mapInputParm.get('Source_Task_No');
         
        system.debug('-->Milestone_No '+milestoneNo);
        system.debug('-->siteCandidateId '+siteCandidateId);
        system.debug('-->SourceTaskNo '+SourceTaskNo);
        
     
        Map<String,STring> returndata= new Map<String,STring>();
        Milestone1_Milestone__c oldMilestone = getMilestoneDetails(milestoneNo,siteCandidateId);
        system.debug('-->oldMilestone '+oldMilestone);
         if(oldMilestone != null){
            oldMilestone.Create_Unrelated_Task__c = sourceTaskNo;
            update oldMilestone;
            //do some action here say get :-
            returndata.put('Status','Done');
        }
        else{
            returndata.put('Status','Failure:Milestone not available to create task');
        }
        return returndata;
    }
    public String getImplementedObjApiName(){
        return 'Milestone1_Milestone__c'; 
    }
    public Milestone1_Milestone__c getMilestoneDetails(String milestoneNo, String siteCandidateId){
        Milestone1_Milestone__c milestone = null;
        for(Milestone1_Milestone__c m : [SELECT Id, project__c from Milestone1_Milestone__c WHERE MS_No__c = : milestoneNo and project__c = :siteCandidateId]){
            milestone = m;
        }
        return milestone;
    }
    
}