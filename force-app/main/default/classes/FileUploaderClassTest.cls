@isTest
public class FileUploaderClassTest {
    @isTest static void testUploadFile() {
        // Create a test record
        Account acc = new Account();
        acc.name = 'Virginia Insurance Department';
        acc.Priority_Type__c= 'Standard';
        acc.Review_Type__c = 'Medical Necessity';
        acc.Number_of_Days__c = 4;
        acc.Project_State__c = 'VA';
        acc.Program_Code__c = 'VA';
        acc.Contract_Party__c = 'Virginia Insurance Department';
        acc.Introduction__c = 'test';
        acc.Standard_Of_Review__c = 'test';
        acc.Conclusion__c = 'test';
        acc.Dispute_Narrative__c = 'test';
        acc.Other_Narrative__c = 'test';
        acc.Health_Plan_Denial_Reason__c = 'test';
        acc.Questions_to_Expert__c = 'test';
        acc.Send_Billing_To__c = 'Enrollee';
        insert acc;
        

        // Prepare a test file
        String filename = 'test.txt';
        Blob contentBlob = Blob.valueOf('Test Content');
        String base64 = EncodingUtil.base64Encode(contentBlob);

        // Call the method to test
        Test.startTest();
        String resultId = FileUploaderClass.uploadFile(base64, filename, acc.Id);
        Test.stopTest();

        // Perform assertions
        System.assertNotEquals(null, resultId, 'The returned ID should not be null');

        // Query the inserted ContentDocumentLink
        ContentDocumentLink cdl = [SELECT Id, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE Id =: resultId];
        System.assertEquals(acc.Id, cdl.LinkedEntityId, 'The linked entity ID should match the test record ID');
    }
}