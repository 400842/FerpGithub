@isTest
public class TestCreateCase {
 	@testSetup
     public static void setup(){
         
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
        
        Account acc1 = new Account();
        acc1.name = 'Virginia Insurance Department Test';
        acc1.Priority_Type__c= 'Standard';
        acc1.Review_Type__c = 'Medical Necessity';
        acc1.Number_of_Days__c = 4;
        acc1.Project_State__c = 'VA';
        acc1.Program_Code__c = 'VS';
        acc1.Contract_Party__c = 'Virginia Insurance Department';
        acc1.Introduction__c = 'test';
        acc1.Standard_Of_Review__c = 'test';
        acc1.Conclusion__c = 'test';
        acc1.Dispute_Narrative__c = 'test';
        acc1.Other_Narrative__c = 'test';
        acc1.Health_Plan_Denial_Reason__c = 'test';
        acc1.Questions_to_Expert__c = 'test';
        acc1.Send_Billing_To__c='Health Plan';
        insert acc1;
        
        RecordType rt= [SELECT Id FROM RecordType WHERE sObjectType = 'Program_Review_Type__c' AND Name = 'Review Type'];
        Program_Review_Type__c revType = new Program_Review_Type__c();
        revType.Name = 'Medical Necessity';
        revType.RecordTypeId = rt.Id;
        revType.Program_Name__c = acc.Id;
        revType.Type__c = 'Appeal Category';
        insert revType; 
        
        Program_Review_Type__c revType1 = new Program_Review_Type__c();
        revType1.Name = 'Medical Necessity';
        revType1.RecordTypeId = rt.Id;
        revType1.Program_Name__c = acc1.Id;
        revType1.Type__c = 'Appeal Category';
        insert revType1; 
        
        //RecordType rti= [SELECT Id FROM RecordType WHERE sObjectType = 'Program_Review_Type__c' AND Name = 'Review Decision']; 
        Program_Review_Type__c revTypes = new Program_Review_Type__c();
        revTypes.Name = 'Medical Necessity';
        revTypes.RecordTypeId = rt.Id;
        revTypes.Program_Name__c = acc.Id;
        revTypes.Type__c = 'Appeal Type';
        insert revTypes;
        
        RecordType rts= [SELECT Id FROM RecordType WHERE sObjectType = 'Program_Priority__c' AND Name = 'Priority Type'];
        Program_Priority__c pr = new Program_Priority__c();
        pr.Program_Review_Type__c = revType.Id;
        pr.name = 'Standard';
        pr.RecordTypeId = rts.Id;       
        insert pr;

        
        Program_Priority__c pr1 = new Program_Priority__c();
        pr1.Program_Review_Type__c = revType1.Id;
        pr1.name = 'Standard';
        pr1.RecordTypeId = rts.Id;       
        insert pr1;
        
        Fee__c f = new Fee__c();
        f.Fee_Amount__c = 350.00;
        f.Fee_Effective_To__c = system.today() + 120;
        f.Fee_Type__c = 'Billing Fee';
        f.Unit__c = 'Hourly';
        f.Program_Priority__c = pr.Id;
        f.Fee_Effective_From__c = system.today() - 120;
        insert f;
        
        Fee__c f1 = new Fee__c();
        f1.Fee_Amount__c = 350.00;
        f1.Fee_Effective_To__c = system.today() + 120;
        f1.Fee_Effective_From__c = system.today() - 120;
        f1.Fee_Type__c = 'Physician Fee';
        f1.Unit__c = 'Hourly';
        f1.Program_Priority__c = pr.Id;
        insert f1;
                Test.startTest(); 
        Case c = new Case();
        c.AccountId = acc.Id;
        c.Program_Review_Type__c = revType.Id;
        c.Program_Priority__c = pr.Id;
       c.Received_Date__c = system.now()-10; 
        c.Status = 'Ready to be Closed';
        c.Document_Addressee__c = 'test1';
        insert c;
          
         
        Case c1 = new Case();
        c1.AccountId = acc1.Id;
        c1.Program_Review_Type__c = revType1.Id;
        c1.Program_Priority__c = pr1.Id;
        c1.Received_Date__c = system.now()-10; 
        c1.Status = 'Closed/Completed';
        c1.Document_Addressee__c = 'test';
        insert c1;
         Test.stopTest();
        Entity__c en = new Entity__c();
         en.Name = 'Test';
         en.Secondary_Name__c = 'entity';
         en.TAX_ID__c= '1234';
         en.Entity_Type__c = 'Health Plan';
         en.Project_Id__c = 'test';
         insert en;
         
        Entity_Address__c enAdd = new Entity_Address__c();
         enAdd.Name = 'test dr.,';
         enAdd.Address_2__c = 'ste 400';
         enAdd.City__c = 'Reston';
         enAdd.State__c = 'VA';
         enAdd.Zip__c = '20190';
         enAdd.Entity__c = en.Id;
         enAdd.Address_Type__c='Billing Address';
         insert enAdd;
         
        Entity_Contact__c enCon = new Entity_Contact__c();
         enCon.name = 'test';
         enCon.Contact_Person_First_Name__c='test';
         enCon.Contact_Person_Last_Name__c = 'user';
         enCon.Entity__c= en.Id;
         enCon.Entity_Address__c= enAdd.Id;
         insert enCon;
         
        CaseEntityJunction__c ce = new CaseEntityJunction__c();
         ce.Is_Send_Billing_To__c = false;
         ce.Case__c = c.Id;
         ce.Entity__c = en.Id;
         ce.Entity_Address__c = enAdd.Id;
         ce.Entity_Contact__c = enCon.Id;
         insert ce;
         
         CaseEntityJunction__c ce1 = new CaseEntityJunction__c();
         ce1.Is_Send_Billing_To__c = true;
         ce1.Case__c = c1.Id;
         ce1.Entity__c = en.Id;
         ce1.Entity_Address__c = enAdd.Id;
         ce1.Entity_Contact__c = enCon.Id;
         insert ce1;
         
        Invoice_Header__c invoice = new Invoice_Header__c();
        invoice.Entity__c = en.Id;
        invoice.Status__c = 'Unpaid';
        invoice.Invoice_Date__c = Date.Today();
        invoice.Invoice_Number__c = '123invoicetest';
        Insert invoice;
         
         
        Participant__c p = new Participant__c();
         p.First_Name__c = 'test';
         p.Last_Name__c = 'user';
         p.Participant_Enrollee_Type__c='Requestor';
         p.Address_Line_1__c='test dr';
         p.Address_Line_2__c='ste 400';
         p.City__c='Reston';
         p.State__c='VA';
         p.Zip_Code__c='78690';
         p.Case__c=c.Id;
         p.Address__c=true;
         //p.Send_Billing_To__c = false;
         insert p;	
         
        Participant__c p1 = new Participant__c();
         p1.First_Name__c = 'test';
         p1.Last_Name__c = 'user';
         p1.Participant_Enrollee_Type__c='Requestor';
         p1.Address_Line_1__c='test dr';
         p1.Address_Line_2__c='ste 400';
         p1.City__c='Reston';
         p1.State__c='VA';
         p1.Zip_Code__c='78690';
         p1.Case__c=c1.Id;
         p1.Address__c=false;
         //p1.Send_Billing_To__c=false;
         insert p1;
         
        /*Case_Attestation__c ca = new Case_Attestation__c();
         ca.name = 'test';
         ca.Case__c = c.Id;
         ca.Comments__c= 'test';
         insert ca;*/
         
        RFI_Log__c rfi = new RFI_Log__c();
         rfi.Comments__c='test';
         rfi.Status__c = 'Open';
         rfi.Send_Date__c = system.today() -20;
         rfi.Case__c = c.Id;
         rfi.Due_Date__c = system.today() -2;
         insert rfi;
                
    }
    
    @isTest
    public static void testing(){
        Test.startTest();
        Account acc = [select Id from Account limit 1];
        Program_Review_Type__c revType = [select id from Program_Review_Type__c where Type__c = 'Appeal Category' limit 1];
        Program_Priority__c pr =[select Id from Program_Priority__c limit 1];
        CaseEntityJunction__c ce = [select id from CaseEntityJunction__c limit 1];
        Entity__c en = [select id from Entity__c limit 1];
        Entity_Address__c enAdd = [select id from Entity_Address__c limit 1];
        Case c = [select id from Case where Status = 'Ready to be Closed' limit 1];
        Case c1 = [select id from Case where Status = 'Closed/Completed' limit 1];
        Entity_Contact__c enCon = [select id from Entity_Contact__c limit 1];
        
        CaseEntityJunction__c ent = new CaseEntityJunction__c();
         ent.Is_Send_Billing_To__c = true;
         ent.Case__c = c.Id;
         ent.Entity__c = en.Id;
         ent.Entity_Address__c = enAdd.Id;
         ent.Entity_Contact__c = enCon.Id;
        
        
        CreateCase.getAccount(acc.Id);
         CreateCase.getAccount('');
        CreateCase.getProgramDetails(acc.Id);
        CreateCase.getReviewType(acc.Id);
        CreateCase.getAppealCategory(acc.Id);
        CreateCase.getAppealType(acc.Id);
        CreateCase.getPriorityType(revType.Id);
        CreateCase.getReviewFeeAmount(pr.Id);
        CreateCase.getBillingFeeAmount(pr.Id);
        CreateCase.getObjectDetails('Entity_Address__c');
        //CreateCase.checkAttestation(c.Id);
        CreateCase.getBillingInformation(c.Id);
        CreateCase.getBillingInformation(c1.Id);
        CreateCase.checkOpenRFI(c.Id);
        CreateCase.checkOpenPastRFI(c.Id);
        CreateCase.checkOpenPanelReview(c.Id);
        CreateCase.checkOpenPastPanelReview(c.Id);
        CreateCase.getALLBillingFeeAmount(c.Id);
        CreateCase.getAllDetails();
        CreateCase.getEntData(c.Id);
        CreateCase.getEnt(ce.Id);
        CreateCase.getEntitytypes();
        CreateCase.getFeeAmount(pr.Id);
        CreateCase.getRDs(revType.Id);
        CreateCase.getNotes(c.Id);
        CreateCase.getCase(c.Id);
        CreateCase.updateQcCaseStatus(c.Id,'Yes');
        CreateCase.updateQcCaseStatus(c.Id,'No'); 
        CreateCase.getEntities('Health Plan');
        CreateCase.getAdd(en.Id);
        CreateCase.getCon(enAdd.Id);
        CreateCase.GetRecord('Entity_Address__c',null,enAdd.Id);
        CreateCase.GetRecentRecords('Entity_Address__c', c.Id, null, null);
        CreateCase.GetRecentRecords('Entity_Contact__c', enAdd.Id, null, null);
        //CreateCase.savEntity(ent);
        //CreateCase.updateEntity(ent);
         CreateCase.getCACTUSAssignment();
       Test.stopTest();
    }
    @isTest
    public static void testing2(){
        Test.startTest();
        Case c = [select id from Case where Status = 'Ready to be Closed' limit 1];
        Panel_Review__c prev = new Panel_Review__c();
         prev.Case__c = c.Id;
         prev.Date_returned_to_MMS__c = null;
         prev.Review_Due_Date__c = system.today();
         prev.Review_Status__c = 'Review Accepted';
         prev.Review_Number__c =1;
         insert prev;
         
        Panel_Review__c prev1 = new Panel_Review__c();
         prev1.Case__c = c.Id;
         prev1.Date_returned_to_MMS__c = null;
         prev1.Review_Due_Date__c = system.today()-10;
         prev1.Review_Status__c = 'Request Review';
         prev1.Review_Number__c= 2;
         insert prev1;
        
        
                CreateCase.getDecisions(c.Id);
        		CreateCase.GetRecentRecords('Fee__c', prev.Id, null, null);
        Test.stopTest();
    }
   @isTest
    public static void testing4(){
        Case c = [select id from Case where Status = 'Ready to be Closed' limit 1];
        Test.startTest();
        CreateCase.getCaseRecordTypeID();
        Test.stopTest();
    }
   /* @isTest
    public static void testing5(){
        Invoice_Header__c inv = [select id from Invoice_Header__c limit 1];
        Test.startTest();
        inv.Status__c = '--Select--';
        CreateCase.updateInvoiceHeader(inv);
        Test.stopTest();
    }*/
    
     @isTest
    public static void testing6(){
        Invoice_Header__c inv = [select id from Invoice_Header__c limit 1];
        Test.startTest();
        inv.Status__c = 'new';
        Test.stopTest();
    }
    
}