global class AccountBatch implements Database.batchable<sObject>{ 
    //maintain count of active assets on accounts
    public String query='Select Id, Name From Account';
    
    global database.querylocator start(Database.BatchableContext BC){
      if (Test.isRunningTest()){
            query += ' limit 200';
        }
      return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<SObject> scope){
       
        if (scope.size() > 0){
            for(Account s : (List<Account>)scope){
                s.Name = s.Name + 'test';
            }
            try{
                update scope;
            } catch (Exception e){}
        }
    }
    
    global void finish(Database.BatchableContext BC){}
        //Schedule the next batch job to run for 24 hours later:}

}