/*
    AUTHOR:         Patrick Fordey
    NAME:           MassUpdateLeadEx
    CALLED FROM:    MassUpdateLeadv2 Visual Force Page
    DESCRIPTION:    Holds updates in a working lead record, applies the changes to that object to all selected Leads and then forwards user back to Leads home page
    TEST CLASS:     None - Not possible to test updates on sets
    NOTE:           This page will cycle through all the record types of the selected to get around issues with pick lists being different
    CHANGE HISTORY: 4 April 2014 - Initial Version.
*/ 

public class MassUpdateLeadEx {
 
    Private List<Lead> recordsToUpdate = new List<Lead>();
    
    Private List<Lead> sgAELeads = new List<Lead>();
    Private List<Lead> sgSDRLeads = new List<Lead>();
    Private List<Lead> partnerGeneratedLeads = new List<Lead>();
    Private List<Lead> partnerAppLeads = new List<Lead>();
    Private List<Lead> portalCreatedLeads = new List<Lead>();
    Private List<Lead> DealRegLeads = new List<Lead>();
    Private List<Lead> spJointLeads = new List<Lead>();
    Private List<Lead> sgPartnerLeads = new List<Lead>();
    
    Private Map<String,Id> rtIdNameMap = new Map<String,Id>();
    Private List<String> paramRecords = new List<String>();
    
    public ApexPages.StandardSetController stdCntrlr {get; set;}
 
    public MassUpdateLeadEx(ApexPages.StandardSetController controller) 
    {
        stdCntrlr = controller;
        
        //create a map of lead record types along with their name
        rtIdNameMap.put('Sophos Generated-AE', Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Sophos Generated-AE').getRecordTypeId());
        rtIdNameMap.put('Sophos Generated-SDR', Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Sophos Generated-SDR').getRecordTypeId());
        rtIdNameMap.put('Partner Generated', Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Partner Generated').getRecordTypeId());
        rtIdNameMap.put('Partner Application', Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Partner Application').getRecordTypeId());
       // rtIdNameMap.put('Portal Created', Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Portal Created').getRecordTypeId());
       rtIdNameMap.put('Deal Registration', Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Deal Registration').getRecordTypeId());
       // rtIdNameMap.put('Sophos/Partner Jointly Generated', Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Sophos/Partner Jointly Generated').getRecordTypeId());
      //  rtIdNameMap.put('Sophos Generated-Partner', Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Sophos Generated-Partner').getRecordTypeId());
        //end of record type map
         

        
        workingLead = (Lead)stdCntrlr.getRecord();
        workingLead.RecordTypeId = rtIdNameMap.get('Sophos Generated-AE');
        
       //get record Ids from parameters and put them in a list
       if(ApexPages.currentPage().getParameters().get('recs')<>null) 
       { 
            String [] idsFromParams = ApexPages.currentPage().getParameters().get('recs').split(',',-1); 
        
            for (String id : idsFromParams)
            {
                paramRecords.add(id);
            }
       }
       //end of get record Ids from parameters
       
       system.debug('--->params '+paramRecords);
       
       //SOQL query for the leads we want to update
       recordsToUpdate = [SELECT Id, Account_Type__c, Status, Lead_Status_Reason__c,Assignment_Status__c, OwnerId, Assigned_to_Partner__c, Assigned_to_Distributor__c, Assigned_to_Distributor_Contact__c, Assigned_to_Partner_Contact__c, RecordTypeID FROM Lead where Id in :paramRecords];
        
       //Create a set of all the record type Ids
       Set<Id> recordTypes = new Set<Id>();
       
       for (Lead o: recordsToUpdate)
       {
              if(!recordTypes.contains(o.RecordTypeId))
              {
                recordTypes.add(o.RecordTypeId);
              }
       }
       
       //seperate the leads in to seperate lists per record type
       leadInMyBucket(recordsToUpdate);
       //create the working leads and set rendering flags for the second page in the process
       setupWorkingLeads();
     
    }
    
    private void leadInMyBucket(List<Lead> recordsToUpdate)
    { //for each lead in the list seperate them into seperate lists per record type
        System.debug('Leads to update: ' + recordsToUpdate);
        for(Lead l: recordsToUpdate)
        {
            if(l.RecordTypeId == rtIdNameMap.get('Sophos Generated-AE'))
            {
                sgAELeads.add(l);
            }
            if(l.RecordTypeId == rtIdNameMap.get('Sophos Generated-SDR'))
            {
                sgSDRLeads.add(l);
            }
            if(l.RecordTypeId == rtIdNameMap.get('Partner Generated'))
            {
                partnerGeneratedLeads.add(l);
            }
            if(l.RecordTypeId == rtIdNameMap.get('Partner Application'))
            {
                partnerAppLeads.add(l);
            }
            if(l.RecordTypeId == rtIdNameMap.get('Portal Created'))
            {
                portalCreatedLeads.add(l);
            }
            if(l.RecordTypeId == rtIdNameMap.get('Deal Registration'))
            {
                DealRegLeads.add(l);
            }
            if(l.RecordTypeId == rtIdNameMap.get('Sophos/Partner Jointly Generated'))
            {
                spJointLeads.add(l);
            }
            if(l.RecordTypeId == rtIdNameMap.get('Sophos Generated-Partner'))
            {
                sgPartnerLeads.add(l);
            }   
        }
    }
 
    private void setUpWorkingLeads()
    {
            //if there is at least one lead of a certain record type set the rendering flag to true and create the working lead for that record type
            if(sgAELeads.size() > 0)
            {
                sgAEworkingLead = new Lead();
                sgAEworkingLead.RecordTypeId = sgAELeads[0].RecordTypeID;
                renderAE = '1';
            }
            if(sgSDRLeads.size() > 0)
            {
                sgSDRworkingLead = new Lead();
                sgSDRworkingLead.RecordTypeId = sgSDRLeads[0].RecordTypeID;
                renderSDR = '1';
            }
            if(partnerGeneratedLeads.size() > 0)
            {
                pgworkingLead = new Lead();
                pgworkingLead.RecordTypeId = partnerGeneratedLeads[0].RecordTypeID;
                renderPG = '1';
            }
            if(partnerAppLeads.size() > 0)
            {
                partAppworkingLead = new Lead();
                partAppworkingLead.RecordTypeId = partnerAppLeads[0].RecordTypeID;
                renderPartApp = '1';
            }
            if(portalCreatedLeads.size() > 0)
            {
                pcworkingLead = new Lead();
                pcworkingLead.RecordTypeId = portalCreatedLeads[0].RecordTypeID;
                renderPC = '1';
            }
            if(DealRegLeads.size() > 0)
            {
                DRworkingLead = new Lead();
                DRworkingLead.RecordTypeId = DealRegLeads[0].RecordTypeID;
                renderDR = '1';
            }
            if(spJointLeads.size() > 0)
            {
                SPJworkingLead = new Lead();
                SPJworkingLead.RecordTypeId = spJointLeads[0].RecordTypeID;
                renderSPJ = '1';
            }
            if(sgPartnerLeads.size() > 0)
            {
                sgPGworkingLead = new Lead();
                sgPGworkingLead.RecordTypeId = sgPartnerLeads[0].RecordTypeID;
                renderSGPG = '1';
            }
        
    }
    
    public PageReference saveRecs()
    {     
       
        List<Lead> objs = new List<Lead>();
        
        if(fieldsToRender =='1')
        {
            objs.addAll(processAE());
            
            objs.addAll(processSDR());
            
            objs.addAll(processPG());
            
            objs.addAll(processPartApp());
            
            objs.addAll(processPC());
            
            objs.addAll(processDR());
            
            objs.addAll(processSPJ());
            
            objs.addAll(processSGPG());
        } 
        else if (fieldsToRender == '2')
        {
            objs.addAll(processOwner());
        } 
        else if (fieldsToRender == '3')
        {
            objs.addAll(processPartner());
        } 
		else if (fieldsToRender == '4')
		{
			objs.addAll(processDistributor());
		}else if (fieldsToRender == '7')
		{
			objs.addAll(processAccountType());
		}
        
        try
        {
            update objs;
        }
        catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Error saving changes. Error Message: '+e.getMessage()));
        }
        
        PageReference pageRef = new PageReference('/00Q');
        return pageRef;
    } 
    
    private List<Lead> processOwner()
    {
        List<Lead> tempLeads = new List<Lead>();
        if(recordsToUpdate.size() > 0)
        {
            for(Lead l: recordsToUpdate)
            {
                l.OwnerId = workingLead.OwnerId;
                tempLeads.add(l);
            }
        }
        
        return tempLeads;
        
    }
    
    private List<Lead> processPartner()
    {
        List<Lead> tempLeads = new List<Lead>();
        if(recordsToUpdate.size() > 0)
        {
            for(Lead l: recordsToUpdate)
            {
                l.Assigned_to_Partner__c = workingLead.Assigned_to_Partner__c;
				l.Assigned_to_Partner_Contact__c = null;
                tempLeads.add(l);
            }
        }
        return tempLeads;   
     }
	
	private List<Lead> processAccountType()
    {
    List<Lead> tempLeads = new List<Lead>();
        if(recordsToUpdate.size() > 0)
        {
        	for(Lead l: recordsToUpdate)
            {
            	l.Account_Type__c= workingLead.Account_Type__c;
				tempLeads.add(l);
            }
        }
       return tempLeads;    
    }
    
    private List<Lead> processDistributor()
    {
        List<Lead> tempLeads = new List<Lead>();
        if(recordsToUpdate.size() > 0)
        {
            for(Lead l: recordsToUpdate)
            {
                l.Assigned_to_Distributor__c = workingLead.Assigned_to_Distributor__c;
				l.Assigned_to_Distributor_Contact__c = null;
                tempLeads.add(l);
            }
        }
        return tempLeads;   
     }
    
    private List<Lead> processAE()
    {
        List<Lead> tempLeads = new List<Lead>();
        if(sgAELeads.size() > 0)
        {
            for (Lead o: sgAELeads)
            {
                o.Status = sgAEworkingLead.Status;
                o.Lead_Status_Reason__c = sgAEworkingLead.Lead_Status_Reason__c; 
                tempLeads.add(o);
            }
        }
        return tempLeads;
    }
    
    private List<Lead> processSDR()
    {
        List<Lead> tempLeads = new List<Lead>();
        if(sgSDRLeads.size() > 0)
        {
            for (Lead o: sgSDRLeads)
            {
                o.Status = sgSDRworkingLead.Status;
                o.Lead_Status_Reason__c = sgSDRworkingLead.Lead_Status_Reason__c; 
                tempLeads.add(o);
            }
        }
		System.debug('SDR: ' + tempLeads);
        return tempLeads;
    }
    
    private List<Lead> processPG()
    {
        List<Lead> tempLeads = new List<Lead>();
        if(partnerGeneratedLeads.size() > 0)
        {
            for (Lead o: partnerGeneratedLeads)
            {
                o.Status = pgworkingLead.Status;
                o.Lead_Status_Reason__c = pgworkingLead.Lead_Status_Reason__c; 
                tempLeads.add(o);
            }
        }
		System.debug('Partner Generated: ' + tempLeads);
        return tempLeads;
    }
    
    private List<Lead> processPartApp()
    {
        List<Lead> tempLeads = new List<Lead>();
        if(partnerAppLeads.size() > 0)
        {
            for (Lead o: partnerAppLeads)
            {
                o.Status = partAppworkingLead.Status;
                o.Lead_Status_Reason__c = partAppworkingLead.Lead_Status_Reason__c;  
                tempLeads.add(o);
            }
        }
        return tempLeads;
    }
    
    private List<Lead> processPC()
    {
        List<Lead> tempLeads = new List<Lead>();
        if(portalCreatedLeads.size() > 0)
        {
            for (Lead o: portalCreatedLeads)
            {
                o.Status = pcworkingLead.Status;
                o.Lead_Status_Reason__c = pcworkingLead.Lead_Status_Reason__c;
                tempLeads.add(o);
            }
        }
        return tempLeads;
    }
    
    private List<Lead> processDR()
    {
        List<Lead> tempLeads = new List<Lead>();
        if(DealRegLeads.size() > 0)
        {
            for (Lead o: DealRegLeads)
            {
                o.Status = DRworkingLead.Status;
                o.Lead_Status_Reason__c = DRworkingLead.Lead_Status_Reason__c;
                tempLeads.add(o);
            }
        }
        return tempLeads;
    }
    
    private List<Lead> processSPJ()
    {
        List<Lead> tempLeads = new List<Lead>();
        if(spJointLeads.size() > 0)
        {
            for (Lead o: spJointLeads)
            {
                o.Status = SPJworkingLead.Status;
                o.Lead_Status_Reason__c = SPJworkingLead.Lead_Status_Reason__c;
                tempLeads.add(o);
            }
        }
        return tempLeads;
    }
    
    private List<Lead> processSGPG()
    {
        List<Lead> tempLeads = new List<Lead>();
        if(sgPartnerLeads.size() > 0)
        {
            for (Lead o: sgPartnerLeads)
            {       
                o.Status = sgPGworkingLead.Status;
                o.Lead_Status_Reason__c = sgPGworkingLead.Lead_Status_Reason__c;
                tempLeads.add(o);
            }
        }
        return tempLeads;
    }
 
    public PageReference cancel()
    {
       PageReference pageRef = new PageReference('/00Q');
       return pageRef;
    }
    
    public void setRenderMiddlePage()
    {
        renderMiddlePage = '1';
        renderFirstPage = '0';
    }
    
    public void setAttributes()
    {
        //Set all rendering flags. These control what is visible on the page and what is not depending on what point in the process you are at and also which record types were in the selected records
        fieldsToRender = '0';
        renderLastPage = '0';
        renderMiddlePage = '0';
        renderFirstPage = '1';
        //end of rendering flags
    }
	
	//bulk accept leads
	public void acceptLeads()
	{
		List<Lead> leads = new List<Lead>();
		
		for(Lead l: recordsToUpdate)
		{
			if(l.Assignment_Status__c != 'Accepted')
			{
				l.Status = '1 - Open'; 
        		l.Lead_Status_Reason__c = '1 - Accepted'; 
        		/* Setting the Assignment Status field */ 
        		l.Assignment_Status__c = 'Accepted'; 
        		l.Assigned_Date__c = Datetime.now(); 
        		/* Setting the Closed By field */ 
        		l.Closed_By__c = UserInfo.getUserId();
				
				leads.add(l);
			}
		}
		
		update leads;
	}
	
	public void rejectLeads()
	{
		List<Lead> leads = new List<Lead>();
		
		for(Lead l: recordsToUpdate)
		{
			if(l.Assignment_Status__c != 'Accepted')
			{
				l.Status = '1 - Open'; 
        		l.Lead_Status_Reason__c = '1 - Accepted'; 
        		/* Setting the Assignment Status field */ 
        		l.Assignment_Status__c = 'Rejected'; 
        		l.Assigned_Date__c = Datetime.now(); 
        		/* Setting the Closed By field */ 
        		l.Closed_By__c = UserInfo.getUserId();
				
				leads.add(l);
			}
		}
		
		update leads;
	}
    
    public Lead sgAEworkingLead
    {        
        get;
        set;
    }
    
    public string renderAE
    {        
        get;
        set;
    }
    
    public Lead sgSDRworkingLead
    {        
        get;
        set;
    }
    
    public string renderSDR
    {        
        get;
        set;
    }
    
    public Lead pgworkingLead
    {        
        get;
        set;
    }
    
    public string renderPG
    {        
        get;
        set;
    }
    
    public Lead partAppworkingLead
    {        
        get;
        set;
    }
    
    public string renderPartApp
    {        
        get;
        set;
    }
    
    public Lead pcworkingLead
    {        
        get;
        set;
    }
    
    public string renderPC
    {        
        get;
        set;
    }
    
    public Lead DRworkingLead
    {        
        get;
        set;
    }
    
    public string renderDR
    {        
        get;
        set;
    }
    
    public Lead SPJworkingLead
    {        
        get;
        set;
    }
    
    public string renderSPJ
    {        
        get;
        set;
    }
    
    public Lead sgPGworkingLead
    {        
        get;
        set;
    }
    
    public string renderSGPG
    {        
        get;
        set;
    }
    
    public string renderFirstPage
    {        
        get;
        set;
    }
    
    public string renderMiddlePage
    {        
        get;
        set;
    }
    
    public string renderLastPage
    {        
        get;
        set;
    }
    
    public String fieldsToRender 
    {
        get
        {
            if(fieldsToRender == null)
            {
                fieldsToRender = '0';
            }
             
            return fieldsToRender;
        }
        set;
    }
    
    public Lead workingLead
    {
        get;
        set;
    }
    
}