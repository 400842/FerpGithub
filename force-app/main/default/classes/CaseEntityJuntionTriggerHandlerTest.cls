@isTest
public class CaseEntityJuntionTriggerHandlerTest {
    
    public  static void setup() {
        List<Account> progs = new List<Account>();
        Account program = new Account();
        program.Name='Pennsylvania Department of Health';
        program.Program_Code__c = 'NI';
        program.Send_Billing_To__c = 'Enrollee';
        program.Billing_Cycle__c = 'Per Case';
        program.Review_Type__c = 'Medical Necessity';
        program.Priority_Type__c = 'Expedited';
        program.Number_of_Days__c = 5;
        program.Contract_Party__c = 'Pennsylvania Department of Health';
        program.Project_State__c = 'PA';
        program.Case_Sequence__c='0075';
        progs.add(program);
        // insert program;
        
        Account program1 = new Account();
        program1.Name='California Department of Health';
        program1.Program_Code__c = 'IR';
        program1.Send_Billing_To__c = 'Enrollee';
        program1.Billing_Cycle__c = 'Per Case';
        program1.Review_Type__c = 'Medical Necessity';
        program1.Priority_Type__c = 'Expedited';
        program1.Number_of_Days__c = 5;
        program1.Contract_Party__c = 'California Department of Health';
        program1.Project_State__c = 'CA';
        program1.Case_Sequence__c='0076';
        progs.add(program1);
        insert progs;
        
        RecordType recordType = new RecordType ();
        recordType.Name='Review Type';
        
        RecordType recordType1 = new RecordType ();
        recordType1.Name='Priority Type';
        // recordType.IsActive= true;
        
        
        
        
        Program_Review_Type__c reviewType = new Program_Review_Type__c();
        reviewType.Name='Medical Necessity';
        reviewType.Type__c = 'Appeal Type';
        //	reviewType.Review_Type__c = 'Medical Necessity';
        //reviewType.No_of_panel_review_for_each_review_type__c = 4;
        reviewType.Program_Name__c = program.Id;
        //reviewType.Record_Type_Name__c = 'Project ID';
        reviewType.RecordTypeId = [Select Id from recordType where Name = 'Review Type' and sObjectType = 'Program_Review_Type__c'].Id;
        insert reviewType;
        
        Program_Review_Type__c reviewType1 = new Program_Review_Type__c();
        reviewType1.Name='Medical Necessity';
        reviewType1.Type__c = 'Appeal Type';
        reviewType1.RecordTypeId = [Select Id from recordType where Name = 'Review Type' and sObjectType = 'Program_Review_Type__c'].Id;
        // reviewType1.Record_Type_Name__c = 'Project ID';
        //  reviewType1.No_of_panel_review_for_each_review_type__c = 4; 
        // 	reviewType1.Review_Type__c = 'Medical Necessity';
        reviewType1.Program_Name__c = program1.Id;
        insert reviewType1;
        
        
        
        Program_Priority__c priority = new Program_Priority__c();
        priority.Name ='Standard';
        priority.Number_of_Days__c = 5;
        priority.Program__c= program.Id;
        priority.Program_Review_Type__c = reviewType.Id;
        // priority.Priority_Type__c = 'Standard';
        insert priority;
        
        Program_Priority__c priority1 = new Program_Priority__c();
        priority1.Name ='Standard';
        priority1.Number_of_Days__c = 5;
        priority1.Program__c= program1.Id;
        priority1.Program_Review_Type__c = reviewType1.Id;
        //priority1.Priority_Type__c = 'Standard';
        insert priority1;
        Case newCase1 = new Case();
        newcase1.AccountId = program1.Id;
        newCase1.Status = 'Initiated';
        newCase1.Document_Address__c = 'Test';
        newCase1.Program_Priority__c = priority1.Id;
        newCase1.Request_Specialty__c ='Internal Medicine';
        //newCase1.Program_Code__c = 'MA';
        newCase1.Created_By_MDIRO__c = 'a.a@g.co';
        newCase1.Program_Review_Type__c = reviewType1.Id;
        newCAse1.Created_By_MDIRO__c = System.UserInfo.getUserEmail();
        newCAse1.Received_Date__c = Date.today();
        insert newCase1;
        
        Case newCase = new Case();
        newcase.AccountId = program.Id;
        newCase.Status = 'Panel Review';
        newCase.Document_Address__c = 'Test';
        newCase.Program_Priority__c = priority.Id;
        newCase.Program_Review_Type__c = reviewType.Id;
        newCase.Created_By_MDIRO__c = 'a.a@g.co';   
        newCase.Request_Specialty__c ='Internal Medicine';
        //newCase.Program_Code__c = 'MA';
        newCase.Program_Review_Type__c = reviewType.Id;
        newCase.Clock_Start_Date__c = Date.Today();
        insert newCase;
        
        Expert_Review__c expert = new Expert_Review__c();
        expert.Name = 'Test Name';
        expert.MDID__c='312';
        insert expert;
        
        Panel_Review__c pr = new Panel_Review__c();
        pr.Case__c = newCase.Id;
        pr.Expert_Review__c = expert.Id;
        pr.Review_Status__c = 'Request Review';
        insert pr;  
        Entity__c caseEntity = new Entity__c();
        caseEntity.Name = 'Test';
        caseEntity.TAX_ID__c= '1234';
        caseEntity.Project_Id__c = 'IR';
        caseEntity.Entity_Type__c = 'MCO';
        //entities.add(en3);
        
        insert caseEntity;
        
        
        Entity_Address__c eAddress = new Entity_Address__c(
            Address_1__c = 'TestAddress_1__c',
            State__c = 'PA',
            Address_Type__c = 'Billing Address',
            Entity__c = caseEntity.Id
            
        );
        insert eAddress;
        
        Entity_Address__c eAddress1 = new Entity_Address__c(
            Address_1__c = 'TestAddress_2__c',
            State__c = 'PA',
            Address_Type__c = 'Billing Address',
            Entity__c = caseEntity.Id
            
        );
        
        insert eAddress1;
        
        Entity_Contact__c entityContact = new Entity_Contact__c(
            Email_Address__c = System.UserInfo.getUserEmail(),
            Contact_Person_First_Name__c= 'John',
            Contact_Person_Last_Name__c='Jones Mailing',
            Contact_Person_Title__c='Manager',
            Entity_Address__c= eAddress.Id,
            Entity__c = caseEntity.Id
            
        );
        
        insert entityContact;
        Participant__c enrollee = new Participant__c(
            First_Name__c = 'Test john',
            Middle_Name__c = 'Brito',
            Last_Name__c = 'Test ',
            Address_Line_1__c = 'Test Address_Line_1__c',
            Address_Line_2__c = 'Test Address_Line_2__c',
            City__c = 'Test',
            State__c = 'PA',
            Zip_Code__c = '52000',
            Entity__c = caseEntity.Id,
            Address__c = true,
            Case__c = newCase.Id
        );
        insert enrollee;
        
        
        
        CaseEntityJunction__c participantEntity = new CaseEntityJunction__c(
            Entity__c = caseEntity.Id,
            Is_Send_Billing_To__c= true,
            Entity_Address__c = eAddress.Id,
            Entity_Contact__c= entityContact.Id,
            Addressee__c = true,
            
            Case__c = newCase1.id
        );
        insert participantEntity;
        
        Fee__c f = new Fee__c();
        f.Fee_Amount__c = 350.00;
        f.Fee_Effective_To__c = system.today() + 120;
        f.Fee_Type__c = 'Physician Fee';
        
        f.Unit__c = 'Hourly';
        f.Program_Priority__c = priority1.Id;
        f.Fee_Effective_From__c = system.today() - 120;
        insert f;
        
        Fee__c f1 = new Fee__c();
        f1.Fee_Amount__c = 350.00;
        f1.Fee_Effective_To__c = system.today() + 120;
        f1.Fee_Type__c = 'Billing Fee';
        f1.Unit__c = 'Hourly';
        f1.Program_Priority__c = priority1.Id;
        f1.Fee_Effective_From__c = system.today() - 120;
        insert f1;
        
        
    }
    
    @isTest static void testmethods1() {
        Test.startTest();
        setUp();
        List<CaseEntityJunction__c> cej=[select id,Send_Billing_To__c,Case__c,Addressee__c,Is_Send_Billing_To__c,Entity_Contact__c,Entity_Address__c,Entity__c from CaseEntityJunction__c];
        CaseEntityJunctionTriggerHandler.checkAddressee(cej);
        CaseEntityJunctionTriggerHandler.addSendBillingTo(cej);
        CaseEntityJunctionTriggerHandler.updatecaseaddressee(cej);
        CaseEntityJunctionTriggerHandler.MDIROCaseSubmissionNotification(cej);
        Test.stopTest();
    }
    @isTest static void testmethods2() {
        Test.startTest();
        list<User> userObj = [Select Id from User where Name = 'Integration User'];
        if(userObj!=null && !userObj.isEmpty()){
            
        System.runAs(userObj[0]) {
            setUp();
        }
        }
        Test.stopTest();
    }
    
     @isTest static void testmethods3() {
        Test.startTest();
        setUp();
		delete[select id from CaseEntityJunction__c];
         Test.stopTest();
    }
    
}