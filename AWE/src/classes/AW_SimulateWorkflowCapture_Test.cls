@isTest
public with sharing class AW_SimulateWorkflowCapture_Test {
	
	private static Id workflowId;
	private static Rule__c rule1;
	private static Rule__c rule2;
	private static Rule__c rule3;
	
	/*
	*	SetupTest Data
	*/
	private static void setUpData(){
		workflowId = Database.insert(new Advance_Workflow__c(Name='Test Workflow',Object__c='Account',Enabled__c=true,Description__c='This is a test workflow')).getId();
		
		// Create rules 
		
        rule1  = new Rule__c(Name = 'Test rule 1',Object__c = 'Account', Status__c='Draft',Evaluation_Rule__c='Record is created or edited',Description__c='Rule 1 Description');
        insert rule1 ;
        List<RuleCriteria__c> ruleCriterias = new List<RuleCriteria__c>();
        ruleCriterias.add(new RuleCriteria__c(rule__c=rule1.id,related_object__c='Account',  Matching_Type__c='Contains', Matching_Value__c='Test',
                                                            field_name__c='Name',field_API_Name__c='Name',Field_Type__c='Text'));
        
        ruleCriterias.add(new RuleCriteria__c(rule__c=rule1.id,related_object__c='Account',  Matching_Type__c='Not Null', Matching_Value__c='Test',
                                                            field_name__c='OwnerId',field_API_Name__c='OwnerId',Field_Type__c='Text'));
        insert ruleCriterias ;
        RuleAction__c ruleaction1 = new RuleAction__c(rule__c=rule1.id,related_object__c='Account',
                                                            field_name__c='Name',Type__c='Update Field',Value__c='TestUpdate1');
        insert ruleaction1;
        
        rule2  = new Rule__c(Name = 'Test rule 2',Object__c = 'Account', Status__c='Draft',Evaluation_Rule__c='Record is created or edited',Description__c='Rule 2 Description');
        insert rule2 ;
        RuleCriteria__c ruleCriteria2 = new RuleCriteria__c(rule__c=rule2.id,related_object__c='Account',  Matching_Type__c='Contains', Matching_Value__c='Test',
                                                            field_name__c='Name',field_API_Name__c='Name',Field_Type__c='Text');
        insert ruleCriteria2 ;
        RuleAction__c ruleaction2 = new RuleAction__c(rule__c=rule2.id,related_object__c='Account',
                                                            field_name__c='Description',Type__c='Update Field',Value__c='TestUpdate2');
        insert ruleaction2;
        
        rule3  = new Rule__c(Name = 'Test rule 3',Object__c = 'Account', Status__c='Draft',Evaluation_Rule__c='Record is created or edited',Description__c='Rule 3 Description');
        insert rule3 ;
        RuleCriteria__c ruleCriteria3 = new RuleCriteria__c(rule__c=rule3.id,related_object__c='Account',  Matching_Type__c='Contains', Matching_Value__c='Test',
                                                            field_name__c='Name',field_API_Name__c='Name',Field_Type__c='Text');
        insert ruleCriteria3 ;
        RuleAction__c ruleaction3 = new RuleAction__c(rule__c=rule3.id,related_object__c='Account',
                                                            field_name__c='Description',Type__c='Description',Value__c='TestUpdate3');
        insert ruleaction3;
        
        
		
		rule1.Order__c=10;
        rule1.Status__c = 'Active';
        rule1.Execution_Behavior__c='Execute and Exit';
        rule1.Advance_Workflow__c=workflowId;
        rule1.Filter_Logic__c = '1 AND 2';
        update rule1;
        
		rule2.Order__c=20;
        rule2.Status__c = 'Active';
        rule2.Execution_Behavior__c='Execute and Exit';
        rule2.Advance_Workflow__c=workflowId;
        update rule2;
        
        rule3.Order__c=30;
        rule3.Status__c = 'Active';
        rule3.Execution_Behavior__c='Execute and Exit';
        rule3.Advance_Workflow__c=workflowId;
        update rule3;
	}
	
	/*
	*	SetupTest Account Data for test
	*/
	
	private static void setUpAccountData(){
		List<Account> accountsList = new List<Account>{	new Account(Name='Test Account 1'),
														new Account(Name='Test Account 2'),
														new Account(Name='Test Account 3'),
														new Account(Name='Test Account 4')
													  };
		insert accountsList;
	}
	
	/*
	*	test Constructor
	*/
	@isTest
	static void test_Constructor(){
		Test.startTest();
		setUpData();
		Advance_Workflow__c workflow = [SELECT Id, Name FROM Advance_Workflow__c WHERE Id=:workflowId LIMIT 1];
		System.Test.setCurrentPageReference(new PageReference('/apex/x?id='+workflowId));
		AW_SimulateWorkflowCapture cls = new AW_SimulateWorkflowCapture(new ApexPages.standardController(workflow));
		System.assertNotEquals(true,cls.showInputBlock);
		System.assertEquals('workflow',cls.selectedMode);
		System.assertNotEquals(1,cls.fieldsList.size());
		Test.stopTest();
	}
	
	/*
	*	test getRecordsForUpdate method
	*/
	@isTest
	static void test_getRecordsForUpdate(){
		Test.startTest();
		setUpData();
		setUpAccountData();
		Advance_Workflow__c workflow = [SELECT Id, Name FROM Advance_Workflow__c WHERE Id=:workflowId LIMIT 1];
		System.Test.setCurrentPageReference(new PageReference('/apex/x?id='+workflowId));
		AW_SimulateWorkflowCapture  cls = new AW_SimulateWorkflowCapture(new ApexPages.standardController(workflow));
		//cls.addObjectField();
		//cls.removeObjectField();
		System.assertNotEquals(true,cls.showInputBlock);
		System.assertEquals('workflow',cls.selectedMode); 
		//System.assertEquals(4,cls.getRecordsForUpdate().size());
		Test.stopTest();
	}
	
	/*
	*	test simulateWorkflow method	
	*/
	@isTest
	static void test_simulateWorkflow(){
		Test.startTest();
		setUpData();
		setUpAccountData();
		Advance_Workflow__c workflow = [SELECT Id, Name FROM Advance_Workflow__c WHERE Id=:workflowId LIMIT 1];
		System.Test.setCurrentPageReference(new PageReference('/apex/x?id='+workflowId));
		AW_SimulateWorkflowCapture  cls = new AW_SimulateWorkflowCapture(new ApexPages.standardController(workflow));
		
		cls.selectedMode = 'rule';
		cls.operationType = 'update';
		cls.selectedRule = rule1.id;
		cls.recordName = 'Test Account 1,Test Account 2,Test Account 3';
		cls.ruleCriterias();
		PageReference pReference = cls.simulateWorkflow();
		Test.stopTest();
	
	}
	
	/*
	*	test InputRecord method
	*/
	@isTest
	static void test_InputRecord(){
		Test.startTest();
		setUpData();
		setUpAccountData();
		Advance_Workflow__c workflow = [SELECT Id, Name FROM Advance_Workflow__c WHERE Id=:workflowId LIMIT 1];
		System.Test.setCurrentPageReference(new PageReference('/apex/x?id='+workflowId));
		AW_SimulateWorkflowCapture  cls = new AW_SimulateWorkflowCapture(new ApexPages.standardController(workflow));
		Account account = [Select Name from Account where Name = 'Test Account 1' limit 1];
		Map<Id,SObject> recdBefore = new Map<Id,SObject>{account.id => account};
		Advance_Workflow__c workFlow1 = [select Name, Object__c from Advance_Workflow__c where id =:workflowId];
		List<AW_SimulateWorkflowCapture.ObjectFields> objectFieldsList = new List<AW_SimulateWorkflowCapture.ObjectFields>();
		//objectFieldsList.add(new AW_SimulateWorkflowCapture.ObjectFields(1,cls.fieldsList));
		SObject returnedSObject = AW_SimulateWorkflowCapture.InputRecord(recdBefore, workFlow1, objectFieldsList);
		//System.debug('********OutPutSObject****'+returnedSObject);
		Test.stopTest();
	}
	
	/*
	*	test getRules method
	*/
	@isTest
	static void test_getRules(){
		Test.startTest();
		setUpData();
		Advance_Workflow__c workflow = [SELECT Id, Name FROM Advance_Workflow__c WHERE Id=:workflowId LIMIT 1];
		System.Test.setCurrentPageReference(new PageReference('/apex/x?id='+workflowId));
		AW_SimulateWorkflowCapture  cls = new AW_SimulateWorkflowCapture(new ApexPages.standardController(workflow));
		System.assertEquals(3,cls.getRules().size());
		Test.stopTest();
	}
	
	/*
	*	test checkSelectedMode method
	*/
	@isTest
	static void test_checkSelectedMode(){
		Test.startTest();
		setUpData();
		Advance_Workflow__c workflow = [SELECT Id, Name FROM Advance_Workflow__c WHERE Id=:workflowId LIMIT 1];
		System.Test.setCurrentPageReference(new PageReference('/apex/x?id='+workflowId));
		AW_SimulateWorkflowCapture cls = new AW_SimulateWorkflowCapture(new ApexPages.standardController(workflow));
		cls.checkSelectedMode();
		
		// Test with value
		cls.selectedMode = 'workflow';
		cls.operationType = 'create';
		cls.checkSelectedMode();
		System.assertEquals(3,cls.criteriaList.size());
		Test.stopTest();
	}
	
	/*
	*	test ruleCriterias method
	*/
	@isTest
	static void test_ruleCriterias(){
		Test.startTest();
		setUpData();
		Advance_Workflow__c workflow = [SELECT Id, Name FROM Advance_Workflow__c WHERE Id=:workflowId LIMIT 1];
		System.Test.setCurrentPageReference(new PageReference('/apex/x?id='+workflowId));
		AW_SimulateWorkflowCapture cls = new AW_SimulateWorkflowCapture(new ApexPages.standardController(workflow));
		
		// Test with value
		cls.selectedMode = 'rule';
		cls.operationType = 'update';
		cls.ruleCriterias();
		
		// Test selected mode is null
		List<Apexpages.Message> messages = ApexPages.getMessages();
		System.assertEquals(1, messages.size());
		System.assertNotEquals(true, cls.showInputBlock);
		Test.stopTest();
	}
	
	/*
	*	test simulateWorkflow method	
	*/
	@isTest
	static void test_addMore(){
		Test.startTest();
		setUpData();
		setUpAccountData();
		Advance_Workflow__c workflow = [SELECT Id, Name FROM Advance_Workflow__c WHERE Id=:workflowId LIMIT 1];
		System.Test.setCurrentPageReference(new PageReference('/apex/x?id='+workflowId));
		AW_SimulateWorkflowCapture  cls = new AW_SimulateWorkflowCapture(new ApexPages.standardController(workflow));
		
		cls.selectedMode = 'rule';
		cls.operationType = 'update';
		cls.selectedRule = rule1.id;
		cls.recordName = 'Test Account 1,Test Account 2,Test Account 3';
		cls.ruleCriterias();
		cls.addmorefilter();
		cls.addmorefilter();
		cls.addmorefilter();
		cls.toremovecounter =  String.valueOf(cls.FilterWrapper.size() - 1);
		System.assert(cls.FilterWrapper.size() > 0);
		cls.deleteFilter();
		Test.stopTest();
	
	}
}