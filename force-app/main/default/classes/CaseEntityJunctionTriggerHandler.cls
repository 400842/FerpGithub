public with sharing class CaseEntityJunctionTriggerHandler {
    public static void checkAddressee(List<CaseEntityJunction__c> partEnrollee){ 
        
        Set<Id> allEnrolleCaseIds = new Set<Id>();       
        for (CaseEntityJunction__c allEnrolleeCase : partEnrollee) {
            system.debug ('Address__c'+allEnrolleeCase.Addressee__c);
            if (allEnrolleeCase.Addressee__c) {
                allEnrolleCaseIds.add(allEnrolleeCase.Case__c);
            }
        }
        system.debug('CaseIds'+ allEnrolleCaseIds);       
        List<CaseEntityJunction__c> entitList = [Select Id, Addressee__c, Case__c From CaseEntityJunction__c where Addressee__c = true and Case__c IN :allEnrolleCaseIds];           
        List<Participant__c> enroleeList = [Select Id, Address__c, Case__c From Participant__c where Address__c = true and Case__c IN :allEnrolleCaseIds];  

        system.debug('Size'+ entitList.size());
        system.debug('Size'+ enroleeList.size());

        for (CaseEntityJunction__c allEnrollee : partEnrollee) {
            if (allEnrollee.Addressee__c) {
                if (entitList.size() > 0) {
                    allEnrollee.addError ('Another Entity has been selected as Addressee. Please unselect it before selecting this record.');
                }            
                else if (enroleeList.size() > 0) {
                    allEnrollee.addError ('Another Enrollee has been selected as Addressee. Please unselect it before selecting this record.');
                }
            }
        }

    }

    public static void addSendBillingTo(List<CaseEntityJunction__c> partEntity){
        for (CaseEntityJunction__c allpartEntity : partEntity) {
                allpartEntity.Is_Send_Billing_To__c = allpartEntity.Send_Billing_To__c;
        }
    }

    public static void updatecaseaddressee(List<CaseEntityJunction__c> CaseEntity){ 
        try {
            String Address1;
            for (CaseEntityJunction__c co : CaseEntity){
                Case po = [SELECT Id, Document_Address__c,Document_Addressee__c  FROM Case WHERE Id = :co.Case__c];
                
                List<CaseEntityJunction__c> l_co = [SELECT Id,Contact_Name__c,Entity__c,Entity_Name__c,Addressee__c,Entity_Address_f__c,Entity_Address__r.Address_1__c, 
                Entity_Address__r.Address_2__c,Entity_Address__r.City__c,Entity_Address__r.State__c,Entity_Address__r.Zip__c FROM CaseEntityJunction__c WHERE Case__c = :po.Id AND Addressee__c = true];
                for(CaseEntityJunction__c am_co : l_co) {
                    if (l_co[0].Entity_Address__r.Address_2__c != null) 
                        Address1 = l_co[0].Contact_Name__c + '\n' + l_co[0].Entity_Address__r.Address_1__c + '\n' + l_co[0].Entity_Address__r.Address_2__c + '\n' + l_co[0].Entity_Address__r.City__c + ', ' + l_co[0].Entity_Address__r.State__c + ' ' + l_co[0].Entity_Address__r.Zip__c;                        
                    else                        
                        Address1 = l_co[0].Contact_Name__c + '\n' + l_co[0].Entity_Address__r.Address_1__c + '\n' + l_co[0].Entity_Address__r.City__c + ', ' + l_co[0].Entity_Address__r.State__c + ' ' + l_co[0].Entity_Address__r.Zip__c;                        
                }               
                po.Document_Address__c = Address1;
                po.Document_Addressee__c = l_co[0].Contact_Name__c;
                update po;
            }
        } catch (Exception e) {
            System.debug(e);
        }
    }
    
    public static void MDIROCaseSubmissionNotification(List<CaseEntityJunction__c> CaseEntity){
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        for(CaseEntityJunction__c cEn: [select Id,Case__r.Program_Code__c,Entity_Contact__r.Email_Address__c,Case__r.Created_By_MDIRO__c,
                                       Entity_Contact__r.Contact_Person_First_Name__c,Entity_Contact__r.Contact_Person_Last_Name__c,Entity_Contact__r.Suffix__c,
                                       Case__r.Received_Date__c,Case__r.Document_Case_Number__c,Case__r.Case_Number_f__c from CaseEntityJunction__c where Id IN : CaseEntity ]){
            if(cEn.Case__r.Program_Code__c == 'IR' && cEn.Entity_Contact__r.Email_Address__c == cEn.Case__r.Created_By_MDIRO__c){
               String converted = cEn.Case__r.Received_Date__c.format('MM/dd/yyyy HH:mm a', 'America/New_York');
                system.debug('===== converted ==== '+converted);
                String suffix;
                if(cEn.Entity_Contact__r.Suffix__c != null){
                    suffix = cEn.Entity_Contact__r.Suffix__c;
                }else{
                    suffix = '';
                }
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                List<String> toAddress = new List<String> ();
                toAddress.add(cEn.Entity_Contact__r.Email_Address__c);
                message.setToAddresses(toAddress);
                String body = '<html>Dear '+cEn.Entity_Contact__r.Contact_Person_First_Name__c+' '+cEn.Entity_Contact__r.Contact_Person_Last_Name__c+' '+suffix+','+
                    '<br/>'+
                    '<br/>'+
                    'Thank you for submitting your case for review on the MD IRO Portal. We received your request on '+converted+' ET and created case number '+cEn.Case__r.Document_Case_Number__c+' per your submission.'+
                    '<br/>'+
                    '<br/>'+
                    'You may view the status of this case at any time, by logging into your portal account.'+
                    '<br/>'+
                    '<br/>'+
                    'Please <a href = "https://mdiro.maximus.com">click here</a> to access the MD IRO Portal.'+
                    '<br/>'+
                    '<br/>'+
                    '<b>Note: Maximus will notify you if there was an issue with your document(s) submission in a separate email.</b>'+
                    '<br/>'+
                    '<br/>'+
                    'Thank you,'+
                    '<br/>'+
                    'MD IRO Staff'+
                    '<br/>'+
                    'MAXIMUS Federal Services</html>';
                message.setHtmlBody(body);
                message.setSubject('Request for Case Review – Submission Confirmation');
                mails.add(message);
            }
        }
        Messaging.SendEmailResult[] result = Messaging.sendEmail(mails);
        System.debug('result0'+result);
    }
}