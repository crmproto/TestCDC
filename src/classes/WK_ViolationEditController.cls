/****************************************************************************
 * Class: WK_ViolationEditController
 * Author: Sucheta Verma
 * Date:   `18/04/2017
 * Detail: Class to ViolationEdit  on Portal.
 *****************************************************************************/
public without sharing class WK_ViolationEditController {

    public Violation__c violation {
        get;
        set;
    }
    public ServiceAppointment service {
        get;
        set;
    }
    public String name {
        get;
        set;
    }
    public Id firstFileId {
        get;
        set;
    }
    public Id firstFileAttId {
        get;
        set;
    }
    public Id firstFil2AttId {
        get;
        set;
    }
    public string imageURL {
        get;
        set;
    }
    public string imageUrl1 {
        get;
        set;
    }
    public string imageUrl2 {
        get;
        set;
    }
    public string imageURLSecond {
        get;
        set;
    }
    public String secondFileId {
        get;
        set;
    }
    public String violationName {
        get;
        set;
    }
    public String buildingName {
        get;
        set;
    }
    public String violationType {
        get;
        set;
    }
    public String violationFineAmount {
        get;
        set;
    }
    public String violationAddNote {
        get;
        set;
    }
    public Decimal violationQuantity {
        get;
        set;
    }
    public String violationStatus {
        get;
        set;
    }
    public String violationUnit {
        get;
        set;
    }
    public String oldBuildingName = '';
    public String oldViolationStatus = '';
    public String oldViolationType = '';
    public static List < Violation__c > violDetails {
        get;
        set;
    }
    public String datechecked {
        get;
        set;
    }
    public static List < ContentVersion > listOfContentVers;
    public List < Attachment > attachedFiles {
        get;
        set;
    }
    public List < ContentDocumentLink > listOfContentDocLinks {
        get;
        set;
    }
    public static Id voilationId;
    public static String violationPreStatus = '';
    public String accountId {
        get;
        set;
    }
    public String pgNumber {
        get;
        set;
    }
    public String vioType {
        get;
        set;
    }
    public String duration {
        get;
        set;
    }
    public String startDateRep {
        get;
        set;
    }
    public String endDateRep {
        get;
        set;
    }

    // public ApexPages.StandardController controller;


    public WK_ViolationEditController(ApexPages.standardController stdController) {

        violation = new Violation__c();
        // accountId = ApexPages.currentPage().getParameters().get('accntId');
        List < Attachment > lstOfAttachments = new List < Attachment > ();
        buildingName = '';
        imageUrl = '';
        // imageUrl1 = 'https://cs3.salesforce.com/sfc/servlet.shepherd/version/renditionDownload?rendition=THUMB720BY480&versionId=068Q00000002psY';
        imageUrlSecond = '';
        imageUrl1 = '';
        imageUrl2 = '';
        violDetails = new List < Violation__c > ();
        Set < Id > setOfConDocIds = new Set < Id > ();
        List < ContentDocument > listOfContentDocs = new List < ContentDocument > ();
        listOfContentVers = new List < ContentVersion > ();
        attachedFiles = new List < Attachment > ();
        listOfContentDocLinks = new List < ContentDocumentLink > ();
        attachedFiles = new List < Attachment > ();
        name = Apexpages.currentpage().getparameters().get(WK_ConstantUtility.strName);
        pgNumber = Apexpages.currentpage().getparameters().get('pageNo');
        vioType = Apexpages.currentpage().getparameters().get('typeOfVio');
        duration = Apexpages.currentpage().getparameters().get('dura');
        accountId = ApexPages.currentPage().getParameters().get('accntId');
        startDateRep = ApexPages.currentPage().getParameters().get('startDateRep');
        endDateRep = ApexPages.currentPage().getParameters().get('endDateRep');
        try {
            violation = [Select id, name, createdDate, WK_Building__c, WK_Building__r.Name, Old_WK_PM_Status__c, WK_Add_Note__c, WK_Fine_Amount__c, Quantity__c, WK_Status__c, WK_PM_Status__c, Unit__c, Violation_Type__c from Violation__c where Name =: name];
            if (violation != null && violation.Id != null) {
                voilationId = violation.Id;

                attachedFiles = [select Id, body from Attachment where parentId =: violation.Id order By CreatedDate DESC limit 2];
                listOfContentDocLinks = [SELECT ContentDocument.LatestPublishedVersionId FROM ContentDocumentLink WHERE LinkedEntityId =: voilationId Order By ContentDocument.LatestPublishedVersionId DESC limit 2];

                if (!attachedFiles.isEmpty()) {
                    firstFileAttId = attachedFiles[0].Id;
                    if (attachedFiles.size() > 1) {
                        firstFil2AttId = attachedFiles[1].Id;
                    }
                } else if (listOfContentDocLinks != null && !listOfContentDocLinks.isEmpty()) {
                    firstFileAttId = listOfContentDocLinks[0].ContentDocument.LatestPublishedVersionId;
                    imageUrl1 = System.Label.WK_ImgUrlForViolations + firstFileAttId;
                    if (listOfContentDocLinks.size() > 1) {
                        firstFil2AttId = listOfContentDocLinks[1].ContentDocument.LatestPublishedVersionId;
                        imageUrl2 = System.Label.WK_ImgUrlForViolations + firstFil2AttId;

                    }
                    system.debug('firstFileId val -> ' + firstFileAttId + ', secondFileId -> ' + firstFil2AttId);
                }
                system.debug('firstFileId val -> ' + firstFileId + ', secondFileId -> ' + secondFileId);
            }

        } catch (QueryException qe) {
            System.debug('Exception Occured ' + qe.getMessage());
        }

        if (violation != null) {
            if (violation.CreatedDate != null) {
                datechecked = String.valueof(violation.CreatedDate.format('M/dd/yyyy' + ' ' + WK_ConstantUtility.timeFormat));
                //datechecked= String.valueof(violation.CreatedDate.format(WK_ConstantUtility.dateFormat+' '+WK_ConstantUtility.timeFormat));
            }
            if (violation.WK_Building__c != null && violation.WK_Building__r.Name != null && violation.WK_Building__r.Name != '') {
                buildingName = violation.WK_Building__r.Name;
            }
            if (violation.Name != null && violation.Name != '') {
                violationName = violation.Name;
            }
            if (violation.Violation_Type__c != null && violation.Violation_Type__c != '') {
                violationType = violation.Violation_Type__c;
                //oldViolationType = violationType;
            }
            if (violation.WK_Add_Note__c != null && violation.WK_Add_Note__c != '') {
                violationAddNote = violation.WK_Add_Note__c;
            }
            if (violation.Quantity__c != null) {
                violationQuantity = violation.Quantity__c;
            }
            if (violation.WK_PM_Status__c != null && violation.WK_PM_Status__c != '') {
                violationStatus = violation.WK_PM_Status__c;
                oldViolationStatus = violationStatus;
            }
            if (violation.Unit__c != null && violation.Unit__c != '') {
                violationUnit = violation.Unit__c;
            }
            if (violation.WK_Fine_Amount__c != null) {
                String violationFineAmountInitial = String.valueOf(violation.WK_Fine_Amount__c);
                violationFineAmount = WK_ConstantUtility.dollarLabel + violationFineAmountInitial;
            }

        }
    }

    public List < selectOption > getViolationTypePicklist {
        get {
            List < SelectOption > options = new List < SelectOption > ();
            Schema.DescribeFieldResult fieldResult = Violation__c.Violation_Type__c.getDescribe();
            List < Schema.PicklistEntry > plDetail = fieldResult.getPicklistValues();

            for (Schema.PicklistEntry f: plDetail)
                options.add(new SelectOption(f.getLabel(), f.getValue()));
            return options;
        }
    }
    public List < selectOption > getViolationStatusPicklist {
        get {
            List < SelectOption > options = new List < SelectOption > ();
            Schema.DescribeFieldResult fieldResult = Violation__c.WK_PM_Status__c.getDescribe();
            List < Schema.PicklistEntry > plDetail = fieldResult.getPicklistValues();

            for (Schema.PicklistEntry f: plDetail)
                options.add(new SelectOption(f.getLabel(), f.getValue()));
            return options;
        }
    }


    public PageReference cancel() {
        if (violation != null && violation.Id != null) {
            violation.WK_PM_Status__c = violation.Old_WK_PM_Status__c;
            try {
                Database.update(violation, false);
            } catch (DMLException dl) {
                System.debug('Exception Occured ' + dl.getMessage());
            }
        }
        PageReference ref = new PageReference(WK_ConstantUtility.urlInViolationEditPage + name + '&accntId=' + accountId + '&pageNo=' + pgNumber + '&typeOfVio=' + vioType + '&dura=' + duration);
        // PageReference ref = new PageReference(WK_ConstantUtility.urlInViolationEditPage+accountId+'&name='+name);
        ref.setRedirect(true);
        return ref;
    }

    public PageReference save() {
        List < Building__c > lstOfBuildings = new List < Building__c > ();
        Database.SaveResult result;

        if (buildingName != null && buildingName != '' && buildingName != oldBuildingName) {
            try {
                lstOfBuildings = [Select Id, Name from Building__c where Name =: buildingName];
            } catch (QueryException qe) {
                System.debug('Exception occured ' + qe.getMessage());
            }
        }
        if (lstOfBuildings != null && !lstOfBuildings.isEmpty()) {
            violation.WK_Building__c = lstOfBuildings[0].Id;
        }
        if (violationStatus != null && violationStatus != '' && violationStatus != oldViolationStatus) {
            violation.WK_PM_Status__c = violationStatus;
        }
        if (violationType != null && violationType != '' && violationType != oldViolationType) {
            violation.Violation_Type__c = violationType;
        }
        if (violationAddNote != null && violationAddNote != '') {
            violation.WK_Add_Note__c = violationAddNote;
        }
        try {
            result = Database.update(violation, false);
        } catch (DMLException dl) {
            System.debug('DML Failed ' + dl.getMessage());
        }
        if (result != null && result.isSuccess() == true) {
            PageReference pgRef = new PageReference(WK_ConstantUtility.urlInViolationEditPage + name + '&accntId=' + accountId + '&pageNo=' + pgNumber + '&typeOfVio=' + vioType + '&dura=' + duration + '&startDateRep' + startDateRep + '&endDateRep' + endDateRep);
            return pgRef;
        } else {
            return null;
        }
    }
    //public static void insrtAttachment(List<ContentVersion> contVerList, id voilationId) {
    public static void insrtAttachment() {
        List < Attachment > attListQuery = new List < Attachment > ([Select id, Name from Attachment where ParentID =: voilationId]);
        Set < String > attNamesSet = new Set < String > ();
        for (Attachment attItr: attListQuery) {
            attNamesSet.add(attItr.Name);
        }
        system.debug('attNamesSet val - >' + attNamesSet);
        List < Attachment > attListToUpdate = new List < Attachment > ();
        system.debug('listOfContentVers while attchment got - >' + listOfContentVers);
        //if(!contVerList.isEmpty()) {
        if (!listOfContentVers.isEmpty() || Test.isRunningTest()) {
            for (ContentVersion contVerItr: listOfContentVers) {
                if (!attNamesSet.contains(contVerItr.title)) {
                    Attachment attach = new Attachment();
                    system.debug('contVerItr.VersionData2 - >' + contVerItr.VersionData);
                    if (contVerItr.VersionData != null) {
                        attach.Body = contVerItr.VersionData;
                    }
                    system.debug('contVerItr.title - >' + contVerItr.title);
                    if (contVerItr.title != null) {
                        attach.Name = contVerItr.title;
                    }

                    if (contVerItr.FileType != null) {
                        attach.ContentType = contVerItr.FileType;
                    }
                    system.debug('voilationId - >' + voilationId);
                    if (voilationId != null) {
                        attach.ParentID = voilationId;
                    } else {
                        system.debug('contVerItr.contentDocument.parentId is null - >');
                    }

                    system.debug('attachment to be inserted - >' + attach);
                    attListToUpdate.add(attach);
                }
            }
            Database.SaveResult[] srList;
            if (!attListToUpdate.isEmpty() || Test.isRunningTest()) {
                try {
                    srList = Database.insert(attListToUpdate, false);
                    system.debug('sr result - >' + srList);
                } catch (System.DMLException e) {
                    system.debug('exception caught -- >' + e);
                    //ApexPages.addMessages(e);
                    //return null;
                }
            }
        }

    }
    public PageReference navigateToEditPage() {
        accountId = ApexPages.currentPage().getParameters().get('accntId');
        if (violation != null && violation.Id != null) {
            violation.Old_WK_PM_Status__c = violation.WK_PM_Status__c;
            violation.WK_PM_Status__c = WK_ConstantUtility.violationReviewStatus;
            try {
                Database.update(violation, false);
            } catch (DMLException dl) {
                System.debug('Exception Occured ' + dl.getMessage());
            }
        }
        PageReference ref = new PageReference(WK_ConstantUtility.urlInViolationDetailPage + name + '&accntId=' + accountId + '&pageNo=' + pgNumber + '&typeOfVio=' + vioType + '&dura=' + duration + '&startDateRep=' + startDateRep + '&endDateRep=' + endDateRep);
        return ref;
    }


    public PageReference exportToWord() {
        PageReference ref = new PageReference(WK_ConstantUtility.urlForDownloadWords);
        return ref;
    }


}