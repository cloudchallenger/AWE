public class TheController {
 
public String AWFid {get;set;}
/*
 public TheController(ApexPages.StandardController controller) {
		this.controller = controller;
	}
  public PageReference getRedir() {
  	
  	  PageReference newPage;
  	  return newPage.setRedirect(true);
  }
*/
   public PageReference returnPage(String mode)
   {
   	  
   	 return Page.AW_ImportExport_VF ;
   	 /*
   	  PageReference newPage;
   	  AWFid=ApexPages.currentPage().getParameters().get('id');
   	  newPage = Page.AW_ImportExport_VF ;
     if ( mode == '')  newPage = Page.AW_ImportExport_VF ;
    */
    // if ( mode == 'cancel') return Page.AW_ImportExport_VF ;
    //return 
    
       /*
 
        if (c.recordtypeid == '111111111111') {
            
 
        } else {
            newPage = new PageReference('/' + c.id + '/e');
            newPage.getParameters().put('nooverride', '1');
        }
 
        newPage.getParameters().put('id', c.id);
 */
       // return newPage.setRedirect(true);
 
     
   }
   private final ApexPages.StandardController controller;
}