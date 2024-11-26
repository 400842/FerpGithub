trigger CaseTrigger on Case (after insert, after update, after delete, before insert, before update) {
    if (Trigger.isBefore) {
        if (Trigger.isUpdate) {
            CaseTriggerHelper.updateFeeAmount(Trigger.New, Trigger.oldMap);
            CaseTriggerHelper.updateProgramReferenceData(Trigger.New);
            CaseTriggerHelper.updateDocumentAddress(Trigger.New);

        }
        if (Trigger.isInsert) {
            CaseTriggerHelper.updateProgramReferenceData(Trigger.New);
            CaseTriggerHelper.updateDocumentAddress(Trigger.New);
            CaseTriggerHelper.updateCaseSequenceNumber(Trigger.New);
        }
    }
    if (Trigger.isAfter) {
        if (Trigger.isUpdate) {
             CaseTriggerHelper.createInvoiceDetailRecord(Trigger.new,Trigger.oldMap);
             //CaseTriggerHelper.MDIROSendEmailNotifications(Trigger.new,Trigger.oldMap); 
        }
    }
    
   /* if (Trigger.isAfter) {
        if (Trigger.isInsert || Trigger.isUpdate) {
            CaseTriggerHelper.updatePanelReviewFields(Trigger.New);
        }
    } */
}