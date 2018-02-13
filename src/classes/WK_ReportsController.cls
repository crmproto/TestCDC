/****************************************************************************
 * Class: WK_ReportsController
 * Author: Anush Shivanna
 * Date:   `13/04/2017
 * Detail: Class to show details of Reports on Portal Reports Page.
 *****************************************************************************/
public class WK_ReportsController {
    public static String selectedType {
        get;
        set;
    }
    public static String duration {
        get;
        set;
    }
    public static String durationForUpcoming {
        get;
        set;
    } // for future reference
    public static Date startDate {
        get;
        set;
    }
    public static Date endDate {
        get;
        set;
    }
    public static DateTime startDateTime {
        get;
        set;
    }
    public static DateTime endDateTime {
        get;
        set;
    }
    public static String sQuery;
    public static String header {
        get;
        set;
    }
    public static String AccName;
    public static String NameFromParam5;
    public static String param3;
    public static String param4;
    public static String JSONString {
        get;
        set;
    }
    public static boolean isExport {
        get;
        set;
    }
    public String ChkMapKeyForAtt {
        get;
        set;
    }
    public String ChkMapKeyForCont {
        get;
        set;
    }
    public static List < violationWrapper > listOfViolationWrapper {
        get;
        set;
    }
    public static List < violationWrapper > listOf5DayViolationsWrapper {
        get;
        set;
    }
    public static List < ClosedInquiriesWrapper > listClosedInquiriesWrapper {
        get;
        set;
    }
    public static List < OpenInquiriesWrapper > listOpenInquiriesWrapper {
        get;
        set;
    }
    public static List < assigResWrapper > listOfCheckinWrapper {
        get;
        set;
    }
    public static List < serviceHistroyWrapper > listOfServiceHistoryWrapper {
        get;
        set;
    }
    public List < serviceHistroyWrapper > listOfServiceHistoryWrapperToSearch = new List < serviceHistroyWrapper > ();
    public static List < upcomingServicesWrapper > upcomingServicesWrapperList {
        get;
        set;
    }
    public static List < Integer > lstPagesToBeDisplayed {
        get;
        set;
    }
    public string conName {
        get;
        set;
    }
    public string violationName {
        get;
        set;
    }
    public string startDateVal {
        get;
        set;
    }
    public string endDateVal {
        get;
        set;
    }
    public static string searchText {
        get;
        set;
    }
    public string conEmail {
        get;
        set;
    }
    public string reportCSVName {
        get;
        set;
    }
    public static String accountId {
        get;
        set;
    }
    public String selectedInquiryId {
        get;
        set;
    }
    public String returnURL {
        get;
        set;
    }
    public static String accId {
        get;
        set;
    }
    public String accId2 {
        get;
        set;
    }
    public Map < Id, List < Attachment >> mapOfAttachments {
        get;
        set;
    }
    public Map < Id, List < ContentDocumentLink >> mapOfContentDocLinks {
        get;
        set;
    }
    public List < Attachment > listOfAttachments {
        get;
        set;
    }
    public List < ContentDocumentLink > listOfContentDocLinks {
        get;
        set;
    }
    public String pgNumber {
        get;
        set;
    }
    public String typeOfVio {
        get;
        set;
    }
    public String typeOfDuration {
        get;
        set;
    }
    public String imageUrl1 {
        get;
        set;
    }
    public String imageUrl2 {
        get;
        set;
    }

    /**************************************************************************** 
     * Detail: Construtor for ReportsController
     *****************************************************************************/
    public WK_ReportsController() {
        listOfViolationWrapper = new List < violationWrapper > ();
        listOfCheckinWrapper = new List < assigResWrapper > ();
        listOfServiceHistoryWrapper = new List < serviceHistroyWrapper > ();
        upcomingServicesWrapperList = new List < upcomingServicesWrapper > ();
        lstPagesToBeDisplayed = new List < Integer > ();
        listOf5DayViolationsWrapper = new List < violationWrapper > ();
        listClosedInquiriesWrapper = new List < ClosedInquiriesWrapper > ();
        listOpenInquiriesWrapper = new List < OpenInquiriesWrapper > ();
        mapOfAttachments = new Map < Id, List < Attachment >> ();
        mapOfContentDocLinks = new Map < Id, List < ContentDocumentLink >> ();
        listOfAttachments = new List < Attachment > ();
        listOfContentDocLinks = new List < ContentDocumentLink > ();
        AccName = '';
        conName = '';
        ChkMapKeyForAtt = '';
        ChkMapKeyForCont = '';
        conEmail = '';
        durationForUpcoming = '';
        NameFromParam5 = '';
        violationName = '';
        selectedInquiryId = '';
        returnURL = '';
        String param1 = ApexPages.currentPage().getParameters().get(WK_ConstantUtility.reportsParam1);
        String param2 = ApexPages.currentPage().getParameters().get(WK_ConstantUtility.reportsParam2);
        param3 = ApexPages.currentPage().getParameters().get(WK_ConstantUtility.reportsParam3);
        param4 = ApexPages.currentPage().getParameters().get(WK_ConstantUtility.reportsParam4);
        String param5 = ApexPages.currentPage().getParameters().get(WK_ConstantUtility.reportsParam5);
        String Type = ApexPages.currentPage().getParameters().get(WK_ConstantUtility.reportsType);
        accountId = ApexPages.currentPage().getParameters().get('Id');
        pgNumber = Apexpages.currentpage().getparameters().get('pgName');
        typeOfVio = Apexpages.currentpage().getparameters().get('typeOfVio');
        typeOfDuration = Apexpages.currentpage().getparameters().get('dura');

        startDateVal = Apexpages.currentpage().getparameters().get('startDateRep');
        endDateVal = Apexpages.currentpage().getparameters().get('endDateRep');
        searchText = Apexpages.currentpage().getparameters().get('searchText');

        //pgNumber ='1'; 
        // accountId = System.currentPageReference().getParameters().get('Id');
        //   accountId =  String.valueOf(Cache.Session.get('Id'));
        system.debug('AccountId' + accountId);
        accId = accountId;
        header = '';
        if (param1 != null && param1 != '' && param2 != null && param2 != '') {
            selectedType = param1;
            duration = param2;
            //code for CSV Header
            if (selectedType == WK_ConstantUtility.reportsValetTrashViolations) {
                header = WK_ConstantUtility.headerValetTrashViolations;
                reportCSVName = WK_ConstantUtility.csvValetTrashViolations;
            } else if (selectedType == WK_ConstantUtility.reports5dayViolationsTSys) {
                header = WK_ConstantUtility.headerFiveDayViolations;
                reportCSVName = WK_ConstantUtility.csvFiveDayViolations;
            } else if (selectedType == WK_ConstantUtility.reportsServiceHistory) {
                header = WK_ConstantUtility.headerServiceHistory;
                reportCSVName = WK_ConstantUtility.csvServiceHistory;
            } else if (selectedType == WK_ConstantUtility.reportsUpcomingServices) {
                header = WK_ConstantUtility.headerUpcomingServices;
                reportCSVName = WK_ConstantUtility.csvUpcomingServices;
            } else if (selectedType == WK_ConstantUtility.reportsValetTrashCheckinCheckout) {
                header = WK_ConstantUtility.headerValetTrashCheckinCheckout;
                reportCSVName = WK_ConstantUtility.csvValetTrashCheckinCheckout;
            } else if (selectedType.equals(WK_ConstantUtility.reportsClosedInquiries)) {
                header = WK_ConstantUtility.headerClosedInquiries;
                reportCSVName = WK_ConstantUtility.csvClosedInquiries;
            } else if (selectedType.equals(WK_ConstantUtility.reportsOpenInquiries)) {
                header = WK_ConstantUtility.headerOpenInquiries;
                reportCSVName = WK_ConstantUtility.csvOpenInquiries;
            }
            //
            if (param3 != null && param3 != '') {
                Map < String, Integer > monthNames = new Map < String, Integer > {
                    'Jan' => 1,
                    'Feb' => 2,
                    'Mar' => 3,
                    'Apr' => 4,
                    'May' => 5,
                    'Jun' => 6,
                    'Jul' => 7,
                    'Aug' => 8,
                    'Sep' => 9,
                    'Oct' => 10,
                    'Nov' => 11,
                    'Dec' => 12
                };
                List < String > stringParts = param3.split(' ');
                List < String > timeParts = stringParts[3].split(':');
                DateTime yourDateVariable = DateTime.newInstanceGmt(Integer.valueOf(stringParts[5]), monthNames.get(stringParts[1]), Integer.valueOf(stringParts[2]), Integer.valueOf(timeParts[0]), Integer.valueOf(timeParts[1]), Integer.valueOf(timeParts[2]));
                startDateTime = yourDateVariable;
            }
            if (param4 != null && param4 != '') {
                Map < String, Integer > monthNames = new Map < String, Integer > {
                    'Jan' => 1,
                    'Feb' => 2,
                    'Mar' => 3,
                    'Apr' => 4,
                    'May' => 5,
                    'Jun' => 6,
                    'Jul' => 7,
                    'Aug' => 8,
                    'Sep' => 9,
                    'Oct' => 10,
                    'Nov' => 11,
                    'Dec' => 12
                };
                List < String > stringParts = param4.split(' ');
                List < String > timeParts = stringParts[3].split(':');
                DateTime yourDateVariable = DateTime.newInstanceGmt(Integer.valueOf(stringParts[5]), monthNames.get(stringParts[1]), Integer.valueOf(stringParts[2]), Integer.valueOf(timeParts[0]), Integer.valueOf(timeParts[1]), Integer.valueOf(timeParts[2]));
                endDateTime = yourDateVariable;
            }

        } else if (Type != null) {
            if (Type == WK_ConstantUtility.reportsViolations) {
                selectedType = WK_ConstantUtility.reportsValetTrashViolations;
                duration = WK_ConstantUtility.reportsLast30Days;
            } else if (Type == WK_ConstantUtility.reportsServices) {
                selectedType = WK_ConstantUtility.reportsServiceHistory;
                duration = WK_ConstantUtility.reportsLast30Days;
            } else if (Type == WK_ConstantUtility.reportsUpcoming) {
                selectedType = WK_ConstantUtility.reportsUpcomingServices;
                duration = WK_ConstantUtility.reportsNext30Days;
                durationForUpcoming = WK_ConstantUtility.reportsNext30Days;
            } else if (Type == WK_ConstantUtility.reportsCheckIn) {
                selectedType = WK_ConstantUtility.reportsValetTrashCheckinCheckout;
                duration = WK_ConstantUtility.reportsLast30Days;
            } else if (Type.equals(WK_ConstantUtility.reportClosedInqParam)) {
                selectedType = WK_ConstantUtility.reportsClosedInquiries;
                duration = WK_ConstantUtility.reportsLast30Days;
            } else if (Type.equals(WK_ConstantUtility.reportOpenInqParam)) {
                selectedType = WK_ConstantUtility.reportsOpenInquiries;
                duration = WK_ConstantUtility.reportsLast30Days;
            }

            if (typeOfDuration != null && String.isNotBlank(typeOfDuration)) {
                if (typeOfDuration == 'L30') {
                    duration = WK_ConstantUtility.reportsLast30Days;
                } else if (typeOfDuration == 'L60') {
                    duration = WK_ConstantUtility.reportsLast60Days;
                } else if (typeOfDuration == 'L90') {
                    duration = WK_ConstantUtility.reportsLast90Days;
                } else if (typeOfDuration == 'L12') {
                    duration = WK_ConstantUtility.reportsPast12months;
                } else if (typeOfDuration == 'L7') {
                    duration = WK_ConstantUtility.reportsLast7Days;
                } else if (typeOfDuration == 'yest') {
                    duration = WK_ConstantUtility.reportsYesterday;
                } else if (typeOfDuration == 'sdr') {
                    duration = WK_ConstantUtility.reportsSelectDateRange;
                }

                if (startDateVal != null && startDateVal != '') {
                    System.debug('++++++++++++++++++++++++++++++++ ' + startDateVal);
                    Integer d = Date.parse(startDateVal).day();
                    Integer mo = Date.parse(startDateVal).month();
                    Integer yr = Date.parse(startDateVal).year();

                    DateTime DT = DateTime.newInstance(yr, mo, d);
                    startDate = date.newinstance(DT.year(), DT.month(), DT.day());
                    system.debug('AccountId++++++++' + accountId + ' ' + startDate);

                }
                if (endDateVal != null && endDateVal != '') {
                    Integer d1 = Date.parse(startDateVal).day();
                    Integer mo1 = Date.parse(startDateVal).month();
                    Integer yr1 = Date.parse(startDateVal).year();

                    DateTime DT = DateTime.newInstance(yr1, mo1, d1);
                    endDate = date.newinstance(DT.year(), DT.month(), DT.day());
                }
            }

        } else if (typeOfVio != null && String.isNotBlank(typeOfVio)) {
            if (typeOfVio == WK_ConstantUtility.reportsValetTrashViolations) {
                selectedType = WK_ConstantUtility.reportsValetTrashViolations;
            } else {
                selectedType = WK_ConstantUtility.reports5dayViolationsTSys;
            }
            if (typeOfDuration != null && String.isNotBlank(typeOfDuration)) {
                if (typeOfDuration == 'L30') {
                    duration = WK_ConstantUtility.reportsLast30Days;
                } else if (typeOfDuration == 'L60') {
                    duration = WK_ConstantUtility.reportsLast60Days;
                } else if (typeOfDuration == 'L90') {
                    duration = WK_ConstantUtility.reportsLast90Days;
                } else if (typeOfDuration == 'L12') {
                    duration = WK_ConstantUtility.reportsPast12months;
                } else if (typeOfDuration == 'L7') {
                    duration = WK_ConstantUtility.reportsLast7Days;
                } else if (typeOfDuration == 'yest') {
                    duration = WK_ConstantUtility.reportsYesterday;
                } else if (typeOfDuration == 'sdr') {
                    duration = WK_ConstantUtility.reportsSelectDateRange;
                }

            }
            if (startDateVal != null && startDateVal != '') {
                System.debug('++++++++++++++++++++++++++++++++ ' + startDateVal);
                Integer d = Date.parse(startDateVal).day();
                Integer mo = Date.parse(startDateVal).month();
                Integer yr = Date.parse(startDateVal).year();

                DateTime DT = DateTime.newInstance(yr, mo, d);
                startDate = date.newinstance(DT.year(), DT.month(), DT.day());
                system.debug('AccountId++++++++' + accountId + ' ' + startDate);

            }
            if (endDateVal != null && endDateVal != '') {
                Integer d1 = Date.parse(endDateVal).day();
                Integer mo1 = Date.parse(endDateVal).month();
                Integer yr1 = Date.parse(endDateVal).year();

                DateTime DT = DateTime.newInstance(yr1, mo1, d1);
                endDate = date.newinstance(DT.year(), DT.month(), DT.day());
            }

        } else {
            selectedType = WK_ConstantUtility.reportsValetTrashViolations;
            duration = WK_ConstantUtility.reportsLast30Days;
        }
        if (param5 != null && param5 != '') {
            AccName = param5;
        }


        runReport();
        system.debug('######AccountID' + accountId);

    }
    /**************************************************************************** 
     * Detail: Method for Query of defferent Objects
     *****************************************************************************/
    public static String fetchViolationRecords() {
        String tempInput = '\'%' + searchText + '%\'';
        System.debug('++++++++++++++++++++ '+tempInput);
        if (selectedType == WK_ConstantUtility.reportsValetTrashViolations || selectedType == WK_ConstantUtility.reports5dayViolationsTSys) {

            sQuery = 'Select id,Name,CreatedByID,WK_Building__c,WK_Building__r.Name,LastModifiedByID,Unit__c,Quantity__c,WK_Fine_Amount__c,WK_Add_Note__c,Violation_Type__c,CreatedDate,WK_PM_Status__c,WK_Status__c' +
                ' from Violation__c';

        } else if (selectedType == WK_ConstantUtility.reportsServiceHistory) {
            sQuery = 'Select Id,AppointmentNumber,CreatedByID,SchedStartTime,WK_Services__c,WK_Account__c,AccountId,Account.Name,Status' +
                ' from ServiceAppointment';
        } else if (selectedType == WK_ConstantUtility.reportsUpcomingServices) {
            sQuery = 'Select Id,AppointmentNumber,CreatedByID,SchedStartTime,WK_Services__c,WK_Account__c,AccountId,Account.Name,Status' +
                ' from ServiceAppointment';

        } else if (selectedType.equals(WK_ConstantUtility.reportsClosedInquiries)) {
            sQuery = 'SELECT Id, CaseNumber,CreatedDate,Status,ClosedDate,Type,Sub_Type__c FROM Case';
        } else if (selectedType.equals(WK_ConstantUtility.reportsOpenInquiries)) {
            sQuery = 'SELECT Id, CaseNumber, CreatedDate,Status,Type,Sub_Type__c FROM Case';
        } else {
            sQuery = 'Select Id,AppointmentNumber,CreatedByID,SchedStartTime,ActualEndTime,WK_Account__c,AccountId,Account.Name,ActualStartTime,WK_Duration__c,WK_Services__c,Status' +
                ' from ServiceAppointment';
        }
        if (selectedType == WK_ConstantUtility.reportsUpcomingServices) {
            if (durationForUpcoming == WK_ConstantUtility.reportsSelectDateRange) {
                duration = WK_ConstantUtility.reportsSelectDateRange;
            } else if (durationForUpcoming == WK_ConstantUtility.reportsNext30Days) {
                duration = WK_ConstantUtility.reportsNext30Days;
            }
        }
        //DE9759 Start- Change by Himanshu all queries except Future Services and Custom
        if (duration != null && duration != '') {

            if (duration == WK_ConstantUtility.reportsLast30Days && selectedType != WK_ConstantUtility.reportsUpcomingServices) {
                if (selectedType == WK_ConstantUtility.reportsServiceHistory) {
                    if (tempInput != null && tempInput != '' && searchText != null && searchText != '') {
                        sQuery = sQuery + ' Where (SchedStartTime = LAST_N_DAYS:29 OR SchedStartTime = TODAY) ' + 'AND (ActualEndTime != null OR Status =\'Canceled\' OR Status =\'Cannot Complete\') AND Account.Name = ' + '\'' + AccName + '\'' + ' AND (AppointmentNumber LIKE ' + tempInput + ' OR WK_Services__c LIKE ' + tempInput + ' OR Status LIKE ' + tempInput + ')' + ' ORDER BY SchedStartTime DESC';

                    } else {
                        sQuery = sQuery + ' Where (SchedStartTime = LAST_N_DAYS:29 OR SchedStartTime = TODAY) ' + 'AND (ActualEndTime != null OR Status =\'Canceled\' OR Status =\'Cannot Complete\') AND Account.Name = ' + '\'' + AccName + '\'' + ' ORDER BY SchedStartTime DESC';
                    }
                } else if (selectedType == WK_ConstantUtility.reportsValetTrashViolations) {
                    if (tempInput != null && tempInput != '' && searchText != null && searchText != '') {
                        sQuery = sQuery + ' Where (CreatedDate = LAST_N_DAYS:29 OR CreatedDate = TODAY) ' + 'AND WK_Status__c= \'Approved\' AND WK_Service_Appointment__r.Account.Name = ' + '\'' + AccName + '\'' + ' AND (Unit__c LIKE ' + tempInput + ' OR Name LIKE ' + tempInput + ' OR Violation_Type__c LIKE ' + tempInput + ' OR WK_PM_Status__c LIKE ' + tempInput + ')' + ' AND Violation_Type__c NOT IN (\'5-Day violation tracking system\') ORDER BY CreatedDate DESC';
                    } else {
                        sQuery = sQuery + ' Where (CreatedDate = LAST_N_DAYS:29 OR CreatedDate = TODAY) ' + 'AND WK_Status__c= \'Approved\' AND WK_Service_Appointment__r.Account.Name = ' + '\'' + AccName + '\'' + ' AND Violation_Type__c NOT IN (\'5-Day violation tracking system\') ORDER BY CreatedDate DESC';
                    }
                } else if (selectedType == WK_ConstantUtility.reports5dayViolationsTSys) {
                    if (tempInput != null && tempInput != '' && searchText != null && searchText != '') {
                        sQuery = sQuery + ' Where (CreatedDate = LAST_N_DAYS:29 OR CreatedDate = TODAY) ' + 'AND WK_Status__c= \'Approved\' AND WK_Service_Appointment__r.Account.Name = ' + '\'' + AccName + '\'' + ' AND (Unit__c LIKE ' + tempInput + ' OR Name LIKE ' + tempInput + ' OR Violation_Type__c LIKE ' + tempInput + ' OR WK_PM_Status__c LIKE ' + tempInput + ')' + ' AND Violation_Type__c = \'5-Day violation tracking system\' ORDER BY CreatedDate DESC';
                    } else {
                        sQuery = sQuery + ' Where (CreatedDate = LAST_N_DAYS:29 OR CreatedDate = TODAY) ' + 'AND WK_Status__c= \'Approved\' AND WK_Service_Appointment__r.Account.Name = ' + '\'' + AccName + '\'' + ' AND Violation_Type__c = \'5-Day violation tracking system\' ORDER BY CreatedDate DESC';

                    }
                } else if (selectedType.equals(WK_ConstantUtility.reportsClosedInquiries)) {
                    if (tempInput != null && tempInput != '' && searchText != null && searchText != '') {
                        sQuery = sQuery + ' WHERE (ClosedDate = LAST_N_DAYS:29 OR ClosedDate = TODAY) AND Account.Name = \'' + AccName + '\' AND Status = \'' + WK_ConstantUtility.CASE_CLOSED_STATUS + '\'' + ' AND (CaseNumber LIKE ' + tempInput + ' OR Type LIKE ' + tempInput + ' OR Sub_Type__c LIKE ' + tempInput + ' OR Status LIKE ' + tempInput + ')' + ' ORDER BY CreatedDate DESC';
                    } else {
                        sQuery = sQuery + ' WHERE (ClosedDate = LAST_N_DAYS:29 OR ClosedDate = TODAY) AND Account.Name = \'' + AccName + '\' AND Status = \'' + WK_ConstantUtility.CASE_CLOSED_STATUS + '\' ORDER BY CreatedDate DESC';
                    }
                } else if (selectedType.equals(WK_ConstantUtility.reportsOpenInquiries)) {
                    if (tempInput != null && tempInput != '' && searchText != null && searchText != '') {
                        sQuery = sQuery + ' WHERE (CreatedDate = LAST_N_DAYS:29 OR CreatedDate = TODAY) AND Account.Name = \'' + AccName + '\' AND Status NOT IN (\'' + WK_ConstantUtility.CASE_CLOSED_STATUS + '\')' + ' AND (CaseNumber LIKE ' + tempInput + ' OR Type LIKE ' + tempInput + ' OR Sub_Type__c LIKE ' + tempInput + ' OR Status LIKE ' + tempInput + ')' + ' ORDER BY CreatedDate DESC';
                    } else {
                        sQuery = sQuery + ' WHERE (CreatedDate = LAST_N_DAYS:29 OR CreatedDate = TODAY) AND Account.Name = \'' + AccName + '\' AND Status NOT IN (\'' + WK_ConstantUtility.CASE_CLOSED_STATUS + '\') ORDER BY CreatedDate DESC';
                    }
                } else {
                    if (tempInput != null && tempInput != '' && searchText != null && searchText != '') {
                        sQuery = sQuery + ' Where (SchedStartTime = LAST_N_DAYS:29 OR SchedStartTime = TODAY) ' + 'AND (WK_Services__c LIKE \'%Valet Trash%\' OR WK_Services__c LIKE \'%Curbside Pickup%\')  AND Account.Name = ' + '\'' + AccName + '\'' + ' AND ActualEndTime != null' + ' AND ( AppointmentNumber LIKE ' + tempInput + ' OR WK_Duration__c LIKE ' + tempInput + ')' + ' ORDER BY SchedStartTime DESC';
                    } else {
                        sQuery = sQuery + ' Where (SchedStartTime = LAST_N_DAYS:29 OR SchedStartTime = TODAY) ' + 'AND (WK_Services__c LIKE \'%Valet Trash%\' OR WK_Services__c LIKE \'%Curbside Pickup%\')  AND Account.Name = ' + '\'' + AccName + '\'' + ' AND ActualEndTime != null' + ' ORDER BY SchedStartTime DESC';
                    }
                }
            }


            //code start- logic for last 7 days and yesterday - developer: NSebastian@Deloitte
            else if (duration == WK_ConstantUtility.reportsLast7Days && selectedType != WK_ConstantUtility.reportsUpcomingServices) {
                if (selectedType == WK_ConstantUtility.reportsServiceHistory) {
                    if (tempInput != null && tempInput != '' && searchText != null && searchText != '') {
                        sQuery = sQuery + ' Where (SchedStartTime = LAST_N_DAYS:6 OR SchedStartTime = TODAY)' + 'AND (ActualEndTime != null OR Status =\'Canceled\' OR Status =\'Cannot Complete\') AND Account.Name = ' + '\'' + AccName + '\'' + ' AND (AppointmentNumber LIKE ' + tempInput + ' OR WK_Services__c LIKE ' + tempInput + ' OR Status LIKE ' + tempInput + ')' + ' ORDER BY SchedStartTime DESC';
                    } else {
                        sQuery = sQuery + ' Where (SchedStartTime = LAST_N_DAYS:6 OR SchedStartTime = TODAY)' + 'AND (ActualEndTime != null OR Status =\'Canceled\' OR Status =\'Cannot Complete\') AND Account.Name = ' + '\'' + AccName + '\'' + ' ORDER BY SchedStartTime DESC';

                    }
                } else if (selectedType == WK_ConstantUtility.reportsValetTrashViolations) {
                    if (tempInput != null && tempInput != '' && searchText != null && searchText != '') {
                        sQuery = sQuery + ' Where (CreatedDate = LAST_N_DAYS:6  OR CreatedDate = TODAY)' + 'AND WK_Status__c= \'Approved\' AND WK_Service_Appointment__r.Account.Name = ' + '\'' + AccName + '\'' + ' AND (Unit__c LIKE ' + tempInput + ' OR Name LIKE ' + tempInput + ' OR Violation_Type__c LIKE ' + tempInput + ' OR WK_PM_Status__c LIKE ' + tempInput + ')' + '  AND Violation_Type__c NOT IN (\'5-Day violation tracking system\') ORDER BY CreatedDate DESC';
                    } else {
                        sQuery = sQuery + ' Where (CreatedDate = LAST_N_DAYS:6  OR CreatedDate = TODAY)' + 'AND WK_Status__c= \'Approved\' AND WK_Service_Appointment__r.Account.Name = ' + '\'' + AccName + '\'' + '  AND Violation_Type__c NOT IN (\'5-Day violation tracking system\') ORDER BY CreatedDate DESC';

                    }
                } else if (selectedType == WK_ConstantUtility.reports5dayViolationsTSys) {
                    if (tempInput != null && tempInput != '' && searchText != null && searchText != '') {
                        sQuery = sQuery + ' Where (CreatedDate = LAST_N_DAYS:6 OR CreatedDate = TODAY)' + 'AND WK_Status__c= \'Approved\' AND WK_Service_Appointment__r.Account.Name = ' + '\'' + AccName + '\'' + ' AND (Unit__c LIKE ' + tempInput + ' OR Name LIKE ' + tempInput + ' OR Violation_Type__c LIKE ' + tempInput + ' OR WK_PM_Status__c LIKE ' + tempInput + ')' + '  AND Violation_Type__c = \'5-Day violation tracking system\' ORDER BY CreatedDate DESC';
                    } else {
                        sQuery = sQuery + ' Where (CreatedDate = LAST_N_DAYS:6 OR CreatedDate = TODAY)' + 'AND WK_Status__c= \'Approved\' AND WK_Service_Appointment__r.Account.Name = ' + '\'' + AccName + '\'' + '  AND Violation_Type__c = \'5-Day violation tracking system\' ORDER BY CreatedDate DESC';
                    }
                } else if (selectedType.equals(WK_ConstantUtility.reportsClosedInquiries)) {
                    if (tempInput != null && tempInput != '' && searchText != null && searchText != '') {
                        sQuery = sQuery + ' WHERE (ClosedDate = LAST_N_DAYS:6 OR ClosedDate = TODAY) AND Account.Name = \'' + AccName + '\' AND Status = \'' + WK_ConstantUtility.CASE_CLOSED_STATUS + '\'' + ' AND (CaseNumber LIKE ' + tempInput + ' OR Type LIKE ' + tempInput + ' OR Sub_Type__c LIKE ' + tempInput + ' OR Status LIKE ' + tempInput + ')' + ' ORDER BY CreatedDate DESC';
                    } else {
                        sQuery = sQuery + ' WHERE (ClosedDate = LAST_N_DAYS:6 OR ClosedDate = TODAY) AND Account.Name = \'' + AccName + '\' AND Status = \'' + WK_ConstantUtility.CASE_CLOSED_STATUS + '\' ORDER BY CreatedDate DESC';
                    }
                } else if (selectedType.equals(WK_ConstantUtility.reportsOpenInquiries)) {
                    if (tempInput != null && tempInput != '' && searchText != null && searchText != '') {
                        sQuery = sQuery + ' WHERE (CreatedDate = LAST_N_DAYS:6 OR CreatedDate = TODAY) AND Account.Name = \'' + AccName + '\' AND Status NOT IN (\'' + WK_ConstantUtility.CASE_CLOSED_STATUS + '\')' + ' AND (CaseNumber LIKE ' + tempInput + ' OR Type LIKE ' + tempInput + ' OR Sub_Type__c LIKE ' + tempInput + ' OR Status LIKE ' + tempInput + ')' + ' ORDER BY CreatedDate DESC';
                    } else {
                        sQuery = sQuery + ' WHERE (CreatedDate = LAST_N_DAYS:6 OR CreatedDate = TODAY) AND Account.Name = \'' + AccName + '\' AND Status NOT IN (\'' + WK_ConstantUtility.CASE_CLOSED_STATUS + '\') ORDER BY CreatedDate DESC';
                    }
                } else {
                    if (tempInput != null && tempInput != '' && searchText != null && searchText != '') {
                        sQuery = sQuery + ' Where (SchedStartTime = LAST_N_DAYS:6 OR SchedStartTime = TODAY)' + 'AND (WK_Services__c LIKE \'%Valet Trash%\' OR WK_Services__c LIKE \'%Curbside Pickup%\')  AND Account.Name = ' + '\'' + AccName + '\'' + ' AND ActualEndTime != null' + ' AND ( AppointmentNumber LIKE ' + tempInput + ' OR WK_Duration__c LIKE ' + tempInput + ')' + ' ORDER BY SchedStartTime DESC';
                    } else {
                        sQuery = sQuery + ' Where (SchedStartTime = LAST_N_DAYS:6 OR SchedStartTime = TODAY)' + 'AND (WK_Services__c LIKE \'%Valet Trash%\' OR WK_Services__c LIKE \'%Curbside Pickup%\')  AND Account.Name = ' + '\'' + AccName + '\'' + ' AND ActualEndTime != null' + ' ORDER BY SchedStartTime DESC';
                    }
                }
            } else if (duration == WK_ConstantUtility.reportsYesterday && selectedType != WK_ConstantUtility.reportsUpcomingServices) {
                if (selectedType == WK_ConstantUtility.reportsServiceHistory) {
                    if (tempInput != null && tempInput != '' && searchText != null && searchText != '') {
                        sQuery = sQuery + ' Where SchedStartTime = YESTERDAY ' + 'AND (ActualEndTime != null OR Status =\'Canceled\' OR Status =\'Cannot Complete\') AND Account.Name = ' + '\'' + AccName + '\'' + ' AND (AppointmentNumber LIKE ' + tempInput + ' OR WK_Services__c LIKE ' + tempInput + ' OR Status LIKE ' + tempInput + ')' + ' ORDER BY SchedStartTime DESC';
                    } else {
                        sQuery = sQuery + ' Where SchedStartTime = YESTERDAY ' + 'AND (ActualEndTime != null OR Status =\'Canceled\' OR Status =\'Cannot Complete\') AND Account.Name = ' + '\'' + AccName + '\'' + ' ORDER BY SchedStartTime DESC';
                    }
                } else if (selectedType == WK_ConstantUtility.reportsValetTrashViolations) {
                    if (tempInput != null && tempInput != '' && searchText != null && searchText != '') {
                        sQuery = sQuery + ' Where CreatedDate = YESTERDAY ' + 'AND WK_Status__c= \'Approved\' AND WK_Service_Appointment__r.Account.Name = ' + '\'' + AccName + '\'' + ' AND (Unit__c LIKE ' + tempInput + ' OR Name LIKE ' + tempInput + ' OR Violation_Type__c LIKE ' + tempInput + ' OR WK_PM_Status__c LIKE ' + tempInput + ')' + '  AND Violation_Type__c NOT IN (\'5-Day violation tracking system\') ORDER BY CreatedDate DESC';
                    } else {
                        sQuery = sQuery + ' Where CreatedDate = YESTERDAY ' + 'AND WK_Status__c= \'Approved\' AND WK_Service_Appointment__r.Account.Name = ' + '\'' + AccName + '\'' + '  AND Violation_Type__c NOT IN (\'5-Day violation tracking system\') ORDER BY CreatedDate DESC';

                    }
                } else if (selectedType == WK_ConstantUtility.reports5dayViolationsTSys) {
                    if (tempInput != null && tempInput != '' && searchText != null && searchText != '') {
                        sQuery = sQuery + ' Where CreatedDate = YESTERDAY ' + 'AND WK_Status__c= \'Approved\' AND WK_Service_Appointment__r.Account.Name = ' + '\'' + AccName + '\'' + ' AND (Unit__c LIKE ' + tempInput + ' OR Name LIKE ' + tempInput + ' OR Violation_Type__c LIKE ' + tempInput + ' OR WK_PM_Status__c LIKE ' + tempInput + ')' + '  AND Violation_Type__c = \'5-Day violation tracking system\' ORDER BY CreatedDate DESC';
                    } else {
                        sQuery = sQuery + ' Where CreatedDate = YESTERDAY ' + 'AND WK_Status__c= \'Approved\' AND WK_Service_Appointment__r.Account.Name = ' + '\'' + AccName + '\'' + '  AND Violation_Type__c = \'5-Day violation tracking system\' ORDER BY CreatedDate DESC';

                    }
                } else if (selectedType.equals(WK_ConstantUtility.reportsClosedInquiries)) {
                    if (tempInput != null && tempInput != '' && searchText != null && searchText != '') {
                        sQuery = sQuery + ' WHERE ClosedDate = YESTERDAY AND Account.Name = \'' + AccName + '\' AND Status = \'' + WK_ConstantUtility.CASE_CLOSED_STATUS + '\'' + ' AND (CaseNumber LIKE ' + tempInput + ' OR Type LIKE ' + tempInput + ' OR Sub_Type__c LIKE ' + tempInput + ' OR Status LIKE ' + tempInput + ')' + ' ORDER BY CreatedDate DESC';
                    } else {
                        sQuery = sQuery + ' WHERE ClosedDate = YESTERDAY AND Account.Name = \'' + AccName + '\' AND Status = \'' + WK_ConstantUtility.CASE_CLOSED_STATUS + '\' ORDER BY CreatedDate DESC';
                    }
                } else if (selectedType.equals(WK_ConstantUtility.reportsOpenInquiries)) {
                    if (tempInput != null && tempInput != '' && searchText != null && searchText != '') {
                        sQuery = sQuery + ' WHERE CreatedDate = YESTERDAY AND Account.Name = \'' + AccName + '\' AND Status NOT IN (\'' + WK_ConstantUtility.CASE_CLOSED_STATUS + '\')' + ' AND (CaseNumber LIKE ' + tempInput + ' OR Type LIKE ' + tempInput + ' OR Sub_Type__c LIKE ' + tempInput + ' OR Status LIKE ' + tempInput + ')' + ' ORDER BY CreatedDate DESC';
                    } else {
                        sQuery = sQuery + ' WHERE CreatedDate = YESTERDAY AND Account.Name = \'' + AccName + '\' AND Status NOT IN (\'' + WK_ConstantUtility.CASE_CLOSED_STATUS + '\') ORDER BY CreatedDate DESC';
                    }
                } else {
                    if (tempInput != null && tempInput != '' && searchText != null && searchText != '') {
                        sQuery = sQuery + ' Where SchedStartTime = YESTERDAY ' + 'AND (WK_Services__c LIKE \'%Valet Trash%\' OR WK_Services__c LIKE \'%Curbside Pickup%\')  AND Account.Name = ' + '\'' + AccName + '\'' + ' AND ActualEndTime != null' + ' ORDER BY SchedStartTime DESC';
                    } else {
                        sQuery = sQuery + ' Where SchedStartTime = YESTERDAY ' + 'AND (WK_Services__c LIKE \'%Valet Trash%\' OR WK_Services__c LIKE \'%Curbside Pickup%\')  AND Account.Name = ' + '\'' + AccName + '\'' + ' AND ActualEndTime != null' + ' AND ( AppointmentNumber LIKE ' + tempInput + ' OR WK_Duration__c LIKE ' + tempInput + ')' + ' ORDER BY SchedStartTime DESC';
                    }
                }
            }
            //code end - logic for last 7 days and yesterday
            else if (duration == WK_ConstantUtility.weeklyEmailFrequency) {
                if (selectedType == WK_ConstantUtility.reportsValetTrashViolations) {
                    sQuery = sQuery + ' Where CreatedDate = THIS_WEEK ' + 'AND WK_Status__c= \'Approved\' AND WK_PM_Status__c = \'New\' AND WK_Service_Appointment__r.Account.Name = ' + '\'' + NameFromParam5 + '\'';
                }
            }
            /*    else if(duration == WK_ConstantUtility.dailyEmailFrequency) {
                    if(selectedType == WK_ConstantUtility.reportsValetTrashViolations) {
                        DateTime dtStart = datetime.newInstance(System.Today().year(), System.Today().month(),System.Today().day());
                        DateTime dtEnd = datetime.newInstance(System.Today().year(), System.Today().month(),System.Today().day());
                        String dateTimeFormat = dtStart.format('yyyy-MM-dd\'T\'00:00:00\'Z\'');
                        String dateTimeFormatEnd = dtEnd.format('yyyy-MM-dd\'T\'23:59:59\'Z\'');
                        sQuery = sQuery + ' Where CreatedDate >= ' + dateTimeFormat+' AND CreatedDate <= '+dateTimeFormatEnd+' AND WK_Status__c= \'Approved\' AND WK_PM_Status__c = \'New\' AND WK_Account_Name__c = '+'\''+ NameFromParam5+'\'';
                    }
                }*/
            else if (duration == WK_ConstantUtility.reportsLast60Days && selectedType != WK_ConstantUtility.reportsUpcomingServices) {
                if (selectedType == WK_ConstantUtility.reportsServiceHistory) {
                    if (tempInput != null && tempInput != '' && searchText != null && searchText != '') {
                        sQuery = sQuery + ' Where (SchedStartTime = LAST_N_DAYS:59 OR SchedStartTime = TODAY) ' + 'AND (ActualEndTime != null OR Status =\'Canceled\' OR Status =\'Cannot Complete\') AND Account.Name = ' + '\'' + AccName + '\'' + ' AND (AppointmentNumber LIKE ' + tempInput + ' OR WK_Services__c LIKE ' + tempInput + ' OR Status LIKE ' + tempInput + ')' + ' ORDER BY SchedStartTime DESC';
                    } else {
                        sQuery = sQuery + ' Where (SchedStartTime = LAST_N_DAYS:59 OR SchedStartTime = TODAY) ' + 'AND (ActualEndTime != null OR Status =\'Canceled\' OR Status =\'Cannot Complete\') AND Account.Name = ' + '\'' + AccName + '\'' + ' ORDER BY SchedStartTime DESC';
                    }
                } else if (selectedType == WK_ConstantUtility.reportsValetTrashViolations) {
                    if (tempInput != null && tempInput != '' && searchText != null && searchText != '') {
                        sQuery = sQuery + ' Where (CreatedDate = LAST_N_DAYS:59 OR CreatedDate = TODAY) ' + 'AND WK_Status__c= \'Approved\' AND WK_Service_Appointment__r.Account.Name = ' + '\'' + AccName + '\'' + ' AND (Unit__c LIKE ' + tempInput + ' OR Name LIKE ' + tempInput + ' OR Violation_Type__c LIKE ' + tempInput + ' OR WK_PM_Status__c LIKE ' + tempInput + ')' + ' AND Violation_Type__c NOT IN (\'5-Day violation tracking system\') ORDER BY CreatedDate DESC';
                    } else {
                        sQuery = sQuery + ' Where (CreatedDate = LAST_N_DAYS:59 OR CreatedDate = TODAY) ' + 'AND WK_Status__c= \'Approved\' AND WK_Service_Appointment__r.Account.Name = ' + '\'' + AccName + '\'' + ' AND Violation_Type__c NOT IN (\'5-Day violation tracking system\') ORDER BY CreatedDate DESC';

                    }
                } else if (selectedType == WK_ConstantUtility.reports5dayViolationsTSys) {
                    if (tempInput != null && tempInput != '' && searchText != null && searchText != '') {
                        sQuery = sQuery + ' Where (CreatedDate = LAST_N_DAYS:59 OR CreatedDate = TODAY) ' + 'AND WK_Status__c= \'Approved\' AND WK_Service_Appointment__r.Account.Name = ' + '\'' + AccName + ' AND (Unit__c LIKE ' + tempInput + ' OR Name LIKE ' + tempInput + ' OR Violation_Type__c LIKE ' + tempInput + ' OR WK_PM_Status__c LIKE ' + tempInput + ')' + '\'' + ' AND Violation_Type__c = \'5-Day violation tracking system\' ORDER BY CreatedDate DESC';
                    } else {
                        sQuery = sQuery + ' Where (CreatedDate = LAST_N_DAYS:59 OR CreatedDate = TODAY) ' + 'AND WK_Status__c= \'Approved\' AND WK_Service_Appointment__r.Account.Name = ' + '\'' + AccName + '\'' + ' AND Violation_Type__c = \'5-Day violation tracking system\' ORDER BY CreatedDate DESC';

                    }
                } else if (selectedType.equals(WK_ConstantUtility.reportsClosedInquiries)) {
                    if (tempInput != null && tempInput != '' && searchText != null && searchText != '') {
                        sQuery = sQuery + ' WHERE (ClosedDate = LAST_N_DAYS:59 OR ClosedDate = TODAY) AND Account.Name = \'' + AccName + '\' AND Status = \'' + WK_ConstantUtility.CASE_CLOSED_STATUS + '\'' + ' AND (CaseNumber LIKE ' + tempInput + ' OR Type LIKE ' + tempInput + ' OR Sub_Type__c LIKE ' + tempInput + ' OR Status LIKE ' + tempInput + ')' + ' ORDER BY CreatedDate DESC';
                    } else {
                        sQuery = sQuery + ' WHERE (ClosedDate = LAST_N_DAYS:59 OR ClosedDate = TODAY) AND Account.Name = \'' + AccName + '\' AND Status = \'' + WK_ConstantUtility.CASE_CLOSED_STATUS + '\' ORDER BY CreatedDate DESC';
                    }
                } else if (selectedType.equals(WK_ConstantUtility.reportsOpenInquiries)) {
                    if (tempInput != null && tempInput != '' && searchText != null && searchtext != '') {
                        sQuery = sQuery + ' WHERE (CreatedDate = LAST_N_DAYS:59 OR CreatedDate = TODAY) AND Account.Name = \'' + AccName + '\' AND Status NOT IN (\'' + WK_ConstantUtility.CASE_CLOSED_STATUS + '\')' + ' AND (CaseNumber LIKE ' + tempInput + ' OR Type LIKE ' + tempInput + ' OR Sub_Type__c LIKE ' + tempInput + ' OR Status LIKE ' + tempInput + ')' + ' ORDER BY CreatedDate DESC';
                    } else {
                        sQuery = sQuery + ' WHERE (CreatedDate = LAST_N_DAYS:59 OR CreatedDate = TODAY) AND Account.Name = \'' + AccName + '\' AND Status NOT IN (\'' + WK_ConstantUtility.CASE_CLOSED_STATUS + '\') ORDER BY CreatedDate DESC';
                    }
                } else {
                    sQuery = sQuery + ' Where (SchedStartTime = LAST_N_DAYS:59 OR SchedStartTime = TODAY) ' + 'AND (WK_Services__c LIKE \'%Valet Trash%\'  OR WK_Services__c LIKE \'%Curbside Pickup%\') AND Account.Name = ' + '\'' + AccName + '\'' + ' AND ActualEndTime != null' + ' ORDER BY SchedStartTime DESC';
                }
            } else if (duration == WK_ConstantUtility.reportsLast90Days && selectedType != WK_ConstantUtility.reportsUpcomingServices) {
                if (selectedType == WK_ConstantUtility.reportsServiceHistory) {
                    if (tempInput != null && tempInput != '' && searchText != null && searchText != '') {
                        sQuery = sQuery + ' Where (SchedStartTime = LAST_N_DAYS:89 OR SchedStartTime = TODAY) ' + 'AND (ActualEndTime != null OR Status =\'Canceled\' OR Status =\'Cannot Complete\') AND Account.Name = ' + '\'' + AccName + '\'' + ' AND (AppointmentNumber LIKE ' + tempInput + ' OR WK_Services__c LIKE ' + tempInput + ' OR Status LIKE ' + tempInput + ')' + ' ORDER BY SchedStartTime DESC';
                    } else {
                        sQuery = sQuery + ' Where (SchedStartTime = LAST_N_DAYS:89 OR SchedStartTime = TODAY) ' + 'AND (ActualEndTime != null OR Status =\'Canceled\' OR Status =\'Cannot Complete\') AND Account.Name = ' + '\'' + AccName + '\'' + ' ORDER BY SchedStartTime DESC';
                    }
                } else if (selectedType == WK_ConstantUtility.reportsValetTrashViolations) {
                    if (tempInput != null && tempInput != '' && searchText != null && searchText != '') {
                        sQuery = sQuery + ' Where (CreatedDate = LAST_N_DAYS:89 OR CreatedDate = TODAY) ' + 'AND WK_Status__c  = \'Approved\' AND WK_Service_Appointment__r.Account.Name = ' + '\'' + AccName + '\'' + ' AND (Unit__c LIKE ' + tempInput + ' OR Name LIKE ' + tempInput + ' OR Violation_Type__c LIKE ' + tempInput + ' OR WK_PM_Status__c LIKE ' + tempInput + ')' + ' AND Violation_Type__c NOT IN (\'5-Day violation tracking system\') ORDER BY CreatedDate DESC';
                    } else {
                        sQuery = sQuery + ' Where (CreatedDate = LAST_N_DAYS:89 OR CreatedDate = TODAY) ' + 'AND WK_Status__c  = \'Approved\' AND WK_Service_Appointment__r.Account.Name = ' + '\'' + AccName + '\'' + ' AND Violation_Type__c NOT IN (\'5-Day violation tracking system\') ORDER BY CreatedDate DESC';

                    }
                } else if (selectedType == WK_ConstantUtility.reports5dayViolationsTSys) {
                    if (tempInput != null && tempInput != '' && searchText != null && searchText != '') {
                        sQuery = sQuery + ' Where (CreatedDate = LAST_N_DAYS:89 OR CreatedDate = TODAY) ' + 'AND WK_Status__c  = \'Approved\' AND WK_Service_Appointment__r.Account.Name = ' + '\'' + AccName + ' AND (Unit__c LIKE ' + tempInput + ' OR Name LIKE ' + tempInput + ' OR Violation_Type__c LIKE ' + tempInput + ' OR WK_PM_Status__c LIKE ' + tempInput + ')' + '\'' + ' AND Violation_Type__c = \'5-Day violation tracking system\' ORDER BY CreatedDate DESC';
                    } else {
                        sQuery = sQuery + ' Where (CreatedDate = LAST_N_DAYS:89 OR CreatedDate = TODAY) ' + 'AND WK_Status__c  = \'Approved\' AND WK_Service_Appointment__r.Account.Name = ' + '\'' + AccName + '\'' + ' AND Violation_Type__c = \'5-Day violation tracking system\' ORDER BY CreatedDate DESC';

                    }
                } else if (selectedType.equals(WK_ConstantUtility.reportsClosedInquiries)) {
                    if (tempInput != null && tempInput != '' && searchText != null && searchText != '') {
                        sQuery = sQuery + ' WHERE (ClosedDate = LAST_N_DAYS:89 OR ClosedDate = TODAY) AND Account.Name = \'' + AccName + '\' AND Status = \'' + WK_ConstantUtility.CASE_CLOSED_STATUS + '\'' + ' AND (CaseNumber LIKE ' + tempInput + ' OR Type LIKE ' + tempInput + ' OR Sub_Type__c LIKE ' + tempInput + ' OR Status LIKE ' + tempInput + ')' + ' ORDER BY CreatedDate DESC';
                    } else {
                        sQuery = sQuery + ' WHERE (ClosedDate = LAST_N_DAYS:89 OR ClosedDate = TODAY) AND Account.Name = \'' + AccName + '\' AND Status = \'' + WK_ConstantUtility.CASE_CLOSED_STATUS + '\' ORDER BY CreatedDate DESC';
                    }
                } else if (selectedType.equals(WK_ConstantUtility.reportsOpenInquiries)) {
                    if (tempInput != null && tempInput != '' && searchText != null && searchText != '') {
                        sQuery = sQuery + ' WHERE (CreatedDate = LAST_N_DAYS:89 OR CreatedDate = TODAY) AND Account.Name = \'' + AccName + '\' AND Status NOT IN (\'' + WK_ConstantUtility.CASE_CLOSED_STATUS + '\')' + ' AND (CaseNumber LIKE ' + tempInput + ' OR Type LIKE ' + tempInput + ' OR Sub_Type__c LIKE ' + tempInput + ' OR Status LIKE ' + tempInput + ')' + ' ORDER BY CreatedDate DESC';
                    } else {
                        sQuery = sQuery + ' WHERE (CreatedDate = LAST_N_DAYS:89 OR CreatedDate = TODAY) AND Account.Name = \'' + AccName + '\' AND Status NOT IN (\'' + WK_ConstantUtility.CASE_CLOSED_STATUS + '\') ORDER BY CreatedDate DESC';
                    }
                } else {
                    if (tempInput != null && tempInput != '' && searchText != null && searchText != '') {
                        sQuery = sQuery + ' Where (SchedStartTime = LAST_N_DAYS:89 OR SchedStartTime = TODAY)' + 'AND (WK_Services__c LIKE \'%Valet Trash%\' OR WK_Services__c LIKE \'%Curbside Pickup%\') AND Account.Name = ' + '\'' + AccName + '\'' + ' AND ActualEndTime != null' + ' AND ( AppointmentNumber LIKE ' + tempInput + ' OR WK_Duration__c LIKE ' + tempInput + ')' + ' ORDER BY SchedStartTime DESC';
                    } else {
                        sQuery = sQuery + ' Where (SchedStartTime = LAST_N_DAYS:89 OR SchedStartTime = TODAY)' + 'AND (WK_Services__c LIKE \'%Valet Trash%\' OR WK_Services__c LIKE \'%Curbside Pickup%\') AND Account.Name = ' + '\'' + AccName + '\'' + ' AND ActualEndTime != null' + ' ORDER BY SchedStartTime DESC';
                    }
                }

            } else if (duration == WK_ConstantUtility.reportsPast12months && selectedType != WK_ConstantUtility.reportsUpcomingServices) {
                if (selectedType == WK_ConstantUtility.reportsServiceHistory) {
                    if (tempInput != null && tempInput != '' && searchText != null && searchText != '') {
                        sQuery = sQuery + ' Where (SchedStartTime = LAST_N_MONTHS:11 OR SchedStartTime = THIS_MONTH) ' + 'AND (ActualEndTime != null OR Status =\'Canceled\' OR Status =\'Cannot Complete\') AND Account.Name = ' + '\'' + AccName + '\'' + ' AND (AppointmentNumber LIKE ' + tempInput + ' OR WK_Services__c LIKE ' + tempInput + ' OR Status LIKE ' + tempInput + ')' + ' ORDER BY SchedStartTime DESC';
                    } else {
                        sQuery = sQuery + ' Where (SchedStartTime = LAST_N_MONTHS:11 OR SchedStartTime = THIS_MONTH) ' + 'AND (ActualEndTime != null OR Status =\'Canceled\' OR Status =\'Cannot Complete\') AND Account.Name = ' + '\'' + AccName + '\'' + ' ORDER BY SchedStartTime DESC';
                    }
                } else if (selectedType == WK_ConstantUtility.reportsValetTrashViolations) {
                    if (tempInput != null && tempInput != '' && searchText != null && searchText != '') {
                        sQuery = sQuery + ' Where (CreatedDate = LAST_N_MONTHS:11 OR CreatedDate = THIS_MONTH) ' + 'AND WK_Status__c = \'Approved\' AND WK_Service_Appointment__r.Account.Name = ' + '\'' + AccName + '\'' + ' AND (Unit__c LIKE ' + tempInput + ' OR Name LIKE ' + tempInput + ' OR Violation_Type__c LIKE ' + tempInput + ' OR WK_PM_Status__c LIKE ' + tempInput + ')' + ' AND Violation_Type__c NOT IN (\'5-Day violation tracking system\') ORDER BY CreatedDate DESC';
                        System.debug('++++++++++++++++ ' + tempInput + '--------' + searchText);
                    } else {
                        sQuery = sQuery + ' Where (CreatedDate = LAST_N_MONTHS:11 OR CreatedDate = THIS_MONTH) ' + 'AND WK_Status__c = \'Approved\' AND WK_Service_Appointment__r.Account.Name = ' + '\'' + AccName + '\'' + ' AND Violation_Type__c NOT IN (\'5-Day violation tracking system\') ORDER BY CreatedDate DESC';
                    }
                } else if (selectedType == WK_ConstantUtility.reports5dayViolationsTSys) {
                    if (tempInput != null && tempInput != '' && searchText != null && searchText != '') {
                        sQuery = sQuery + ' Where (CreatedDate = LAST_N_MONTHS:11 OR CreatedDate = THIS_MONTH) ' + 'AND WK_Status__c = \'Approved\' AND WK_Service_Appointment__r.Account.Name = ' + '\'' + AccName + '\'' + ' AND (Unit__c LIKE ' + tempInput + ' OR Name LIKE ' + tempInput + ' OR Violation_Type__c LIKE ' + tempInput + ' OR WK_PM_Status__c LIKE ' + tempInput + ')' + ' AND Violation_Type__c = \'5-Day violation tracking system\' ORDER BY CreatedDate DESC';
                    } else {
                        sQuery = sQuery + ' Where (CreatedDate = LAST_N_MONTHS:11 OR CreatedDate = THIS_MONTH) ' + 'AND WK_Status__c = \'Approved\' AND WK_Service_Appointment__r.Account.Name = ' + '\'' + AccName + '\'' + ' AND Violation_Type__c = \'5-Day violation tracking system\' ORDER BY CreatedDate DESC';


                    }
                } else if (selectedType.equals(WK_ConstantUtility.reportsClosedInquiries)) {
                    if (tempInput != null && tempInput != '') {
                        sQuery = sQuery + ' WHERE (ClosedDate = LAST_N_MONTHS:11 OR ClosedDate = THIS_MONTH) AND Account.Name = \'' + AccName + '\' AND Status = \'' + WK_ConstantUtility.CASE_CLOSED_STATUS + '\'' + ' AND (CaseNumber LIKE ' + tempInput + ' OR Type LIKE ' + tempInput + ' OR Sub_Type__c LIKE ' + tempInput + ' OR Status LIKE ' + tempInput + ')' + ' ORDER BY CreatedDate DESC';
                    } else {
                        sQuery = sQuery + ' WHERE (ClosedDate = LAST_N_MONTHS:11 OR ClosedDate = THIS_MONTH) AND Account.Name = \'' + AccName + '\' AND Status = \'' + WK_ConstantUtility.CASE_CLOSED_STATUS + '\' ORDER BY CreatedDate DESC';
                    }
                } else if (selectedType.equals(WK_ConstantUtility.reportsOpenInquiries)) {
                    if (tempInput != null && tempInput != '' && searchText != null && searchText != '') {
                        sQuery = sQuery + ' WHERE (CreatedDate = LAST_N_MONTHS:11 OR CreatedDate = THIS_MONTH) AND Account.Name = \'' + AccName + '\' AND Status NOT IN (\'' + WK_ConstantUtility.CASE_CLOSED_STATUS + '\')' + ' AND (CaseNumber LIKE ' + tempInput + ' OR Type LIKE ' + tempInput + ' OR Sub_Type__c LIKE ' + tempInput + ' OR Status LIKE ' + tempInput + ')' + ' ORDER BY CreatedDate DESC';
                    } else {
                        sQuery = sQuery + ' WHERE (CreatedDate = LAST_N_MONTHS:11 OR CreatedDate = THIS_MONTH) AND Account.Name = \'' + AccName + '\' AND Status NOT IN (\'' + WK_ConstantUtility.CASE_CLOSED_STATUS + '\') ORDER BY CreatedDate DESC';
                    }
                } else {
                    if (tempInput != null && tempInput != '' && searchText != null && searchText != '') {
                        sQuery = sQuery + ' Where (SchedStartTime = LAST_N_MONTHS:11 OR SchedStartTime = THIS_MONTH) ' + 'AND (WK_Services__c LIKE \'%Valet Trash%\' OR WK_Services__c LIKE \'%Curbside Pickup%\') AND Account.Name = ' + '\'' + AccName + '\'' + ' AND ActualEndTime != null' + ' AND ( AppointmentNumber LIKE ' + tempInput + ' OR WK_Duration__c LIKE ' + tempInput + ')' + ' ORDER BY SchedStartTime DESC';
                    } else {
                        sQuery = sQuery + ' Where (SchedStartTime = LAST_N_MONTHS:11 OR SchedStartTime = THIS_MONTH) ' + 'AND (WK_Services__c LIKE \'%Valet Trash%\' OR WK_Services__c LIKE \'%Curbside Pickup%\') AND Account.Name = ' + '\'' + AccName + '\'' + ' AND ActualEndTime != null' + ' ORDER BY SchedStartTime DESC';
                    }
                }
            }
            //DE9759 End- Change by Himanshu all queries except Future Services
            else if (duration == WK_ConstantUtility.reportsSelectDateRange && selectedType != WK_ConstantUtility.reportsUpcomingServices) {
                if (startDate != null && endDate != null) {
                    if (selectedType == WK_ConstantUtility.reportsServiceHistory) {
                        DateTime dtStart = datetime.newInstance(startDate.year(), startDate.month(), startDate.day());
                        //changes added as part of DE9044 by Anush
                        //DateTime dtEnd = datetime.newInstance(endDate.year(), endDate.month(),endDate.day());

                        DateTime dtEnd = datetime.newInstance((endDate.addDays(1)).year(), (endDate.addDays(1)).month(), (endDate.addDays(1)).day());
                        String dateTimeFormat = dtStart.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
                        String dateTimeFormatEnd = dtEnd.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
                        //  String dateTimeFormat = dtStart.formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'');
                        // String dateTimeFormatEnd = dtEnd.formatGMT('yyyy-MM-dd\'T\'23:59:59\'Z\'');
                        System.debug('-------------------------------- ' + dateTimeFormat + ';;;;;; ' + dateTimeFormatEnd);
                        if (tempInput != null && tempInput != '' && searchText != null && searchText != '') {
                            sQuery = sQuery + ' Where SchedStartTime >= ' + dateTimeFormat + ' AND SchedStartTime <= ' + dateTimeFormatEnd + ' AND (ActualEndTime != null OR Status =\'Canceled\' OR Status =\'Cannot Complete\') AND Account.Name = ' + '\'' + AccName + '\'' + ' AND (AppointmentNumber LIKE ' + tempInput + ' OR WK_Services__c LIKE ' + tempInput + ' OR Status LIKE ' + tempInput + ')' + ' ORDER BY SchedStartTime DESC';
                        } else {
                            sQuery = sQuery + ' Where SchedStartTime >= ' + dateTimeFormat + ' AND SchedStartTime <= ' + dateTimeFormatEnd + ' AND (ActualEndTime != null OR Status =\'Canceled\' OR Status =\'Cannot Complete\') AND Account.Name = ' + '\'' + AccName + '\'' + ' ORDER BY SchedStartTime DESC';
                        }
                    } else if (selectedType == WK_ConstantUtility.reportsValetTrashViolations || selectedType == WK_ConstantUtility.reports5dayViolationsTSys) {
                        //Date date.parse
                        DateTime dtStart = datetime.newInstance(startDate.year(), startDate.month(), startDate.day());
                        DateTime dtEnd = datetime.newInstance((endDate.addDays(1)).year(), (endDate.addDays(1)).month(), (endDate.addDays(1)).day());
                        //changes added as part of DE9044 by Anush
                        //DateTime dtEnd = datetime.newInstance(endDate.year(), endDate.month(),endDate.day());
                        String dateTimeFormat = dtStart.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
                        String dateTimeFormatEnd = dtEnd.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
                        //String dateTimeFormat = dtStart.formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'');
                        //String dateTimeFormatEnd = dtEnd.formatGMT('yyyy-MM-dd\'T\'23:59:59\'Z\'');
                        //changes of DE9044 ends
                        if (selectedType == WK_ConstantUtility.reportsValetTrashViolations) {
                            System.debug('++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ '+tempInput);
                            if (tempInput != null && tempInput != '' && searchText != null && searchText != '') {
                                sQuery = sQuery + ' Where CreatedDate >= ' + dateTimeFormat + ' AND CreatedDate <= ' + dateTimeFormatEnd + ' AND  WK_Status__c = \'Approved\' AND WK_Service_Appointment__r.Account.Name = ' + '\'' + AccName + ' AND (Unit__c LIKE ' + tempInput + ' OR Name LIKE ' + tempInput + ' OR Violation_Type__c LIKE ' + tempInput + ' OR WK_PM_Status__c LIKE ' + tempInput + ')' + '\'' + ' AND Violation_Type__c NOT IN (\'5-Day violation tracking system\') ORDER BY CreatedDate DESC';
                            } else {
                                sQuery = sQuery + ' Where CreatedDate >= ' + dateTimeFormat + ' AND CreatedDate <= ' + dateTimeFormatEnd + ' AND  WK_Status__c = \'Approved\' AND WK_Service_Appointment__r.Account.Name = ' + '\'' + AccName + '\'' + ' AND Violation_Type__c NOT IN (\'5-Day violation tracking system\') ORDER BY CreatedDate DESC';

                            }
                        } else {
                            if (tempInput != null && tempInput != '' && searchText != null && searchText != '') {
                                sQuery = sQuery + ' Where CreatedDate >= ' + dateTimeFormat + ' AND CreatedDate <= ' + dateTimeFormatEnd + ' AND  WK_Status__c = \'Approved\' AND WK_Service_Appointment__r.Account.Name = ' + '\'' + AccName + '\'' + ' AND (Unit__c LIKE ' + tempInput + ' OR Name LIKE ' + tempInput + ' OR Violation_Type__c LIKE ' + tempInput + ' OR WK_PM_Status__c LIKE ' + tempInput + ')' + ' AND Violation_Type__c =\'5-Day violation tracking system\' ORDER BY CreatedDate DESC';
                            } else {
                                sQuery = sQuery + ' Where CreatedDate >= ' + dateTimeFormat + ' AND CreatedDate <= ' + dateTimeFormatEnd + ' AND  WK_Status__c = \'Approved\' AND WK_Service_Appointment__r.Account.Name = ' + '\'' + AccName + '\'' + ' AND Violation_Type__c =\'5-Day violation tracking system\' ORDER BY CreatedDate DESC';

                            }
                        }
                    } else if (selectedType.equals(WK_ConstantUtility.reportsClosedInquiries) || selectedType.equals(WK_ConstantUtility.reportsOpenInquiries)) {
                        DateTime dtStart = datetime.newInstance(startDate.year(), startDate.month(), startDate.day());
                        DateTime dtEnd = datetime.newInstance((endDate.addDays(1)).year(), (endDate.addDays(1)).month(), (endDate.addDays(1)).day());
                        //changes added as part of DE9044 by Anush
                        //DateTime dtEnd = datetime.newInstance(endDate.year(), endDate.month(),endDate.day());
                        String dateTimeFormat = dtStart.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
                        String dateTimeFormatEnd = dtEnd.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
                        // String dateTimeFormat = dtStart.formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'');
                        // String dateTimeFormatEnd = dtEnd.formatGMT('yyyy-MM-dd\'T\'23:59:59\'Z\'');
                        if (tempInput != null && tempInput != '' && searchText != null && searchText != '') {
                            sQuery += selectedType.equals(WK_ConstantUtility.reportsClosedInquiries) ?
                                ' WHERE ClosedDate >= ' + dateTimeFormat + ' AND ClosedDate <= ' + dateTimeFormatEnd + ' AND Account.Name = \'' + AccName + '\' AND Status = \'' + WK_ConstantUtility.CASE_CLOSED_STATUS + '\'' + ' AND (CaseNumber LIKE ' + tempInput + ' OR Type LIKE ' + tempInput + ' OR Sub_Type__c LIKE ' + tempInput + ' OR Status LIKE ' + tempInput + ')' + ' ORDER BY CreatedDate DESC' :
                                ' WHERE CreatedDate >= ' + dateTimeFormat + ' AND CreatedDate <= ' + dateTimeFormatEnd + ' AND Account.Name = \'' + AccName + '\' AND Status NOT IN (\'' + WK_ConstantUtility.CASE_CLOSED_STATUS + '\')' + ' AND (CaseNumber LIKE ' + tempInput + ' OR Type LIKE ' + tempInput + ' OR Sub_Type__c LIKE ' + tempInput + ' OR Status LIKE ' + tempInput + ')' + ' ORDER BY CreatedDate DESC';
                        } else {
                            sQuery += selectedType.equals(WK_ConstantUtility.reportsClosedInquiries) ?
                                ' WHERE ClosedDate >= ' + dateTimeFormat + ' AND ClosedDate <= ' + dateTimeFormatEnd + ' AND Account.Name = \'' + AccName + '\' AND Status = \'' + WK_ConstantUtility.CASE_CLOSED_STATUS + '\' ORDER BY CreatedDate DESC' :
                                ' WHERE CreatedDate >= ' + dateTimeFormat + ' AND CreatedDate <= ' + dateTimeFormatEnd + ' AND Account.Name = \'' + AccName + '\' AND Status NOT IN (\'' + WK_ConstantUtility.CASE_CLOSED_STATUS + '\') ORDER BY CreatedDate DESC';
                        }
                    } else {

                        DateTime dtStart = datetime.newInstance(startDate.year(), startDate.month(), startDate.day());
                        DateTime dtEnd = datetime.newInstance((endDate.addDays(1)).year(), (endDate.addDays(1)).month(), (endDate.addDays(1)).day());
                        //changes added as part of DE9044 by Anush
                        //DateTime dtEnd = datetime.newInstance(endDate.year(), endDate.month(),endDate.day());
                        String dateTimeFormat = dtStart.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
                        String dateTimeFormatEnd = dtEnd.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
                        // String dateTimeFormat = dtStart.formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'');
                        // String dateTimeFormatEnd = dtEnd.formatGMT('yyyy-MM-dd\'T\'23:59:59\'Z\'');
                        if (tempInput != null && tempInput != '' && searchText != null && searchText != '') {
                            sQuery = sQuery + ' Where SchedStartTime >= ' + dateTimeFormat + ' AND SchedStartTime <= ' + dateTimeFormatEnd + 'AND (WK_Services__c LIKE \'%Valet Trash%\' OR WK_Services__c LIKE \'%Curbside Pickup%\') AND Account.Name = ' + '\'' + AccName + '\'' + ' AND ActualEndTime != null' + ' AND ( AppointmentNumber LIKE ' + tempInput + ' OR WK_Duration__c LIKE ' + tempInput + ')' + ' ORDER BY SchedStartTime DESC';
                        } else {
                            sQuery = sQuery + ' Where SchedStartTime >= ' + dateTimeFormat + ' AND SchedStartTime <= ' + dateTimeFormatEnd + 'AND (WK_Services__c LIKE \'%Valet Trash%\' OR WK_Services__c LIKE \'%Curbside Pickup%\') AND Account.Name = ' + '\'' + AccName + '\'' + ' AND ActualEndTime != null' + ' ORDER BY SchedStartTime DESC';
                        }
                    }

                } else if (startDateTime != null && endDateTime != null) {
                    if (selectedType == WK_ConstantUtility.reportsServiceHistory) {
                        //changes added as part of DE9044 by Anush
                        String dateTimeFormat = startDateTime.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
                        String dateTimeFormatEnd = endDateTime.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
                        //String dateTimeFormat = startDateTime.formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'');
                        // String dateTimeFormatEnd = endDateTime.formatGMT('yyyy-MM-dd\'T\'23:59:59\'Z\'');
                        //changes of DE9044 ends here
                        sQuery = sQuery + ' Where SchedStartTime >= ' + dateTimeFormat + ' AND SchedStartTime <= ' + dateTimeFormatEnd + ' AND (ActualEndTime != null OR Status =\'Canceled\' OR Status =\'Cannot Complete\') AND Account.Name = ' + '\'' + AccName + '\'' + ' ORDER BY SchedStartTime DESC';
                    } else if (selectedType == WK_ConstantUtility.reportsValetTrashViolations || selectedType == WK_ConstantUtility.reports5dayViolationsTSys) {
                        //changes added as part of DE9044 by Anush
                        String dateTimeFormat = startDateTime.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
                        String dateTimeFormatEnd = endDateTime.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
                        //String dateTimeFormat = startDateTime.formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'');
                        //String dateTimeFormatEnd = endDateTime.formatGMT('yyyy-MM-dd\'T\'23:59:59\'Z\'');
                        //changes of DE9044 ends here
                        if (selectedType == WK_ConstantUtility.reportsValetTrashViolations) {
                            sQuery = sQuery + ' Where CreatedDate >= ' + dateTimeFormat + ' AND CreatedDate <= ' + dateTimeFormatEnd + ' AND  WK_Status__c = \'Approved\' AND WK_Service_Appointment__r.Account.Name = ' + '\'' + AccName + '\'' + ' AND Violation_Type__c NOT IN (\'5-Day violation tracking system\') ORDER BY CreatedDate DESC';
                        } else {
                            sQuery = sQuery + ' Where CreatedDate >= ' + dateTimeFormat + ' AND CreatedDate <= ' + dateTimeFormatEnd + ' AND  WK_Status__c = \'Approved\' AND WK_Service_Appointment__r.Account.Name = ' + '\'' + AccName + '\'' + ' AND Violation_Type__c = \'5-Day violation tracking system\' ORDER BY CreatedDate DESC';
                        }
                    } else if (selectedType.equals(WK_ConstantUtility.reportsClosedInquiries) || selectedType.equals(WK_ConstantUtility.reportsOpenInquiries)) {
                        //changes added as part of DE9044 by Anush
                        String dateTimeFormat = startDateTime.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
                        String dateTimeFormatEnd = endDateTime.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
                        //String dateTimeFormat = startDateTime.formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'');
                        // String dateTimeFormatEnd = endDateTime.formatGMT('yyyy-MM-dd\'T\'23:59:59\'Z\'');
                        //changes of DE9044 ends here
                        sQuery += selectedType.equals(WK_ConstantUtility.reportsClosedInquiries) ?
                            ' WHERE ClosedDate >= ' + dateTimeFormat + ' AND ClosedDate <= ' + dateTimeFormatEnd + ' AND Account.Name = \'' + AccName + '\' AND Status = \'' + WK_ConstantUtility.CASE_CLOSED_STATUS + '\' ORDER BY CreatedDate DESC' :
                            ' WHERE CreatedDate >= ' + dateTimeFormat + ' AND CreatedDate <= ' + dateTimeFormatEnd + ' AND Account.Name = \'' + AccName + '\' AND Status NOT IN (\'' + WK_ConstantUtility.CASE_CLOSED_STATUS + '\') ORDER BY CreatedDate DESC';
                    } else {
                        //changes added as part of DE9044 by Anush
                        String dateTimeFormat = startDateTime.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
                        String dateTimeFormatEnd = endDateTime.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
                        //String dateTimeFormat = startDateTime.formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'');
                        //String dateTimeFormatEnd = endDateTime.formatGMT('yyyy-MM-dd\'T\'23:59:59\'Z\'');
                        if (tempInput != null && tempInput != '' && searchText != null && searchText != '') {
                            sQuery = sQuery + ' Where SchedStartTime >= ' + dateTimeFormat + ' AND SchedStartTime <= ' + dateTimeFormatEnd + 'AND (WK_Services__c LIKE \'%Valet Trash%\' OR WK_Services__c LIKE \'%Curbside Pickup%\') AND Account.Name = ' + '\'' + AccName + '\'' + ' AND ActualEndTime != null' + ' AND ( AppointmentNumber LIKE ' + tempInput + ' OR WK_Duration__c LIKE ' + tempInput + ')' + ' ORDER BY SchedStartTime DESC';
                        } else {
                            sQuery = sQuery + ' Where SchedStartTime >= ' + dateTimeFormat + ' AND SchedStartTime <= ' + dateTimeFormatEnd + 'AND (WK_Services__c LIKE \'%Valet Trash%\' OR WK_Services__c LIKE \'%Curbside Pickup%\') AND Account.Name = ' + '\'' + AccName + '\'' + ' AND ActualEndTime != null' + ' ORDER BY SchedStartTime DESC';
                        }
                    }
                }

            }
            //code start - logic for Next 30 Days for Upcoming Services Report
            else if (selectedType == WK_ConstantUtility.reportsUpcomingServices) {
                if (duration == WK_ConstantUtility.reportsNext30Days) {
                    //duration = WK_ConstantUtility.reportsNext30Days;
                    system.debug('####NEXT 30 DAYS');

                    //changed cuz of DE9265
                    //sQuery = sQuery + ' where (SchedStartTime = TODAY OR SchedStartTime = NEXT_N_DAYS:30) '+'AND Status !=\'Canceled\' AND Account.Name = '+'\''+ AccName+'\''+' ORDER BY SchedStartTime DESC';
                    if (tempInput != null && tempInput != '' && searchText != null && searchText != '') {
                        sQuery = sQuery + ' where (SchedStartTime = TODAY OR SchedStartTime = NEXT_N_DAYS:30) ' + 'AND Status !=\'Canceled\' AND Account.Name = ' + '\'' + AccName + '\'' + ' AND (AppointmentNumber LIKE ' + tempInput + ' OR WK_Services__c LIKE ' + tempInput + ' OR Status LIKE ' + tempInput + ')' + ' ORDER BY SchedStartTime';
                    } else {
                        sQuery = sQuery + ' where (SchedStartTime = TODAY OR SchedStartTime = NEXT_N_DAYS:30) ' + 'AND Status !=\'Canceled\' AND Account.Name = ' + '\'' + AccName + '\'' + ' ORDER BY SchedStartTime';
                    }
                } else if (duration == WK_ConstantUtility.reportsSelectDateRange) {
                    if (startDate != null && endDate != null) {
                        if (startDate < System.Today()) {
                            //changes added as part of DE9044 by Anush
                            DateTime dtStart = datetime.newInstance(System.Today().year(), System.Today().month(), System.Today().day());
                            //DateTime dtEnd = datetime.newInstance(endDate.year(), endDate.month(),endDate.day());
                            DateTime dtEnd = datetime.newInstance((endDate.addDays(1)).year(), (endDate.addDays(1)).month(), (endDate.addDays(1)).day());
                            String dateTimeFormat = dtStart.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
                            String dateTimeFormatEnd = dtEnd.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
                            //String dateTimeFormat = dtStart.formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'');
                            //String dateTimeFormatEnd = dtEnd.formatGMT('yyyy-MM-dd\'T\'23:59:59\'Z\'');
                            //changes of DE9044 ends here 
                            //changed cuz of DE9265
                            //sQuery = sQuery + ' Where SchedStartTime >= ' + dateTimeFormat+' AND SchedStartTime <= '+dateTimeFormatEnd+' AND Status !=\'Canceled\' AND Account.Name = '+'\''+ AccName+'\''+' ORDER BY SchedStartTime DESC';
                            if (tempInput != null && tempInput != '' && searchText != null && searchText != '') {
                                sQuery = sQuery + ' Where SchedStartTime >= ' + dateTimeFormat + ' AND SchedStartTime <= ' + dateTimeFormatEnd + ' AND Status !=\'Canceled\' AND Account.Name = ' + '\'' + AccName + '\'' + ' AND (AppointmentNumber LIKE ' + tempInput + ' OR WK_Services__c LIKE ' + tempInput + ' OR Status LIKE ' + tempInput + ')' + ' ORDER BY SchedStartTime';
                            } else {
                                sQuery = sQuery + ' Where SchedStartTime >= ' + dateTimeFormat + ' AND SchedStartTime <= ' + dateTimeFormatEnd + ' AND Status !=\'Canceled\' AND Account.Name = ' + '\'' + AccName + '\'' + ' ORDER BY SchedStartTime';
                            }
                        } else {
                            DateTime dtStart = datetime.newInstance(startDate.year(), startDate.month(), startDate.day());
                            //changes added as part of DE9044 by Anush
                            DateTime dtEnd = datetime.newInstance((endDate.addDays(1)).year(), (endDate.addDays(1)).month(), (endDate.addDays(1)).day());
                            //DateTime dtEnd = datetime.newInstance(endDate.year(), endDate.month(),endDate.day());
                            String dateTimeFormat = dtStart.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
                            String dateTimeFormatEnd = dtEnd.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
                            //String dateTimeFormat = dtStart.formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'');
                            //String dateTimeFormatEnd = dtEnd.formatGMT('yyyy-MM-dd\'T\'23:59:59\'Z\'');

                            //changed cuz of DE9265
                            //sQuery = sQuery + ' Where SchedStartTime >= ' + dateTimeFormat+' AND SchedStartTime <= '+dateTimeFormatEnd+' AND Status !=\'Canceled\' AND Account.Name = '+'\''+ AccName+'\''+' ORDER BY SchedStartTime DESC';
                            if (tempInput != null && tempInput != '' && searchText != null && searchText != '') {
                                sQuery = sQuery + ' Where SchedStartTime >= ' + dateTimeFormat + ' AND SchedStartTime <= ' + dateTimeFormatEnd + ' AND Status !=\'Canceled\' AND Account.Name = ' + '\'' + AccName + '\'' + ' AND (AppointmentNumber LIKE ' + tempInput + ' OR WK_Services__c LIKE ' + tempInput + ' OR Status LIKE ' + tempInput + ')' + ' ORDER BY SchedStartTime';
                            } else {
                                sQuery = sQuery + ' Where SchedStartTime >= ' + dateTimeFormat + ' AND SchedStartTime <= ' + dateTimeFormatEnd + ' AND Status !=\'Canceled\' AND Account.Name = ' + '\'' + AccName + '\'' + ' ORDER BY SchedStartTime';
                            }
                        }
                    }
                }
            }
        }
        if (String.isNotBlank(sQuery)) {
            sQuery = sQuery + ' LIMIT 1000';
            System.debug('_________________ '+sQuery);
        }
        return sQuery;
    }

    /**************************************************************************** 
     * Detail: Method which populates the wrappers which gets displayed on the Page
     *****************************************************************************/
    public PageReference runReport() {
        system.debug('######AccountID inside run report' + accountId);
        listOfViolationWrapper = new List < violationWrapper > ();
        Id ownerId = UserInfo.getUserId();
        List < User > loggedUser = new List < User > ();
        List < Violation__c > lstOfVioRecs = new List < Violation__c > ();
        List < Contact > loggedInContact = new List < Contact > ();
        mapOfAttachments = new Map < Id, List < Attachment >> ();
        mapOfContentDocLinks = new Map < Id, List < ContentDocumentLink >> ();
        listOfAttachments = new List < Attachment > ();
        listOfContentDocLinks = new List < ContentDocumentLink > ();
        listOfCheckinWrapper = new List < assigResWrapper > ();
        listOfServiceHistoryWrapper = new List < serviceHistroyWrapper > ();
        upcomingServicesWrapperList = new List < upcomingServicesWrapper > ();
        String sQueryToRetrieve = '';
        String sQueryForPastMonths = '';
        Set < Id > lstOfVioIds = new Set < Id > ();
        List < Violation__c > listOfViolationRecs = new List < Violation__c > ();
        List < ServiceAppointment > listOfAssigResRecs = new List < ServiceAppointment > ();
        List < ServiceAppointment > listOfAsResRecs = new List < ServiceAppointment > ();
        List < ServiceAppointment > listOfServiceAppRecs = new List < ServiceAppointment > ();
        List < ServiceAppointment > listOfUpcomingServiceAppRecs = new List < ServiceAppointment > ();
        List < ServiceAppointment > listOfSerAppRecs = new List < ServiceAppointment > ();
        accountId = ApexPages.currentPage().getParameters().get('Id');
        try {
            loggedUser = [Select ContactId, name, email from User Where Id =: ownerId];
            if (loggedUser != null && !loggedUser.isEmpty()) {
                loggedInContact = [Select Id, Name, AccountId, Account.Name from Contact where Id =: loggedUser[0].ContactId];
            }
        } catch (QueryException qe) {
            System.debug('Query Failed ' + qe.getMessage());
        }

        /*  try{
                  if(accountId != null && accountId != ''){
                  List<Account> accNameRec = [Select id, name from Account where id =: accountId];
                 if(accNameRec != null && !accNameRec.isEmpty()) { 
                 AccName = accNameRec[0].name; 
             }
                  }  //else{
                   //   if(loggedInContact != null && !loggedInContact.isEmpty()) {
                  //    AccName = loggedInContact[0].Account.Name;
                   //   }
                //  }
         }
         catch(QueryException e){
              System.debug('Query Failed '+ e.getMessage());
         }*/

        List < Account > accNameRec = new List < Account > ([Select id, Name from Account where id =: accountId]);
        system.debug('#####accNameRec' + accNameRec);
        if (loggedInContact != null && !loggedInContact.isEmpty()) {
            system.debug('#####loggedInContact' + loggedInContact);
            if (accNameRec != null && !accNameRec.isEmpty()) {
                system.debug('#####inside IF');
                AccName = accNameRec[0].Name;
                accId = accNameRec[0].Id;
                system.debug('@@@@@Account Name' + AccName);
            } else {
                AccName = loggedInContact[0].Account.Name;
                accId = loggedInContact[0].AccountId;
                system.debug('######Account Name' + AccName);
            }
        }
        if (selectedType == WK_ConstantUtility.reportsValetTrashViolations) {
            if (duration == WK_ConstantUtility.reportsSelectDateRange) {
                if (startDate != null && endDate != null) {
                    sQueryToRetrieve = fetchViolationRecords();
                } else if (startDateTime != null && endDateTime != null) {
                    sQueryToRetrieve = fetchViolationRecords();
                } else {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, WK_ConstantUtility.validationMessageForSelectRange));
                    return null;
                }
            } else {
                sQueryToRetrieve = fetchViolationRecords();
            }
            try {
                listOfViolationRecs = Database.Query(sQueryToRetrieve);
                if (duration == WK_ConstantUtility.reportsPast12months) {
                    //Commented as part of DE9044 - Anush
                    //sQueryForPastMonths = 'Select id,Name,CreatedByID,LastModifiedByID,WK_Building__c,WK_Building__r.Name,Unit__c,Quantity__c,WK_Fine_Amount__c,WK_Add_Note__c,Violation_Type__c,CreatedDate,WK_PM_Status__c,WK_Status__c'+' from Violation__c Where CreatedDate = THIS_MONTH '+'AND WK_Status__c = \'Approved\' AND WK_Service_Appointment__r.Account.Name = '+'\''+ AccName+'\''+' AND Violation_Type__c NOT IN (\'5-Day violation tracking system\') ORDER BY CreatedDate DESC';
                    //lstOfVioRecs = Database.Query(sQueryForPastMonths);
                    //listOfViolationRecs.addAll(lstOfVioRecs);
                }
            } catch (QueryException qe) {
                System.debug('Query Failed ' + qe.getMessage());
            }
            if (listOfViolationRecs != null && !listOfViolationRecs.isEmpty()) {
                for (Violation__c vioRec: listOfViolationRecs) {
                    lstOfVioIds.add(vioRec.Id);
                }
                try {
                    listOfAttachments = [Select Id, Name, ParentId from Attachment where ParentId IN: listOfViolationRecs Order By CreatedDate DESC];
                    listOfContentDocLinks = [SELECT ContentDocument.LatestPublishedVersionId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId IN: lstOfVioIds Order By ContentDocument.LatestPublishedVersionId DESC];
                } catch (QueryException qe) {}
                if (listOfAttachments != null && !listOfAttachments.isEmpty()) {
                    for (Attachment attRec: listOfAttachments) {
                        if (!mapOfAttachments.containsKey(attRec.ParentId)) {
                            mapOfAttachments.put(attRec.ParentId, new List < Attachment > ());
                            mapOfAttachments.get(attRec.ParentId).add(attRec);
                        } else {
                            mapOfAttachments.get(attRec.ParentId).add(attRec);
                        }
                    }
                }
                if (listOfContentDocLinks != null && !listOfContentDocLinks.isEmpty()) {
                    for (ContentDocumentLink conDocRec: listOfContentDocLinks) {
                        if (!mapOfContentDocLinks.containsKey(conDocRec.LinkedEntityId)) {
                            mapOfContentDocLinks.put(conDocRec.LinkedEntityId, new List < ContentDocumentLink > ());
                            mapOfContentDocLinks.get(conDocRec.LinkedEntityId).add(conDocRec);
                        } else {
                            mapOfContentDocLinks.get(conDocRec.LinkedEntityId).add(conDocRec);
                        }
                    }
                }
                ChkMapKeyForAtt = String.valueof(mapOfAttachments.keyset()).replace('{', '').replace('{', '');
                ChkMapKeyForCont = String.valueof(mapOfContentDocLinks.keyset()).replace('{', '').replace('{', '');
                for (Violation__c vioRec: listOfViolationRecs) {
                    violationWrapper vioWrapper = new violationWrapper();
                    vioWrapper.vioName = vioRec.Name;
                    vioWrapper.vioId = vioRec.Id;
                    vioWrapper.vioUnit = vioRec.Unit__c;
                    vioWrapper.vioType = vioRec.Violation_Type__c;
                    vioWrapper.vioBuildingName = vioRec.WK_Building__r.Name;
                    if (vioRec.Quantity__c != null) {
                        vioWrapper.vioQuantity = String.valueOf(vioRec.Quantity__c);
                    }
                    if (vioRec.WK_Fine_Amount__c != null) {
                        vioWrapper.vioFineAmount = WK_ConstantUtility.dollarLabel + String.valueOf(vioRec.WK_Fine_Amount__c);
                    }
                    if (vioRec.WK_Add_Note__c != null && vioRec.WK_Add_Note__c != '') {
                        vioWrapper.vioNote = vioRec.WK_Add_Note__c;
                    }
                    vioWrapper.violationRecordWrapper = new Violation__c();
                    vioWrapper.violationRecordWrapper.Id = vioRec.Id;
                    System.debug('DATE ISSUE +++++++++++++++' + lstOfVioIds);
                    vioWrapper.createdDate = vioRec.CreatedDate.format(WK_ConstantUtility.dateFormat);
                    vioWrapper.vioStatus = vioRec.WK_PM_Status__c;
                    if ((mapOfAttachments != null && !mapOfAttachments.isEmpty()) || (mapOfContentDocLinks != null && !mapOfContentDocLinks.isEmpty())) {
                        if (mapOfAttachments.containsKey(vioRec.Id)) {
                            if (mapOfAttachments.get(vioRec.Id) != null && !mapOfAttachments.get(vioRec.Id).isEmpty()) {
                                vioWrapper.vioAttachmentId = mapOfAttachments.get(vioRec.Id)[0].Id;
                                if (mapOfAttachments.get(vioRec.Id).size() > 1) {
                                    vioWrapper.vioAttachmentId2 = mapOfAttachments.get(vioRec.Id)[1].Id;
                                }
                            }

                        } else if (mapOfContentDocLinks.containsKey(vioRec.Id)) {
                            if (mapOfContentDocLinks.get(vioRec.Id) != null && !mapOfContentDocLinks.get(vioRec.Id).isEmpty()) {
                                vioWrapper.vioContDocId = mapOfContentDocLinks.get(vioRec.Id)[0].ContentDocument.LatestPublishedVersionId;
                                vioWrapper.vioImageUrl = System.Label.WK_ImgUrlForViolations + vioWrapper.vioContDocId;
                                if (mapOfContentDocLinks.get(vioRec.Id).size() > 1) {
                                    vioWrapper.vioContDocId2 = mapOfContentDocLinks.get(vioRec.Id)[1].ContentDocument.LatestPublishedVersionId;
                                    vioWrapper.vioImageUrl2 = System.Label.WK_ImgUrlForViolations + vioWrapper.vioContDocId2;
                                }
                            }
                        }
                    }
                    listOfViolationWrapper.add(vioWrapper);
                }
                JSONString = JSON.serialize(listOfViolationWrapper);
            }
        } else if (selectedType == WK_ConstantUtility.reports5dayViolationsTSys) {
            if (duration == WK_ConstantUtility.reportsSelectDateRange) {
                if (startDate != null && endDate != null) {
                    sQueryToRetrieve = fetchViolationRecords();
                } else if (startDateTime != null && endDateTime != null) {
                    sQueryToRetrieve = fetchViolationRecords();
                } else {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, WK_ConstantUtility.validationMessageForSelectRange));
                    return null;
                }
            } else {
                sQueryToRetrieve = fetchViolationRecords();
            }
            run5dayViolationReport();
        } else if (selectedType == WK_ConstantUtility.reportsValetTrashCheckinCheckout) {
            if (duration == WK_ConstantUtility.reportsSelectDateRange) {
                if (startDate != null && endDate != null) {
                    sQueryToRetrieve = fetchViolationRecords();
                } else if (startDateTime != null && endDateTime != null) {
                    sQueryToRetrieve = fetchViolationRecords();
                } else {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, WK_ConstantUtility.validationMessageForSelectRange));
                    return null;
                }
            } else {
                sQueryToRetrieve = fetchViolationRecords();
            }
            try {
                listOfAssigResRecs = Database.Query(sQueryToRetrieve);
                if (duration == WK_ConstantUtility.reportsPast12months) {
                    //Commented as part of DE9044 - Anush
                    //sQueryForPastMonths = 'Select Id,AppointmentNumber,CreatedByID,SchedStartTime,ActualEndTime,WK_Account__c,AccountId,Account.Name,ActualStartTime,WK_Duration__c,WK_Services__c,Status'+' from ServiceAppointment Where SchedStartTime = THIS_MONTH '+'AND (WK_Services__c LIKE \'%Valet Trash%\' OR WK_Services__c LIKE \'%Curbside Pickup%\') AND Account.Name = '+'\''+ AccName+'\''+ ' AND ActualEndTime != null'+' ORDER BY SchedStartTime DESC';
                    //listOfAsResRecs = Database.Query(sQueryForPastMonths);
                    //listOfAssigResRecs.addAll(listOfAsResRecs);
                }
            } catch (QueryException qe) {
                System.debug('Query Failed ' + qe.getMessage());
            }
            if (listOfAssigResRecs != null && !listOfAssigResRecs.isEmpty()) {
                for (ServiceAppointment checkInRec: listOfAssigResRecs) {
                    assigResWrapper checkInWrapper = new assigResWrapper();
                    checkInWrapper.checkInAppointmentNumb = checkInRec.AppointmentNumber;
                    if (checkInRec.SchedStartTime != null) {
                        checkInWrapper.checkInSchDate = checkInRec.SchedStartTime.format(WK_ConstantUtility.dateFormat);
                    }

                    if (checkInRec.ActualStartTime != null) {
                        checkInWrapper.checkInTeamIn = checkInRec.ActualStartTime.format(WK_ConstantUtility.timeFormat);

                    }
                    if (checkInRec.ActualEndTime != null) {
                        checkInWrapper.checkInTeamOut = checkInRec.ActualEndTime.format(WK_ConstantUtility.timeFormat);

                    }
                    checkInWrapper.assignedResRecordWrapper = checkInRec;

                    checkInWrapper.checkInDuration = checkInRec.WK_Duration__c;

                    listOfCheckinWrapper.add(checkInWrapper);
                }
            }
        } else if (selectedType == WK_ConstantUtility.reportsServiceHistory) {
            if (duration == WK_ConstantUtility.reportsSelectDateRange) {
                if (startDate != null && endDate != null) {
                    sQueryToRetrieve = fetchViolationRecords();
                } else if (startDateTime != null && endDateTime != null) {
                    sQueryToRetrieve = fetchViolationRecords();
                } else {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, WK_ConstantUtility.validationMessageForSelectRange));
                    return null;
                }
            } else {
                sQueryToRetrieve = fetchViolationRecords();
            }
            try {
                listOfServiceAppRecs = Database.Query(sQueryToRetrieve);
                if (duration == WK_ConstantUtility.reportsPast12months) {
                    //Commented as part of DE9044 - Anush
                    //sQueryForPastMonths = 'Select Id,AppointmentNumber,CreatedByID,SchedStartTime,WK_Services__c,WK_Account__c,AccountId,Account.Name,Status'+' from ServiceAppointment Where SchedStartTime = THIS_MONTH '+'AND (ActualEndTime != null OR Status =\'Canceled\' OR Status =\'Cannot Complete\') AND Account.Name = '+'\''+ AccName+'\''+' ORDER BY SchedStartTime DESC';
                    //listOfSerAppRecs = Database.Query(sQueryForPastMonths);
                    //listOfServiceAppRecs.addAll(listOfSerAppRecs);
                }
            } catch (QueryException qe) {
                System.debug('Query Failed ' + qe.getMessage());
            }
            if (listOfServiceAppRecs != null && !listOfServiceAppRecs.isEmpty()) {
                for (ServiceAppointment serviceAppRec: listOfServiceAppRecs) {
                    serviceHistroyWrapper serviceAppWrapper = new serviceHistroyWrapper();
                    serviceAppWrapper.serviceAppAppointNo = serviceAppRec.AppointmentNumber;
                    if (serviceAppRec.SchedStartTime != null) {
                        serviceAppWrapper.serviceAppSchDate = serviceAppRec.SchedStartTime.format(WK_ConstantUtility.dateFormat);
                        serviceAppWrapper.serviceAppSchTime = serviceAppRec.SchedStartTime.format(WK_ConstantUtility.timeFormat);
                    }
                    serviceAppWrapper.serviceAppService = serviceAppRec.WK_Services__c;
                    serviceAppWrapper.serviceAppStatus = serviceAppRec.Status;
                    serviceAppWrapper.serviceAppRecordWrapper = serviceAppRec;
                    listOfServiceHistoryWrapper.add(serviceAppWrapper);
                }
            }
        } else if (selectedType == WK_ConstantUtility.reportsUpcomingServices) {
            /* if(duration== WK_ConstantUtility.reportsSelectDateRange) {
                    if(startDate != null && endDate != null) {
                        sQueryToRetrieve = fetchViolationRecords();
                    }
                    else if(startDateTime != null && endDateTime != null) {
                        sQueryToRetrieve = fetchViolationRecords();
                }
                else {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,WK_ConstantUtility.validationMessageForSelectRange));
                    return null;
                }
            }
                else {*/
            sQueryToRetrieve = fetchViolationRecords();
            system.debug('######sQueryToRetrieve' + sQueryToRetrieve);
            //  }
            //  try {
            listOfUpcomingServiceAppRecs = Database.Query(sQueryToRetrieve);
            system.debug('######listOfUpcomingServiceAppRecs' + listOfUpcomingServiceAppRecs);
            /*  if(duration == WK_ConstantUtility.reportsPast12months) {
                  sQueryForPastMonths = 'Select Id,AppointmentNumber,CreatedByID,SchedStartTime,WK_Services__c,WK_Account__c,AccountId,Account.Name,Status'+' from ServiceAppointment Where SchedStartTime = THIS_MONTH '+'AND (ActualEndTime != null OR Status =\'Canceled\' OR Status =\'Cannot Complete\') AND Account.Name = '+'\''+ AccName+'\''+' ORDER BY SchedStartTime DESC';
                  listOfSerAppRecs = Database.Query(sQueryForPastMonths);
                  listOfServiceAppRecs.addAll(listOfSerAppRecs);
              }*/
            // }
            //  catch(QueryException qe) {
            //     System.debug('Query Failed '+ qe.getMessage());
            //  }
            //  if(listOfUpcomingServiceAppRecs != null && !listOfUpcomingServiceAppRecs.isEmpty()) {
            for (ServiceAppointment serviceAppRec: listOfUpcomingServiceAppRecs) {
                upcomingServicesWrapper serviceAppWrapper = new upcomingServicesWrapper();
                serviceAppWrapper.serviceAppAppointNo = serviceAppRec.AppointmentNumber;
                if (serviceAppRec.SchedStartTime != null) {
                    serviceAppWrapper.serviceAppSchDate = serviceAppRec.SchedStartTime.format(WK_ConstantUtility.dateFormat);
                    serviceAppWrapper.serviceAppSchTime = serviceAppRec.SchedStartTime.format(WK_ConstantUtility.timeFormat);
                }
                serviceAppWrapper.serviceAppService = serviceAppRec.WK_Services__c;
                serviceAppWrapper.serviceAppStatus = serviceAppRec.Status;
                serviceAppWrapper.serviceAppRecordWrapper = serviceAppRec;
                upcomingServicesWrapperList.add(serviceAppWrapper);
                system.debug('####upcomingServicesWrapperList' + upcomingServicesWrapperList);
                //}
            }
        } else if (selectedType.equals(WK_ConstantUtility.reportsClosedInquiries)) {
            List < Case > listClosedInquiries = new List < Case > ();
            List < Case > listPast12ClosedEnquiries = new List < Case > ();
            listClosedInquiriesWrapper = new List < ClosedInquiriesWrapper > ();
            if (duration.equals(WK_ConstantUtility.reportsSelectDateRange)) {
                if ((startDate != null && endDate != null) || (startDateTime != null && endDateTime != null)) {
                    sQueryToRetrieve = fetchViolationRecords();
                } else {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, WK_ConstantUtility.validationMessageForSelectRange));
                    return null;
                }
            } else {
                sQueryToRetrieve = fetchViolationRecords();
            }
            try {
                listClosedInquiries = Database.Query(sQueryToRetrieve);
                if (duration.equals(WK_ConstantUtility.reportsPast12months)) {
                    //Commented as part of DE9044 - Anush
                    //sQueryForPastMonths = 'SELECT Id, CaseNumber,CreatedDate,Status,ClosedDate,Type,Sub_Type__c FROM Case WHERE ClosedDate = THIS_MONTH '+' AND Account.Name = \''+AccName+'\' AND Status = \''+WK_ConstantUtility.CASE_CLOSED_STATUS+'\' ORDER BY CreatedDate DESC';
                    //listPast12ClosedEnquiries = Database.Query(sQueryForPastMonths);
                    //listClosedInquiries.addAll(listPast12ClosedEnquiries);
                }
            } catch (QueryException qe) {
                //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Some error occurred. Please try again later.'));
            }
            if (!listClosedInquiries.isEmpty()) {
                for (Case closedinq: listClosedInquiries) {
                    ClosedInquiriesWrapper ciwrap = new ClosedInquiriesWrapper(
                        closedInq.Id, closedinq.Type, closedinq.Sub_Type__c, closedinq.Status,
                        (closedinq.CreatedDate != null ? closedinq.CreatedDate.format(WK_ConstantUtility.dateFormat) : ''), closedinq.CaseNumber,
                        (closedinq.ClosedDate != null ? closedinq.ClosedDate.format(WK_ConstantUtility.dateFormat) : ''));
                    listClosedInquiriesWrapper.add(ciwrap);
                }
                //JSONString = JSON.serialize(listClosedInquiriesWrapper);
            }
        } else if (selectedType.equals(WK_ConstantUtility.reportsOpenInquiries)) {
            List < Case > listOpenInquiries = new List < Case > ();
            List < Case > listPast12OpenEnquiries = new List < Case > ();
            listOpenInquiriesWrapper = new List < OpenInquiriesWrapper > ();
            if (duration.equals(WK_ConstantUtility.reportsSelectDateRange)) {
                if ((startDate != null && endDate != null) || (startDateTime != null && endDateTime != null)) {
                    sQueryToRetrieve = fetchViolationRecords();
                } else {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, WK_ConstantUtility.validationMessageForSelectRange));
                    return null;
                }
            } else {
                sQueryToRetrieve = fetchViolationRecords();
            }
            try {
                listOpenInquiries = Database.Query(sQueryToRetrieve);
                if (duration.equals(WK_ConstantUtility.reportsPast12months)) {
                    //Commented as part of DE9044 - Anush
                    //sQueryForPastMonths = 'SELECT Id, CaseNumber, CreatedDate,Status,Type,Sub_Type__c FROM Case Where CreatedDate = THIS_MONTH '+' AND Account.Name = \''+AccName+'\' AND Status NOT IN (\''+WK_ConstantUtility.CASE_CLOSED_STATUS+'\' ) ORDER BY CreatedDate DESC';
                    //listPast12OpenEnquiries = Database.Query(sQueryForPastMonths);
                    //listOpenInquiries.addAll(listPast12OpenEnquiries);
                }
            } catch (QueryException qe) {
                //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Some error occurred. Please try again later.'));
            }
            if (!listOpenInquiries.isEmpty()) {
                for (Case openinq: listOpenInquiries) {
                    OpenInquiriesWrapper oiwrap = new OpenInquiriesWrapper(
                        openInq.Id, openinq.Type, openInq.Sub_Type__c, openInq.Status,
                        (openinq.CreatedDate != null ? openinq.CreatedDate.format(WK_ConstantUtility.dateFormat) : ''), openInq.CaseNumber);
                    listOpenInquiriesWrapper.add(oiwrap);
                }
                //JSONString = JSON.serialize(listOpenInquiriesWrapper);
            }
        }
        return null;

    }

    /**************************************************************************** 
     * Detail: Method to query 5 Day Violation tracking system records on report Run.
     *****************************************************************************/
    public void run5dayViolationReport() {
        listOf5DayViolationsWrapper = new List < violationWrapper > ();
        String sQueryToRetrieve = '';
        List < Violation__c > list5DayViolations = new List < Violation__c > ();
        List < Violation__c > lstOf5DayVioRecs = new List < Violation__c > ();
        Set < Id > lstOfVioIds = new Set < Id > ();
        mapOfAttachments = new Map < Id, List < Attachment >> ();
        mapOfContentDocLinks = new Map < Id, List < ContentDocumentLink >> ();
        listOfAttachments = new List < Attachment > ();
        listOfContentDocLinks = new List < ContentDocumentLink > ();
        String sQueryForPastMonths = '';

        sQueryToRetrieve = fetchViolationRecords();

        try {
            list5DayViolations = Database.Query(sQueryToRetrieve);
            if (duration == WK_ConstantUtility.reportsPast12months) {
                //Commented as part of DE9044 - Anush
                //sQueryForPastMonths = 'Select id,Name,CreatedByID,LastModifiedByID,WK_Building__c,WK_Building__r.Name,Unit__c,Quantity__c,WK_Fine_Amount__c,WK_Add_Note__c,Violation_Type__c,CreatedDate,WK_PM_Status__c,WK_Status__c'+' from Violation__c Where CreatedDate = THIS_MONTH '+'AND WK_Status__c = \'Approved\' AND WK_Service_Appointment__r.Account.Name = '+'\''+ AccName+'\''+' AND Violation_Type__c = \'5-Day violation tracking system\' ORDER BY CreatedDate DESC';
                // lstOf5DayVioRecs = Database.Query(sQueryForPastMonths);
                // list5DayViolations.addAll(lstOf5DayVioRecs);
            }
        } catch (QueryException qe) {
            System.debug('Query Failed ' + qe.getMessage());
        }

        if (list5DayViolations != null && !list5DayViolations.isEmpty()) {
            for (Violation__c vioRec: list5DayViolations) {
                lstOfVioIds.add(vioRec.Id);
            }
            try {
                listOfAttachments = [Select Id, Name, ParentId from Attachment where ParentId IN: list5DayViolations Order By CreatedDate DESC];
                listOfContentDocLinks = [SELECT ContentDocument.LatestPublishedVersionId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId IN: lstOfVioIds Order By ContentDocument.LatestPublishedVersionId DESC];
            } catch (QueryException qe) {}
            if (listOfAttachments != null && !listOfAttachments.isEmpty()) {
                for (Attachment attRec: listOfAttachments) {
                    if (!mapOfAttachments.containsKey(attRec.ParentId)) {
                        mapOfAttachments.put(attRec.ParentId, new List < Attachment > ());
                        mapOfAttachments.get(attRec.ParentId).add(attRec);
                    } else {
                        mapOfAttachments.get(attRec.ParentId).add(attRec);
                    }
                }
            }
            if (listOfContentDocLinks != null && !listOfContentDocLinks.isEmpty()) {
                for (ContentDocumentLink conDocRec: listOfContentDocLinks) {
                    if (!mapOfContentDocLinks.containsKey(conDocRec.LinkedEntityId)) {
                        mapOfContentDocLinks.put(conDocRec.LinkedEntityId, new List < ContentDocumentLink > ());
                        mapOfContentDocLinks.get(conDocRec.LinkedEntityId).add(conDocRec);
                    } else {
                        mapOfContentDocLinks.get(conDocRec.LinkedEntityId).add(conDocRec);
                    }
                }
            }
            ChkMapKeyForAtt = String.valueof(mapOfAttachments.keyset()).replace('{', '').replace('{', '');
            ChkMapKeyForCont = String.valueof(mapOfContentDocLinks.keyset()).replace('{', '').replace('{', '');
            for (Violation__c vioRec: list5DayViolations) {
                violationWrapper vioWrapper = new violationWrapper();
                vioWrapper.vioName = vioRec.Name;
                vioWrapper.vioId = vioRec.Id;
                vioWrapper.vioUnit = vioRec.Unit__c;
                vioWrapper.vioType = vioRec.Violation_Type__c;
                vioWrapper.vioBuildingName = vioRec.WK_Building__r.Name;
                if (vioRec.Quantity__c != null) {
                    vioWrapper.vioQuantity = String.valueOf(vioRec.Quantity__c);
                }
                if (vioRec.WK_Fine_Amount__c != null) {
                    vioWrapper.vioFineAmount = WK_ConstantUtility.dollarLabel + String.valueOf(vioRec.WK_Fine_Amount__c);
                }
                if (vioRec.WK_Add_Note__c != null && vioRec.WK_Add_Note__c != '') {
                    vioWrapper.vioNote = vioRec.WK_Add_Note__c;
                }
                vioWrapper.violationRecordWrapper = new Violation__c();
                vioWrapper.violationRecordWrapper.Id = vioRec.Id;
                System.debug('DATE ISSUE ' + vioRec.CreatedDate);
                vioWrapper.createdDate = vioRec.CreatedDate.format(WK_ConstantUtility.dateFormat);
                vioWrapper.vioStatus = vioRec.WK_PM_Status__c;
                if ((mapOfAttachments != null && !mapOfAttachments.isEmpty()) || (mapOfContentDocLinks != null && !mapOfContentDocLinks.isEmpty())) {
                    if (mapOfAttachments.containsKey(vioRec.Id)) {
                        if (mapOfAttachments.get(vioRec.Id) != null && !mapOfAttachments.get(vioRec.Id).isEmpty()) {
                            vioWrapper.vioAttachmentId = mapOfAttachments.get(vioRec.Id)[0].Id;
                            if (mapOfAttachments.get(vioRec.Id).size() > 1) {
                                vioWrapper.vioAttachmentId2 = mapOfAttachments.get(vioRec.Id)[1].Id;
                            }
                        }
                    } else if (mapOfContentDocLinks.containsKey(vioRec.Id)) {
                        if (mapOfContentDocLinks.get(vioRec.Id) != null && !mapOfContentDocLinks.get(vioRec.Id).isEmpty()) {
                            vioWrapper.vioContDocId = mapOfContentDocLinks.get(vioRec.Id)[0].ContentDocument.LatestPublishedVersionId;
                            vioWrapper.vioImageUrl = System.Label.WK_ImgUrlForViolations + vioWrapper.vioContDocId;
                            if (mapOfContentDocLinks.get(vioRec.Id).size() > 1) {
                                vioWrapper.vioContDocId2 = mapOfContentDocLinks.get(vioRec.Id)[1].ContentDocument.LatestPublishedVersionId;
                                vioWrapper.vioImageUrl2 = System.Label.WK_ImgUrlForViolations + vioWrapper.vioContDocId2;
                            }
                        }
                    }
                }
                listOf5DayViolationsWrapper.add(vioWrapper);
            }
            JSONString = JSON.serialize(listOf5DayViolationsWrapper);
        }
    }


    /**************************************************************************** 
     * Detail: Method to Navigate the page to Violation WK_Reports Page from PrintingVioPage
     *****************************************************************************/
    public static PageReference printingCancel() {

        Pagereference ref = new Pagereference(WK_ConstantUtility.urlWkReportsTypeViolations);
        ref.setRedirect(true);
        return ref;

    }
    /**************************************************************************** 
     * Detail: Method to Navigate to partiular Violation pages
     *****************************************************************************/
    public PageReference navigateToVioRec() {
        List < FeedItem > lstFeedItems = new List < FeedItem > ();
        accountId = ApexPages.currentPage().getParameters().get('Id');
        List < Violation__c > lstOfVioRecSelected = new List < Violation__c > ();
        List < Attachment > attListToUpdate = new List < Attachment > ();
        List < ContentVersion > listOfContentVers = new List < ContentVersion > ();
        if (violationName != null && violationName != '') {
            try {
                lstOfVioRecSelected = [Select Id, Name from Violation__c where Name =: violationName limit 1];
            } catch (QueryException qe) {
                System.debug('Query Failed ' + qe.getMessage());
            }
            Set < Id > setOfConDocIds = new Set < Id > ();
            Violation__c violationRec = new Violation__c();
            violationRec = lstOfVioRecSelected[0];
            List < Attachment > attListQuery = new List < Attachment > ([Select id, Name from Attachment where ParentID =: violationRec.Id]);
            Set < String > attNamesSet = new Set < String > ();
            for (Attachment attItr: attListQuery) {
                attNamesSet.add(attItr.Name);
            }
            if (violationRec != null && violationRec.Id != null) {
                for (FeedItem feedRecord: WK_ConstantUtility.getFeedItems(violationRec.Id)) {
                    if (feedRecord.RelatedRecordId != null) {
                        setOfConDocIds.add(feedRecord.RelatedRecordId);
                    }
                    if (setOfConDocIds.size() >= 2) {
                        break;
                    }
                }
            }
            if (setOfConDocIds != null && !setOfConDocIds.isEmpty()) {
                listOfContentVers = WK_ConstantUtility.getContentVersionId(setOfConDocIds);
            }
            if (!listOfContentVers.isEmpty()) {
                for (ContentVersion contVerItr: listOfContentVers) {
                    if (!attNamesSet.contains(contVerItr.title)) {
                        Attachment attach = new Attachment();
                        if (contVerItr.VersionData != null) {
                            attach.Body = contVerItr.VersionData;
                        }
                        if (contVerItr.title != null) {
                            attach.Name = contVerItr.title;
                        }

                        if (contVerItr.FileType != null) {
                            attach.ContentType = contVerItr.FileType;
                        }
                        if (violationRec.Id != null) {
                            attach.ParentID = violationRec.Id;
                        } else {}
                        attListToUpdate.add(attach);
                    }
                }
                Database.SaveResult[] srList;
                if (!attListToUpdate.isEmpty()) {
                    try {
                        //srList = Database.insert(attListToUpdate,false);
                    } catch (System.DMLException e) {
                        system.debug('exception caught -- >' + e);
                    }
                }
            }
            PageReference pgRef = new PageReference(WK_ConstantUtility.urlInViolationEditPage + violationName + '&accntId=' + accountId);
            return pgRef;
        } else {
            return null;
        }
    }

    /**
     * @author: NSebastian@Deloitte
     * @description: Method to navigate to Case Detail Page on click of Inquiry number
     * @param: inquiry number of type String
     * @returntype: pagereference
     */
    public PageReference navigateToInquiryDetails() {
        PageReference pf = null;
        pf = Page.WK_InquiryDetails;
        if (String.isNotBlank(selectedInquiryId) && String.isNotBlank(returnURL)) {
            pf.getParameters().put(WK_ConstantUtility.URL_PARAM_ID, accId2);
            pf.getParameters().put(WK_ConstantUtility.URL_PARAM_INQUIRY_ID, selectedInquiryId);
            pf.getParameters().put(WK_ConstantUtility.URL_PARAM_RETURN_URL, returnURL);
            pf.setRedirect(true);
        }
        return pf;
    }

    public List < selectOption > getReportTypePicklist {
        get {
            List < SelectOption > options = new List < SelectOption > ();
            List < WK_PortalReportTypes__c > listOfReportTypes = new List < WK_PortalReportTypes__c > ();
            listOfReportTypes = WK_PortalReportTypes__c.getAll().values();
            // Schema.DescribeFieldResult fieldResult = Violation__c.Violation_Type__c.getDescribe();
            // List<Schema.PicklistEntry> plDetail = fieldResult.getPicklistValues();

            for (WK_PortalReportTypes__c f: listOfReportTypes)
                options.add(new SelectOption(f.Name, f.Name));
            return options;
        }
    }

    public List < selectOption > getReportDurationPicklist {
        get {
            List < SelectOption > options = new List < SelectOption > ();
            List < WK_PortalReportDuration__c > listOfReportDurations = new List < WK_PortalReportDuration__c > ();
            Map < String, WK_PortalReportDuration__c > MapOfReportDurations = WK_PortalReportDuration__c.getAll();

            options.add(new SelectOption(MapOfReportDurations.get('Yesterday').Name, MapOfReportDurations.get('Yesterday').Name));
            options.add(new SelectOption(MapOfReportDurations.get('Last 7 Days').Name, MapOfReportDurations.get('Last 7 Days').Name));
            options.add(new SelectOption(MapOfReportDurations.get('Last 30 Days').Name, MapOfReportDurations.get('Last 30 Days').Name));
            options.add(new SelectOption(MapOfReportDurations.get('Last 60 Days').Name, MapOfReportDurations.get('Last 60 Days').Name));
            options.add(new SelectOption(MapOfReportDurations.get('Last 90 Days').Name, MapOfReportDurations.get('Last 90 Days').Name));
            options.add(new SelectOption(MapOfReportDurations.get('Last 12 months').Name, MapOfReportDurations.get('Last 12 months').Name));
            options.add(new SelectOption(MapOfReportDurations.get('Select Date Range').Name, MapOfReportDurations.get('Select Date Range').Name));
            // Schema.DescribeFieldResult fieldResult = Violation__c.Violation_Type__c.getDescribe();
            // List<Schema.PicklistEntry> plDetail = fieldResult.getPicklistValues();
            listOfReportDurations.sort();

            //  for(WK_PortalReportDuration__c f : listOfReportDurations)

            //    options.add(new SelectOption(f.Name, f.Name));
            return options;
        }
    }

    public List < selectOption > getReportUSDurationPicklist {
        get {
            List < SelectOption > options = new List < SelectOption > ();
            List < WK_PortalReportUSDuration__c > listOfReportUSDurations = new List < WK_PortalReportUSDuration__c > ();
            listOfReportUSDurations = WK_PortalReportUSDuration__c.getAll().values();
            // Schema.DescribeFieldResult fieldResult = Violation__c.Violation_Type__c.getDescribe();
            // List<Schema.PicklistEntry> plDetail = fieldResult.getPicklistValues();

            // for(WK_PortalReportUSDuration__c f : listOfReportUSDurations)
            options.add(new SelectOption(listOfReportUSDurations[1].Name, listOfReportUSDurations[1].Name));
            options.add(new SelectOption(listOfReportUSDurations[0].Name, listOfReportUSDurations[0].Name));
            return options;
        }
    }


    /**************************************************************************** 
     * Detail: Wrapper for Closed Inquiries
     *****************************************************************************/
    public class ClosedInquiriesWrapper {
        public String inquirySFId {
            get;
            set;
        }
        public String inquiryType {
            get;
            set;
        }
        public String inquirySubType {
            get;
            set;
        }
        public String inquiryStatus {
            get;
            set;
        }
        public String inquiryClosedDate {
            get;
            set;
        }
        public String inquiryCreatedDate {
            get;
            set;
        }
        public String inquiryNumber {
            get;
            set;
        }

        public ClosedInquiriesWrapper(String inqId, String casetype, String subtype, String status, String createdon, String casenumber, String closedon) {
            this.inquiryNumber = casenumber;
            this.inquiryType = casetype;
            this.inquirySubType = subtype;
            this.inquiryStatus = status;
            this.inquiryCreatedDate = createdon;
            this.inquiryClosedDate = closedon;
            this.inquirySFId = inqId;
        }
    }
    /**************************************************************************** 
     * Detail: Wrapper for Open Inquiries
     *****************************************************************************/
    public class OpenInquiriesWrapper {
        public String inquirySFId {
            get;
            set;
        }
        public String inquiryType {
            get;
            set;
        }
        public String inquirySubType {
            get;
            set;
        }
        public String inquiryStatus {
            get;
            set;
        }
        public String inquiryCreatedDate {
            get;
            set;
        }
        public String inquiryNumber {
            get;
            set;
        }

        public OpenInquiriesWrapper(String inqId, String casetype, String subtype, String status, String createdon, String casenumber) {
            this.inquiryNumber = casenumber;
            this.inquiryType = casetype;
            this.inquirySubType = subtype;
            this.inquiryStatus = status;
            this.inquiryCreatedDate = createdon;
            this.inquirySFId = inqId;
        }
    }
    /**************************************************************************** 
     * Detail: Wrapper for Violation Reports
     *****************************************************************************/
    public class violationWrapper {
        public String viocreateddate {
            get;
            set;
        }
        public String vioName {
            get;
            set;
        }
        public Id vioId {
            get;
            set;
        }
        public String vioUnit {
            get;
            set;
        }
        public String vioType {
            get;
            set;
        }
        public String vioQuantity {
            get;
            set;
        }
        public String vioFineAmount {
            get;
            set;
        }
        public String vioNote {
            get;
            set;
        }
        public String createdDate {
            get;
            set;
        }
        public String vioStatus {
            get;
            set;
        }
        public String vioRecId {
            get;
            set;
        }
        public String vioAttachmentId {
            get;
            set;
        }
        public String vioAttachmentId2 {
            get;
            set;
        }
        public String vioContDocId {
            get;
            set;
        }
        public String vioContDocId2 {
            get;
            set;
        }
        public String vioBuildingName {
            get;
            set;
        }
        public String vioAccName {
            get;
            set;
        }
        public String vioImageUrl {
            get;
            set;
        }
        public String vioImageUrl2 {
            get;
            set;
        }
        public Violation__c violationRecordWrapper {
            get;
            set;
        }
    }
    /**************************************************************************** 
     * Detail: Wrapper for CheckInCheckOut Reports
     *****************************************************************************/
    public class assigResWrapper {
        public String checkInAppointmentNumb {
            get;
            set;
        }
        public String checkInSchDate {
            get;
            set;
        }
        public String checkInTeamIn {
            get;
            set;
        }
        public String checkInTeamOut {
            get;
            set;
        }
        public String checkInDuration {
            get;
            set;
        }
        public ServiceAppointment assignedResRecordWrapper {
            get;
            set;
        }
    }
    /**************************************************************************** 
     * Detail: Wrapper for ServiceHistory Reports
     *****************************************************************************/
    public class serviceHistroyWrapper {
        public String serviceAppAppointNo {
            get;
            set;
        }
        public String serviceAppSchDate {
            get;
            set;
        }
        public String serviceAppSchTime {
            get;
            set;
        }
        public String serviceAppService {
            get;
            set;
        }
        public String serviceAppStatus {
            get;
            set;
        }
        public ServiceAppointment serviceAppRecordWrapper {
            get;
            set;
        }
    }
    /**************************************************************************** 
     * Detail: Wrapper for Upcoming Services Reports
     *****************************************************************************/
    public class upcomingServicesWrapper {
        public String serviceAppAppointNo {
            get;
            set;
        }
        public String serviceAppSchDate {
            get;
            set;
        }
        public String serviceAppSchTime {
            get;
            set;
        }
        public String serviceAppService {
            get;
            set;
        }
        public String serviceAppStatus {
            get;
            set;
        }
        public ServiceAppointment serviceAppRecordWrapper {
            get;
            set;
        }
    }


}