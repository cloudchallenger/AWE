public class MileageExtension {
private final Mileage__c mileageObj;
public MileageExtension(ApexPages.StandardController controller) {
	this.mileageObj =(MIleage__c)controller.getSubject();
}
}