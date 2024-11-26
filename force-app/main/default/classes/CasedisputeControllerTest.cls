@isTest
public with sharing class CasedisputeControllerTest {
    @testSetup static void setup() {
        Account program = new Account();
        program.Name='Pennsylvania Department of Health';
        program.Program_Code__c = 'PA';
        program.Send_Billing_To__c = 'Health Plan';
        program.Billing_Cycle__c = 'Per Case';
        program.Review_Type__c = 'Medical Necessity';
        program.Priority_Type__c = 'Expedited';
        program.Number_of_Days__c = 5;
        program.Contract_Party__c = 'Pennsylvania Department of Health';
        program.Project_State__c = 'PA';
        program.Program_CACTUS_Assignment__c='CA';
        program.CACTUS_Assignment__c='CA';
        insert program;
      
        Case cse = new Case();
        cse.AccountId = program.Id;
        insert cse;
    }

    @isTest
    public static void testing(){
        Case cse = [SELECT Id from Case LIMIT 1];
        CasedisputeController.getCase(cse.Id);
        CasedisputeController.getRequestedSpecialty();
    }

}