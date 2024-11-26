public class FERPRequestClaimWrapper {
    @AuraEnabled
    public Integer id {set;get;}
    @AuraEnabled
    public String ClaimName {set;get;}
    @AuraEnabled
    public Date Service_Start_Date {set;get;}
    @AuraEnabled
    public Date Service_End_Date {set;get;}
}