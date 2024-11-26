@isTest
public class createCaseAPIsTest {
    
    @testSetup static void testData(){
        //Insert Account
        Account acc = new Account();
        acc.Name = 'Test';
        acc.Program_Code__c = 'test';
        acc.Case_Sequence__c = '5';
        acc.Contract_Party__c = 'Maryland Department of Health';
        acc.Project_State__c = 'MD';
        Insert acc;
        
        Id prgRevRecordTypeId =  Schema.SObjectType.Program_Review_Type__c.getRecordTypeInfosByDeveloperName().get('Review_Type').getRecordTypeId();
        Id prgPriRecordTypeId =  Schema.SObjectType.Program_Priority__c.getRecordTypeInfosByDeveloperName().get('Priority_Type').getRecordTypeId();
        //Insert Program_Review_Type__c
        Program_Review_Type__c pReview = new Program_Review_Type__c();
        pReview.Name = 'Coverage';
        pReview.Program_Name__c = acc.Id;
        pReview.RecordTypeId = prgRevRecordTypeId;
        Insert pReview;
        
        //Insert Program_Priority__c
        Program_Priority__c prgPriority = new Program_Priority__c();
        prgPriority.Name = 'Standard';
        prgPriority.recordTypeId = prgPriRecordTypeId;
        prgPriority.Program_Review_Type__c = pReview.Id;
        Insert prgPriority;
        Program_Priority__c prgPriority1 = new Program_Priority__c();
        prgPriority1.Name = 'Expedited';
        prgPriority1.recordTypeId = prgPriRecordTypeId;
        prgPriority1.Program_Review_Type__c = pReview.Id;
        Insert prgPriority1;
        //case
        Case c = new Case();
        c.Status ='New';
        c.Origin ='Web';
        c.AccountId = acc.Id;
        c.Created_Date_MDIRO__c = System.today();
        c.Updated_Date_MDIRO__c = System.today();
        Insert c;
        //Participant__c
        Participant__c participant = new Participant__c();
        participant.Case__c = c.Id;
        participant.Participant_Enrollee_Type__c = 'Requestor';
        Insert participant;
        
        Entity__c entity1 = new Entity__c();
        //entity1.isDeleted_MDIRO__c  = false;
        entity1.Name = 'Test Entity';
        entity1.Project_id__c = 'Test';
        entity1.Entity_Type__c = 'MCO';
        Insert entity1;
        
        //Insert Entity_Address__c
        Entity_Address__c address = new Entity_Address__c();
        address.Entity__c = entity1.Id;
        address.Address_1__c = 'test drive';
        address.State__c = 'VA';
        address.City__c = 'test';
        address.Zip__c = '20190';
        Insert address;
        
        //Insert Entity_Contact__c
        Entity_Contact__c entityContact1 = new Entity_Contact__c();
        //entityContact1.Name = 'Test';
        entityContact1.Contact_Person_Last_Name__c = 'user';
        entityContact1.Contact_Person_First_Name__c = 'test';
        entityContact1.Entity_Address__c = address.Id;
        Insert entityContact1;
        
        
    }
    //Method 1 : Request URL last index = 'persistMDIROCase' and without programCode, reviewTypeCd and, priorityTypeCd
    @isTest static void testMethod1(){
        Test.startTest();
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestUri = 'https://maximushealthcareappeals--maxdev.my.salesforce.com/services/apexrest/api/appealCaseRemoteService/persistMDIROCase';
        request.httpMethod = 'POST';
        RestContext.request = request;
        request.requestBody = Blob.valueof('{ "rCaseDispute" : {}, "rFiles": [], "rCaseParticipants":[]}');
        response.addHeader('Content-Type', 'application/json');
        RestContext.response = response;
        /*SF_MD_GCaseDetails wrapperObj =*/ //createCaseAPIs.saveCase();
        //System.assertEquals(417, wrapperObj.statusCode);
        Test.stopTest();
    }
    //Request URL last index 'persistMDIROCase' and with programCode, reviewTypeCd and, priorityTypeCd
    //entityTypeCode = 'PRP'
    @isTest static void testMethod2(){
        Test.startTest();
        Case c = [SELECT Id FROM Case LIMIT 1];
        Participant__c participant = [SELECT Id FROM Participant__c LIMIT 1];
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestUri = 'https://maximushealthcareappeals--maxdev.my.salesforce.com/services/apexrest/api/appealCaseRemoteService/persistMDIROCase';
        request.httpMethod = 'POST';
        RestContext.request = request;
        request.requestBody = Blob.valueof('{ "programCode": "test", "reviewTypeCd" : "test", "priorityTypeCd": "test", "id" : "'+c.Id+'", "rCaseDispute" : {}, "rFiles": [], "rCaseParticipants":[ {"rPersonParticipant" :{ "personId": "'+participant.Id+'"}},{"rEntityParticipant":{ "entityTypeCode": "PRP"}}]}');
        response.addHeader('Content-Type', 'application/json');
        RestContext.response = response;
        //createCaseAPIs.saveCase();
        Test.stopTest();
    }
    
        @isTest static void testMethod0(){
        Test.startTest();
        Case c = [SELECT Id,Program_Priority__c FROM Case LIMIT 1];
        Program_Priority__c pp=[select id,Program_Review_Type__c from Program_Priority__c where name='Expedited' limit 1];
            Program_Review_Type__c pr=[select id from Program_Review_Type__c where id=: pp.Program_Review_Type__c limit 1];
            c.Program_Priority__c=pp.id;
            c.Program_Review_Type__c=pr.id;
            update c;
        Test.stopTest();
    }
    //Request URL last index 'persistMDIROCase' and with programCode, reviewTypeCd and, priorityTypeCd
    //entityTypeCode = 'PRP'
    //With Entity Id
    @isTest static void testMethod3(){
        Test.startTest();
        Case c = [SELECT Id FROM Case LIMIT 1];
        Participant__c participant = [SELECT Id FROM Participant__c LIMIT 1];
        Entity__c en = [SELECT Id FROM Entity__c LIMIT 1];
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestUri = 'https://maximushealthcareappeals--maxdev.my.salesforce.com/services/apexrest/api/appealCaseRemoteService/persistMDIROCase';
        request.httpMethod = 'POST';
        RestContext.request = request;
        request.requestBody = Blob.valueof('{ "programCode": "test", "reviewTypeCd" : "test", "priorityTypeCd": "test", "id" : "'+c.Id+'", "rCaseDispute" : {}, "rFiles": [], "rCaseParticipants":[ {"rPersonParticipant" :{ "personId": "'+participant.Id+'"}},{"rEntityParticipant":{ "entityTypeCode": "PRP", "entityId": "'+en.Id+'", "firstName":"Test"}}]}');
        response.addHeader('Content-Type', 'application/json');
        RestContext.response = response;
        //createCaseAPIs.saveCase();
        
        Test.stopTest();
    }
    //Request URL last index 'persistMDIROCase' and with programCode, reviewTypeCd and, priorityTypeCd
    //entityTypeCode = 'MCO'
    //With Entity Id
    @isTest static void testMethod4(){
        Test.startTest();
        Case c = [SELECT Id FROM Case LIMIT 1];
        Participant__c participant = [SELECT Id FROM Participant__c LIMIT 1];
        Entity__c en = [SELECT Id FROM Entity__c LIMIT 1];
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestUri = 'https://maximushealthcareappeals--maxdev.my.salesforce.com/services/apexrest/api/appealCaseRemoteService/persistMDIROCase';
        request.httpMethod = 'POST';
        RestContext.request = request;
        request.requestBody = Blob.valueof('{ "programCode": "test", "reviewTypeCd" : "test", "priorityTypeCd": "test", "id" : "'+c.Id+'", "rCaseDispute" : {}, "rFiles": [], "rCaseParticipants":[ {"rPersonParticipant" :{ "personId": "'+participant.Id+'"}},{"rEntityParticipant":{ "entityTypeCode": "MCO", "entityId": "'+en.Id+'", "firstName":"Test"}}]}');
        response.addHeader('Content-Type', 'application/json');
        RestContext.response = response;
        //createCaseAPIs.saveCase();
        
        Test.stopTest();
    }
    //Request URL last index 'persistMDIROCase' and with programCode, reviewTypeCd and, priorityTypeCd
    //entityTypeCode = null/'PRV'
    //With Entity Id
    @isTest static void testMethod5(){
        Test.startTest();
        Case c = [SELECT Id FROM Case LIMIT 1];
        Participant__c participant = [SELECT Id FROM Participant__c LIMIT 1];
        Entity__c en = [SELECT Id FROM Entity__c LIMIT 1];
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestUri = 'https://maximushealthcareappeals--maxdev.my.salesforce.com/services/apexrest/api/appealCaseRemoteService/persistMDIROCase';
        request.httpMethod = 'POST';
        RestContext.request = request;
        request.requestBody = Blob.valueof('{ "programCode": "test", "reviewTypeCd" : "test", "priorityTypeCd": "test", "id" : "'+c.Id+'", "rCaseDispute" : {}, "rFiles": [], "rCaseParticipants":[ {"rPersonParticipant" :{ "personId": "'+participant.Id+'"}},{"rEntityParticipant":{ "entityTypeCode": "PRV", "entityId": "'+en.Id+'", "firstName":"Test"}}]}');
        response.addHeader('Content-Type', 'application/json');
        RestContext.response = response;
        //createCaseAPIs.saveCase();
        
        Test.stopTest();
    }
    //Request URL last index 'persistMDIROCase' and with programCode, reviewTypeCd and, priorityTypeCd
    //entityTypeCode = null/'PRV'
    //Without Entity Id
    //With File data
    @isTest static void testMethod6(){
        Test.startTest();
        Case c = [SELECT Id FROM Case LIMIT 1];
        Participant__c participant = [SELECT Id FROM Participant__c LIMIT 1];
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestUri = 'https://maximushealthcareappeals--maxdev.my.salesforce.com/services/apexrest/api/appealCaseRemoteService/persistMDIROCase';
        request.httpMethod = 'POST';
        RestContext.request = request;
        request.requestBody = Blob.valueof('{ "programCode": "test", "reviewTypeCd" : "test", "priorityTypeCd": "test", "id" : "'+c.Id+'", "rCaseDispute" : {}, "rFiles": [{"filePath":"test"}], "rCaseParticipants":[ {"rPersonParticipant" :{ "personId": "'+participant.Id+'"}},{"rEntityParticipant":{ "entityTypeCode": "PRV", "entityId": null, "firstName":"Test"}}]}');
        response.addHeader('Content-Type', 'application/json');
        RestContext.response = response;
        //createCaseAPIs.saveCase();
        
        Test.stopTest();
    }
    //Request URL last index 'persistMDIROCase' and with programCode, reviewTypeCd and, priorityTypeCd
    //Wirhout Case Id
    //entityTypeCode = null/'PRV'
    //With Entity Id
    //With File data
    @isTest static void testMethod7(){
        Test.startTest();
        Case c = [SELECT Id FROM Case LIMIT 1];
        Participant__c participant = [SELECT Id FROM Participant__c LIMIT 1];
        Entity__c en = [SELECT Id FROM Entity__c LIMIT 1];
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestUri = 'https://maximushealthcareappeals--maxdev.my.salesforce.com/services/apexrest/api/appealCaseRemoteService/persistMDIROCase';
        request.httpMethod = 'POST';
        RestContext.request = request;
        request.requestBody = Blob.valueof('{ "programCode": "test", "reviewTypeCd" : "test", "priorityTypeCd": "test", "id" : null, "rCaseDispute" : {}, "rFiles": [{"filePath":"test"}], "rCaseParticipants":[ {"rPersonParticipant" :{ "personId": "'+participant.Id+'"}},{"rEntityParticipant":{ "entityTypeCode": "PRV", "entityId": "'+en.id+'", "firstName":"Test"}}]}');
        response.addHeader('Content-Type', 'application/json');
        RestContext.response = response;
        //createCaseAPIs.saveCase();
        
        Test.stopTest();
    }
    //Request URL last index 'persistMDIROCase' and with programCode, reviewTypeCd and, priorityTypeCd
    //Wirhout Case Id
    //entityTypeCode = 'MCO'
    //With Entity Id
    //With File data
    @isTest static void testMethod8(){
        Test.startTest();
        Case c = [SELECT Id FROM Case LIMIT 1];
        Participant__c participant = [SELECT Id FROM Participant__c LIMIT 1];
        Entity__c en = [SELECT Id FROM Entity__c LIMIT 1];
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestUri = 'https://maximushealthcareappeals--maxdev.my.salesforce.com/services/apexrest/api/appealCaseRemoteService/persistMDIROCase';
        request.httpMethod = 'POST';
        RestContext.request = request;
        request.requestBody = Blob.valueof('{ "programCode": "test", "reviewTypeCd" : "test", "priorityTypeCd": "test", "id" : null, "rCaseDispute" : {}, "rFiles": [{"filePath":"test"}], "rCaseParticipants":[ {"rPersonParticipant" :{ "personId": "'+participant.Id+'"}},{"rEntityParticipant":{ "entityTypeCode": "MCO", "entityId": "'+en.id+'", "firstName":"Test","entityFullName":"Test Entity"}}]}');
        response.addHeader('Content-Type', 'application/json');
        RestContext.response = response;
        //createCaseAPIs.saveCase();
        
        Test.stopTest();
    }
    //Request URL last index 'persistMDIROCase' and with programCode, reviewTypeCd and, priorityTypeCd
    //Wirhout Case Id
    //entityTypeCode = 'MCO'
    //With Entity Id
    //With File data
    @isTest static void testMethod9(){
        Test.startTest();
        Case c = [SELECT Id FROM Case LIMIT 1];
        Participant__c participant = [SELECT Id FROM Participant__c LIMIT 1];
        Entity__c en = [SELECT Id FROM Entity__c LIMIT 1];
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestUri = 'https://maximushealthcareappeals--maxdev.my.salesforce.com/services/apexrest/api/appealCaseRemoteService/persistMDIROCase';
        request.httpMethod = 'POST';
        RestContext.request = request;
        request.requestBody = Blob.valueof('{ "programCode": "test", "reviewTypeCd" : "test", "priorityTypeCd": "test", "id" : null, "rCaseDispute" : {}, "rFiles": [{"filePath":"test"}], "rCaseParticipants":[ {"rPersonParticipant" :{ "personId": "'+participant.Id+'","firstNameTxt":" TestFirstName", "lastNameTxt":"LastName", "insuranceId":"Test","personTypeCd":"ENRO"}},{"rEntityParticipant":{ "entityTypeCode": "MCO", "entityId": "'+en.id+'", "firstName":"Test","entityFullName":"Test"}}]}');
        response.addHeader('Content-Type', 'application/json');
        RestContext.response = response;
        //createCaseAPIs.saveCase();
        
        Test.stopTest();
    }
    
    @isTest static void testMethod10(){
        Test.startTest();
        SF_MD_DefaultResponseWrapper tst=new SF_MD_DefaultResponseWrapper();
        tst.statusCode=200;
        tst.message='test';
        Test.stopTest();
        
    }
    
      @isTest
    static void testSF_MD_CasesWithParticipants() {
        // Create an instance of the main class
        SF_MD_CasesWithPartcipants caseWithParticipants = new SF_MD_CasesWithPartcipants();
        
        // Set some fields to ensure coverage
        caseWithParticipants.id = '001xx000003DGbPAAW';
        caseWithParticipants.caseNumber = 'C-12345';
        caseWithParticipants.pendingRi = true;
        caseWithParticipants.sfCaseNumber = 'SF123';
        caseWithParticipants.deletedFlag = false;
        caseWithParticipants.reviewTypeCd = 'RT001';
        caseWithParticipants.priorityTypeCd = 'High';
        caseWithParticipants.priorityTypeDesc = 'High Priority';
        caseWithParticipants.referenceNumber = 'REF-001';
        caseWithParticipants.recievedDateStr = '2023-01-01';
        caseWithParticipants.recievedDate = DateTime.now();
        caseWithParticipants.startDateStr = '2023-01-05';
        caseWithParticipants.startDate = DateTime.now().addDays(5);
        caseWithParticipants.createUser = 'TestUser1';
        caseWithParticipants.updatedUser = 'TestUser2';
        caseWithParticipants.daysLeft = 10;
        caseWithParticipants.createTimestamp = DateTime.now().getTime();
        caseWithParticipants.updateTimestamp = DateTime.now().getTime();
        caseWithParticipants.reason = 'Test Reason';
        caseWithParticipants.statusCd = 'Active';
        caseWithParticipants.statusCdForWeb = 'Active';
        caseWithParticipants.dateOfDecision = DateTime.now().addDays(7);
        caseWithParticipants.dateLetterSent = Date.today().addDays(7);
        caseWithParticipants.decisionCodeDescription = 'Approved';
        caseWithParticipants.sourceType = 'External';
        caseWithParticipants.programId = 'PRG001';
        caseWithParticipants.programCode = 'P001';
        caseWithParticipants.providerRepName = 'Provider Rep';
        caseWithParticipants.providerName = 'Provider Name';
        caseWithParticipants.patientName = 'John Doe';
        
        // Test caseParticipants inner class
        SF_MD_CasesWithPartcipants.caseParticipants caseParticipant = new SF_MD_CasesWithPartcipants.caseParticipants();
        caseParticipant.id = 'P001';
        
        // Set RpersonParticipant for caseParticipant
        SF_MD_CasesWithPartcipants.RpersonParticipant personParticipant = new SF_MD_CasesWithPartcipants.RpersonParticipant();
        personParticipant.personId = 'PP001';
        personParticipant.firstNameTxt = 'John';
        personParticipant.lastNameTxt = 'Doe';
        personParticipant.emailAddress = 'john.doe@example.com';
        personParticipant.phoneNumber = '1234567890';
        caseParticipant.rPersonParticipant = personParticipant;

        // Set RentityParticipant for caseParticipant
        SF_MD_CasesWithPartcipants.RentityParticipant entityParticipant = new SF_MD_CasesWithPartcipants.RentityParticipant();
        entityParticipant.entityId = 'E001';
        entityParticipant.entityFullName = 'Test Entity';
        entityParticipant.phoneNumber = '9876543210';
        caseParticipant.rEntityParticipant = entityParticipant;
        
        // Add caseParticipants to the main class
        caseWithParticipants.rCaseParticipants.add(caseParticipant);
        
        // Test files inner class
        SF_MD_CasesWithPartcipants.files file = new SF_MD_CasesWithPartcipants.files();
        file.name = 'Test File';
        file.uploadBy = 'TestUser1';
        file.documentType = 'PDF';
        file.uploadTime = DateTime.now();
        file.length = 12345L;
        file.docRecId = 'DOC001';
        caseWithParticipants.rFiles.add(file);

        // Test caseDispute inner class
        SF_MD_CasesWithPartcipants.caseDispute caseDispute = new SF_MD_CasesWithPartcipants.caseDispute();
        caseDispute.dateInitialClaimDenial = Date.today();
        caseDispute.diagnosisTypeDescription = 'Diagnosis Test';
        caseWithParticipants.rCaseDispute = caseDispute;

        // Insert necessary records if required (depending on your org setup)
        // For example, if Case object or related data needs to be inserted

        // Test assertions to ensure data integrity
        System.assertEquals('001xx000003DGbPAAW', caseWithParticipants.id);
        System.assertEquals('John', caseWithParticipants.rCaseParticipants[0].rPersonParticipant.firstNameTxt);
        System.assertEquals('Test File', caseWithParticipants.rFiles[0].name);
        System.assertEquals('Diagnosis Test', caseWithParticipants.rCaseDispute.diagnosisTypeDescription);
    }
}