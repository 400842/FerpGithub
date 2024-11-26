public class CasedisputeController {

    
     @AuraEnabled
    public static Case getCase(String caseId){
       
        system.debug('caseId'+caseId);
        Case ca = [Select id, Account.Program_Code__c,Account.Link_To_Document_List_Sample__c ,Account.Enable_Document_List__c,Requested_Specialty__c from Case where id =: caseId];
        
        return ca;
    }

    @AuraEnabled(cacheable = true)
    public static List<Board__mdt> getRequestedSpecialty(){
        return [SELECT Id,Board_Value__c FROM Board__mdt WHERE Status__c = 'Active' ORDER BY Board_Value__c ];
    }
    
}