// 
// (c) 2014 Appirio, Inc.
//
//  AW_ExecutionHistoryController 1                                                    
//
// This class is used to display history record in various modes
//
// 01 Jul 2014     Peter Babalis     Original
public with sharing class AW_ExecutionHistoryController1 {
	  
		String advId;
		String query;
		
		public string historyBy{get;set;} 
		public string objectName{get;set;}
		
		public List<SelectOption> objOptions    {get;set;}
		
		public List<Rule_Execution_History__c> allHistoryRecords {get;set;}
		
		public ApexPages.StandardSetController setCon {get;set;}
		Public Integer noOfRecords{get; set;}
    	Public Integer size{get;set;}
		
		/*
		  variable that stores this value for which the history needs to be filter
		*/
		public string filterValue{get;set;}
		public string recordCaptureName{get;set;}
		public String recKeyPrefix{get;set;}
		public String ruleKeyPrefix{get;set;}
		
		public AW_ExecutionHistoryController1(Apexpages.StandardController ctrl){
			 advId = ctrl.getId();
			 objectName=[Select  Object__c FROM Advance_Workflow__c WHERE Id =:advId].Object__c;
			 recKeyPrefix = Schema.getGlobalDescribe().get(objectName.toLowerCase()).getDescribe().getKeyPrefix();	
			 ruleKeyPrefix= Schema.getGlobalDescribe().get('Rule__c').getDescribe().getKeyPrefix();	
			 size=20;
			 
		}
		
		public AW_ExecutionHistoryController1(){
			historyBy= ApexPages.currentPage().getParameters().get('historyBy');
		 	filterValue= ApexPages.currentPage().getParameters().get('filterValue');
			buildquery();
			
			allHistoryRecords = database.query(query);
		}
		
		private void buildquery(){
				
			/*
			  build the query for the filter
			*/	
			query='Select CreatedDate, Id,Rule__c,Advance_Workflow__c,Criteria__c,Record_After_Action_Applied__c,	Actions__c,Evaluation__c,Execution__c,Record_ID__c,Record_Name__c,RuleName__c,Rule_Execution_Status__c,	Rule_object__c,	Rule_Version__c,Transaction_Stamp__c FROM Rule_Execution_History__c WHERE Id!=\'\'';
			if(historyBy=='historybyobject'  ){
				query+=' AND Rule_object__c=\''+filterValue+'\'';			
			}else if(historyBy=='historybyrecord'  ){
				query+=' AND Record_ID__c LIKE \''+filterValue+'%\'';  			
			}else if(historyBy=='historybyrule'  ){
				query+=' AND Rule__c LIKE \''+filterValue+'%\'';  			
			}else {
				query+=' AND Transaction_Stamp__c=\''+filterValue+'\'';			
			}
			 
		}
		
		public void loadHistory(){
			
			if(filterValue==null){
				ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING,'Filter not provided..loading entire history'));
				return;
			}
			
			buildquery();
			
			setCon = new ApexPages.StandardSetController(Database.getQueryLocator(query));
	        setCon.setPageSize(size);
	        noOfRecords = setCon.getResultSize();
			//history = database.query(query);
				
		} 
		
		public List<Rule_Execution_History__c> gethistory(){
			List<Rule_Execution_History__c> historyList = new List<Rule_Execution_History__c>();
	        if(setCon!=null){
		        for(Rule_Execution_History__c a : (List<Rule_Execution_History__c>)setCon.getRecords())
		            historyList.add(a);
	        }
	        return historyList;
		} 
		
		public void initfilters(){
             recordCaptureName ='';
             filterValue='';  
             if(historyBy=='historybyobject' && (filterValue==null || filterValue == '')){
			 	filterValue = objectName;
			 }
        }
		
		public PageReference exportToCSV(){
			PageReference p = new PageReference('/apex/AW_ExecutionHistoryCSV_VF?historyBy='+historyBy+'&filterValue='+filterValue);
			p.setRedirect(true);
			return p;	
		}
		
		
}