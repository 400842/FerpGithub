public class CaseUtilityBatch implements Database.Batchable<sObject> {
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        return Database.getQueryLocator(
            'select Id,Case__c,Case_IR_Number__c,Decision__c,Entity__r.Entity_Type__c,Program_Code__c,Review_Fee__c, '+
            'Project_Id__c,Entity__c,Entity_Contact__c,Entity_Contact__r.Entity_Address__r.Entity__c '+
            'from Invoice_Details__c '+
            'Where Case__r.Status = \'Completed\' AND Case__r.Invoiced__c = false'
            /*'SELECT ID, Status, Created_By_MDIRO__c, Program_Code__c, Program_Priority__c, Decision_Code__c, Received_Date__c ' +
            'FROM Case ' +
            'Where Status = \'Completed\' AND Invoiced__c = false'*/
        );
    }
    
    public void execute(Database.BatchableContext bc, List<Invoice_Details__c> records){
        // process each batch of records
        CaseTriggerHelper.createInvoiceHeaderRecord(records);
    }
    
    public void finish(Database.BatchableContext bc){
        // execute any post-processing operations
    }
}