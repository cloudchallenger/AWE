/**
 * CSV Reader test
 */
@isTest
private class AW_CSVReader_Test {

    static testMethod void testCSVReader() {
       String csv = '"Workflow" , "Rule"\r' + '"Account", "Test Rule 1"\r' + '"Account", "Test Rule 2"';
       AW_CSVReader csvReader = new AW_CSVReader(csv,',');
       System.assert(csvReader.getData().size() > 0);
       
       
    }
    
     static testMethod void testCommaCSVReader() {
       String csv = '"Workflow" , "Rule"\r' + '"Account", "Test , Rule 1"\r' + '"Account", "Test Rule 2"';
       AW_CSVReader csvReader = new AW_CSVReader(csv,',');
       System.assert(csvReader.getData().size() > 0);
    }
    
    static testMethod void testDefaultCSVReader() {
       String csv = '"Workflow" , "Rule"\r' + '"Account", "Test , Rule 1"\r' + '"Account", "Test Rule 2"';
       AW_CSVReader csvReader = new AW_CSVReader(csv);
       System.assertEquals(csvReader.getRowDelim() , '\r');
       System.assert(csvReader.getData().size() > 0);
    }
}