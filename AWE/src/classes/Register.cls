global class Register {
    Webservice static String registerUser(String loginId, String Firstname, String lastname, String vantivePersonID, String vantiveCustomerID) 
    {
        Contact contact = new Contact();
       contact.FirstName = Firstname;
       contact.LastName = lastname;
    //    contact.Description = '' + getTemp();
       Insert contact;
        
         SendMail1.sendEmail1('peter@appirio.com', 'autoreg ' + 
            loginId + '/' + firstname + '/' + lastname + '/' +
           vantivePersonID + '/' + vantiveCustomerID, ''+ contact.ID);
            
        return contact.ID;
    }
    
   // private static double getTemp() 
   // {
     //   webservicesDaehostingComTemperature.TemperatureConversionsSoap cnvt = 
         //  new webservicesDaehostingComTemperature.TemperatureConversionsSoap();
     //   double ans = cnvt.CelciusToFahrenheit(0.0);
       // return ans;
  //  }
}