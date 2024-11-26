global with sharing class SF_MD_CasesWithPartcipants extends SF_MD_DefaultResponseWrapper{
	public String id;
	public String caseNumber;
    public boolean pendingRi;
    public string sfCaseNumber;
    public Boolean deletedFlag;
	public String reviewTypeCd;
	public String priorityTypeCd;
	public String priorityTypeDesc;
	public String referenceNumber;
    public string recievedDateStr;
    public DateTime recievedDate;
    public String startDateStr;
    public DateTime startDate;
	public String initiatedDate;
	public String createUser;
	public String updatedUser;
    public Integer daysLeft;
	public Long createTimestamp;
	public Long updateTimestamp;
	public String reason;
	public String statusCd;
	public String statusCdForWeb;
	public DateTime dateOfDecision;
	public Date dateLetterSent;
	public String decisionCodeDescription;
	public String sourceType;
	public String userProviderAndFirstTimeSave;
	public String userProviderRepAndFirstTimeSave;
	public String submittedDate;
    public String programId;
    public string programCode;
	public String providerRepName;
	public String providerName;
	public String providerContactName;
	Public String providerRepContactName;
	Public String mcoContactName;
	public String mcoName;
	public String patientName;
	public List<caseParticipants> rCaseParticipants = new List<caseParticipants>();//Within each record either entityParticipamt or personParticpant will be there but never both.
    public List<files> rFiles = new List<files>();
    public List<casePatients> rCasePatients = new List<casePatients>();
    public List<caseProviders> rCaseProviders = new List<caseProviders>();
    public caseDispute rCaseDispute;
    //public List<notes> rCaseNotes;
	//public String primaryContact;
	//public String agreementFile;
	
    public class caseParticipants{ 
        public RentityParticipant rEntityParticipant;
        public RpersonParticipant rPersonParticipant;
        public Rcontact rContact;
        public String id;
    }
    public class RpersonParticipant{
		public String personId;  
        Public string caseEntityId;
        public String firstNameTxt;
        public String middleNameTxt;
        public String lastNameTxt;
        public String insuranceId;
        public String personTypeCd;
        public String addrLine1Txt;
        public String addrLine2Txt;
        public String addrZipCd;
        public String addrCityNm;
        public String addrStCd;
        //public String addrCounty;
        //public String addrCntryCd;
        public String organization;
        public String rowCreatUser;
        public String rowUpdatedUser;
        public String gender;
        public Decimal age;
        public String emailAddress;
        public String phoneNumber;
        public String faxNumber;
        public String suffixTxt;
        public Date dateofbirth;
    }
    public class RentityParticipant{
        public String entityId;
        public String caseEntityId;
        public String entityLine1Nm;
        public String entityLine2Nm;
        public String entityFullName;
        public String firstName;
        public String lastName;
        public string middleName;
        public String contactTitle;
        public String entityContactId;
        public String suffix;
        public String address;
        public String address2;
        public String entityTypeCode;
        public string city;
        public String state;
        public String federalTaxId;
        public string zipCode ;
        public String phoneNumber;
        public String providerId;
        public String providerTypeCode;
        public String rowCreateUser;
        public String faxNumber;
        public String email;
        public string contactEmail;
    }
    public class Rcontact{
        public string firstNameTxt;
        public string lastNameTxt;
        public string contactId;
        public string contactEmail;
    }
    public class files{
        public String name;
        public String uploadBy;
        public String description;
        public String documentType;
        public DateTime uploadTime;
        public String uploadTimeStr;
        public Long length;
        public String docRecId;
        public string documentId;
    }
    
    public class casePatients{
        public RentityParticipant rEntityParticipant;
        public RpersonParticipant rPersonParticipant;
    }
    
    public class caseProviders{
        public RentityParticipant rEntityParticipant;
        public RpersonParticipant rPersonParticipant;
    }
    
    public class caseDispute{
        Public Date dateInitialClaimDenial;
		Public Long dateInitialAppealFiled;
		Public Long datePlanReviewCompleted;
        public String dateInitialClaimDenialStr;
		public String dateInitialAppealFiledStr;
		public String datePlanReviewCompletedStr;
		public String dateCoveredPersonBilledStr;
		Public Long dateCoveredPersonBilled;
        public String diagnosisTypeDescription;
        public String itemService;
        public String documentList;
        public String caseNarrative;
    }
   /* public class notes{
        public String id;
        public String caseNote;
        public String refCaseNoteTypeString;
        public String createUser;
        public String updatedUser;
        public String createTimestamp;
        public String updateTimestamp; 
    }*/
}