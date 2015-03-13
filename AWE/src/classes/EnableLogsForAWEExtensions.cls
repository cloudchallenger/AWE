public with sharing class EnableLogsForAWEExtensions {
	public Advance_Workflow__c advWorkflow{get; set;}
	
	public EnableLogsForAWEExtensions(ApexPages.StandardController stdController){
		Id advWFId = (ID)stdController.getId();
		if(advWFId != null){
			for(Advance_Workflow__c advWF : [select id , is_Log_Enabled__c from Advance_Workflow__c where id = : advWFId]){
				advWorkflow = advWF;
			}
		}
	}
	
	public PageReference updateLogging(){
		if(advWorkflow != null){
			advWorkflow.is_Log_Enabled__c = !advWorkflow.is_Log_Enabled__c;
			try{
				update advWorkflow;
				return new PageReference('/'+advWorkflow.id);
			}catch(Exception ex){
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ex.getMessage()));
        		return null;
			}
		}
		return null;
	}

}