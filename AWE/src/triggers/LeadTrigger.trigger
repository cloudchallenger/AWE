trigger LeadTrigger on Lead (after insert, after update, before insert, 
before update) {

 
      trgh_Lead handler = new trgh_Lead();
      
      if (Trigger.isBefore)
      {
              
        if (Trigger.isInsert)
        {
          handler.onBeforeInsert(Trigger.new, Trigger.newMap);
        }
        else if (Trigger.isUpdate)
        {
          handler.onBeforeUpdate(Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap);
        }
        
      }
      else if (Trigger.isAfter)
      {        
        if (Trigger.isInsert)
        {
          handler.onAfterInsert(Trigger.new, Trigger.newMap);
        }
        else if (Trigger.isUpdate)
        {
          handler.onAfterUpdate(Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap);
        }
      }
    

}