public with sharing class AW_ApexLogsController {

	public Apex_Log__c apexLogger{get;set;}
	public Boolean isResult {get;set;}
	
	public List<Apex_Log__c> apexLoggerResults{get{
		if(stdController != null){
            	return (List<Apex_Log__c>)stdController.getRecords();            	
        }else
                return new List<Apex_Log__c>();
	}set;}
	@TestVisible
  	private static Integer PAGE_SIZE = 10;
	private ApexPages.StandardSetController stdController;
	
	public AW_ApexLogsController(){
		apexLogger = new Apex_Log__c();
		isResult = false;
	}
	
	public PageReference search(){
		String soqlQuery = 'Select Name, class_name__c, Owner.Name, Exception_Stack_Trace_String__c , start_dtm__c, Exception_Type__c, Log_Type__c , Message__c, method_name__c , Status_Message__c'
     			   			 + ' FROM Apex_Log__c ';
        String filterLogic = '';
        Id ownerId = apexlogger.OwnerId;
        DateTime stDate = apexlogger.start_dtm__c;
        DateTime endDate = apexlogger.stop_dtm__c;
        if(ownerId != null){
        	filterLogic = ' ownerId = : ownerId ';
        }
        if(stDate !=  null){
        	if(filterLogic == ''){
        		filterLogic += ' start_dtm__c > =  : stDate ';
        	}else{
        		filterLogic += ' AND start_dtm__c > =  : stDate ';
        	}
        }
        if(endDate !=  null){
        	if(filterLogic == ''){
        		filterLogic += ' start_dtm__c < =  : endDate';
        	}else{
        		filterLogic += ' AND start_dtm__c < =  : endDate';
        	}
        }
        soqlQuery += (filterLogic != '' ?  ' WHERE ' + filterLogic : '') + ' Order by start_dtm__c DESC limit 10000';
       System.debug('::soqlQuery'+soqlQuery);
      stdController = new ApexPages.StandardSetController(Database.query(soqlQuery));
      // sets the number of records in each page set
      stdController.setPageSize(PAGE_SIZE);
      isResult = true;
      return null;
	}
	
	//Boolean to check if there are more records after the present displaying records
    public Boolean hasNext{
        get
        {
            if(stdController != null){
                return stdController.getHasNext();
            }
            return false;
        }set;}
 
    //Boolean to check if there are more records before the present displaying records
    public Boolean hasPrevious{
        get
        {
            if(stdController != null){
                return stdController.getHasPrevious();
            }
            return false;
        }set;}
 
    //Page number of the current displaying records
    public Integer pageNumber{
        get
        {
            if(stdController != null){
                return stdController.getPageNumber();
            }
            return 0;
        }set;}

     //Page number of the Size
    public Integer pageSize{
        get
        {
            if(stdController != null){
                return stdController.getPageSize();
            }
            return 0;
        }set;}
    
    //Returns the previous page of records
    public void previous(){
        if(stdController != null){
            stdController.previous();
        }
    }
 
    //Returns the next page of records
    public void next(){
       if(stdController != null){
            stdController.next();
        }
    }
    
	
}