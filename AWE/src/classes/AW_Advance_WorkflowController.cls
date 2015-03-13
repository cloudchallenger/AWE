// 
// (c) 2012 Appirio, Inc.
//
//  AW_Advance_WorkflowController                                                     
//
// This class is used to define Execution Plan 
//
// 18 Nov 2012     Peter Babalis     Original
// 01 May 2014     Peter Babalis     Added Create Field for AweTracking
  
//  
public with sharing class AW_Advance_WorkflowController {
     
    public Advance_Workflow__c newruleexecutionplan {get;set;} 
    public String obj {get;set;}
    public List<SelectOption> objOptions {get;set;}
    public boolean edit {get;set;}
    public boolean ruleAssigned {get;set;}
    public String AWFId;
    public ApexLogHandler.apexLog apexLogger;
    public Boolean isLogEnabled;
    
    public List<MetadataService.AsyncResult> AsyncResults {get;set;}
    /**
    * Constructor
    */    
    public AW_Advance_WorkflowController(Apexpages.StandardController stdcon){
        String ruleexecutionplanId;
         
        ruleexecutionplanId = stdcon.getId();
        AWFId=ruleexecutionplanId;
        newruleexecutionplan = new Advance_Workflow__c();
       apexLogger =  new ApexLogHandler.apexLog('AW_Advance_WorkflowController','All'); 
        objOptions = new List<SelectOption>();
        edit=false;
        ruleAssigned = false;
        isLogEnabled = false;
        Map<String, Schema.SObjectType> mapObj = Schema.getGlobalDescribe();
        for(String objname:mapObj.keySet()){
            Schema.SObjectType sobj = mapObj.get(objname);
            Schema.DescribeSObjectResult descRes = sobj.getDescribe();
            if(!descRes.isCustomSetting() && descRes.isAccessible() && (descRes.isCreateable() || descRes.isUpdateable())){
             //if(!descRes.isCustomSetting() && descRes.isCustom()){
                String objLabel = descRes.getLabel();
                objOptions.add(new SelectOption(descRes.getName(),objLabel + ' (' + descRes.getName() + ')'));
            }
        }
        for(SelectOption op: objOptions){           
                system.debug('---------> List of Objects' + op);
                apexLogger.logDebug('---------> List of Objects' + op,isLogEnabled);
        }
        objOptions.sort();
        if(ruleexecutionplanId != null){
            edit = true;
            newruleexecutionplan = [SELECT name,object__c,
                                           Description__c ,
                                           Enabled__c,
                                           Advance_Rule_Stamp__c,
                                           is_Log_Enabled__c,
                                           CountRulesassociatedtoAdvanceWorkflow__c 
                                   FROM Advance_Workflow__c 
                                   WHERE id =: ruleexecutionplanId];
            if(newruleexecutionplan != null){
                obj = newruleexecutionplan.object__c;
                isLogEnabled = newruleexecutionplan.is_Log_Enabled__c;
                ruleAssigned = (newruleexecutionplan.CountRulesassociatedtoAdvanceWorkflow__c == null || newruleexecutionplan.CountRulesassociatedtoAdvanceWorkflow__c > 0) ?true:false;
            }
        }
    }
     
   public PageReference returnPage()
   {
      
     return new PageReference('/apex/AW_ImportExport_VF?id='+AWFId);
   } 
   
    /**
    * Save and New Action
    */
    public PageReference saveAndNewRule(){
    	apexLogger =  new ApexLogHandler.apexLog('AW_Advance_WorkflowController','All');
    	apexLogger.logMethodIn('saveAndNewRule',isLogEnabled);
    
        newruleexecutionplan.object__c = obj;
        edit = false;
        PageReference pageRef = null;
        try{
            if(newruleexecutionplan.Advance_Rule_Stamp__c) deployFields();
            upsert newruleexecutionplan;
            newruleexecutionplan = new Advance_Workflow__c();
            apexLogger.logMethodOut('saveAndNewRule',isLogEnabled);
            pageRef = new PageReference('/apex/AW_Advance_Workflow_VF');
        }
        catch(Exception e){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error,e.getDMLMessage(0));
            ApexPages.addMessage(msg);
            apexLogger.logException(e, isLogEnabled);
        }
        System.debug('apexLogger:::::'+apexLogger);
    	apexLogger.saveLogs(isLogEnabled);
        return pageRef;
    }
   
    /**
    * Save Action
    */
    
    public PageReference saveRule(){
         apexLogger =  new ApexLogHandler.apexLog('AW_Advance_WorkflowController','All');
    	 apexLogger.logMethodIn('saveRule',isLogEnabled);
    
        newruleexecutionplan.object__c = obj;
        try{
        	 
             apexLogger.logDebug('::saveRule newruleexecutionplan.Advance_Rule_Stamp__c' +newruleexecutionplan.Advance_Rule_Stamp__c, isLogEnabled);
        	if(newruleexecutionplan.Advance_Rule_Stamp__c)deployFields();
            apexLogger.logDebug('::saveRule Before Upsert ' + '', isLogEnabled);
            upsert newruleexecutionplan;
            apexLogger.logMethodOut('saveRule',isLogEnabled);
            return(new PageReference('/'+newruleexecutionplan.id));
        }
        catch(Exception e){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error,e.getDMLMessage(0));
            ApexPages.addMessage(msg);
            apexLogger.logException(e,isLogEnabled);
            return null;
        }
    }
    
 /**
      @Sneha 
      DT:- 22/4/14
      Method that uses metadata api to create two custom fields 
      in the object associated with the advance workflow
    */
    private void deployFields(){
    	apexLogger.logMethodIn('deployFields',isLogEnabled);
    	Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get(newruleexecutionplan.object__c).getDescribe().fields.getMap();
    	
    	if(objectFields.get('AWE_Rule__c')!=null && objectFields.get('AWE_RuleURL__c')!=null){
    		//do nothing
    		apexLogger.logDebug('....if(objectFields.get(... ' ,isLogEnabled);
	    	apexLogger.logMethodOut('deployFields',isLogEnabled);
    		return;
    	}
    	
    	
    	MetadataService.MetadataPort service = createService();
    	// Define Metadata item to create a Custom Field on the above object
	    MetadataService.CustomField customField1 = new MetadataService.CustomField();
	    customField1.fullName = newruleexecutionplan.object__c+'.AWE_Rule__c';
	    customField1.label = 'AWE Rule';
	    customField1.type_x = 'Text';
	    customField1.length=255;
		customField1.trackHistory=true;
	    // Define Metadata item to create a Custom Field on the above object
	    MetadataService.CustomField customField2 = new MetadataService.CustomField();
	    customField2.fullName = newruleexecutionplan.object__c+'.AWE_RuleURL__c';
	    customField2.label = 'AWE Rule';
	    customField2.type_x = 'Text';	
	    /*
	    SUBSTITUTE(text, old_text, new_text) and replace text with the field or value for 
	    which you want to substitute values, old_text with the text you want replaced, 
	    and new_text with the text you want to replace the old_text.
	    /a0o70000006AjSgAAK~No BulkRule~092414 01:54:14
	    
	    customField2.formula=='HYPERLINK(SUBSTITUTE(AWE_Rule__c,AWE_Rule__c,LEFT(AWE_Rule__c, FIND('~', AWE_Rule__c)-1)), 
SUBSTITUTE(AWE_Rule__c, LEFT(AWE_Rule__c, FIND('~',AWE_Rule__c)), '')  )';'
	    */    	   
	    
	  //  system.debug('My Link '+  LEFT('/a0o70000006AjSgAAK~No BulkRule~092414 01:54:14',4));
	     
	     customField2.formula='HYPERLINK(SUBSTITUTE(AWE_Rule__c, AWE_Rule__c,LEFT(AWE_Rule__c, FIND(\'~\', AWE_Rule__c)-1)), SUBSTITUTE(AWE_Rule__c, LEFT(AWE_Rule__c, FIND(\'~\',AWE_Rule__c)) , \'\')  )';
	  apexLogger.logDebug('--> customField1.formula '+customField1.formula , isLogEnabled);
	  apexLogger.logDebug('--> customField2.formula '+customField2.formula, isLogEnabled );
	
	 //  customField2.formula='HYPERLINK(\'/apex/AWE__AW_RecordRuleExecutionHistory_VF?recordId=\' & Id, SUBSTITUTE(AWE_Rule__c, LEFT(AWE_Rule__c, FIND(\'~\',AWE_Rule__c)), \'\') )';
     //HYPERLINK( My_Link__c , Display_Text__c, 'Self')
      AsyncResults = service.create(new List<MetadataService.Metadata> { customField1,customField2 });
    
    apexLogger.logMethodOut('deployFields',isLogEnabled);	
    }
    
    
    
    private MetadataService.MetadataPort createService()
	{ 
	    MetadataService.MetadataPort service = new MetadataService.MetadataPort();
	    service.SessionHeader = new MetadataService.SessionHeader_element();
	    service.SessionHeader.sessionId = UserInfo.getSessionId();
	    return service;     
	}    
    
}