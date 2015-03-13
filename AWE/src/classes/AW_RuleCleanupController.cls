public with sharing class AW_RuleCleanupController {
	
	public string selectedCleanupOpt {get;set;}
	public string objectName {get;set;}
	public String ruleStatus {get;set;}
	public Rule__c rule {get;set;}
	public RuleCriteria__c ruleCriteria {get;set;}
	
	public AW_RuleCleanupController(){
		rule = new Rule__c();
		ruleCriteria = new RuleCriteria__c();
	}
	
	public List<SelectOption> getCleanupOptions(){
		List<SelectOption> cleanupOptions = new List<SelectOption>();
		cleanupOptions.add(new SelectOption('Delete All Rules' , 'Delete All Rules'));
		cleanupOptions.add(new SelectOption('Delete Rules of specific object' , 'Delete Rules of specific object'));
		cleanupOptions.add(new SelectOption('Delete Selected Rule' , 'Delete Selected Rule'));
		return cleanupOptions;
	
	}
	
	public List<SelectOption> getObjectsRelatedToAWE(){
		List<SelectOption> objectsRelatedToAWE = new List<SelectOption>();
		for(Advance_Workflow__c aw : [select id , Object__c from Advance_Workflow__c where Object__c != null]){
			objectsRelatedToAWE.add(new SelectOption(aw.Object__c , aw.Object__c));
		}
		return objectsRelatedToAWE;
	}
	
	public PageReference populateObjectPicklist(){
		return null;
	}
	
	public PageReference cleanupRules(){
		List<Rule__c> rulesToDelete;
		if(selectedCleanupOpt == null || selectedCleanupOpt == ''){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select a option before clean up')); 
            return null;
		}
		if(selectedCleanupOpt == 'Delete All Rules'){
			rulesToDelete = [select id from Rule__c limit 10];
		}else if(selectedCleanupOpt == 'Delete Rules of specific object'){
			if(objectName == null || objectName == ''){
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select a object before with this clean up option')); 
            	return null;
			}
			if(rule.status__c == null || rule.Status__c == ''){
				rulesToDelete = [select id from Rule__c limit 10000];
			}else{
				rulesToDelete = [select id from Rule__c where Status__c = : rule.Status__c limit 10000];
			}
		}else if(selectedCleanupOpt == 'Delete Selected Rule'){
			if(ruleCriteria.rule__c == null){
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select a rule before with this clean up option')); 
            	return null;
			}
			rulesToDelete = new List<Rule__c>{new Rule__c(id = ruleCriteria.rule__c)};
		}
		if(!rulesToDelete.isEmpty()){
			try{
				delete rulesToDelete;
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,rulesToDelete.size() + ' Rules are deleted successfully')); 
			}catch(Exception ex){
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage())); 
            	return null;
			}
		}
		return null;
	}

}