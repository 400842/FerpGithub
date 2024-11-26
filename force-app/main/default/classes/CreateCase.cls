public class CreateCase {
    @AuraEnabled
    public static String getCaseRecordTypeID() {
        String CaseRTID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('FERP').getRecordTypeId();
        return CaseRTID;
    } 
    @AuraEnabled
    public static list <Account> getAccount(String AccountId) {
        try{
            If(!String.isBlank(AccountId)){            
                List <Account> accountLIst = [select id, name, Priority_Type__c, Review_Type__c,Number_of_Days__c, (select id,Fee_Amount__c,Fee_Effective_To__c from Fees__r where Fee_Effective_To__c >= TODAY order by Fee_Effective_To__c desc limit 1 ) from account where id =:AccountId];
                system.debug('accountLIst' + accountLIst);   
                return accountLIst;
            }
        }
        catch(Exception ex){
            system.debug('Exception in CreateCase.getAccount ' + ex);
        }
        
        return null;
        
    }
    @AuraEnabled
    public static list <Program_Review_Type__c> getReviewType(String AccountId) {
        If(!String.isBlank(AccountId)){            
            List <Program_Review_Type__c> reviewLIst = [select id, name from Program_Review_Type__c where Program_Name__c =:AccountId and RecordType.Name = 'Review Type'];
            system.debug('reviewLIst' + reviewLIst);   
            return reviewLIst;
        }
        return null;
    } 
    
    @AuraEnabled
    public static list <Program_Review_Type__c> getAppealType(String AccountId) {
        system.debug('appealtypeaccntid' + AccountId);  
        If(!String.isBlank(AccountId)){            
            List <Program_Review_Type__c> atypeLIst = [select id, name from Program_Review_Type__c where Program_Name__c =:AccountId and Type__c = 'Appeal Type'];
            system.debug('appealtype' + atypeLIst);   
            return atypeLIst;
        }
        return null;
    }
    
    @AuraEnabled
    public static list <Program_Review_Type__c> getAppealCategory(String AccountId) {
        system.debug('appealCataccntid' + AccountId);   
        If(!String.isBlank(AccountId)){            
            List <Program_Review_Type__c> aCatLIst = [select id, name from Program_Review_Type__c where Program_Name__c =:AccountId and Type__c = 'Appeal Category'];
            system.debug('appealCategory' + aCatLIst);   
            return aCatLIst;
        }
        return null;
    }
    
    @AuraEnabled
    public static list <Program_Priority__c> getPriorityType(String ReviewTypeId) {
        If(!String.isBlank(ReviewTypeId)){    
            //string recordtypename = Schema.SObjectType.Opportunity.getRecordTypeInfosById().get(ReviewTypeId).getname();       
            List <Program_Priority__c> priorityLIst = [select id, name,Number_of_Days__c,RecordTypeId from Program_Priority__c where Program_Review_Type__c =: ReviewTypeId and RecordType.Name = 'Priority Type'];
            system.debug('priorityLIst' + priorityLIst);   
            return priorityLIst;
        }
        return null;
    }  
    @AuraEnabled
    public static list <Fee__c> getBillingFeeAmount(String PriorityId) {
        If(!String.isBlank(PriorityId)){            
            List <Fee__c> feeLIst = [select id,Fee_Amount__c,Fee_Effective_To__c,Unit__c from Fee__c where Program_Priority__c =: PriorityId and Fee_Effective_To__c >= TODAY and Fee_Type__c = 'Billing Fee' order by Fee_Effective_To__c desc limit 1];
            system.debug('feeLIst' + feeLIst);   
            return feeLIst;
        }
        return null;
    }    
    @AuraEnabled
    public static list <Fee__c> getReviewFeeAmount(String PriorityId) {
        If(!String.isBlank(PriorityId)){            
            List <Fee__c> rfeeLIst = [select id,Fee_Amount__c,Fee_Effective_To__c,Unit__c from Fee__c where Program_Priority__c =: PriorityId and Fee_Effective_To__c >= TODAY and Fee_Type__c = 'Physician Fee' order by Fee_Effective_To__c desc limit 1];
            system.debug('rfeeLIst' + rfeeLIst);   
            return rfeeLIst;
        }
        return null;
    }     
    
   /* @AuraEnabled
    public static list <object> checkAttestation(String CaseId) {
        system.debug('Case Id '+CaseId);
        If(!String.isBlank(CaseId)){                      
            List <Case_Attestation__c> attestExist = [select id,Name from Case_Attestation__c where Case__c  =: CaseId and CreatedById =: UserInfo.getUserId()];
            system.debug('rfeeLIst' + attestExist);   
            return attestExist;
        }
        return null;
    }  */
    
    @AuraEnabled
    public static list <RFI_Log__c> checkOpenRFI(String CaseId) {
        system.debug('Case Id '+CaseId);
        If(!String.isBlank(CaseId)){                      
            //Date dueDate = Date.today();
            Date dueDate = System.Today();
            system.debug('dueDate '+dueDate);
            List <RFI_Log__c> RFIExist = [select id,Name,Status__c,Case__c,Send_Date__c,Due_Date__c from RFI_Log__c where Case__c  =: CaseId and Due_Date__c= TODAY  and Status__c = 'Open'];
            system.debug('RFIExist' + RFIExist);   
            return RFIExist;
        }
        return null;
    } 
    @AuraEnabled
    public static list <RFI_Log__c> checkOpenPastRFI(String CaseId) {
        system.debug('Case Id '+CaseId);
        If(!String.isBlank(CaseId)){                      
            //Date dueDate = Date.today();
            Date dueDate = System.Today();
            system.debug('dueDate '+dueDate);
            List <RFI_Log__c> RFIPastExist = [select id,Name,Status__c,Case__c,Send_Date__c,Due_Date__c from RFI_Log__c where Case__c  =: CaseId and Due_Date__c < TODAY  and Status__c = 'Open'];
            system.debug('RFIPastExist' + RFIPastExist);   
            return RFIPastExist;
        }
        return null;
    } 
    
    @AuraEnabled
    public static list <Panel_Review__c> checkOpenPanelReview(String CaseId) {
        system.debug('Case Id '+CaseId);
        If(!String.isBlank(CaseId)){                                  
            List <Panel_Review__c> panelReviewExist = [select id,Name,Case__c,Review_Due_Date__c,Date_returned_to_MMS__c  from Panel_Review__c where Case__c =: CaseId and Review_Due_Date__c = Today and Date_returned_to_MMS__c = null
                                                       AND Review_Status__c NOT IN ('Review Accepted', 'Review Rejected', 'Review Cancelled' , 'Review Returned')];
            system.debug('panelReviewExist' + panelReviewExist);   
            return panelReviewExist;
        }
        return null;
    } 
    
    @AuraEnabled
    public static list <Panel_Review__c> checkOpenPastPanelReview(String CaseId) {
        system.debug('Case Id '+CaseId);
        If(!String.isBlank(CaseId)){                                  
            List <Panel_Review__c> panelReviewPastExist = [select id,Name,Case__c,Review_Due_Date__c,Date_returned_to_MMS__c  from Panel_Review__c where Case__c =: CaseId and Review_Due_Date__c < Today and Date_returned_to_MMS__c = null
                                                           AND Review_Status__c NOT IN ('Review Accepted', 'Review Rejected', 'Review Cancelled' , 'Review Returned')];
            system.debug('panelReviewExist' + panelReviewPastExist);   
            return panelReviewPastExist;
        }
        return null;
    } 
    //@AuraEnabled
    /*public static Boolean isProgramAlreadyExists(String accountId) {
       String programCode = [SELECT Id,Program_Code__c FROM Account WHERE Id=:accountId].Program_Code__c;
       return ProgramCheckService.calloutForProgram(String.isNotBlank(programCode) ? programCode : '') ;
    }*/
    @AuraEnabled
    public static Object getBillingInformation(String caseId) {
        if(caseId != null){
            List<CaseEntityJunction__c> participantEntityList =  [SELECT Id,Contact_Name__c,Entity__c,Entity_Name__c  FROM CaseEntityJunction__c WHERE Case__c =: caseId AND Is_Send_Billing_To__c = true];
            
            List<Participant__c> participantEnrolleeList = [SELECT Id,First_Name__c,Middle_Name__c,Last_Name__c,Address_Line_1__c,
                                                            Address_Line_2__c, City__c, State__c,Zip_Code__c,Entity__r.Name
                                                            FROM Participant__c 
                                                            WHERE Case__c =: caseId AND Send_Billing_To__c = true];
            System.debug('participant Entity List'+ participantEntityList.size());
            System.debug('participant Enrollee List'+ participantEnrolleeList.size());
            
            Case caseToUpdate = [SELECT Id,Billing_Enrollee_Contact_Name__c,Billing_Enrollee_Address__c
                                 ,Billing_Entity_Address__c,Billing_Entity_Name__c,Billing_Entity_Contact__c,
                                 Project_Manager_Hours__c,Project_Manager_Hours_Comment__c,Project_Manager_Rate__c,
                                 Project_Manager_Total__c,Senior_Consultant_Hours__c,Senior_Consultant_Hours_Comment__c,
                                 Senior_Consultant_Rate__c,Senior_Consultant_Total__c,Associate_Consultant_Hours__c,
                                 Associate_Consultant_Hours_Comment__c,Associate_Consultant_Rate__c,
                                 Associate_Consultant_Total__c,Medical_Director_Hours__c,Medical_Director_Hours_Comment__c,
                                 Medical_Director_Rate__c,Medical_Director_Total__c,Project_Director_Hours__c,
                                 Project_Director_Hours_Comment__c,Project_Director_Rate__c,Project_Director_Total__c,
                                 Physician_Total__c,Physician_Hours__c,Physician_Hours_Comment__c,Physician_Rate__c,
                                 Nurse_Hours__c,Nurse_Hours_Comment__c,Nurse_Rate__c,Nurse_Total__c,
                                 Attorney_Hours__c,Attorney_Hours_Comment__c,Attorney_Rate__c,Attorney_Total__c,
                                 Others_Hours__c,Others_Hours_Comment__c,Others_Rate__c,Others_Total__c 
                                 FROM Case WHERE Id=: caseId];
            
            try{
                if(participantEnrolleeList != null && participantEnrolleeList.size() == 1 
                   && (participantEntityList == null || (participantEntityList != null && participantEntityList.size() ==0))){
                       //Updating Billing Enrollee fields to Case
                       String enrolleeContactName = participantEnrolleeList[0].Middle_Name__c != null ? participantEnrolleeList[0].First_Name__c + ' ' + participantEnrolleeList[0].Middle_Name__c + ' ' + participantEnrolleeList[0].Last_Name__c : participantEnrolleeList[0].First_Name__c + ' ' + participantEnrolleeList[0].Last_Name__c;
                       
                       String enrolleeAddress = ''; 
                       if(participantEnrolleeList[0].Address_Line_1__c != null){
                           enrolleeAddress = enrolleeAddress + participantEnrolleeList[0].Address_Line_1__c;
                       }
                       if(participantEnrolleeList[0].Address_Line_2__c !=null){
                           enrolleeAddress = enrolleeAddress +' ' +participantEnrolleeList[0].Address_Line_2__c;
                       }
                       if(participantEnrolleeList[0].City__c !=null){
                           enrolleeAddress = enrolleeAddress +' ' +participantEnrolleeList[0].City__c;
                       }
                       if(participantEnrolleeList[0].State__c !=null){
                           enrolleeAddress = enrolleeAddress +' ' +participantEnrolleeList[0].State__c;
                       }
                       if(participantEnrolleeList[0].Zip_Code__c != null){
                           enrolleeAddress = enrolleeAddress +' ' +participantEnrolleeList[0].Zip_Code__c;
                       }
                       
                       // String enrolleeAddress  = participantEnrolleeList[0].Address_Line_1__c+' ' +participantEnrolleeList[0].Address_Line_2__c + ' ' + participantEnrolleeList[0].City__c+' ' + participantEnrolleeList[0].State__c + ' ' + participantEnrolleeList[0].Zip_Code__c;
                       
                       
                       String enrolleeEntityName = participantEnrolleeList[0].Entity__r.Name;
                       if (caseToUpdate != null && (caseToUpdate.Billing_Enrollee_Contact_Name__c != enrolleeContactName 
                                                    || caseToUpdate.Billing_Enrollee_Address__c != enrolleeAddress || 
                                                    caseToUpdate.Billing_Entity_Name__c != enrolleeEntityName) ) {
                                                        caseToUpdate.Billing_Enrollee_Contact_Name__c = enrolleeContactName;
                                                        caseToUpdate.Billing_Enrollee_Address__c = enrolleeAddress;
                                                        caseToUpdate.Billing_Entity_Name__c = enrolleeEntityName;
                                                        
                                                        // Setting Entity to empty
                                                        caseToUpdate.Billing_Entity_Contact__c = null;
                                                        caseToUpdate.Billing_Entity_Address__c = null;
                                                        update caseToUpdate;
                                                        
                                                    }
                       
                   }
                else if(participantEntityList != null && participantEntityList.size() == 1
                        && (participantEnrolleeList == null || (participantEnrolleeList != null && participantEnrolleeList.size() ==0))){
                            system.debug('Inside Entity IF');
                            List<Entity_address__c> entityAddress = [SELECT Id, name,Address_Type__c,Entity__r.Name, (select Id, Name from Entity_Contacts__r ) from Entity_address__c  where Address_Type__c='Billing Address' and  Entity__c =: participantEntityList[0].Entity__c];
                            
                            system.debug('Enitity Address' + entityAddress);
                            if (entityAddress !=null && entityAddress.size() >0 && caseToUpdate != null) {
                                
                                if(entityAddress != null && entityAddress.size()>0){
                                    Map<String, List<Entity_Contact__c>> cmap = new Map<String, List<Entity_Contact__c>>();
                                    for(Entity_address__c ea: entityAddress){
                                        List<Entity_Contact__c> econtacts = new List<Entity_Contact__c>();
                                        econtacts.addAll(ea.Entity_Contacts__r);
                                        cmap.put(ea.Id, econtacts);
                                    }
                                    caseToUpdate.Billing_Entity_Name__c =  entityAddress[0].Entity__r.Name;
                                    
                                    for(Id addressId : cmap.keySet()){
                                        List<Entity_Contact__c> econtacts = cmap.get(addressId);
                                        if(econtacts != null && econtacts.size()>=1 ){
                                            if(caseToUpdate.Billing_Entity_Contact__c == null && caseToUpdate.Billing_Entity_Address__c ==null)
                                                /*  if(caseToUpdate.Billing_Entity_Contact__c != econtacts[0].Id ||
caseToUpdate.Billing_Entity_Address__c != addressId || 
caseToUpdate.Billing_Entity_Name__c != entityAddress[0].Entity__r.Name
)*/{
    caseToUpdate.Billing_Entity_Contact__c = econtacts[0].Id;
    caseToUpdate.Billing_Entity_Address__c = addressId;
    break;
}
                                        }
                                    }
                                    if(caseToUpdate.Billing_Entity_Address__c == null){
                                        caseToUpdate.Billing_Entity_Address__c =  entityAddress[0].Id;
                                    }
                                    
                                }
                                caseToUpdate.Billing_Enrollee_Contact_Name__c = null;
                                caseToUpdate.Billing_Enrollee_Address__c = null;
                                update caseToUpdate; 
                                
                            } 
                            
                        } 
                
            }
            Catch(Exception ex){
                
            }
            if(
                participantEnrolleeList.size() >= 1 
                &&
                participantEntityList.size() >= 1){
                    return 'Billing Info may have multiple Entities or Enrollee, Please Select One';
                }
            else if(
                (participantEntityList != null && participantEntityList.size() == 1 ) 
                || (participantEnrolleeList != null && participantEnrolleeList.size() == 1 )
            ){
                return caseToUpdate;
            }
            else if(
                ((participantEntityList != null && participantEntityList.size() == 0) 
                 && (participantEnrolleeList != null && participantEnrolleeList.size() > 1 ))
                ||
                ((participantEnrolleeList != null && participantEnrolleeList.size() == 0) && 
                 (participantEntityList != null && participantEntityList.size() > 1 ))){
                     return 'Billing Info has multiple Entities and Enrollee';
                 }
            
            else if((participantEntityList != null && participantEntityList.size() == 0 ) && (participantEnrolleeList != null && participantEnrolleeList.size()  == 0 )){
                return 'Billing Info not available';
            }else if((participantEntityList == null) && (participantEnrolleeList == null )){
                return 'Billing Info not available';
            }
        }
        return null;
    }
    
    @AuraEnabled
    public static list<sObject> GetRecentRecords(String ObjectName, String RecordId, List<String> ReturnFields, Integer MaxResults) {
        if(Objectname == 'Entity_Address__c'){
            List<CaseEntityJunction__c> participantEntityList =  [SELECT Id,Contact_Name__c,Entity__c,Entity_Name__c  FROM CaseEntityJunction__c WHERE Case__c =: RecordId AND Is_Send_Billing_To__c = true];
            List<Entity_address__c> entityAddress;
            if(participantEntityList != null && participantEntityList.size()>= 1)
                entityAddress = [SELECT Id, name from Entity_address__c  where Address_Type__c='Billing Address' 
                                 and  Entity__c =: participantEntityList[0].Entity__c];
            return entityAddress;
        }
        if(Objectname == 'Entity_Contact__c'){
            List<Entity_Contact__c> entityContacts = [SELECT Id, Name,Entity_Address__c From Entity_Contact__c where
                                                      Entity_Address__c =: RecordId And Entity_Address__r.Address_Type__c = 'Billing Address' ];
            return entityContacts;
            
        }
        if(Objectname == 'Fee__c'){
            Panel_Review__c panelReview =[select Id, Override__c,Case__c, Case__r.Program_Priority__c, Case__r.Received_Date__c from Panel_Review__c where Id= :RecordId ] ;
            
            if( panelReview!=null && panelReview.Case__r.Program_Priority__c != null){
                List <Fee__c> feeLIst = [select id,Name,Fee_Amount__c,Fee_Effective_To__c,Unit__c,Fee_Type__c from Fee__c where Program_Priority__c =: panelReview.Case__r.Program_Priority__c 
                                         and Fee_Effective_To__c > : date.newInstance(panelReview.Case__r.Received_Date__c.year(),panelReview.Case__r.Received_Date__c.month(),panelReview.Case__r.Received_Date__c.day()) and Fee_Type__c = 'Physician Fee'
                                        ];
                system.debug('feeLIst' + feeLIst);   
                return feeLIst;
            }      
        }
        return null;
    }
    
    @AuraEnabled
    public static List<sObject> GetRecord(String ObjectName, List<String> ReturnFields, String Id) {
        String sQUERY = 'SELECT Id, ';
        
        if (ReturnFields != null && ReturnFields.Size() > 0) {
            sQuery += String.join(ReturnFields, ',');
        } else {
            sQuery += 'Name';   
        }
        
        sQuery += ' FROM ' + ObjectName + ' WHERE Id = :Id';
        
        List<sObject> searchResult = Database.query(sQuery);
        
        return searchResult;
    }
    
    @AuraEnabled
    public static objectDetails getObjectDetails(String ObjectName) {    
        
        objectDetails details = new objectDetails();
        
        Schema.DescribeSObjectResult describeSobjectsResult = Schema.describeSObjects(new List<String>{ObjectName})[0];
        
        details.label = describeSobjectsResult.getLabel();
        details.pluralLabel = describeSobjectsResult.getLabelPlural();
        
        details.iconName = findObjectIcon(ObjectName);
        
        return details;
    }
    
    public class objectDetails {
        @AuraEnabled
        public string iconName;
        @AuraEnabled
        public string label;
        @AuraEnabled
        public string pluralLabel;
    }
    
    @AuraEnabled
    public static string findObjectIcon(String ObjectName) {    
        String u;
        List<Schema.DescribeTabResult> tabDesc = new List<Schema.DescribeTabResult>();
        List<Schema.DescribeIconResult> iconDesc = new List<Schema.DescribeIconResult>();
        
        for(Schema.DescribeTabSetResult describeTabSetResult : Schema.describeTabs()) {
            for(Schema.DescribeTabResult describeTabResult : describeTabSetResult.getTabs()) {
                if(describeTabResult.getSobjectName() == ObjectName) { 
                    if( describeTabResult.isCustom() == true ) {
                        for (Schema.DescribeIconResult describeIcon : describeTabResult.getIcons()) {
                            if (describeIcon.getContentType() == 'image/svg+xml'){
                                return 'custom:' + describeIcon.getUrl().substringBetween('custom/','.svg').substringBefore('_');
                            }
                        }
                    } else {
                        return 'standard:' + ObjectName.toLowerCase();
                    }
                }
            }
        }
        
        return 'standard:default';
    }
    
    @AuraEnabled
    public static list <Fee__c> getALLBillingFeeAmount(String caseId) {
        if(caseId != null){
            Case detail = [select Id,Received_Date__c, Program_Priority__c from Case where Id =: caseId];
            
            if( detail!=null && detail.Program_Priority__c != null ){
                List <Fee__c> feeLIst = [select id,Name,Fee_Amount__c,Fee_Effective_To__c,Unit__c,Fee_Type__c from Fee__c
                                         where Program_Priority__c =: detail.Program_Priority__c and Fee_Effective_To__c >= : date.newInstance(detail.Received_Date__c.year(),detail.Received_Date__c.month(),detail.Received_Date__c.day()) and Fee_Type__c = 'Billing Fee' order by Fee_Effective_To__c ];
                system.debug('feeLIst' + feeLIst);   
                return feeLIst;
            }          
            
        }
        
        return null;
    }
    
    @AuraEnabled
    public static list<Panel_Review__c> getFeeAmount(String panelReviewId) {
        return [select Id, Review_Fee__c,Panel_Payment_Amount__c,Review_Fee_Unit__c, Reviewers_fee__c, Unit__c, Override__c,Override_Reason_Other__c, Reviewer_Number_of_Hours__c, Authorized__c from Panel_Review__c where Id= :panelReviewId];
    }
    
    @AuraEnabled
    public static list<Program_Priority__c>  getRDs(String reviewType) {        
        system.debug('reviewType '+reviewType);
        If(!String.isBlank(reviewType)){                      
            List <Program_Priority__c> rdlist = [select Id, name,Review_Decision__c from Program_Priority__c where Program_Review_Type__c = :reviewType and Record_Type_Name__c= 'Review Decision'];
            system.debug('rdlist' + rdlist);   
            return rdlist;
        }
        return null;
    }
    
    @AuraEnabled
    public static String getDecisions (String caseId){
        List<Panel_Review__c> Dec = [Select Decision_Code__c from Panel_Review__c where Case__c =: caseId and Review_Status__c = 'Review Accepted'];
        List<String> Decis = new List<String> ();
        for (Panel_Review__c pr: Dec){
            Decis.add(pr.Decision_Code__c);
        }
        Map<String,Integer> elCount = new Map<String,Integer>();
        for(String key : Decis)
        {
            if(!elCount.containsKey(key)){
                elCount.put(key,0);
            }
            Integer currentInt=elCount.get(key)+1;
            elCount.put(key,currentInt);
        }
        system.debug('map $$$ ' +elCount);
        List<Integer> counts = elCount.values();
        counts.sort();
        Integer maxCount;
        Integer max = counts[(counts.size()-1)];
        if(counts.size()>1){        
            Integer max1 = counts[(counts.size()-2)];        
            if(max == max1){
                maxCount = -1;
            }else {
                maxCount = max;
            }}else{
                maxCount = max;
            }
        
        String maxVals = '';
        for(String s : elCount.keySet()){
            Integer elCountValue = elCount.get(s);        
            if(elCountValue == maxCount){
                System.debug('Majority Decision is: ' +s+ 'Repeated Count is' +elCountValue);
                maxVals = s;
            }        
        }
        system.debug('highest decisions: ' +maxVals);
        return maxVals;
    }
    @AuraEnabled
    public static String getNotes(String CaseId){
        String s = '';
        system.debug(' caseId in notes:>>> '+CaseId);
        Case ca = [Select Status, Document_Addressee__c from Case where Id =: CaseId];
        if(ca.Status == 'Ready to be Closed' || ca.Status == 'Closed/Completed'){
            s= ca.Document_Addressee__c;
        }
        return s;
    }
    
    
    @AuraEnabled
    public static Case getCase(String c){
        system.debug('c'+c);
        Case ca = [Select Account.Enable_Document_List__c,Account.Introduction_Reference__c,
                   Account.Link_To_Document_List_Sample__c ,Program_Code__c,Was_Panel_Reviewer_an_MD_or_DO__c from Case where id =: c];
        return ca;
    }
    
    @AuraEnabled
    public static void updateQcCaseStatus(String caseId,String QcCheck) {
        Case caseStatusToUpdate = [Select Id,Is_Qc_Status_Dialog__c,Status from case where Id=:caseId ];
        
        if(QcCheck == 'Yes' &&  caseStatusToUpdate.Is_Qc_Status_Dialog__c==false){
            caseStatusToUpdate.Status = 'QC';
            caseStatusToUpdate.Is_Qc_Status_Dialog__c= true;
            
        }else if(QcCheck == 'No'){
            caseStatusToUpdate.Status = 'Drafting Decision'; 
            caseStatusToUpdate.Is_Qc_Status_Dialog__c= false;
        }
        
        update caseStatusToUpdate;
    }
    
    @AuraEnabled
    public static List<Entity__c> getEntities(String types){
        return [select Full_Entity_Name__c from Entity__c where Entity_Type__c =: types];
    }
    @AuraEnabled
    public static List<Entity_Address__c> getAdd(String ent){
        return [select Name, Address_Type__c from Entity_Address__c where Entity__c =: ent];
    }
    @AuraEnabled
    public static List<Entity_Contact__c> getCon(String entAdd){
        return [select Name from Entity_Contact__c where Entity_Address__c =: entAdd];
    }
    @AuraEnabled
    public static List<String> getEntitytypes(){        
        List<String> pickListValuesList= new List<String>();
        Schema.DescribeFieldResult fieldResult = Entity__c.Entity_Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
        }     
        return pickListValuesList;
    }
    public class entDetails {
        @AuraEnabled
        public List<String> pickListValuesList =  new List<String>();
        @AuraEnabled
        public List<Entity__c> en = new List<Entity__c>();
        @AuraEnabled
        public List<Entity_Address__c> eadd =  new List<Entity_Address__c>();
        @AuraEnabled
        public List<Entity_Contact__c> econ =  new List<Entity_Contact__c>();
    }
    @AuraEnabled
    public static entDetails getAllDetails(){        
        //List<String> pickListValuesList= new List<String>();
        entDetails entd = new entDetails();
        Schema.DescribeFieldResult fieldResult = Entity__c.Entity_Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            entd.pickListValuesList.add(pickListVal.getLabel());
        }     
        entd.en = [select Full_Entity_Name__c from Entity__c];
        entd.eadd =[select Name,Address_Type__c from Entity_Address__c];
        entd.econ =[select Name from Entity_Contact__c];
        return entd;
    }
    @AuraEnabled
    public static void savEntity(CaseEntityJunction__c ent){
        insert ent;
    }
    @AuraEnabled
    public static List<CaseEntityJunction__c> getEntData(String ca){
        return [select Id,Name,Entity_Name__c,Entity_Type__c,Entity_Address_f__c,Contact_Name__c from CaseEntityJunction__c where Case__c =: ca];
    }
    @AuraEnabled
    public static CaseEntityJunction__c getEnt(String ent){
        return [Select Id, Entity_Type_Filter__c, Entity__c, Entity_Address__c, Entity_Contact__c, Addressee__c, Is_Send_Billing_To__c,Case__c from CaseEntityJunction__c where id =: ent ];
    }
    @AuraEnabled
    public static void updateEntity(CaseEntityJunction__c ent){
        system.debug('ENTITY>>> ' +ent);
        update ent;
    }
    
     @AuraEnabled(cacheable = true)
    public static List<Assignment__mdt> getCACTUSAssignment(){
        return [SELECT Id,Assignment_value__c FROM Assignment__mdt WHERE Status__c = 'Active' ORDER BY Assignment_value__c ];
    }
    @AuraEnabled
    public static Account getProgramDetails(String accountId) {
       return [ Select Id, Name, Program_CACTUS_Assignment__c from Account WHERE Id=:accountId LIMIT 1];
    }
}