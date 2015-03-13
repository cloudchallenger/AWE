public with sharing class trgh_Lead {

public static final string RT_LEAD_SOPHOS_GENERATED_AE = 'Sophos Generated-AE';
    public static final string RT_LEAD_SOPHOS_GENERATED_PARTNER = 'Sophos Generated-Partner';
    public static final string RT_LEAD_SOPHOS_GENERATED_SDR = 'Sophos Generated-SDR';
    public static final string LEAD_STATUS_REASON_1_CONVERTED_TO_CONTACT = '1 - Converted to Contact';
    public static final string LEAD_STATUS_REASON_2_CONVERTED_TO_OPPORTUNITY = '2 - Converted to Opportunity';
    public static Set <ID >recordTypeIds_SophosGenerated = null;
     
    //Setup Automated Processes private variables
    private static final integer TERRITORY_MANAGEMENT = 1;
    private static final integer AWE = 2;
    private List <Lead >objectsForTMList;
    private static Set <Id >objectsForTMCache = new Set <Id >();
    private List <Lead >objectsForAWEList;
    private static Set <Id >objectsForAWECache = new Set <Id >();
    private static Integer currentOperations;
    //Send of Automated Processes setup
   
    public trgh_Lead() {
   //     initRecordTypes();
    }
    
    Boolean isAWEenabled =true;
    public void onBeforeInsert(List <Lead >newList, Map <id, Lead >newMap) 
    {
        Boolean isInsert = true;
        Boolean isUpdate = false;
        //LeadFieldUpdate.processRules(newList, null);
        // Territory Management
        //Reset operations
        currentOperations = 0;
        
       	// TransactionContext.processesExecuted.add(AutomatedProcessDefinition.TERRITORY_MANAGEMENT);
			currentOperations |=TERRITORY_MANAGEMENT;
		 
        //Set the data maps/lists for current operations
        SetDataForOperations(newList, null);
        //perform the operations for which we have data
        //since this is an insert the old list and map are null
    
    //    PerformOperations(newMap, null, null, isUpdate, isInsert);
        
        //End Territory Management
        
    
        
    }
    
    // Event Before Update
    public void onBeforeUpdate(List <Lead >newList, Map <id, Lead >newMap, List <Lead >oldList, Map <id, Lead >oldMap) 
    {
        Boolean isInsert = false;
        Boolean isUpdate = true;
        //Set the data maps/lists for current operations
        SetDataForOperations(newList, oldMap);
        
        //perform the operations for which we have data
      //  PerformOperations(newMap, oldList, oldMap, isUpdate, isInsert);
        
     
    }
    
     // Event After Insert
    public void onAfterInsert(List <Lead >newList, Map <id, Lead >newMap) 
    {
        Boolean isInsert = true;
        Boolean isUpdate = false;
          // AWE
        //Reset operations
        currentOperations = 0;
       
       //  ShareLead.shareLead(newList, oldmap);
       
        
         //	TransactionContext.processesExecuted.add(AutomatedProcessDefinition.AWE);
			currentOperations |=AWE;
		 
        
                
        SetDataForOperations(newList, null);
        //perform the operations for which we have data
        //since this is an insert the old list and map are null
        
      //  PerformOperations(newMap, null, null, isUpdate, isInsert);
        //End AWE
        
        // NS 03/19/2014 after update trigger method to update LeadShare for Partner
        //Start CMC-I-110701/S-171829 Ranjeet Singh(Appirio), Account has new field to control the partner sharing
      //  LeadPartnerSharing.processRecords(newList, null, false);
        
        //stop CMC-I-110701/S-171829 Ranjeet Singh(Appirio)
        // Update Round Robin Group Members that were added in Before Trigger
       // LeadAssignment.updateRRMembers();
   
        
    }
    
    // Event After Update
    public void onAfterUpdate(List <Lead >newList, Map <id, Lead >newMap, List <Lead >oldList, Map <id, Lead >oldMap) 
    {
        Boolean isInsert = false;
        Boolean isUpdate = true;
         // NS 03/19/2014 after update trigger method to clear the lead team
      //  trg_HandlerLeadRelatedTeam.UpdateRelatedTeam(newList, oldMap);
        
        // AWE
        //Reset operations
        currentOperations = 0;
         //	TransactionContext.processesExecuted.add(AutomatedProcessDefinition.AWE);
			currentOperations |=AWE;
		 
        //Set the data maps/lists for current operations
        SetDataForOperations(newList, oldMap);
        
        //perform the operations for which we have data
        PerformOperations(newMap, oldList, oldMap, isUpdate, isInsert);
        
        //End AWE
        // NS 03/19/2014 after update trigger method to update LeadShare for Partner
        //Start CMC-I-110701/S-171829 Ranjeet Singh(Appirio), Account has new field to control the partner sharing
        
      //  LeadPartnerSharing.processRecords(newList, oldList, true);
        
        //stop CMC-I-110701/S-171829 Ranjeet Singh(Appirio)
        // Update Round Robin Group Members that were added in Before Trigger
       // LeadAssignment.updateRRMembers();
   
        
        
    }
    
        //setup data required to be passed to specific operations based on set criteria
    private void setDataForOperations(List <Lead >affectedLeads, Map <Id, Lead >affectedLeadsPriorVersionMap) {
        //Reset collections
        objectsForTMList = new List <Lead >();
        objectsForAWEList = new List <Lead >();
        //loop scope objects to filter into operational collections
        for (Lead l :affectedLeads) {
            Lead priorVersion = affectedLeadsPriorVersionMap == null ?null :affectedLeadsPriorVersionMap.get(l.Id);
            if ((currentOperations &TERRITORY_MANAGEMENT)== TERRITORY_MANAGEMENT && !objectsForTMCache.contains(l.Id))
            {
                //add to records to process for operation
                objectsForTMList.add(l);
                //add to cache
                objectsForTMCache.add(l.Id);
            }
			
            if ((currentOperations &AWE)== AWE && !objectsForAWECache.contains(l.Id))
            {
                //add to records to process for operation
                objectsForAWEList.add(l);
                //add to cache
                objectsForAWECache.add(l.Id);
            }
            
        }

    }

//perform all operations set
    private void performOperations(Map <id, Lead >newMap, List <Lead >oldList, Map <id, Lead >oldMap, Boolean isUpdate, Boolean isInsert) {
        //ordered operations
        if ((currentOperations &TERRITORY_MANAGEMENT)== TERRITORY_MANAGEMENT &&!objectsForTMList.isEmpty()) {
         //   TerritoryAssignBatch.RunTM(objectsForTMList, oldList, newMap, oldMap, isInsert, isUpdate);
        }
        if ((currentOperations &AWE)== AWE &&!objectsForAWEList.isEmpty()&&isAWEenabled &&isInsert) {
            LeadAWEtriggerHandler.afterInsert(objectsForAWEList);
        }
        
        System.Debug('AWE Records to Process ' + objectsForAWEList);
        
        if ((currentOperations &AWE)== AWE &&!objectsForAWEList.isEmpty()&&isAWEenabled &&isUpdate) {
            LeadAWEtriggerHandler.afterUpdate(objectsForAWEList, oldMap);
        }
    }
}