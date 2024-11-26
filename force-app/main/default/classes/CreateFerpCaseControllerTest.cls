@isTest
public class CreateFerpCaseControllerTest {
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
        acc1.name = 'FERP HHS Federal External Review Process';
        acc1.Priority_Type__c= 'Standard';
        acc1.Review_Type__c = 'Medical Necessity';
        acc1.Number_of_Days__c = 4;
        acc1.Project_State__c = 'VA';
        acc1.Program_Code__c = 'VA';
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
        revType.Name = 'Coverage';
        revType.RecordTypeId = rt.Id;
        revType.Program_Name__c = acc1.Id;
        revType.Type__c = 'Appeal Category';
        insert revType; 

        Program_Review_Type__c revType1 = new Program_Review_Type__c();
        revType1.Name = 'Standard';
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
         
        Case c = new Case();
        c.AccountId = acc1.Id;
        c.Program_Review_Type__c = revType.Id;
        c.Program_Priority__c = pr.Id;
       c.Received_Date__c = system.now()-10; 
        c.Status = 'Ready to be Closed';
        c.Document_Addressee__c = 'test1';
        insert c;
         
        Case c1 = new Case();
        c1.AccountId = acc1.Id;
        c1.Program_Review_Type__c = revType.Id;
        c1.Program_Priority__c = pr.Id;
        c1.Received_Date__c = system.now()-10; 
        c1.Status = 'Closed/Completed';
        c1.Document_Addressee__c = 'test';
        insert c1;
         
        Entity__c en = new Entity__c();
         en.Name = 'Test';
         en.Secondary_Name__c = 'entity';
         en.TAX_ID__c= '1234';
         en.Entity_Type__c = 'Health Plan';
         en.Project_Id__c = 'FE';
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
         
         
        Participant__c p = new Participant__c();
         p.First_Name__c = 'test';
         p.Last_Name__c = 'user';
         p.Participant_Enrollee_Type__c='Claimant';
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
         p1.Participant_Enrollee_Type__c='Claimant';
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
        
        CreateFerpCaseController.createAttachment('fileName.txt', '990033', c.id);
        CreateFerpCaseController.createMaxAttachment('fileName.txt', '990033', c.id);
        FERPRequestWrapper fwrap = new FERPRequestWrapper();
        fwrap.Expedite_Selected = true;
        fwrap.Reason_for_Review = 'Other';
        fwrap.Denial_Reason = 'test';
        fwrap.Denial_Disagreement_Reason = 'test';
        fwrap.Health_Plan_Street = 'wall street';
        fwrap.Health_Plan_Apt = 'test';
        fwrap.Health_Plan_City = 'New York';
        fwrap.Health_Plan_State = 'NY';
        fwrap.Health_Plan_Zip = '10001';
        fwrap.Age = '23';
        
        FERPRequestClaimWrapper clm = new FERPRequestClaimWrapper();
        clm.ClaimName = 'new claim name';
        clm.Service_Start_Date = system.today();
        clm.Service_End_Date = system.today().addDays(3);
        clm.id = 2234;
        List<FERPRequestClaimWrapper> fcwrapList = new List<FERPRequestClaimWrapper>();
        fcwrapList.add(clm);
        CreateFerpCaseController.CreateCase(fwrap, fcwrapList);
        CreateFerpCaseController.createEntityJunction(fwrap, c.id, en.id, enAdd.id);
        CreateFerpCaseController.createEntityAddress(fwrap, en.id);
        CreateFerpCaseController.createEntity(fwrap);
        CreateFerpCaseController.createClaimants(fcwrapList, c.id);
        //CreateFerpCaseController.createProvider(fwrap, c.id);
        CreateFerpCaseController.createRequestor(fwrap, c.id);
        CreateFerpCaseController.createClaimant(fwrap, c.id);
        CreateFerpCaseController.createSubScriber(fwrap, c.Id);
        CreateFerpCaseController.fetchEntities();
        CreateFerpCaseController.getStatePicklist();
       
       Test.stopTest();
    }
    
}