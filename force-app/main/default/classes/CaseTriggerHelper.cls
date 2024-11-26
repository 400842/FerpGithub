public class CaseTriggerHelper {
    public static void updateFeeAmount(
      list<Case> caseNewList, 
      map<ID, case> caseOldMap
    ) {
      list<case> toProcessCaseList = new List<Case>();
      for (case caseRec : caseNewList) {
        if (
          caseOldMap != null &&
          caseRec.Id != null &&
          caseOldMap.get(caseRec.Id) != null &&
          caseRec.Program_Priority__c !=
          caseOldMap.get(caseRec.Id).Program_Priority__c
        ) {
          Id PriorityId = caseRec.Program_Priority__c;
          if (!String.isBlank(PriorityId)) {
            List<Fee__c> feeLIst = [
              SELECT id, Fee_Amount__c, Unit__c
              FROM Fee__c
              WHERE
                Program_Priority__c = :PriorityId
                AND Fee_Effective_To__c >= TODAY
                AND Fee_Type__c = 'Billing Fee'
              ORDER BY Fee_Effective_To__c DESC
              LIMIT 1
            ];
            List<Fee__c> physfeeLIst = [
              SELECT id, Fee_Amount__c, Fee_Effective_To__c, Unit__c
              FROM Fee__c
              WHERE
                Program_Priority__c = :PriorityId
                AND Fee_Effective_To__c >= TODAY
                AND Fee_Type__c = 'Physician Fee'
              ORDER BY Fee_Effective_To__c DESC
              LIMIT 1
            ];
            if (feeLIst.size() > 0) {
              caseRec.Fee_Amount__c = feeLIst[0].Fee_Amount__c;
              caseRec.Billing_Fee_Unit__c = feeLIst[0].Unit__c;
            } else {
              caseRec.Fee_Amount__c = 0.00;
            }
            if (physfeeLIst.size() > 0) {
              caseRec.Review_Fee__c = physfeeLIst[0].Fee_Amount__c;
              caseRec.Review_Fee_Unit__c = physfeeLIst[0].Unit__c;
            } else {
              caseRec.Review_Fee__c = 0.00;
            }
          }
        }
      }
    }

      /*
      * @description updates the case fields with ReferenceData
      * @param cases - List of cases
      */

      public static void updateProgramReferenceData( List<case> cases) {

          List<Id> AccIds= new List<Id>();
          for(Case c: cases){
              AccIds.add(c.AccountId);
          }
          list<Program_Review_Type__c> listReferenceData = [
              SELECT Id, Template_Name__c, RecordType.Name, Program_Name__c
              FROM Program_Review_Type__c
              WHERE Program_Name__c IN :AccIds
          ];

          Map<Id,Program_Review_Type__c> RevTypes = new Map<Id,Program_Review_Type__c>([Select Id, Name from Program_Review_Type__c where Program_Name__c IN :AccIds]);
          Map<Id,Program_Priority__c> Priors = new Map<Id,Program_Priority__c> ([select Id, name from Program_Priority__c where Program_Review_Type__c IN: listReferenceData]);

          Map<String,Program_Review_Type__c> newMapRefData = new Map<String,Program_Review_Type__c>();
          for (Program_Review_Type__c refData : listReferenceData) {
              if(refData.Program_Name__c != null){
                  if(refData.RecordType.Name == 'Org ID' || refData.RecordType.Name == 'Project ID' || refData.RecordType.Name =='Acct ID' )
                      newMapRefData.put(refData.RecordType.Name+'---'+ refData.Program_Name__c, refData);
                  else if(refData.RecordType.Name =='Document Template' && refData.Template_Name__c != null)
                      newMapRefData.put(refData.RecordType.Name + '---' + refData.Template_Name__c+'---'+ refData.Program_Name__c, refData);

              }
          }
          for(Case caseRec : cases){
              if(caseRec.Program_Code__c == 'MA'){
                      //begin of MA conditional logic here start date 5/13/2021. Author: Pragnya
                      system.debug('In MA Logic');
                      system.debug('Case Review Type is>> '+RevTypes.get(caseRec.Program_Review_Type__c).Name);
                      if(RevTypes.get(caseRec.Program_Review_Type__c).Name == 'ACO/RBPO'){
                      system.debug('Review Type is ACO/RBPO');
                          caseRec.Decision_Letter_Template__c = newMapRefData.get('Document Template---MA ACO RBPO Decision Letter---'+caseRec.AccountId).Id;
                          caseRec.Reference_Data__c = newMapRefData.get('Document Template---MA ACO RBPO Decision Letter Sample---'+caseRec.AccountId).Id;
                      }else if(RevTypes.get(caseRec.Program_Review_Type__c).Name == 'Infertility Services'){
                          caseRec.Decision_Letter_Template__c = newMapRefData.get('Document Template---MA Infertility Decision Letter---'+caseRec.AccountId).Id;
                          caseRec.Reference_Data__c = newMapRefData.get('Document Template---MA Infertility Decision Letter Sample---'+caseRec.AccountId).Id;
                      }else if(RevTypes.get(caseRec.Program_Review_Type__c).Name == 'Experimental/Investigational - 3 Reviewers'){
                          caseRec.Decision_Letter_Template__c = newMapRefData.get('Document Template---MA Experimental Decision Letter---'+caseRec.AccountId).Id;
                          caseRec.Reference_Data__c = newMapRefData.get('Document Template---MA Experimental Decision Letter Sample---'+caseRec.AccountId).Id;
                      }else if(RevTypes.get(caseRec.Program_Review_Type__c).Name == 'Medical Necessity'){
                          if(Priors.get(caseRec.Program_Priority__c).Name != 'Expedited - Continuation of Coverage'){
                            caseRec.Decision_Letter_Template__c = newMapRefData.get('Document Template---MA Medical Necessity Decision Letter---'+caseRec.AccountId).Id;
                            caseRec.Reference_Data__c = newMapRefData.get('Document Template---MA Medical Necessity Decision Letter Sample---'+caseRec.AccountId).Id;
                          }else{
                             caseRec.Decision_Letter_Template__c = null;
                             caseRec.Reference_Data__c = null;
                          }
                      }
                      //end of MA conditional logic here start date 5/13/2021. Author: Pragnya
              }else if(newMapRefData.containsKey('Document Template---Decision Letter---'+caseRec.AccountId)){
                  if(caseRec.Program_Code__c =='PA' && caseRec.Was_Panel_Reviewer_an_MD_or_DO__c == 'No'){
                      caseRec.Decision_Letter_Template__c = newMapRefData.get('Document Template---PA DOH Decision Letter - MD Template---'+caseRec.AccountId).Id;
                  }else{
                      caseRec.Decision_Letter_Template__c = newMapRefData.get('Document Template---Decision Letter---'+caseRec.AccountId).Id;
                  }
              }
              system.debug('After Execute Final Decision Letter Value>> '+caseRec.Decision_Letter_Template__c);
              if(caseRec.Program_Code__c == 'MA'){
                      //begin of MA conditional logic here start date 5/13/2021. Author: Pragnya
                      if(RevTypes.get(caseRec.Program_Review_Type__c).Name == 'ACO/RBPO'){
                          caseRec.Review_Letter_Template__c = newMapRefData.get('Document Template---MA ACO RBPO Review Form---'+caseRec.AccountId).Id;
                      }else if(RevTypes.get(caseRec.Program_Review_Type__c).Name == 'Infertility Services'){
                          caseRec.Review_Letter_Template__c = newMapRefData.get('Document Template---MA Infertility Review Form---'+caseRec.AccountId).Id;
                      }else if(RevTypes.get(caseRec.Program_Review_Type__c).Name == 'Experimental/Investigational - 3 Reviewers'){
                          caseRec.Review_Letter_Template__c = newMapRefData.get('Document Template---MA Experimental Review Form---'+caseRec.AccountId).Id;
                      }else if(RevTypes.get(caseRec.Program_Review_Type__c).Name == 'Medical Necessity'){
                          if(Priors.get(caseRec.Program_Priority__c).Name != 'Expedited - Continuation of Coverage'){
                            caseRec.Review_Letter_Template__c = newMapRefData.get('Document Template---MA Medical Necessity Review Form---'+caseRec.AccountId).Id;
                          }else{
                              caseRec.Review_Letter_Template__c = null;
                              caseRec.Reference_Data__c = null;
                          }
 
                      }
                      //end of MA conditional logic here start date 5/13/2021. Author: Pragnya
              }else if(newMapRefData.containsKey('Document Template---Review Letter---'+caseRec.AccountId)){
                  if(caseRec.Program_Code__c =='PA' && caseRec.Was_Panel_Reviewer_an_MD_or_DO__c == 'No'){
                      caseRec.Review_Letter_Template__c = newMapRefData.get('Document Template---PA DOH Expert Review Form - MD Template---'+caseRec.AccountId).Id;
                  }else{
                      caseRec.Review_Letter_Template__c = newMapRefData.get('Document Template---Review Letter---'+caseRec.AccountId).Id;
                  }
              }

              if(newMapRefData.containsKey('Document Template---Decision Letter Sample---'+caseRec.AccountId)){
                  if(caseRec.Program_Code__c =='PA' && caseRec.Was_Panel_Reviewer_an_MD_or_DO__c == 'No'){
                      caseRec.Reference_Data__c = newMapRefData.get('Document Template---PA DOH Decision Letter - MD Template  Sample---'+caseRec.AccountId).Id;
                  }else{
                      caseRec.Reference_Data__c = newMapRefData.get('Document Template---Decision Letter Sample---'+caseRec.AccountId).Id;
                  }
              }

              if(newMapRefData.containsKey('Document Template---Notice Letter---'+caseRec.AccountId))
              caseRec.Notice_Template__c = newMapRefData.get('Document Template---Notice Letter---'+caseRec.AccountId).Id;
              if(newMapRefData.containsKey('Document Template---Invoice---'+caseRec.AccountId))
              caseRec.Invoice_Template__c  = newMapRefData.get('Document Template---Invoice---'+caseRec.AccountId).Id;
              if(newMapRefData.containsKey('Org ID---'+caseRec.AccountId))
              caseRec.Program_Org_ID__c = newMapRefData.get('Org ID---'+caseRec.AccountId).Id;
              if(newMapRefData.containsKey('Project ID---'+caseRec.AccountId))
              caseRec.Program_Project_ID__c = newMapRefData.get('Project ID---'+caseRec.AccountId).Id;
              if(newMapRefData.containsKey('Acct ID---'+caseRec.AccountId))
              caseRec.Program_Acct_ID__c = newMapRefData.get('Acct ID---'+caseRec.AccountId).Id;



             //caseRec.Invoice_Status__c =caseRec.Status == 'Closed/Completed' ? caseRec.Invoice_Status__c
          }
      }


      public static void updateDocumentAddress(List<Case> cases){
        String Address1;
        String Address2;

        List<Id> caseIds= new List<Id>();
        for(Case c: cases){
          caseIds.add(c.Id);
        }

        List<CaseEntityJunction__c> participantEntityList =  [SELECT Id,Contact_Name__c,Entity__c,Entity_Name__c,Addressee__c,Entity_Address_f__c,Entity_Address__r.Address_1__c,
        Entity_Address__r.Address_2__c,Entity_Address__r.City__c,Entity_Address__r.State__c,Entity_Address__r.Zip__c FROM CaseEntityJunction__c WHERE Case__c IN :caseIds AND Addressee__c = true];

          List<Participant__c> participantEnrolleeList = [SELECT Id,First_Name__c,Middle_Name__c,Last_Name__c,Address_Line_1__c,
                                                          Address_Line_2__c, City__c, State__c,Zip_Code__c,Entity__r.Name,Address__c,Participant_Enrollee_Type__c,Organization_Name__c
                                                          FROM Participant__c
                                                          WHERE  Case__c IN :caseIds AND Address__c = true];
  system.debug('participantEntityList.size() ' +participantEntityList.size());
  system.debug('participantEnrolleeList.size() ' +participantEnrolleeList.size());

        If(participantEntityList.size() == 0 && participantEnrolleeList.size() == 0){
          for(Case caseupdate: cases){
            if(caseupdate.Document_Address__c != null){
              caseupdate.Document_Address__c = null;
              caseupdate.Document_Addressee__c = null;
              caseupdate.Enrollee_Type__c = null;
            }

          }
        }

        if((participantEnrolleeList !=null && participantEnrolleeList.size() == 1)&&
         ((participantEntityList != null && participantEntityList.size() == 0) || participantEntityList == null ) ){
          String enrolleeContactName = participantEnrolleeList[0].Middle_Name__c != null ? participantEnrolleeList[0].First_Name__c + ' ' + participantEnrolleeList[0].Middle_Name__c + ' ' + participantEnrolleeList[0].Last_Name__c : participantEnrolleeList[0].First_Name__c + ' ' + participantEnrolleeList[0].Last_Name__c;

          String enrolleeAddress = ''; String Addressline1 = ''; String Addressline2 = '';String Addressline3 ='';
          String enrolleeType = ''; String enrolleeOrg = '';
          if(participantEnrolleeList[0].Address_Line_1__c != null){
           enrolleeAddress = enrolleeAddress + participantEnrolleeList[0].Address_Line_1__c;
           Addressline1 = participantEnrolleeList[0].Address_Line_1__c;
          }
          if(participantEnrolleeList[0].Address_Line_2__c !=null){
           //enrolleeAddress = enrolleeAddress + '<br/>' +participantEnrolleeList[0].Address_Line_2__c;
           enrolleeAddress = enrolleeAddress + '\n' +participantEnrolleeList[0].Address_Line_2__c;
           Addressline2 = participantEnrolleeList[0].Address_Line_2__c;
          }
          if(participantEnrolleeList[0].City__c !=null){
           //enrolleeAddress = enrolleeAddress + '<br/>' + participantEnrolleeList[0].City__c;
           enrolleeAddress = enrolleeAddress + '\n' + participantEnrolleeList[0].City__c;
              Addressline3 = participantEnrolleeList[0].City__c;
          }
          if(participantEnrolleeList[0].State__c !=null){
           enrolleeAddress = enrolleeAddress +', ' +participantEnrolleeList[0].State__c;
              Addressline3 = Addressline3 +', ' +participantEnrolleeList[0].State__c;
          }
          if(participantEnrolleeList[0].Zip_Code__c != null){
           enrolleeAddress = enrolleeAddress +' ' +participantEnrolleeList[0].Zip_Code__c;
              Addressline3 = Addressline3 +' ' +participantEnrolleeList[0].Zip_Code__c;
          }
          if(participantEnrolleeList[0].Participant_Enrollee_Type__c != null && participantEnrolleeList[0].Participant_Enrollee_Type__c == 'Representative'){
              enrolleeOrg = participantEnrolleeList[0].Organization_Name__c;           
          }
          if(participantEnrolleeList[0].Participant_Enrollee_Type__c != null){
           enrolleeType = participantEnrolleeList[0].Participant_Enrollee_Type__c;
          }

          for(Case caseToUpdate: cases){
              if (enrolleeOrg != '')
                  //caseToUpdate.Document_Address__c = enrolleeContactName + '<br/>' + enrolleeOrg + '<br/>' + enrolleeAddress;
                  caseToUpdate.Document_Address__c = enrolleeContactName + '\n' + enrolleeOrg + '\n' + enrolleeAddress;
              else
                  //caseToUpdate.Document_Address__c = enrolleeContactName + '<br/>' + enrolleeAddress;
                  caseToUpdate.Document_Address__c = enrolleeContactName + '\n' + enrolleeAddress;
              
            caseToUpdate.Document_Address_line_1__c = Addressline1;
            caseToUpdate.Document_Address_line_2__c = Addressline2;
            caseToUpdate.Document_Address_line_3__c = Addressline3;
            caseToUpdate.Document_Addressee__c = enrolleeContactName;
            caseToUpdate.Enrollee_Type__c = enrolleeType;
          }
        }
      }



       public static void updateCaseSequenceNumber( List<Case> caselst){
          Map<Id, Account> accountMap;
          Set<Id> accountIds = new Set<Id>();
          for(Case cObj: caselst){
              accountIds.add(cObj.AccountId);
          }
             accountMap = new Map<Id, Account>([SELECt Id, Case_Sequence__c From account WHERE Id in : accountIds]);
          for(Case cObj: caselst){
              cObj.FERP_Case_Number__c = cObj.Document_Case_Number__c;
              Integer caseNumber = 0;
              if(cObj.AccountId != null && accountMap.containsKey(cObj.AccountId) && accountMap.get(cObj.AccountId).Case_Sequence__c != null)
                  caseNumber = Integer.valueOf(accountMap.get(cObj.AccountId).Case_Sequence__c);
              else if(cObj.AccountId != null && accountMap.containsKey(cObj.AccountId) && accountMap.get(cObj.AccountId).Case_Sequence__c == null)
                  caseNumber = 0;
              String trailingZero = caseNumber <9 ? '0000' : (caseNumber <99 ? '000' :  (caseNumber <999 ? '00' : (caseNumber <9999 ? '0' : '')));
                  cObj.Case_Sequence__c = String.valueOf(trailingZero + ( caseNumber + 1));
                   System.debug('COBJ: ' + cObj.Case_Sequence__c);
                   if( cObj.AccountId !=null && accountMap.containsKey(cObj.AccountId)){
                    accountMap.get(cObj.AccountId).Case_Sequence__c = cObj.Case_Sequence__c;
                   }


              //System.debug('COBJ: ' + cObj.Account.Case_Sequence__c);
         }

          update accountmap.values();
      }
    
      public static void createInvoiceDetailRecord(List<Case> newRecords, Map<Id,Case> caseMap){
          List<Case> caseList = new List<Case>();
          Set<String> childReferenceDataIds = new Set<String>();
          Set<Id> refDataIds = new Set<Id> ();

          for(Case cs : newRecords){
              System.debug('cs.Status'+cs.Status);
              System.debug('caseMap.get(cs.Id).Status'+caseMap.get(cs.Id).Status);
              System.debug('cs.Program_Priority__c'+cs.Program_Priority__c);
              System.debug('cs.Decision_Code__c'+cs.Decision_Code__c);
              if((caseMap == null ? true : cs.Status != caseMap.get(cs.Id).Status) && cs.Status == 'Completed' && cs.Program_Priority__c != null && cs.Received_Date__c != null && (cs.Decision_Code__c == 'Uphold' || cs.Decision_Code__c == 'Overturn' || cs.Decision_Code__c == 'Partial Overturn')){
                  caseList.add(cs);
                  childReferenceDataIds.add(cs.Program_Priority__c);
                  refDataIds.add(cs.AccountId);
              }
          }
          System.debug(caseList);
          if(caseList.isEmpty()){
              return;//do nothing
          }
          System.debug('childReferenceDataIds'+childReferenceDataIds);
          Map<String,List<Fee__c>> feeMap = new Map<String,List<Fee__c>>();
          Map<String,List<Program_Review_Type__c>> projIdMap = new Map<String,List<Program_Review_Type__c>>();
          //for(Fee__c fee : [SELECT Id,Fee_Amount__c,Fee_Effective_From__c,Fee_Effective_To__c,Program_Priority__c from Fee__c WHERE Program_Priority__c IN :childReferenceDataIds AND Fee_Effective_From__c <=:System.Today() AND Fee_Effective_To__c >= :System.today()]){
          for(Program_Priority__c program : [SELECT Id,(SELECT Id,Fee_Amount__c,Fee_Effective_From__c,Fee_Effective_To__c,Program_Priority__c from Fees__r) from Program_Priority__c WHERE Id IN :childReferenceDataIds ]){
              if(program.Fees__r.size() > 0)
                  feeMap.put(program.Id, program.Fees__r);
          }
          System.debug('feeMap'+feeMap);
          for(Account acc : [select Id, (select Id, Name, Effective_Date_From__c,Effective_Date_To__c from Review_Types__r where Record_Type_Name__c =: 'Project ID' ) from Account where Id IN: refDataIds]){
              if(acc.Review_Types__r.size() >0){
                  projIdMap.put(acc.Id, acc.Review_Types__r);
              }
          }
          //get the entities for the
          Map<Id, List<CaseEntityJunction__c>> entitiesByCaseId = new Map<Id, List<CaseEntityJunction__c>>();

          for(CaseEntityJunction__c cej : [SELECT Id, Case__c, Entity__c, Entity_Contact__c, Entity_Contact__r.Email_Address__c, Entity__r.Entity_Type__c FROM CaseEntityJunction__c WHERE Case__c IN : caseList and (Entity__r.Entity_Type__c = 'Representative' or Entity__r.Entity_Type__c = 'MCO' or Entity__r.Entity_Type__c = 'Provider')]){
              if(entitiesByCaseId.get(cej.Case__c) == null ){
                  entitiesByCaseId.put(cej.Case__c, new List<CaseEntityJunction__c>());
              }
              entitiesByCaseId.get(cej.Case__c).add(cej);
          }
          System.debug(entitiesByCaseId);

          Map<String, Invoice_Details__c> invoiceDetailByEnitynContact = new Map<String, Invoice_Details__c>();
          Set<Id> entityIds = new Set<Id>();
          Set<Id> entityContactIds = new Set<Id>();
          Double feeAmount;
          Double discFee;
          String ProjectId;
          for(Case csObj : caseList){
              if(feeMap.containsKey(csObj.Program_Priority__c)){
                  List<CaseEntityJunction__c> cejs = entitiesByCaseId.get(csObj.Id);
                  cejs = cejs == null ? new List<CaseEntityJunction__c> () : cejs;
                  CaseEntityJunction__c provider=null, mco= null;
                  for(CaseEntityJunction__c cejObj : cejs){
                      //If Case decision code is UPHOLD, provider or representative needs to be billed
                      if(csObj.Decision_Code__c == 'Uphold'
                         && (cejObj.Entity__r.Entity_Type__c == 'Representative' || cejObj.Entity__r.Entity_Type__c == 'Provider')
                         && cejObj.Entity_Contact__r.Email_Address__c.equalsIgnorecase(csObj.Created_By_MDIRO__c.trim())
                        ){
                          provider = cejObj;
                      }

                      //If Case decision code is PARTIALLY OVERTURN, MCO & Provider/Provider Rep needs to be billed
                      if(csObj.Decision_Code__c == 'Partial Overturn'){
                          if((cejObj.Entity__r.Entity_Type__c == 'Representative' || cejObj.Entity__r.Entity_Type__c == 'Provider')
                            && cejObj.Entity_Contact__r.Email_Address__c.equalsIgnorecase(csObj.Created_By_MDIRO__c.trim())){
                              provider = cejObj;
                          }
                          if(cejObj.Entity__r.Entity_Type__c == 'MCO'){
                              mco = cejObj;
                          }
                      }
                      //If Case decision code is OVERTURN, only MCO needs to be billed
                      if(csObj.Decision_Code__c == 'Overturn' && cejObj.Entity__r.Entity_Type__c == 'MCO'){
                          mco = cejObj;
                      }
                  }
                  System.debug(provider);
                  System.debug(mco);
system.debug('==========='+JSON.serializePretty(csObj));
                  for(Fee__c fee : feeMap.get(csObj.Program_Priority__c)){
                      if(csObj.Received_Date__c >= fee.Fee_Effective_From__c && csObj.Received_Date__c <= fee.Fee_Effective_To__c){
                          System.debug(fee);
                          if(csObj.Clock_Start_Date__c != null && csObj.Letter_Sent_Date__c != null){
                              Date clockStart = date.newInstance(csObj.Clock_Start_Date__c.year(), csObj.Clock_Start_Date__c.month(), csObj.Clock_Start_Date__c.day());
                              if(clockStart.daysBetween(csObj.Letter_Sent_Date__c) > 30 && clockStart.daysBetween(csObj.Letter_Sent_Date__c) < 41){
                                  discFee = fee.Fee_Amount__c/10;
                              }else if(clockStart.daysBetween(csObj.Letter_Sent_Date__c) > 40 && clockStart.daysBetween(csObj.Letter_Sent_Date__c) < 51){
                                  discFee = fee.Fee_Amount__c/5;
                              }else if(clockStart.daysBetween(csObj.Letter_Sent_Date__c) > 50 && clockStart.daysBetween(csObj.Letter_Sent_Date__c) < 61){
                                  discFee = (fee.Fee_Amount__c*3)/10;
                              }else if(clockStart.daysBetween(csObj.Letter_Sent_Date__c) > 60){
                                  discFee = fee.Fee_Amount__c/2;
                              }else{
                                  discFee = fee.Fee_Amount__c;
                              }
                              feeAmount = discFee;
                              if(provider != null && mco != null){
                                  feeAmount = feeAmount/2;
                              }
                          }
                      }
                  }
                  for(Program_Review_Type__c revType : projIdMap.get(csObj.AccountId)){
                      if(csObj.Received_Date__c >= revType.Effective_Date_From__c && csObj.Received_Date__c <= revType.Effective_Date_To__c){
                          System.debug(revType);
                          String proj = revType.Name;
                          ProjectId = proj.substring(0, 6);
                      }
                  }

                          if(provider != null){
                              entityIds.add(provider.Entity__c);
                              entityContactIds.add(provider.Entity_Contact__c);
                              Invoice_Details__c invoiceRecord = new Invoice_Details__c();
                              invoiceRecord.Review_Fee__c = feeAmount;
                              //invoiceRecord.Decision__c = csObj.Decision_Code__c;
                              //invoiceRecord.Decision_Date__c = csObj.Case_Decision_Date__c;
                              invoiceRecord.Case__c = csObj.Id;
                              invoiceRecord.Program_Code__c = csObj.Program_Code__c;
                              invoiceRecord.Entity__c = provider.Entity__c;
                              invoiceRecord.Entity_Contact__c = provider.Entity_Contact__c;
                              invoiceRecord.Project_Id__c = ProjectId;
                              invoiceDetailByEnitynContact.put(
                                  String.valueOf(''+provider.Entity__c+provider.Entity_Contact__c), invoiceRecord);
                          }

                          if(mco != null){
                              entityIds.add(mco.Entity__c);
                              entityContactIds.add(mco.Entity_Contact__c);
                              Invoice_Details__c invoiceRecord = new Invoice_Details__c();
                              invoiceRecord.Review_Fee__c = feeAmount;
                              //invoiceRecord.Decision__c = csObj.Decision_Code__c;
                              //invoiceRecord.Decision_Date__c = csObj.Case_Decision_Date__c;
                              invoiceRecord.Case__c = csObj.Id;
                              invoiceRecord.Program_Code__c = csObj.Program_Code__c;
                              invoiceRecord.Entity__c = mco.Entity__c;
                              invoiceRecord.Entity_Contact__c = mco.Entity_Contact__c;
                              invoiceRecord.Project_Id__c = ProjectId;
                              invoiceDetailByEnitynContact.put(
                                  String.valueOf(''+mco.Entity__c+mco.Entity_Contact__c), invoiceRecord);
                          }
                      //}
                  //}
              }
          }
          System.debug('invoiceDetails'+invoiceDetailByEnitynContact);
          if(invoiceDetailByEnitynContact.size() > 0){
              INSERT invoiceDetailByEnitynContact.values();
          }

      }

      public static void createInvoiceHeaderRecord(List<Invoice_Details__c> newRecords){

          Map<String, set<Id>> entityProjectMap = new Map<String, set<Id>>();
          Map<String, set<Id>> contactProjectMap = new Map<String, set<Id>>();
          Map<Id, List<Invoice_Details__c>> totals = new Map<Id, List<Invoice_Details__c>> ();
          List<Invoice_Header__c> headersToCreate = new List<Invoice_Header__c> ();
          List<Invoice_Details__c> updateDetails = new List<Invoice_Details__c> ();
          List<Invoice_Header__c> headersToUpdate = new List<Invoice_Header__c> ();
          List<Case> updateCases = new List<Case> ();
          Set<Id> caseIds = new Set<Id> ();
          //Invoice_Number__c obj = [select Id,Sequence__c from Invoice_Number__c];//Invoice_Number__c.getInstance();
          Integer sequenceNumber=0;
          //sequenceNumber = Integer.valueOf(obj.Sequence__c);
          system.debug('inv  sequence number: '+sequenceNumber);

          for(Invoice_Details__c invDetails: newRecords){
              if(invDetails.Entity__r.Entity_Type__c == 'MCO'){
                  if(entityProjectMap.get(invDetails.Project_Id__c) == null){
                      entityProjectMap.put(invDetails.Project_Id__c, new Set<Id> ());
                      entityProjectMap.get(invDetails.Project_Id__c).add(invDetails.Entity__c);
                  }else{
                      if(!entityProjectMap.get(invDetails.Project_Id__c).contains(invDetails.Entity__c)){
                            entityProjectMap.get(invDetails.Project_Id__c).add(invDetails.Entity__c);
                      }
                  }


              } else if (invDetails.Entity__r.Entity_Type__c == 'Provider' || invDetails.Entity__r.Entity_Type__c == 'Representative'){
                  if(contactProjectMap.get(invDetails.Project_Id__c) == null){
                      contactProjectMap.put(invDetails.Project_Id__c, new Set<Id> ());
                      contactProjectMap.get(invDetails.Project_Id__c).add(invDetails.Entity_Contact__c);
                  }else{
                      if(!contactProjectMap.get(invDetails.Project_Id__c).contains(invDetails.Entity_Contact__c)){
                            contactProjectMap.get(invDetails.Project_Id__c).add(invDetails.Entity_Contact__c);
                      }
                  }

              }
          }

          for(String ProjId : entityProjectMap.keySet()){
              set<Id> enIds = entityProjectMap.get(ProjId);
              if(enIds.size()>0){
                  for(Id entity : enIds){
                      Invoice_Header__c invheader = new Invoice_Header__c ();
                      String invNum;
                      if(!String.isBlank(ProjId)){
                           invNum = ProjId.substring(0, 6);
                      }
                      String invNum2 = String.valueOf(sequenceNumber);
                      //invheader.Invoice_Number__c = invNum +' - '+invNum2;
                      invheader.Entity__c = entity;
                      invheader.Project_Id__c = ProjId;
                      invheader.Invoice_Date__c = system.today();
                      invheader.Status__c = 'Unpaid';

                      sequenceNumber += 1;
                      headersToCreate.add(invheader);
                  }
              }
          }

          for(String ProjId : contactProjectMap.keySet()){
              set<Id> conIds = contactProjectMap.get(ProjId);
              if(conIds.size()>0){
                  for(Id contact : conIds){
                      Invoice_Header__c invheader = new Invoice_Header__c ();
                      String invNum = ProjId.substring(0, 6);
                      String invNum2 = String.valueOf(sequenceNumber);
                      //invheader.Invoice_Number__c = invNum +' - '+invNum2;
                      invheader.Entity_Contact__c = contact;
                      invheader.Entity__c = invheader.Entity_Contact__r.Entity_Address__r.Entity__c;
                      invheader.Project_Id__c = ProjId;
                      invheader.Status__c = 'Unpaid';

                      invheader.Invoice_Date__c = system.today();
                      sequenceNumber += 1;
                      headersToCreate.add(invheader);
                  }
              }
          }

          system.debug('header list before insert>> '+headersToCreate);
          insert headersToCreate;
          system.debug('header list after insert>> '+headersToCreate);
          //obj.sequence__c = sequenceNumber;
          //update obj;

          for(Invoice_Header__c header: headersToCreate){
              totals.put(header.Id, new List<Invoice_Details__c> ());
              for(Invoice_Details__c detail: newRecords){
                  if(detail.Project_Id__c == header.Project_Id__c && (detail.Entity__c == header.Entity__c || detail.Entity_Contact__c == header.Entity_Contact__c)){
                      detail.Invoice_Header__c = header.Id;
                      updateDetails.add(detail);
                      caseIds.add(detail.Case__c);
                      totals.get(header.Id).add(detail);
                  }
              }
          }

          update updateDetails;
          system.debug('Details linked to Header: ' +updateDetails);

          for(Id cId : caseIds){
              case c = new case();
              c.Id = cId;
              c.Invoiced__c = true;
              updateCases.add(c);
          }

          update updateCases;

          for(Id key: totals.keySet()){
              decimal totalAmount= 0;
              Id headerEntity;
              for(Invoice_Details__c invDetail: totals.get(key)){
                 if(invDetail.Review_Fee__c!=null) totalAmount += invDetail.Review_Fee__c;
                  headerEntity = invDetail.Entity__c;
              }
              Invoice_Header__c newHeaderVals = new Invoice_Header__c();
              newHeaderVals.Id = key;
              newHeaderVals.Total_Amount__c = totalAmount;
              newHeaderVals.total_cases__c = totals.get(key).size();
              newHeaderVals.Entity__c = headerEntity;
              //if(newHeaderVals.Entity_Contact__c != null){
               //   newHeaderVals.Entity__c = newHeaderVals.Entity_Contact__r.entity__c;
              //}
              headersToUpdate.add(newHeaderVals);
          }

          system.debug('Final Header List: ' +headersToUpdate);
          update headersToUpdate;


      }
   
    /*public static void MDIROSendEmailNotifications(List<Case> newCases, Map<Id,Case> oldCases){
         Set<Id> MCOCaseFileIds = new  Set<Id>();
         Set<Id> caseDecisionFileIds = new  Set<Id>();
          if(oldCases != null && oldCases.size() >0){
             for(case caseObj : newCases){
                 case oldCase = oldCases != null && oldCases.containsKey(caseObj.id) ? oldCases.get(caseObj.id) : null;
                 if(caseObj.MCO_File_Uploaded__c != null && oldCase.MCO_File_Uploaded__c != caseObj.MCO_File_Uploaded__c){
                     MCOCaseFileIds.add(caseObj.id);
                 }
                 if(caseObj.Decision_Code__c != null && oldCase.Decision_Code__c != caseObj.Decision_Code__c){
                     caseDecisionFileIds.add(caseObj.id);
                 }
             }
         }
        
         List<CaseEntityJunction__c> caseEntityJunctionList = [SELECT Id,Case__c, Entity__r.Email_Address__c, Entity_Contact__c,Entity_Contact__r.Email_Address__c, Entity__r.Entity_Type__c,
                                                Entity_Contact__r.Contact_Person_First_Name__c,  Entity_Contact__r.Contact_Person_Last_Name__c, Entity__c, Entity__r.Name,
                                                Entity_Contact__r.Suffix__c, Case__r.Case_Number_f__c,Case__r.MCO_File_Uploaded__c,Case__r.Document_Case_Number__c	
                                                FROM CaseEntityJunction__c WHERE Case__c IN : MCOCaseFileIds];
         Map<Id,Boolean> isRepresentativeMap = new Map<Id,Boolean>();
         Set<Id> entityIds = new Set<Id>();
         for(CaseEntityJunction__c caseEntity: caseEntityJunctionList){
              entityIds.add(caseEntity.Entity__c);
             if(caseEntity.Entity__r.Entity_Type__c == 'Representative'){
                 isRepresentativeMap.put(caseEntity.Case__c, true);
             }else{
                 isRepresentativeMap.put(caseEntity.Case__c, false);
             }
         }
         Map<Id, List<Entity_Contact__c>> entityContactMap = new Map<Id, List<Entity_Contact__c>>();
        for(Entity_Contact__c entityContact :[SELECT Id, Email_Address__c, Contact_Person_First_Name__c, Contact_Person_Last_Name__c, Entity__c, Entity_Address__c, Suffix__c 
                                              FROM Entity_Contact__c
                                              WHERE Entity__c In : entityIds]){
                                                  if(entityContactMap.containsKey(entityContact.Entity__c)){
                                                      List<Entity_Contact__c> entityContactList = entityContactMap.get(entityContact.Entity__c);
                                                      entityContactList.add(entityContact);
                                                      entityContactMap.put(entityContact.Entity__c, entityContactList);
                                                  }else{
                                                      entityContactMap.put(entityContact.Entity__c, new List<Entity_Contact__c>{entityContact});
                                                  }
                                              }
         List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
         for(CaseEntityJunction__c caseEntity: caseEntityJunctionList){
             if(MCOCaseFileIds.contains(caseEntity.Case__c)){
                 List<String> toAddress = new List<String> ();
                 String converted = caseEntity.Case__r.MCO_File_Uploaded__c.format('MM/dd/yyyy HH:mm a', 'America/New_York');
                 String Suffix;
                 if(caseEntity.Entity_Contact__r.Suffix__c != null){Suffix = caseEntity.Entity_Contact__r.Suffix__c;}else{Suffix = '';}
                 if(caseEntity.Entity__r.Entity_Type__c == 'MCO'){
                     if(entityContactMap.containsKey(caseEntity.Entity__c)){
                         for(Entity_Contact__c entityContact : entityContactMap.get(caseEntity.Entity__c)){
                             String entityName = caseEntity.Entity__r.Email_Address__c != null ? caseEntity.Entity__r.Name : entityContact.Contact_Person_First_Name__c+' '+entityContact.Contact_Person_Last_Name__c+' '+Suffix;
                             Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                             String body = '<html>Dear '+entityName+','+
                                 '<br/>'+
                                 '<br/>'+
                                 'Case File Documentation has successfully been uploaded for the following case '+caseEntity.Case__r.Document_Case_Number__c+' on '+converted+' ET.'+  
                                 '<br/>'+
                                 '<br/>'+
                                 'You may view the details and status of this case at any time by logging on to your portal account.'+
                                 '<br/>'+
                                 '<br/>'+
                                 'Please <a href = "https://mdiro.maximus.com">click here</a> to access the MD IRO Portal.'+
                                 '<br/>'+
                                 '<br/>'+
                                 '<p><b>Note: Maximus will notify you if there was an issue with your document(s) submission in a separate email.</b></p>'+
                                 '<br/>'+
                                 '<br/>'+
                                 'Thank you,'+
                                 '<br/>'+
                                 'MD IRO Staff'+
                                 '<br/>'+
                                 'MAXIMUS Federal Services</html>';
                             message.setSubject('Case File Documentation has been Uploaded');
                             message.setHtmlBody(body);
                             if(caseEntity.Entity__r.Email_Address__c != null){
                                 message.setToAddresses(new List<String>{caseEntity.Entity__r.Email_Address__c});
                                 mails.add(message);
                                 break;
                             }else{
                                 message.setToAddresses(new List<String>{entityContact.Email_Address__c});
                                 mails.add(message);
                             }
                         }
                     }
                 }else{
                      Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                  	String body = '<html>Dear '+caseEntity.Entity_Contact__r.Contact_Person_First_Name__c+' '+caseEntity.Entity_Contact__r.Contact_Person_Last_Name__c+' '+Suffix+','+
                     '<br/>'+
                     '<br/>'+
                     'Case File Documentation has successfully been uploaded for the following case '+caseEntity.Case__r.Document_Case_Number__c+' on '+converted+' ET.'+  
                     '<br/>'+
                     '<br/>'+
                     'You may view the details and status of this case at any time by logging on to your portal account.'+
                     '<br/>'+
                     '<br/>'+
                     'Please <a href = "https://mdiro.maximus.com">click here</a> to access the MD IRO Portal.'+
                     '<br/>'+
                     '<br/>'+
                     '<p><b>Note: Maximus will notify you if there was an issue with your document(s) submission in a separate email.</b></p>'+
                     '<br/>'+
                     '<br/>'+
                     'Thank you,'+
                     '<br/>'+
                     'MD IRO Staff'+
                     '<br/>'+
                     'MAXIMUS Federal Services</html>';

                 toAddress.add(caseEntity.Entity_Contact__r.Email_Address__c);
                 message.setSubject('Case File Documentation has been Uploaded');
                 message.setHtmlBody(body);
                 message.setToAddresses(toAddress);
                 if(isRepresentativeMap.containsKey(caseEntity.Case__c) && isRepresentativeMap.get(caseEntity.Case__c) && caseEntity.Entity__r.Entity_Type__c != 'Provider'){
                     mails.add(message);
                 }else if(isRepresentativeMap.containsKey(caseEntity.Case__c) && !isRepresentativeMap.get(caseEntity.Case__c)){
                     mails.add(message);
                 }   
                 }
             }
         }
         List<CaseEntityJunction__c> caseEntityJunctionDecList = [SELECT Id,Case__c, Entity_Contact__c,Entity_Contact__r.Email_Address__c, Entity__r.Entity_Type__c,
                                                Entity_Contact__r.Contact_Person_First_Name__c,  Entity_Contact__r.Contact_Person_Last_Name__c, Entity__r.Name, Entity__r.EMail_Address__c,
                                                Entity_Contact__r.Suffix__c, Case__r.Case_Number_f__c,Case__r.Decision_Code__c,Case__r.MCO_File_Uploaded__c,Case__r.Document_Case_Number__c	
                                                FROM CaseEntityJunction__c WHERE Case__c IN : caseDecisionFileIds];
         isRepresentativeMap = new Map<Id,Boolean>();
        entityIds = new Set<Id>();
         for(CaseEntityJunction__c caseEntity: caseEntityJunctionDecList){
              entityIds.add(caseEntity.Entity__c);
             if(caseEntity.Entity__r.Entity_Type__c == 'Representative'){
                 isRepresentativeMap.put(caseEntity.Case__c, true);
             }else{
                 isRepresentativeMap.put(caseEntity.Case__c, false);
             }
         }
         System.debug('isRepresentativeMap'+isRepresentativeMap);
         entityContactMap = new Map<Id, List<Entity_Contact__c>>();
        for(Entity_Contact__c entityContact :[SELECT Id, Email_Address__c, Contact_Person_First_Name__c, Contact_Person_Last_Name__c, Entity__c, Entity_Address__c, Suffix__c 
                                              FROM Entity_Contact__c
                                              WHERE Entity__c In : entityIds]){
                                                  if(entityContactMap.containsKey(entityContact.Entity__c)){
                                                      List<Entity_Contact__c> entityContactList = entityContactMap.get(entityContact.Entity__c);
                                                      entityContactList.add(entityContact);
                                                      entityContactMap.put(entityContact.Entity__c, entityContactList);
                                                  }else{
                                                      entityContactMap.put(entityContact.Entity__c, new List<Entity_Contact__c>{entityContact});
                                                  }
                                              }
         for(CaseEntityJunction__c caseEntity: caseEntityJunctionDecList){
             if(caseDecisionFileIds.contains(caseEntity.Case__c)){
                 //List<String> toAddress = new List<String> ();
                 //toAddress.add(caseEntity.Entity_Contact__r.Email_Address__c);
                 String Suffix;
                 if(caseEntity.Entity_Contact__r.Suffix__c != null){Suffix = caseEntity.Entity_Contact__r.Suffix__c;}else{Suffix = '';}
                 if(caseEntity.Entity__r.Entity_Type__c == 'MCO'){
                     if(entityContactMap.containsKey(caseEntity.Entity__c)){
                         for(Entity_Contact__c entityContact : entityContactMap.get(caseEntity.Entity__c)){
                             String entityName = caseEntity.Entity__r.Email_Address__c != null ? caseEntity.Entity__r.Name : entityContact.Contact_Person_First_Name__c+' '+entityContact.Contact_Person_Last_Name__c+' '+Suffix;
                             Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                             String body = '<html>Dear '+entityName+','+
                                 '<br/>'+
                                 '<br/>'+
                                 'The IRO has made the decision to '+caseEntity.Case__r.Decision_Code__c+' for the following case '+caseEntity.Case__r.Document_Case_Number__c+'. '+
                                 '<br/>'+
                                 '<br/>'+
                                 'To view associated case details and the MAXIMUS Decision Letter, please <a href = "https://mdiro.maximus.com">click here</a> to access and view this case on the MD IRO Portal.'+                    
                                 '<br/>'+
                                 '<br/>'+
                                 'Thank you,'+
                                 '<br/>'+
                                 'MD IRO Staff'+
                                 '<br/>'+
                                 'MAXIMUS Federal Services</html>';
                             message.setSubject('Case File Review Complete - Decision Letter');
                             message.setHtmlBody(body);
                             if(caseEntity.Entity__r.Email_Address__c != null){
                                 message.setToAddresses(new List<String>{caseEntity.Entity__r.Email_Address__c});
                                 mails.add(message);
                                 break;
                             }else{
                                 message.setToAddresses(new List<String>{entityContact.Email_Address__c});
                                 mails.add(message);
                             }
                         }
                     }
                 }else{
                        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                     String body = '<html>Dear '+caseEntity.Entity_Contact__r.Contact_Person_First_Name__c+' '+caseEntity.Entity_Contact__r.Contact_Person_Last_Name__c+' '+Suffix+','+
                         '<br/>'+
                         '<br/>'+
                         'The IRO has made the decision to '+caseEntity.Case__r.Decision_Code__c+' for the following case '+caseEntity.Case__r.Document_Case_Number__c+'. '+
                         '<br/>'+
                         '<br/>'+
                         'To view associated case details and the MAXIMUS Decision Letter, please <a href = "https://mdiro.maximus.com">click here</a> to access and view this case on the MD IRO Portal.'+                    
                         '<br/>'+
                         '<br/>'+
                         'Thank you,'+
                         '<br/>'+
                         'MD IRO Staff'+
                         '<br/>'+
                         'MAXIMUS Federal Services</html>';
                     message.setSubject('Case File Review Complete - Decision Letter');
                     message.setHtmlBody(body);
                     message.setToAddresses(new List<string>{caseEntity.Entity_Contact__r.Email_Address__c});
                     if(isRepresentativeMap.containsKey(caseEntity.Case__c) && isRepresentativeMap.get(caseEntity.Case__c) && caseEntity.Entity__r.Entity_Type__c != 'Provider'){
                         mails.add(message);
                     }else if(isRepresentativeMap.containsKey(caseEntity.Case__c) && !isRepresentativeMap.get(caseEntity.Case__c)){
                         mails.add(message);
                     }
                 }
             }
         }
          System.debug('mails'+mails);
       /*  Messaging.SendEmailResult[] result = Messaging.sendEmail(mails);
         System.debug('result0'+result);
     }*/
    

    /*  public static void getHeaderTotalAmount(List<Invoice_Header__c> updateHeaders){
          List<Invoice_Details__c> details = [select count(Id),Invoice_Header__c, Review_Fee__c from Invoice_Details__c where Invoice_Header__c IN: updateHeaders group by Invoice_Header__c];
          for(Invoice_Header__c header: updateHeaders){
              header.Total_Amount__c = 0;
              for(Invoice_Details__c detail: details){
                  if(detail.Invoice_Header__c == header.Id){

                  }
              }
          }
      }*/
  //}
}