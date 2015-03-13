public class MyHelloWorld {
// This method updates the Hello field on a list
// of accounts
public static void addHelloWorld(Account[] accs){
for (Account a:accs){
if (a.SLASerialNumber__c != 'World')
a.SLASerialNumber__c = 'World';
}
}
}