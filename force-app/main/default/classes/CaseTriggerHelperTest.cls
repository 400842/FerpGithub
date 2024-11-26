@isTest
public class CaseTriggerHelperTest {
    @testSetup
    public static void setup(){
        Account acc = new Account();
        acc.name = 'Massachusets Health Policy Commission';
        acc.Priority_Type__c= 'Standard';
        acc.Review_Type__c = 'Medical Necessity';
        acc.Number_of_Days__c = 4;
        acc.Project_State__c = 'MA';
        acc.Program_Code__c = 'MA';
        acc.Contract_Party__c = 'Massachusets Health Policy Commission';
        acc.Introduction__c = 'test';
        acc.Standard_Of_Review__c = 'test';
        acc.Conclusion__c = 'test';
        acc.Dispute_Narrative__c = 'test';
        acc.Other_Narrative__c = 'test';
        acc.Health_Plan_Denial_Reason__c = 'test';
        acc.Questions_to_Expert__c = 'test';
        acc.Send_Billing_To__c = 'Enrollee';
        insert acc;
        
        List<Program_Review_Type__c> prTypes = new List<Program_Review_Type__c> ();
        RecordType rt= [SELECT Id FROM RecordType WHERE sObjectType = 'Program_Review_Type__c' AND Name = 'Review Type'];
        Program_Review_Type__c revType = new Program_Review_Type__c();
        revType.Name = 'Medical Necessity';
        revType.RecordTypeId = rt.Id;
        revType.Program_Name__c = acc.Id;
        revType.Type__c = 'Appeal Category';
        revType.Effective_Date_From__c = System.today().addDays(-2);
        prTypes.add(revType); 
        
        RecordType rt1= [SELECT Id FROM RecordType WHERE sObjectType = 'Program_Review_Type__c' AND Name = 'Document Template'];
        Program_Review_Type__c revType1 = new Program_Review_Type__c();
        revType1.Name = 'MA Medical Necessity Decision Letter';
        revType1.RecordTypeId = rt1.Id;
        revType1.Program_Name__c = acc.Id;
        revType1.Template_Name__c = 'MA Medical Necessity Decision Letter';
        revType.Effective_Date_From__c = System.today().addDays(-2);
        revType.Effective_Date_To__c = System.today().addDays(2);
        
        prTypes.add(revType1); 
        
        Program_Review_Type__c revType2 = new Program_Review_Type__c();
        revType2.Name = 'MA Medical Necessity Review Form';
        revType2.RecordTypeId = rt1.Id;
        revType2.Program_Name__c = acc.Id;
        revType2.Template_Name__c = 'MA Medical Necessity Review Form';
        revType2.Effective_Date_From__c = System.today().addDays(-2);
        revType2.Effective_Date_To__c = System.today().addDays(2);
        prTypes.add(revType2); 
        
        Program_Review_Type__c revType8 = new Program_Review_Type__c();
        revType8.Name = 'MA Medical Necessity Decision Letter Sample';
        revType8.RecordTypeId = rt1.Id;
        revType8.Program_Name__c = acc.Id;
        revType8.Template_Name__c = 'MA Medical Necessity Decision Letter Sample';
        revType8.Effective_Date_From__c = System.today().addDays(-2);
        revType8.Effective_Date_To__c = System.today().addDays(2);
        prTypes.add(revType8); 
        
        RecordType rt2= [SELECT Id FROM RecordType WHERE sObjectType = 'Program_Review_Type__c' AND Name = 'Project ID'];
        Program_Review_Type__c revType3 = new Program_Review_Type__c();
        revType3.Name = 'Review Letter';
        revType3.RecordTypeId = rt2.Id;
        revType3.Program_Name__c = acc.Id;
        revType3.Template_Name__c = 'Review Letter';
        revType3.Effective_Date_From__c = System.today().addDays(-2);
        revType3.Effective_Date_To__c = System.today().addDays(2);
        prTypes.add(revType3); 
        
        insert prTypes;
        
        RecordType rts= [SELECT Id FROM RecordType WHERE sObjectType = 'Program_Priority__c' AND Name = 'Priority Type'];
        List<Program_Priority__c> prs = new List<Program_Priority__c>();
        Program_Priority__c pr = new Program_Priority__c();
        pr.Program_Review_Type__c = revType.Id;
        pr.name = 'Standard';
        pr.RecordTypeId = rts.Id;  
        prs.add(pr);
        
        Program_Priority__c pr2 = new Program_Priority__c();
        pr2.Program_Review_Type__c = revType.Id;
        pr2.name = 'Basic';
        pr2.RecordTypeId = rts.Id;  
        prs.add(pr2);
        
        Program_Priority__c pr3 = new Program_Priority__c();
        pr3.Program_Review_Type__c = revType.Id;
        pr3.name = 'Modrate';
        pr3.RecordTypeId = rts.Id;  
        prs.add(pr3);
        insert prs;
        
        Program_Priority__c prgPriority1 = new Program_Priority__c();
        prgPriority1.Name = 'Expedited';
        prgPriority1.recordTypeId = rts.id;
        prgPriority1.Program_Review_Type__c = revType.Id;
        Insert prgPriority1;
        
        List<Fee__c> fees = new List<Fee__c>();
        Fee__c f = new Fee__c();
        f.Fee_Amount__c = 350.00;
        f.Fee_Effective_To__c = system.today() + 120;
        f.Fee_Type__c = 'Billing Fee';
        f.Unit__c = 'Hourly';
        f.Program_Priority__c = pr.Id;
        f.Fee_Effective_From__c = system.today() - 120;
        fees.add(f);
        
        Fee__c f2 = new Fee__c();
        f2.Fee_Amount__c = 350.00;
        f2.Fee_Effective_To__c = system.today() + 120;
        f2.Fee_Type__c = 'Billing Fee';
        f2.Unit__c = 'Hourly';
        f2.Program_Priority__c = pr2.Id;
        f2.Fee_Effective_From__c = system.today() - 120;
        fees.add(f2);
        
        Fee__c f3 = new Fee__c();
        f3.Fee_Amount__c = 350.00;
        f3.Fee_Effective_To__c = system.today() + 120;
        f3.Fee_Type__c = 'Billing Fee';
        f3.Unit__c = 'Hourly';
        f3.Program_Priority__c = pr3.Id;
        f3.Fee_Effective_From__c = system.today() - 120;
        fees.add(f3);
        
        Fee__c f4 = new Fee__c();
        f4.Fee_Amount__c = 350.00;
        f4.Fee_Effective_To__c = system.today() + 120;
        f4.Fee_Type__c = 'Physician Fee';
        f4.Unit__c = 'Hourly';
        f4.Program_Priority__c = pr.Id;
        f4.Fee_Effective_From__c = system.today() - 120;
        fees.add(f4);
            
        insert fees;
        
        List<Case> cases = new List<Case>();
        Case c = new Case();
        c.AccountId = acc.Id;
        c.Priority_Type__c='Standard';
        c.Program_Review_Type__c = revType.Id;
        c.Program_Priority__c = pr.Id;
        c.Received_Date__c = system.now();
        c.Status = 'Ready to be Closed';
        c.Document_Addressee__c = 'test1 Uphold';
        c.Decision_Code__c = 'Uphold';
        c.Created_By_MDIRO__c = 'testinvoice@case1.com';
        c.Case_Decision_Date__c = System.today();
        c.Requestor_Email__c='aa@bb.com';
        c.Document_Address__c = 'Test Addereee';
        //c.Decision_Code__c = 'Overturn';
        c.Clock_Start_Date__c=system.now();
                c.Letter_Sent_Date__c=system.today();
        cases.add(c);
        
        Case c2 = new Case();
        c2.AccountId = acc.Id;
        c2.Program_Review_Type__c = revType.Id;
        c2.Priority_Type__c='Standard';
        c2.Program_Priority__c = pr.Id;
        c2.Received_Date__c = system.now();
        c2.Status = 'Initiated';
        c2.Document_Addressee__c = 'test2 Partial Overturn';
        c2.Decision_Code__c = 'Partial Overturn';
        c2.Created_By_MDIRO__c = 'testinvoice@case2.com';
        c2.Case_Decision_Date__c = System.today();
        c2.Decision_Code__c = 'Overturn';
        cases.add(c2);
        
        Case c3 = new Case();
        c3.AccountId = acc.Id;
        c3.Priority_Type__c='Standard';
        c3.Program_Review_Type__c = revType.Id;
        c3.Program_Priority__c = pr.Id;
        c3.Received_Date__c = system.now();
        c3.Status = 'Draft';
        c3.Document_Addressee__c = 'test2 Overturn';
        c3.Decision_Code__c = 'Partial Overturn';
        c3.Created_By_MDIRO__c = 'testinvoice@case3.com';
        c3.Case_Decision_Date__c = System.today();
        cases.add(c3);
        
        insert cases;
        Participant__c par = new Participant__c(Address__c=true,Case__c=cases[0].Id,Address_Line_1__c='test',Address_Line_2__c='test1');
        INSERT par;
        List<Entity__c> entities = new List<Entity__c>();
        Entity__c en = new Entity__c();
        en.Name = 'Test';
        en.Secondary_Name__c = 'entity';
        en.TAX_ID__c= '1234';
        en.Entity_Type__c = 'Representative';
         en.Project_Id__c = 'test';
        entities.add(en);
        
        Entity__c en2 = new Entity__c();
        en2.Name = 'Test2';
        en2.Secondary_Name__c = 'entity';
        en2.TAX_ID__c= '1234';
        en2.Entity_Type__c = 'Provider';
         en2.Project_Id__c = 'test';
        entities.add(en2);
        
        Entity__c en3 = new Entity__c();
        en3.Name = 'Test';
        en3.Secondary_Name__c = 'entity';
        en3.TAX_ID__c= '1234';
        en3.Entity_Type__c = 'MCO';
         en3.Project_Id__c = 'test';
        entities.add(en3);
        
        insert entities;
        
        List<Entity_Address__c> addresses = new List<Entity_Address__c>();
        Entity_Address__c enAdd = new Entity_Address__c();
        enAdd.Name = 'test dr.,';
        enAdd.Address_1__c = 'ste 200';
        enAdd.Address_2__c = 'ste 400';
        enAdd.City__c = 'Reston';
        enAdd.State__c = 'VA';
        enAdd.Zip__c = '20190';
        enAdd.Entity__c = en.Id;
        enAdd.Address_Type__c='Billing Address';
        addresses.add(enAdd);
        
        Entity_Address__c enAdd2 = new Entity_Address__c();
        enAdd2.Name = 'test dr.,';
        enAdd2.Address_1__c = 'ste 200';
        enAdd2.Address_2__c = 'ste 400';
        enAdd2.City__c = 'Reston';
        enAdd2.State__c = 'VA';
        enAdd2.Zip__c = '20191';
        enAdd2.Entity__c = en2.Id;
        enAdd2.Address_Type__c='Billing Address';
        addresses.add(enAdd2);
        
        Entity_Address__c enAdd3 = new Entity_Address__c();
        enAdd3.Name = 'test dr.,';
        enAdd3.Address_1__c = 'ste 200';
        enAdd3.Address_2__c = 'ste 400';
        enAdd3.City__c = 'Reston';
        enAdd3.State__c = 'VA';
        enAdd3.Zip__c = '20192';
        enAdd3.Entity__c = en3.Id;
        enAdd3.Address_Type__c='Billing Address';
        addresses.add(enAdd3);
        
        insert addresses;
        
        List<Entity_Contact__c> enContacts = new List<Entity_Contact__c>();
        Entity_Contact__c enCon = new Entity_Contact__c();
        enCon.name = 'test';
        enCon.Contact_Person_First_Name__c='test';
        enCon.Contact_Person_Last_Name__c = 'user';
        enCon.Entity__c= en.Id;
        enCon.Entity_Address__c= enAdd.Id;
        enCon.Email_Address__c = c.Created_By_MDIRO__c;
        enContacts.add(enCon);
        
        Entity_Contact__c enCon2 = new Entity_Contact__c();
        enCon2.name = 'test';
        enCon2.Contact_Person_First_Name__c='test';
        enCon2.Contact_Person_Last_Name__c = 'user';
        enCon2.Entity__c= en2.Id;
        enCon2.Entity_Address__c= enAdd2.Id;
        enCon2.Email_Address__c = c2.Created_By_MDIRO__c;
        enContacts.add(enCon2);
        
        Entity_Contact__c enCon3 = new Entity_Contact__c();
        enCon3.name = 'test';
        enCon3.Contact_Person_First_Name__c='test';
        enCon3.Contact_Person_Last_Name__c = 'user';
        enCon3.Entity__c= en3.Id;
        enCon3.Entity_Address__c= enAdd3.Id;
        enCon3.Email_Address__c = c3.Created_By_MDIRO__c;
        enContacts.add(enCon3);
        
        insert enContacts;
        
        List<CaseEntityJunction__c> cejs = new List<CaseEntityJunction__c>();
        CaseEntityJunction__c ce = new CaseEntityJunction__c();
        ce.Is_Send_Billing_To__c = false;
        ce.Case__c = c.Id;
        ce.Entity__c = en.Id;
        ce.Entity_Address__c = enAdd.Id;
        ce.Entity_Contact__c = enCon.Id;
        ce.Addressee__c = false;
        cejs.add(ce);
        
        CaseEntityJunction__c ce2 = new CaseEntityJunction__c();
        ce2.Is_Send_Billing_To__c = false;
        ce2.Case__c = c2.Id;
        ce2.Entity__c = en2.Id;
        ce2.Entity_Address__c = enAdd2.Id;
        ce2.Entity_Contact__c = enCon2.Id;
        ce2.Addressee__c = false;
        cejs.add(ce2);
        
        CaseEntityJunction__c ce3 = new CaseEntityJunction__c();
        ce3.Is_Send_Billing_To__c = false;
        ce3.Case__c = c3.Id;
        ce3.Entity__c = en3.Id;
        ce3.Entity_Address__c = enAdd3.Id;
        ce3.Entity_Contact__c = enCon3.Id;
        ce3.Addressee__c = false;
        cejs.add(ce3);
        
        CaseEntityJunction__c ce4 = new CaseEntityJunction__c();
        ce4.Is_Send_Billing_To__c = false;
        ce4.Case__c = c2.Id;
        ce4.Entity__c = en2.Id;
        ce4.Entity_Address__c = enAdd2.Id;
        ce4.Entity_Contact__c = enCon2.Id;
        ce4.Addressee__c = false;
        cejs.add(ce4);
        
        CaseEntityJunction__c ce5 = new CaseEntityJunction__c();
        ce5.Is_Send_Billing_To__c = false;
        ce5.Case__c = c2.Id;
        ce5.Entity__c = en3.Id;
        ce5.Entity_Address__c = enAdd3.Id;
        ce5.Entity_Contact__c = enCon3.Id;
        ce5.Addressee__c = false;
        cejs.add(ce5);
        
        insert cejs;
        cases[0].Status = 'Completed';
        cases[1].Status = 'Completed';
        cases[2].Status = 'Completed';
        UPDATE cases;
    }
    
        
    
   /* @isTest static void testInvoiceDetailCreation(){
        List<Case> cases = [select Id,Status from Case];
        for(Case c: cases){
            c.Status = 'Completed';
        }
        update cases;
        
        Test.startTest();
        CaseEntityJunction__c cje = [SELECT Entity__c, Entity_Contact__c FROM CaseEntityJunction__c LIMIT 1];
        Invoice_Header__c ih = new Invoice_Header__c(
            Entity__c = cje.Entity__c,
            Entity_Contact__c = cje.Entity_Contact__c
        );
        insert ih;
        
        CaseTriggerHelper.createInvoiceHeaderRecord([SELECT ID, Status, Created_By_MDIRO__c, Program_Code__c, Program_Priority__c, Decision_Code__c, Received_Date__c from Case]);
        
        Test.stopTest();
        
        System.assertEquals([Select Id From Invoice_Details__c].isEmpty(), false, 'Invoice_Details__cs not Created.');
        
        System.assertEquals([Select Id From Invoice_Header__c].isEmpty(), false, 'Invoice_Header__cs not Created.');
        
    }
*/
    
    @isTest static void testInvoiceHeaderCreationBatch() {
        
        Test.startTest();
        //Invoice_Number__c obj = new Invoice_Number__c(Sequence__c=1);
        //INSERT obj;
        CaseUtilityBatch cub = new CaseUtilityBatch();
        Id batchId = Database.executeBatch(cub);
        Test.stopTest();
        
    }
      
    @isTest static void testChechkCasecontroller() {
        case cs=[select id,Case_Number_f__c,Requestor_Email__c from case where Requestor_Email__c='aa@bb.com' limit 1];
        system.debug(cs.Requestor_Email__c+'^^^^^^^^^^'+cs.Case_Number_f__c);
        Test.startTest();
        ChechkCasecontroller.searchCaseId('MA24','aa@bb.com');
        Test.stopTest();
        
    }
    
    @isTest static void testInvoiceHeaderCreationScheduler() {
        String CRON_EXP = '0 0 0 15 3 ? 2025';
        System.debug('$$$$$'+[SELECT Id from Invoice_Details__c]);
        Test.startTest();
        //Invoice_Number__c obj = new Invoice_Number__c(Sequence__c=1);
        //INSERT obj;
        // Schedule the test job
        String jobId = System.schedule('CaseUtilitySchedulerTest', CRON_EXP, new CaseUtilityScheduler());
        Test.stopTest();
    }
    
    @isTest static void testMethodsScheduler() {
        Test.startTest();
        CaseUtilityScheduler ob = new CaseUtilityScheduler();
       
        ob.execute(null);
       
        Test.stopTest();
    }
    
    @isTest static void testPpdateFeeAmount() {
        List<Case> cases = [select Id, Program_Priority__c  from Case];
                Program_Priority__c pr = [SELECT Id FROM Program_Priority__c where name='Expedited' LIMIT 1];

        Test.startTest();
            for(Case c: cases){
                c.Program_Priority__c = pr.Id;
                c.MCO_File_Uploaded__c=system.now();
                c.Decision_Code__c='Partial Overturn';
               c.Clock_Start_Date__c=system.now();
                c.Letter_Sent_Date__c=system.today();
            }
            update cases;
            
        Test.stopTest();
    }
    
    @isTest static void testInvoiceHeaderEmailNotification() {
        List<CaseEntityJunction__c> cjes = [SELECT Entity__c, Entity_Contact__c FROM CaseEntityJunction__c];
        List<Invoice_Header__c> iheaders = new List<Invoice_Header__c>();
        Integer i=1;
        for(CaseEntityJunction__c  cje : cjes){
            iheaders.add(
                new Invoice_Header__c(
                    Entity__c = cje.Entity__c,
                    Entity_Contact__c = cje.Entity_Contact__c,
                    Invoice_Date__c = system.today().addDays(i*15),
                    Invoice_Number__c = 'Invoice_N_'+i
                )
            );
            i = i==3 ? 1 : i;
        }
        insert iheaders;
        
        Test.startTest();
        //Send EMail
        List<Id> ihIDs = new List<Id>();
        if(!iheaders.isEmpty()){
            for(Invoice_Header__c  iheader : iheaders){
                ihIDs.add(iheader.Id);
            }
        }
        //InvoiceHeaderEmailNotification.sendEmailReminders(ihIDs); 
        //Send EMail
        Test.stopTest();
    }
}