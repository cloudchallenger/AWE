public with sharing class AW_LimitsConfiguratorController {
	public List<Advance_Workflow_Limits__c> lstAdvWorkflowLimits {get;set;}
	public AW_LimitsConfiguratorController(){
		lstAdvWorkflowLimits = Advance_Workflow_Limits__c.getAll().values();
	}
	
	public void saveLimits(){
		update lstAdvWorkflowLimits;
		ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Confirm,'Limits saved successfully !'));
	}
}