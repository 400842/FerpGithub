public without sharing class ChechkCasecontroller {
    public class caseWrapper{
        @AuraEnabled public String caseId;
        @AuraEnabled public String status;
        @AuraEnabled public String caseLongId;
        @AuraEnabled public Boolean caseFound;
        @AuraEnabled public Boolean eligibleForFileUpload;
        @AuraEnabled public Date assignedToReviewerDate;
        @AuraEnabled public Date createdDate;
        @AuraEnabled public Date eligibleForReviewDate;
        @AuraEnabled public Date expectedDecisionDate;
    }
    @AuraEnabled
    public static caseWrapper searchCaseId(String caseNumber, String email){
        caseWrapper caseWrap = new caseWrapper();
        caseNumber = '%'+caseNumber+'%';
        List<Case> cases= new List<Case>();
        cases = [SELECT Id, CaseNumber,createdDate, Case_Number_f__c,Status,Assigned_to_Reviewer_Date__c, Eligible_for_Review_Date__c, Expected_Decision_Date__c    
                 ,(SELECT Id FROM RFI_Logs__r WHERE Status__c = 'Open' )
                 FROM Case WHERE Case_Number_f__c  
                 like : caseNumber 
                 AND Requestor_Email__c =: email 
                 LIMIT 1
                ];
        caseWrap.caseFound = cases.size() >0;
        if( cases.size() >0){
            date createdDate = date.newinstance(cases[0].createddate.year(), cases[0].createddate.month(), cases[0].createddate.day());
            caseWrap.eligibleForFileUpload = cases[0].Assigned_to_Reviewer_Date__c ==null  && createdDate.daysBetween(system.today()) <=10;
            caseWrap.caseId = cases[0].Case_Number_f__c.substringBetween('>','<');
            caseWrap.caseLongId = cases[0].Id;
            caseWrap.assignedToReviewerDate = cases[0].Assigned_to_Reviewer_Date__c;
            caseWrap.createdDate = createdDate;
            caseWrap.eligibleForReviewDate = cases[0].Eligible_for_Review_Date__c ;
            caseWrap.expectedDecisionDate = cases[0].Expected_Decision_Date__c ;
            caseWrap.status = getStatusMapping().get(cases[0].status);
            //override eligibleForFileUpload
            if(cases[0].RFI_Logs__r.size()!=0){
                caseWrap.eligibleForFileUpload = true;
            }
        }
        system.debug('caseWrap=>'+JSON.serializePretty(caseWrap));
        return caseWrap;
    }
    @AuraEnabled
    public static Map<String, String> getStatusMapping(){
        Map<String, String> statusMap = new Map<String, String>();
        statusMap.put('Draft','Submitted');
        statusMap.put('Initiated','Submitted');
        statusMap.put('Preliminary Review','Submitted' );
        statusMap.put('Case Preparation','In Review');
        statusMap.put('Panel Review','In Review');
        statusMap.put('Drafting Decision','In Review');
        statusMap.put('QC','In Review');
        statusMap.put('Ready to be Closed','In Review');
        statusMap.put('Completed','Completed');
         statusMap.put('Closed','Closed');
        
        return statusMap;
    }
    @AuraEnabled
    public static void createAttachment(String fileName, String externalId, String recordId){
        //CaseAttachment__c att = new CaseAttachment__c();
        //att.Case_Attachment__c = recordId;
        //att.External_ID__c = externalId;
        //att.Attachment_Name__c = fileName;
        //insert att;
        CreateFerpCaseController.createMaxAttachment(fileName, externalId, recordId);
    }
}