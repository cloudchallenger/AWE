global class AWE_Visual_Flow implements Process.Plugin { 
// The main method to be implemented. The Flow calls this at runtime.
global Process.PluginResult invoke(Process.PluginRequest request) { 
//Some Inputs from Somewhere chatter, objects 
/* 
// Get the subject of the Chatter post from the flow
 String subject = (String) request.inputParameters.get('subject');
        
        
 String lang = (String) request.inputParameters.get('lang');
 String process = (String) request.inputParameters.get('process');

        Flow_Display_Text_2__c[] res = 
            [SELECT AAA_Q_BP_Number__c, AAA_POM_Allowed__c, AAA_POM_Error__c
            FROM Flow_Display_Text_2__c
            WHERE Name =: lang];
*/
//Dispalay Error if Input did not retrieve data
//if (res.size() != 1) throw new TranslationException('System error: translation '+lang+' not supported');
 

// return to Flow For Execution

        Map<String,String> result = new Map<String,String>();
        //result.put('AAA_Q_BP_Number__c',res[0].AAA_Q_BP_Number__c); 
        //result.put('AAA_POM_Allowed__c',res[0].AAA_POM_Allowed__c); 
        //result.put('AAA_POM_Error__c',res[0].AAA_POM_Error__c); 
        return new Process.PluginResult(result); 	
}
// Returns the describe information for the interface
global Process.PluginDescribeResult describe() { 
        Process.PluginDescribeResult result = new Process.PluginDescribeResult(); 
     
        //result.Name = "flowchatplugin";
        //result.Tag = "chat";
     
        result.inputParameters = new 
           List<Process.PluginDescribeResult.InputParameter>{ 
               new Process.PluginDescribeResult.InputParameter('subject', 
               Process.PluginDescribeResult.ParameterType.STRING, true) 
            }; 
        result.outputParameters = new 
           List<Process.PluginDescribeResult.OutputParameter>{ }; 
        return result; 
    }

}