public class AW_CustomSettingsController {

public boolean edit {get;set;}
public AdvanceWorkflowConf__c newaweconf     {get;set;}  
public AdvanceWorkflowConf__c aweconfentry     {get;set;}  
public String aweconfname {get;set;}
public decimal batchsize   {get;set;}
public decimal delaytime   {get;set;}
public boolean editcustomsetting {get;set;}   
      
    
public AW_CustomSettingsController(Apexpages.StandardController stdcon){
      
       aweconfentry = new AdvanceWorkflowConf__c();
      
       AdvanceWorkflowConf__c aweconfentry = [Select Id, Name ,Batch_Size__c,Delay_Time__c From AdvanceWorkflowConf__c Where Name = 'WorkflowConf'];  

   // newaweconf = new AdvanceWorkflowConf__c();
    if(aweconfentry!=null){
     	system.debug( 'HERE 1');
     	editcustomsetting=true;
     	batchsize=aweconfentry.Batch_Size__c;
     	delaytime=aweconfentry.Delay_Time__c;
     	aweconfname=aweconfentry.Name;
     	
     	
     	
     }
     else {
         system.debug( 'HERE 2');   
     	 aweconfname='WorkflowConf1';
            
     }
 }      
 
  public  Pagereference cancel(){

        transient   Pagereference currPage  =   ApexPages.currentPage();
        transient   String  returnURL       =   currPage.getURL().substringBefore('apex')  ;
        return new Pagereference(returnURL);
    }
 
public PageReference savecustomsetting(){   
        
       /*
        newaweconf.Batch_Size__c  = batchsize;
        newaweconf.Delay_Time__c  = delaytime;
        update  newaweconf;
        ss
        newaweconf = new AdvanceWorkflowConf__c(); 
            newaweconf.Name= 'WorkflowConf';
            newaweconf.Batch_Size__c=batchsize; 
    		newaweconf.Delay_Time__c=delaytime;
       */ 
       if(aweconfentry!=null){
       	newaweconf = new AdvanceWorkflowConf__c();
       	 system.debug( 'SAVE 2');   
     	aweconfentry.Batch_Size__c=batchsize;
       	aweconfentry.Delay_Time__c=delaytime;
       	aweconfentry.Name= 'WorkflowConf';
       	update aweconfentry;
       	
       /*
        newaweconf.Name= 'WorkflowConf';
        newaweconf.Batch_Size__c=batchsize; 
    	newaweconf.Delay_Time__c=delaytime;	
    	update newaweconf;
       */
       }
     //  update aweconfentry;
       /* upsert new AdvanceWorkflowConf__c(
            Name = aweconfname,
            Batch_Size__c = batchsize,Delay_Time__c  = delaytime);
 
       */
        
        // PageReference pageRef = New PageReference('/' +   '/o');
        PageReference pageRef = New PageReference('/' );
         pageRef.setRedirect(true);
        return pageRef;     
} 

}