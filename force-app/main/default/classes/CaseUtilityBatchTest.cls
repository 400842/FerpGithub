@isTest
public class CaseUtilityBatchTest {
    
    
@testSetup
    public static void dataSetup(){
        Account acc = new Account();
        acc.Name ='Test';
        acc.BillingCity = 'Test City';
        acc.BillingCountry  = 'Test Country';
        acc.Project_State__c='MN';
        acc.Program_Code__c='MN';
        acc.Contract_Party__c='State of Minnesota';
        insert acc;

        // setup required records
        Contact con = new Contact();
        con.FirstName = 'Test';
        con.LastName = 'Test Last';
        con.AccountId = acc.Id;
        insert con;


        Case cs = new Case();
        cs.AccountId = acc.Id;
        cs.ContactId = con.Id;
        cs.Status = 'Completed';
        cs.Decision_Date_Closing__c= system.today();
        cs.Decision_Code__c = 'Uphold';
        cs.Letter_Sent_Date__c = System.today().toStartOfMonth().addDays(-2);
        insert cs;
        
		/*
        List<MAXAttachments__c> attlist = new List<MAXAttachments__c>();
        
        MAXAttachments__c mx = new MAXAttachments__c();
        mx.Case__c = cs.Id;
        mx.Document_Type__c='PowerofAttorneyAgreement';
        mx.Document_Status__c='Processing';
        attlist.add(mx);
        
        
        MAXAttachments__c mx1 = new MAXAttachments__c();
        mx1.Case__c = cs.Id;
        mx1.Document_Type__c='Additional Member Info';
        mx1.Document_Status__c='Processing';
        mx1.Share_To_Expert__c = true;
        attlist.add(mx1);
        insert attlist;
        */
        List<Entity__c> entities = new List<Entity__c>();
        Entity__c en = new Entity__c();
        en.Name = 'Test';
        en.Secondary_Name__c = 'entity';
        en.TAX_ID__c= '1234';
        en.Entity_Type__c = 'Representative';
        en.Project_Id__c = 'IR';
        entities.add(en);
        
        Entity__c en2 = new Entity__c();
        en2.Name = 'Test2';
        en2.Secondary_Name__c = 'entity';
        en2.TAX_ID__c= '1234';
        en2.Entity_Type__c = 'Provider';
        en2.Project_Id__c = 'IR';
        entities.add(en2);
        
        Entity__c en3 = new Entity__c();
        en3.Name = 'Test';
        en3.Secondary_Name__c = 'entity';
        en3.TAX_ID__c= '1234';
        en3.Project_Id__c = 'IR';
        en3.Entity_Type__c = 'MCO';
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
        enCon.Email_Address__c = 'a.a@g.co';
        enCon.Entity_Address__c= enAdd.Id;
        enCon.Email_Address__c = cs.Created_By_MDIRO__c;
        enContacts.add(enCon);
        
        Entity_Contact__c enCon2 = new Entity_Contact__c();
        enCon2.name = 'test';
        enCon2.Contact_Person_First_Name__c='test';
        enCon2.Contact_Person_Last_Name__c = 'user';
        enCon2.Entity__c= en2.Id;
        enCon2.Email_Address__c = 'a.a@g.co';
        enCon2.Entity_Address__c= enAdd2.Id;
        enCon2.Email_Address__c = cs.Created_By_MDIRO__c;
        enContacts.add(enCon2);
        
        Entity_Contact__c enCon3 = new Entity_Contact__c();
        enCon3.name = 'test';
        enCon3.Email_Address__c = 'a.a@g.co';
        enCon3.Contact_Person_First_Name__c='test';
        enCon3.Contact_Person_Last_Name__c = 'user';
        enCon3.Entity__c= en3.Id;
        enCon3.Entity_Address__c= enAdd3.Id;
        enCon3.Email_Address__c = cs.Created_By_MDIRO__c;
        enContacts.add(enCon3);
        
        insert enContacts;
        
        List<CaseEntityJunction__c> cejs = new List<CaseEntityJunction__c>();
        CaseEntityJunction__c ce = new CaseEntityJunction__c();
        ce.Is_Send_Billing_To__c = false;
        ce.Case__c = cs.Id;
        ce.Entity__c = en.Id;
        ce.Entity_Address__c = enAdd.Id;
        ce.Entity_Contact__c = enCon.Id;
        ce.Addressee__c = false;
        cejs.add(ce);
        
        CaseEntityJunction__c ce2 = new CaseEntityJunction__c();
        ce2.Is_Send_Billing_To__c = false;
        ce2.Case__c = cs.Id;
        ce2.Entity__c = en2.Id;
        ce2.Entity_Address__c = enAdd2.Id;
        ce2.Entity_Contact__c = enCon2.Id;
        ce2.Addressee__c = false;
        cejs.add(ce2);
        
        CaseEntityJunction__c ce3 = new CaseEntityJunction__c();
        ce3.Is_Send_Billing_To__c = false;
        ce3.Case__c = cs.Id;
        ce3.Entity__c = en3.Id;
        ce3.Entity_Address__c = enAdd3.Id;
        ce3.Entity_Contact__c = enCon3.Id;
        ce3.Addressee__c = false;
        cejs.add(ce3);
        
        CaseEntityJunction__c ce4 = new CaseEntityJunction__c();
        ce4.Is_Send_Billing_To__c = false;
        ce4.Case__c = cs.Id;
        ce4.Entity__c = en2.Id;
        ce4.Entity_Address__c = enAdd2.Id;
        ce4.Entity_Contact__c = enCon2.Id;
        ce4.Addressee__c = false;
        cejs.add(ce4);
        
		CaseEntityJunction__c ce5 = new CaseEntityJunction__c();
        ce5.Is_Send_Billing_To__c = false;
        ce5.Case__c = cs.Id;
        ce5.Entity__c = en3.Id;
        ce5.Entity_Address__c = enAdd3.Id;
        ce5.Entity_Contact__c = enCon3.Id;
        ce5.Addressee__c = false;
        cejs.add(ce5);
		
        insert cejs;
        
        Invoice_Header__c invoice = new Invoice_Header__c();
        //invoice.Entity_Contact__c = entityContact.Id;
        invoice.Entity__c = en.Id;
        invoice.Status__c = 'Unpaid';
        invoice.Invoice_Date__c = Date.Today();
        //invoice.Invoice_Number__c = '123invoicetest';
        Insert invoice;
        
        Invoice_Details__c detailObj = new Invoice_Details__c();
        detailObj.Invoice_Header__c = invoice.Id;
        detailObj.Case__c = cs.Id;
        detailObj.Program_Code__c = 'IR';
        insert detailObj;
        //Invoice_Number__c obj = new Invoice_Number__c(Sequence__c=1);
        //INSERT obj;
    }
    
    @isTest static void testMethods() {
        Test.startTest();
        CaseUtilityScheduler ob = new CaseUtilityScheduler();
       
        ob.execute(null);
       
        Test.stopTest();
    }
}