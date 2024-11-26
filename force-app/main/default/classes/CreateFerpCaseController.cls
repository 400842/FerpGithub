public without sharing class CreateFerpCaseController {
    @AuraEnabled
    public static void createAttachment(String fileName, String externalId, String recordId){
        //CaseAttachment__c att = new CaseAttachment__c();
        //att.Case_Attachment__c = recordId;
        //att.External_ID__c = externalId;
        //att.Attachment_Name__c = fileName;
        //insert att;
        //createMaxAttachment(fileName, externalId, recordId);
    }
    @AuraEnabled
    public static void createMaxAttachment(String fileName, String externalId, String recordId){
      //List < MAXAttachments__c > docCreateList = new List < MAXAttachments__c > ();
        //MAXAttachments__c oAttachment = new MAXAttachments__c();
        //oAttachment.Case__c = recordId;
        //oAttachment.Description__c = fileName;
        //oAttachment.Document_Type__c = 'Medical Record';
        //oAttachment.Document_Date__c = system.today();
        //oAttachment.Document_Status__c = 'New';
        //oAttachment.OCR_Complete__c = 'New';
         
        //oAttachment.Share_To_Expert__c = Boolean.valueOf(docShare);
        //oAttachment.Uploaded_By__c = UserInfo.getName();
        //oAttachment.External_ID__c = externalId;
        //oAttachment.Attachment_Name__c = fileName;
        //oAttachment.File_Size__c = String.valueOf(docMap.get('size'));
        //docCreateList.add(oAttachment);
        //insert docCreateList;  
    }
    @AuraEnabled
    public static Case CreateCase (FERPRequestWrapper ferpReqObj, list<FERPRequestClaimWrapper> claimsList){
        String prtype = ferpReqObj.Expedite_Selected ? 'Expedited':'Standard'; // to do
        //system.debug('Expedited' +ferpReqObj.Expedite_Selected);
        
        // add claim to do - done
        //roll back in case of errors 
        //email format in requestor - valid
        //send email after case creation - WF
        //phone 10 chars - enforce in UI should be numeric
        //disable buttons on submission...enable if any errors
        //file upload - check status page
        //status on sf table is to portal status - mapping to do
        Savepoint sp = Database.setSavepoint(); 
        Case currentCase; 
        try{       
            List<Participant__c> lstParticipant = new List<Participant__c>();
            Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Default').getRecordTypeId();
            if(String.isNotBlank(ferpReqObj.Reason_for_Review) &&
              ferpReqObj.Reason_for_Review =='Other'){
            // caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Arbitration').getRecordTypeId();
            }
            //populate Program, Review type and Priority
            Id programId = [SELECT ID,NAME FROM ACCOUNT WHERE NAME = 'FERP HHS Federal External Review Process' limit 1].Id;
            Id programReviewType = [SELECT Id,Program_Name__c FROM Program_Review_Type__c 
                                    WHERE Program_Name__c=:programId 
                                    AND Recordtype.Name = 'Review Type' AND NAME = 'Coverage' limit 1].Id;
            Id programPriorityType = [SELECT Id, Program__c, Program_Review_Type__c FROM Program_Priority__c
                                      WHERE //Program__c =:programId
                                      Program_Review_Type__c=:programReviewType
                                      AND NAME = 'Standard'
                                      AND Recordtype.Name= 'Priority Type' limit 1].Id;
            
            // transform picklist values        
            //create Case
            //Set default record type
            //set orgin - Web
            Case ca = new Case(recordTypeId=caseRecordTypeId, Origin='Web');
            ca.AccountId = programId;
            ca.Program_Review_Type__c = programReviewType;
            list<Program_Priority__c> pp=[select id from Program_Priority__c where name=:prtype and Program_Review_Type__c=: programReviewType limit 1];
            if(pp!=null && !pp.isEmpty())ca.Program_Priority__c = pp[0].id;
            ca.Reason_for_Review__c = ferpReqObj.Reason_for_Review;
            ca.Provider_ferp__c = ferpReqObj.Provider_ferp; //SS
            ca.Expedite_Reason__c = ferpReqObj.Expedite_Reason;
            ca.Dispute_Narrative__c = ferpReqObj.Denial_Reason;
            ca.Dispute_Details__c = ferpReqObj.Denial_Disagreement_Reason;
            ca.Requestor_Email__c = ferpReqObj.Requestor_Email;
            ca.Requestor_Name__c = ferpReqObj.Requestor_First_Name +' '+ ferpReqObj.Requestor_Last_Name;
            ca.Status = 'Preliminary Review';
            ca.Final_Denial_Date__c=Date.valueOf(ferpReqObj.Final_Denial_Date);
            //ca.Final_Denial_Date__c=Date.valueOf(ferpReqObj.Final_Denial_Date);
            ca.received_date__c = System.now(); //B-08284 Fixed Date difference
            insert ca;
            
            createClaimants(claimsList, ca.Id);//to do
            //create Participant
            Id participantRecordTypeId = Schema.SObjectType.Participant__c.getRecordTypeInfosByDeveloperName().get('Enrollee_Contact').getRecordTypeId();
            // create requestor
            lstParticipant.add(createRequestor(ferpReqObj, ca.Id));
            //create Claimant 
            lstParticipant.add(createClaimant(ferpReqObj, ca.Id));
            //create Subscriber   
            lstParticipant.add(createSubScriber(ferpReqObj, ca.Id));
            //create Provider 
           // lstParticipant.add(createProvider(ferpReqObj, ca.Id));
            insert lstParticipant;
            //Create Entity
            ///choosen from popup do not create entity and entity addres...only entity junction
            Entity__c entity = createEntity(ferpReqObj);
            //create Entity Address
            Entity_Address__c entAddress = createEntityAddress(ferpReqObj, entity.Id);
            //create Case Entity
            CaseEntityJunction__c caseEntity = createEntityJunction(ferpReqObj, ca.Id,entity.Id,entAddress.Id  );
            CaseParticipant__c caseParticipant = new CaseParticipant__c();
            currentCase = [SELECT Id,Case_Number_f__c FROM Case WHERE Id =:ca.id];
            //return currentCase.Case_Number_f__c.substringBetween('>','<');
            return currentCase;
        }catch( Exception ex){
            //system.debug('===here=='+ex); system.debug('===here=='+ex.getlinenumber());
            Database.rollback(sp); 
        }
        return currentCase;
    } 
    @AuraEnabled
    public static CaseEntityJunction__c createEntityJunction(
        FERPRequestWrapper ferpReqObj,String caseId, String entityId, String entityAddressId
    ){
        CaseEntityJunction__c caseEntity = new CaseEntityJunction__c();
        caseEntity.Case__c = caseId;
        caseEntity.Entity__c = entityId;
        caseEntity.Entity_Address__c = entityAddressId;
        //entAddress.country = ferpReqObj.;
        //entAddress.phone = ferpReqObj.Health_Plan_Phone;
        //entAddress.fax = ferpReqObj.Health_Plan_Fax;
        insert caseEntity;
        return caseEntity;
    }
    @AuraEnabled
    public static Entity_Address__c createEntityAddress(
        FERPRequestWrapper ferpReqObj, String entityId
    ){ //if id is there do  nothing
        //if id is not there then insert
        if( String.isNotBlank(ferpReqObj.Health_Plan_Entity_AddressId)){
            return [SELECT Id FROM Entity_Address__c WHERE Id=:ferpReqObj.Health_Plan_Entity_AddressId];
        }else{
            List<Entity_Address__c> entityAddress = [Select id from Entity_Address__c where Entity__c =:entityId and Address_1__c=:ferpReqObj.Health_Plan_Street AND 
                                                     Address_2__c=:ferpReqObj.Health_Plan_Apt AND City__c=:ferpReqObj.Health_Plan_City AND 
                                                     state__c=:ferpReqObj.Health_Plan_State AND zip__c=:ferpReqObj.Health_Plan_Zip];
            if(entityAddress.size() >0){
                return entityAddress[0];
            } 
        }
        Entity_Address__c entAddress = new Entity_Address__c(Entity__c=entityId);
        entAddress.Address_1__c = ferpReqObj.Health_Plan_Street;
        entAddress.Address_2__c = ferpReqObj.Health_Plan_Apt;
        entAddress.City__c = ferpReqObj.Health_Plan_City;
        entAddress.State__c = ferpReqObj.Health_Plan_State;
        entAddress.Zip__c = ferpReqObj.Health_Plan_Zip;
        //entAddress.country = ferpReqObj.;
        entAddress.Phone__c = ferpReqObj.Health_Plan_Phone;
        entAddress.Fax__c = ferpReqObj.Health_Plan_Fax;
        insert entAddress; // upsert?
        return entAddress;
    }
    
    
    @AuraEnabled
    public static Entity__c createEntity(
        FERPRequestWrapper ferpReqObj
    ){
        if(String.isNotBlank(ferpReqObj.Health_Plan_Entity_Id)){
            return [SELECT Id FROM Entity__c WHERE Id=:ferpReqObj.Health_Plan_Entity_Id];
        }else if(String.isNotBlank(ferpReqObj.Health_Plan)){
            List<Entity__c> entitylist = [Select id,Name,Primary_Name__c from Entity__c where Name=:ferpReqObj.Health_Plan AND Primary_Name__c = : ferpReqObj.Health_Plan];
            List<Entity_Address__c> entityAddress = [Select id from Entity_Address__c where Address_1__c=:ferpReqObj.Health_Plan_Street AND 
                                                     Address_2__c=:ferpReqObj.Health_Plan_Apt AND City__c=:ferpReqObj.Health_Plan_City AND 
                                                     state__c=:ferpReqObj.Health_Plan_State AND zip__c=:ferpReqObj.Health_Plan_Zip];
            if(entitylist.size() > 0 && entityAddress.size() >0){
                return entitylist[0];
            } 
        }
        Entity__c entity = new Entity__c();
        entity.Entity_Type__c = 'Health Plan';
        entity.Name = ferpReqObj.Health_Plan;
        entity.Primary_Name__c = ferpReqObj.Health_Plan;
        entity.Full_Entity_Name__c =ferpReqObj.Health_Plan;
        entity.Project_Id__c = 'FP';
        insert entity;
        return entity;
    }
    @AuraEnabled
    public static void createClaimants(
        List<FERPRequestClaimWrapper> claimsList,
        String caseId
    ){
        list<Claim__c> insertClaimList = new list<Claim__c>();
        for(FERPRequestClaimWrapper clm: claimsList){
            Claim__c claim = new Claim__c();
            claim.Name = clm.ClaimName;
            claim.Service_Start_Date__c = clm.Service_Start_Date;
            claim.Service_End_Date__c = clm.Service_End_Date;
            claim.Case__c = caseId;
            insertClaimList.add(claim);
        }
        if(insertClaimList.size() >0){
            insert insertClaimList; 
        }
    }
    
   /* @AuraEnabled
    public static Participant__c createProvider
        (
            FERPRequestWrapper ferpReqObj,
            String caseId
        )
    {
        Participant__c provider = new Participant__c();
        provider.Case__c = caseId;
        provider.Participant_Enrollee_Type__c = 'Provider'; 
        provider.Provider_Name__c = ferpReqObj.Provider_ferp; 
        return provider;
    } */
    
    @AuraEnabled
    public static Participant__c createRequestor
        (
            FERPRequestWrapper ferpReqObj,
            String caseId
        )
    {
        Participant__c requestor = new Participant__c();
        requestor.Case__c = caseId;
        requestor.Participant_Enrollee_Type__c = 'Requestor';
        requestor.First_Name__c = ferpReqObj.Requestor_First_Name;
        requestor.Last_Name__c = ferpReqObj.Requestor_Last_Name;
        requestor.Middle_Name__c = ferpReqObj.Requestor_Middle_Name;
        requestor.Address_Line_1__c = ferpReqObj.Requestor_Street;
        requestor.Address_Line_2__c = ferpReqObj.Requestor_Apt;
        requestor.City__c = ferpReqObj.Requestor_City;
        requestor.State__c = ferpReqObj.Requestor_State;
        requestor.Zip_Code__c = ferpReqObj.Requestor_Zip;
        requestor.County__c = ferpReqObj.Requestor_County;
        requestor.Email__c = ferpReqObj.Requestor_Email;
        requestor.Land_Phone__c = ferpReqObj.Requestor_Phone;
        requestor.Fax__c = ferpReqObj.Requestor_Fax;
        return requestor;
    }
    @AuraEnabled
    public static Participant__c createClaimant
        (
            FERPRequestWrapper ferpReqObj,
            String caseId
        )
    {
        Participant__c claimant = new Participant__c();
        claimant.Case__c = caseId;
        claimant.Participant_Enrollee_Type__c = 'Claimant';
        claimant.First_Name__c = ferpReqObj.Claimant_First_Name;
        claimant.Last_Name__c = ferpReqObj.Claimant_Last_Name;
        claimant.Middle_Name__c = ferpReqObj.Claimant_Middle_Name;
        claimant.Address_Line_1__c = ferpReqObj.Claimant_Street;
        claimant.Address_Line_2__c = ferpReqObj.Claimant_Apt;
        claimant.City__c = ferpReqObj.Claimant_City;
        claimant.State__c = ferpReqObj.Claimant_State;
        claimant.Zip_Code__c = ferpReqObj.Claimant_Zip;
        claimant.County__c = ferpReqObj.Claimant_County; 
        claimant.Email__c = ferpReqObj.Claimant_Email;
        claimant.Land_Phone__c = ferpReqObj.Claimant_Phone;
        claimant.Fax__c = ferpReqObj.Claimant_Fax;
        claimant.Age__c = Decimal.valueOf(ferpReqObj.Age);
        return claimant;  
    }
    @AuraEnabled
    public static Participant__c createSubScriber
        (
            FERPRequestWrapper ferpReqObj,
            String caseId
        )
    {
        Participant__c subscriber  = new Participant__c();
        subscriber.Case__c = caseId;
        subscriber.Participant_Enrollee_Type__c = 'Subscriber';
        subscriber.First_Name__c = ferpReqObj.Policy_First_Name;
        subscriber.Last_Name__c = ferpReqObj.Policy_Holder_Last_Name;
        subscriber.Middle_Name__c = ferpReqObj.Policy_Holder_Middle_Name;
        subscriber.Address_Line_1__c = ferpReqObj.Policy_Holder_Street;
        subscriber.Address_Line_2__c = ferpReqObj.Policy_Holder_Apt;
        subscriber.City__c = ferpReqObj.Policy_Holder_City;
        subscriber.State__c = ferpReqObj.Policy_Holder_State;
        subscriber.Zip_Code__c = ferpReqObj.Policy_Holder_Zip;
        subscriber.County__c = ferpReqObj.Policy_Holder_County; 
        subscriber.Email__c = ferpReqObj.Policy_Holder_Email;
        subscriber.Land_Phone__c = ferpReqObj.Policy_Holder_Phone;
        subscriber.Fax__c = ferpReqObj.Policy_Holder_Fax;
        subscriber.Insurance_ID__c = ferpReqObj.Policy_Holder_Insurance_ID;
        return subscriber;
    }
    @AuraEnabled
    public static List<String> getStatePicklist(){
        List<String> lstStateVal = new List<String>();
        try {
            Schema.DescribeFieldResult stateField = Participant__c.State__c.getDescribe();
            List<Schema.PicklistEntry> statePickList = stateField.getPicklistValues();
            for(Schema.PicklistEntry pk:statePickList){
                lstStateVal.add(pk.getValue());
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return lstStateVal;
    }
    
    @AuraEnabled
    public static List<Entity_Address__c> fetchEntities(){
        return [select Id,Entity__c,Entity__r.Name,Name,Address_1__c, Address_2__c, City__c, State__c,Zip__c from Entity_Address__c];
    }
}