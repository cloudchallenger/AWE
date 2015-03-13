public class SendMail1 {
    public static void sendEmail1(String to, String subj, String body) 
    {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();


        mail.setToAddresses( new String[]{to} );
        mail.setSubject(subj);
        mail.setPlainTextBody(body);


        Messaging.sendEmail( new Messaging.SingleEmailMessage[]{mail} );
    }
}