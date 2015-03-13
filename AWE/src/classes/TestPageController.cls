public with sharing class TestPageController {

    public TestPageController() {
    	
		 mapRectypeIdRecName = new Map<String,String>();
            FilterWrapper = new List<filterwrap>();
            deletewrapper  = new List<filterwrap>();
            //ruleId=Apexpages.currentPage().getParameters().get('ruleId'); 
            parentOperator ='';parentObj ='';parentField ='';index ='';index1='';
            toremovecounter = -1;
            objOptions = new List<SelectOption>();
            gd = Schema.getGlobalDescribe();            
            loadfilter();             
            addDefaultFilterLogic();
            //populateFields();
    }

public List<filterwrap> FilterWrapper{get;set;}
         public list<filterwrap> deletewrapper;
         
         Map<String, Schema.SObjectField> mapField=new map<string,Schema.SObjectField>();
         private  map< String,string> Fieldtypemap=new map<string,string>();
         private Map<String,Schema.SObjectType> gd;
         
         public string parentOperator{set;get;}
         public string parentObj{set;get;}
         public string parentField{set;get;}
         public string globalVar{set;get;}
         public string index {get;set;}
         public string index1 {get;set;}
         public Rule__c ruleRecord{set;get;}
         public integer toremovecounter{set;get;}
         
         public List<SelectOption> objOptions    {get;set;}
         private Map<String,String> mapRectypeIdRecName {get;set;}
         
         String ruleId;
         String oldFilterValue = '';         
         
         
         private void loadfilter(){
            Schema.DescribeSObjectResult   objinfo = null;             
            Map<String, Schema.SObjectType> mapObj = Schema.getGlobalDescribe();
            Schema.SObjectType sobj = mapObj.get('Lead');
            objinfo =sobj.GetDescribe();
            
             List<Schema.ChildRelationship> listChild = sobj.getDescribe().getChildRelationships();
             objOptions.add(new SelectOption(objInfo.getName(), objInfo.getLabel() + ' (' + objInfo.getName() + ')'));
             for(Schema.ChildRelationship child: listChild){
                    Schema.DescribeSObjectResult descRes = child.getChildSObject().getDescribe();
                    objOptions.add(new SelectOption(descRes.getName(),descRes.getLabel()+  ' (' + descRes.getName() + ')'));
             }
              // Sorting Objects based on label
              AW_AdvanceWorkflowExecutionHelper.sortSelectListOnLabel(objOptions);
              FilterWrapper.add(new filterwrap(FilterWrapper.size()+1));
              populateField(objInfo.getName(),0); 
              return;
              
              
             /* for(RuleCriteria__C rc:criterias ){
                   if(rc.Field_API_Name__c != null && rc.Field_API_Name__c.equalsIgnoreCase('RecordTypeId')){
                  		rc.Matching_Value__c = rc.Record_Type_Id__c;                  		
                  }

                   //Boolean deleteAllow = FilterWrapper.size()==0 ?false:true;
                   Boolean deleteAllow = FilterWrapper.size()==0 ?true:true;
                   FilterWrapper.add(new filterwrap(deleteAllow,'',rc,FilterWrapper.size()+1));
                   populatefield(rc.Related_Object__c,FilterWrapper.size()-1);
                    
                   parentField=rc.Field_Name;
                   index=':'+string.valueof(FilterWrapper.size()-1)+':';
                   parentOperator=rc.Matching_Type__c;
                   populateOperator();                   
                   
                   
                   index=':'+string.valueof(FilterWrapper.size()-1)+':';
                   togglebtw();
                    
                   Integer i =FilterWrapper.size()-1;
                  
                   if((FilterWrapper[i].ismultiselect || FilterWrapper[i].isPicklist || FilterWrapper[i].isGlobalVariable) && FilterWrapper[i].newrulecriteria.Matching_Value__c!=null){
                        //lets deal it later
                        system.debug('newrulecriteria.Matching_Value__c-->'+FilterWrapper[i].newrulecriteria.Matching_Value__c);
                        list<string> valueList = FilterWrapper[i].newrulecriteria.Matching_Value__c.split(',',20);
                        for(string c:valueList){
                            c=c.trim();
                            FilterWrapper[i].picklistvalues.add(c);
                        }
                        system.debug('picklistvalues-->'+FilterWrapper[i].picklistvalues);
                   }
                   
                   
              }//end for*/
              
             system.debug('FilterWrapper-->'+FilterWrapper);
         }
         
        public void populateFields(){
        
            index1=index1.substringBeforeLast(':');
            index1=index1.substringAfterLast(':');
            parentObj='Lead';
            if(index1!=''&&index1!=null)
                populateField(parentObj,integer.valueof(index1));
        }
        
        private void populateField(string parent, integer pos ){
        	 //hideAllPanels(filterwrap objfilterwrap)
             List<SelectOption> fieldOption= new List<SelectOption>();
            
             Schema.SObjectType sobjTypeParent = gd.get(parent);
            
             Schema.DescribeSObjectResult parentObjFields= sobjTypeParent.getDescribe();
             mapField = parentObjFields.fields.getMap();
             fieldOption.add(new SelectOption('','--Select--'));
             
             for(String fieldname:mapField.keySet()){
                Schema.SObjectField sfield = mapField.get(fieldname);
                Schema.DescribeFieldResult descResField = sfield.getDescribe();
                String fieldLabel = descResField.getLabel();
                //fieldOption.add(new SelectOption(descResField.getName(),fieldLabel));
                String fieldAPIName = descResField.getName();
                if(fieldAPIName.equalsIgnoreCase('RecordTypeID')){
                    fieldOption.add(new SelectOption('Record Type Name',fieldAPIName));
                }
                // Owner name change
                // Start
            	else if(fieldAPIName.equalsIgnoreCase('ownerid')){
            		fieldOption.add(new SelectOption('Owner Name','OwnerName'));
            		fieldOption.add(new SelectOption(fieldLabel,fieldAPIName));
            	}
                else{
                    fieldOption.add(new SelectOption(fieldLabel,fieldAPIName));
                }
                // End
                
                //to add field types
                
                Fieldtypemap.put(descResField.getName(),string.valueof(sfield.getDescribe().gettype()));
            }
            
            if(parent!=null)
             //FilterWrapper.get(pos).newRuleCriteria.Related_Object__c=parent;
          
            FilterWrapper.get(pos).fieldOptions.clear();
            fieldOption.add(new SelectOption('Cross Formula','CrossFormula'));
            fieldOption.add(new SelectOption('Global Variable - User','GlobalVariable-User'));
            fieldOption.add(new SelectOption('Global Variable - Profile','GlobalVariable-Profile'));
            fieldOption.add(new SelectOption('Global Variable - UserRole','GlobalVariable-UserRole'));
            fieldOption.add(new SelectOption('Global Variable - Organization','GlobalVariable-Organization'));
            fieldOption.SORT();
            
            List<SelectOption> sortedfieldOption= new List<SelectOption>();
            for(SelectOption opt : fieldOption){
               sortedfieldOption.add(new SelectOption(opt.getLabel(),opt.getValue())); 
            }
            system.debug('------------------ sortedfieldOption ---------------------'+sortedfieldOption);
            
            FilterWrapper.get(pos).fieldOptions.addall(sortedfieldOption);
        }        
      
        public void addmorefilter(){           
            system.debug('------------------ addmorefilter calling---------------------');
            FilterWrapper.add(new filterwrap(FilterWrapper.size()+1));
            system.debug('------------------ FilterWrapper.size()---------------------'+FilterWrapper.size());
            populateField('Lead',FilterWrapper.size()-1);
            //verified=TRUE;
            //addDefaultFilterLogic();
        }
         
        
        public void deletefilter(){
            if(toremovecounter>0){
                deletewrapper.add(FilterWrapper.get(toremovecounter-2));
                FilterWrapper.remove(toremovecounter-2);
                addDefaultFilterLogic();
            }
        }
        
        private void addDefaultFilterLogic(){
           /* if(oldFilterValue == RuleRecord.Filter_Logic__c){
                    Integer criteriaCount  = FilterWrapper.size();
                    String filterLogic = '1';
                    for(Integer i = 1;i<criteriaCount;i++){
                        filterLogic += ' AND ' + (i+1);  
                    }
                    //RuleRecord.Filter_Logic__c = filterLogic; 
                    //oldFilterValue = RuleRecord.Filter_Logic__c;                                
                }  */
        }
         private void hideAllPanels(filterwrap objfilterwrap){
         	try{
         		system.debug('----------- hideAllPanels calling ---------------------'); 
         		objfilterwrap.isPicklist=false;
                objfilterwrap.isBoolean=false;
                objfilterwrap.isCrossFormula=false;
                objfilterwrap.isGlobalVariable=false;
                objfilterwrap.isMultiselect=false;
                objfilterwrap.isReference=false;
                objfilterwrap.isDateTime=false;      
                objfilterwrap.isTextBox=false;
            }
         	catch(exception ex){
         		
         	}
         }
        private String getRelatedFieldDescribe(String objectName, String fieldName){
			  
			Schema.SObjectType objectSchema = Schema.getGlobalDescribe().get(objectName);
			Map<String, Schema.SObjectField> fieldMap = objectSchema.getDescribe().fields.getMap();
			Schema.DescribeFieldResult fieldDescribe = fieldMap.get(fieldName).getDescribe();
			while(fieldDescribe != null && fieldDescribe.getType() == Schema.Displaytype.REFERENCE){
				return  fieldDescribe.getReferenceTo()[0].getDescribe().getName();
			}
			return  null;
		}
		
        public void populateOperator(){
            index=index.substringBeforeLast(':');
            index=index.substringAfterLast(':');
        
            if(index=='' || index==null || parentField=='' || parentField==null)
                return;
        		system.debug('----------- parentField---------------------'+parentField);
                Integer listindex = integer.Valueof(index);
                hideAllPanels(FilterWrapper.get(listindex));                            
                List<SelectOption> options = new List<SelectOption>();
                if(parentField=='CrossFormula' || parentField.startsWith('GlobalVariable')){
                    FilterWrapper.get(listindex).isCrossFormula = parentField=='CrossFormula'? true:false;
                    FilterWrapper.get(listindex).isGlobalVariable = parentField.startsWith('GlobalVariable')?true:false;                    
                    FilterWrapper.get(listindex).Field_Name=parentField;
                    FilterWrapper.get(listindex).field_API_name = parentField;
                    FilterWrapper.get(listindex).field_type =  'String';                                       
                    //if the field is global variable 
                    if(parentField.startsWith('GlobalVariable') ){
                           FilterWrapper.get(listindex).GlobalVariable = parentField.split('-')[1];    
                           FilterWrapper.get(listindex).ValueOption.clear();                      
                           FilterWrapper.get(listindex).ValueOption.addall(getGlobalVarValues(FilterWrapper.get(listindex).GlobalVariable));
                           FilterWrapper.get(listindex).isGlobalVariable=true;
                    }                                                             
                    return;
                }
             
               // Owner name change
               // Added condition
               //Start
               if((mapField.get(parentField))==null && !parentField.equalsIgnoreCase('OwnerName')){
                    return;
               }
				

           		DisplayType fieldtype;	
           		if(!parentField.equalsIgnoreCase('OwnerName')){
                	fieldtype = mapField.get(parentField).getDescribe().gettype();
           		}
           		else{
           			fieldType = Schema.DisplayType.Reference;
           		}
           		system.debug('----------- fieldType---------------------'+fieldType);
                // End
                if (fieldType!=Schema.DisplayType.anyType && fieldType!=Schema.DisplayType.base64  && 
                  fieldType!=Schema.DisplayType.EncryptedString && fieldType!=Schema.DisplayType.Id )
                {   
                	 system.debug('----------- inside 1---------------------'+fieldType);
                      if(fieldType==Schema.DisplayType.Boolean)
                        FilterWrapper.get(listindex).isBoolean = true;
                      
                      else if(fieldType==Schema.DisplayType.DateTime || fieldType==Schema.DisplayType.Date){
                       	 system.debug('----------- fieldType---------------------'+fieldType);
                       	 
                       	 FilterWrapper.get(listindex).isDateTime = true; 
                      }
                        
                      else if ( fieldType==Schema.DisplayType.String || fieldType==Schema.DisplayType.Email ||
                       fieldType==Schema.DisplayType.ComboBox 
                      ||fieldType==Schema.DisplayType.email|| 
                      fieldType==Schema.DisplayType.Phone||fieldType==Schema.DisplayType.url || 
                      fieldType==Schema.DisplayType.TextArea || fieldType==Schema.DisplayType.Phone){                          
                          		system.debug('----------- inside 2---------------------'+fieldType);
                            	FilterWrapper.get(listindex).isTextBox = true;                                                       
                      }
                      else if(fieldType==Schema.DisplayType.Reference){
                      	system.debug('----------- inside Reference---------------------');
                      	FilterWrapper.get(listindex).referenceObjectName = getRelatedFieldDescribe('Lead', parentField);
                      	FilterWrapper.get(listindex).isReference = true;
                      }
                      else if(fieldType==Schema.DisplayType.MultiPicklist){                            
                           FilterWrapper.get(listindex).ValueOption.clear();                      
                           FilterWrapper.get(listindex).ValueOption.addall(getPicklistValues(gd.get('Lead'), ParentField));
                                FilterWrapper.get(listindex).isMultiselect=true;                         
                       }
                                              
                       else if(fieldType==Schema.DisplayType.Picklist ){                            
                           FilterWrapper.get(listindex).ValueOption.clear();                      
                           FilterWrapper.get(listindex).ValueOption.addall(getPicklistValues(gd.get('Lead'), ParentField));
                                FilterWrapper.get(listindex).isPicklist=true;                         
                       }
                   }  
               
                // Owner name change
                // Start
				if(parentField.equalsIgnoreCase('ownerid')){
					FilterWrapper.get(listindex).isPicklist = true;            		
                	FilterWrapper.get(listindex).ValueOption.clear();                      
                    FilterWrapper.get(listindex).ValueOption.addall(getGlobalVarValues('User.Id'));
                }
                else if(parentField.equalsIgnoreCase('ownername')){
                   	FilterWrapper.get(listindex).isPicklist = true;
                    FilterWrapper.get(listindex).ValueOption.clear();                      
                    FilterWrapper.get(listindex).ValueOption.addall(getGlobalVarValues('User'));
                }
                //End                  
               FilterWrapper.get(listindex).Field_Name=parentField;
               FilterWrapper.get(listindex).field_API_name = parentField;
               FilterWrapper.get(listindex).field_type =  string.valueof(fieldType);
                   
               if(parentField.equalsIgnoreCase('recordtypeid')){
                    FilterWrapper.get(listindex).isPicklist = true;
                    FilterWrapper.get(listindex).ValueOption.clear();                      
                       FilterWrapper.get(listindex).ValueOption.addall(getRecordTypeOptions(
                       'Lead'));
               }  
               system.debug('----------- FilterWrapper.get(listindex).isTextBox ---------------------'+FilterWrapper.get(listindex).isTextBox);                 
    			
        }//end operators
        
         // cc - 30th Sep
        
        public List<SelectOption> getRecordTypeOptions(String sObjName){
            List<SelectOption> options = new List<SelectOption>();
            for(RecordType recType : [select id, name from RecordType where SobjectType =: sObjName ]){
                options.add(new SelectOption(recType.Id,recType.Name));
                mapRectypeIdRecName.put(recType.Id,recType.Name);
            }
            return options;
        }
       
    public static List<SelectOption> getGlobalVarValues(String variable){            

            list<SelectOption> opt = new list<SelectOption>();
            system.debug('variable-->'+variable);
            if(variable=='User'){
                for(User u:[Select Id,Name FROM User Where IsActive=true]){
                    opt.add(new SelectOption(u.Name, u.Name));  
                }
            }
            // Owner name change
            // Start
            else if(variable=='User.Id'){
                for(User u:[Select Id,Name FROM User Where IsActive=true]){
                    opt.add(new SelectOption(u.Id, u.Id));    
                }   
            }
            // End
            else if(variable=='Profile'){
                for(Profile u:[Select Id,Name FROM Profile ]){
                    opt.add(new SelectOption(u.Name, u.Name));  
                }   

            }else if(variable=='UserRole'){
                for(UserRole u:[Select Id,Name FROM UserRole ]){
                    opt.add(new SelectOption(u.Name, u.Name));  
                }   

            }else if(variable=='Organization'){
                for(Organization u:[Select Id,Name FROM Organization ]){
                    opt.add(new SelectOption(u.Name, u.Name));  
                }   
            }
            return opt;
       }
        
       private static list<SelectOption> getPicklistValues(sObjectType objtyp, String fld)
       {
              list<SelectOption> opt = new list<SelectOption>();
              
              Schema.DescribeSObjectResult objDescrib = objTyp.getDescribe();       
              map<String, Schema.SObjectField> fieldMaps = objDescrib.fields.getMap(); 
              list<Schema.PicklistEntry> values = fieldMaps.get(fld).getDescribe().getPickListValues();
              for (Schema.PicklistEntry a : values)
              { 
                opt.add(new SelectOption(a.getLabel(), a.getValue())); 
              }
              return opt;
        }  
        public class filterwrap{
            
            public integer sno{set;get;}            
            public String  Field_Name{set;get;}
            public String  field_API_name{set;get;}
            public String  field_type{set;get;}
            public String  GlobalVariable{set;get;}            
            public boolean isPicklist{set;get;}
            public boolean isBoolean{set;get;}
            public boolean isCrossFormula{set;get;}
            public boolean isGlobalVariable{set;get;}
            public boolean isMultiselect{set;get;}
            public boolean isReference{get;set;}
            public String referenceObjectName{get;set;}
            public boolean isDateTime{get;set;}            
            public boolean isTextBox{get;set;}
            public String textBox{get;set;}             
            public Boolean checkBox{get;set;}            
            public list<string> picklistvalues{set;get;}             
            public List<SelectOption> fieldOptions {get;set;} 
            public List<SelectOption> ValueOption {get;set;}
            
            public filterwrap(integer no){                                   
                    this.sno=no;
                    picklistValues = new List<string>();                    
                    fieldOptions = new List<SelectOption>();
                    FieldOptions.add(new selectoption('None','None'));
                    ValueOption =new List<SelectOption>();
            }
    } 
}