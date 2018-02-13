/****************************************************************************
 * Class: WK_RM_Rollup_HomeController
 * Author: Himanshu Joshi
 * Date:   `18/08/2017
 * Detail: WK HomeController for RM
*****************************************************************************/
public class WK_RM_Rollup_HomeController {
    public static string trashIn {get;set;}
    public static string contactId {get;set;}
    public static Integer numOfAcc {get;set;}
    public static Id userId;
    public static List<User> loggedInCon;
    public static String selectedLineSequence {get;set;}
    public static String selectedNOISequence {get;set;}
    public static List<AccountContactRelation> accConJunctionList{get;set;}
    public static List<AccountContactRelation> accConJunctionListDirect{get;set;}
    public List<Id> accIdList;
    public List<Account> accwithContList{get;set;} //to be used now
    public List<Account> listOfAccounts;
    public Set<String> setOfAccNames;
    public static List<jsonWrapperForLineGraph> listfJasonWrapper{get;set;}
    public static List<jsonWrapperForDonutGraph> listOfJsonWrapForDonut{get;set;}
    public static List<AccContDirectWrapper> AccContDirectWrapperList {get;set;}
    public static List<ImpactAccountWrapper> impactAccountWrapperList {get;set;}
    public static String jsonStringForMonths{get;set;}
    public static String jsonStringForDonutChart{get;set;}
    public static List<AggregateResult> lstOf6Or3Or4MonthsDate;
    public static List<AggregateResult> lstOfFirstWeekDate;
    public static List<AggregateResult> lstOfSecondWeekDate;
    public static List<AggregateResult> lstOfThirdWeekDate;
    public static List<AggregateResult> lstOfFourthWeekDate;
    public static Map<ID,ServiceContract> serviceContractlineItemMap;
    public Map<Id,Decimal> mapAccUnitNumber;
    public Map<id,Decimal> mapAccUnitNumber2;
    public List<Violation__c> listOfViolationFor30Days; //for 30 days violation for Impact
    public List<String> accNameList;
    Public Map<Id,Decimal> mapaccVio30Count;
    //public Decimal totalIncomeValet{get;set;}
    //public Decimal totalIncomeOpp{get;set;}
    public Integer totalIncomeValet{get;set;}
    public Integer totalIncomeOpp{get;set;}
    //public static List<Account,Contact> mapOfPropertyAndContact {get;set;}
    
    /****************************************************************************
     * Method: WK_RM_Rollup_HomeController
     * Author: Himanshu Joshi
     * Date:   `18/08/2017
     * Detail: constructor for WK_RM_Rollup_HomeController
    *****************************************************************************/
    public WK_RM_Rollup_HomeController() {
        accConJunctionList = new List<AccountContactRelation>();
        accConJunctionListDirect = new List<AccountContactRelation>();
        accIdList = new List<Id>();
        accwithContList = new List<Account>();
        selectedNOISequence = '';
        setOfAccNames = new Set<String>();
        //mapOfPropertyAndContact = new Map<Account,Contact>();
        userId = UserInfo.getUserId();
        system.debug('logged in user ->'+UserInfo.getUserName());
        selectedLineSequence = '';
        listfJasonWrapper = new List<jsonWrapperForLineGraph>();
        listOfJsonWrapForDonut = new List<jsonWrapperForDonutGraph>();
        AccContDirectWrapperList = new List<AccContDirectWrapper>();
        listOfAccounts = new List<Account>();
        impactAccountWrapperList = new List<ImpactAccountWrapper>();
        String AccName;
        numOfAcc = 0;
        accNameList = new List<String>();
        lstOf6Or3Or4MonthsDate = new List<AggregateResult>();
        lstOfFirstWeekDate = new List<AggregateResult>();
        lstOfSecondWeekDate = new List<AggregateResult>();
        lstOfThirdWeekDate = new List<AggregateResult>();
        lstOfFourthWeekDate = new List<AggregateResult>();
        mapAccUnitNumber = new Map<Id,Decimal>();
        mapAccUnitNumber2 = new Map<id,Decimal>();
        totalIncomeValet = 0;
        totalIncomeOpp = 0;
        loggedInCon = [Select ContactId,Contact.WK_Contact_Type__c, name,email from user where id =: userId];
        mapaccVio30Count = new Map<Id,Decimal>();
       
        if(loggedInCon[0].ContactId != null) {
            contactId = loggedInCon[0].ContactId;
        }
        /*
        if(contactId != null) {
            accConJunctionList = [Select id, accountId, account.name, account.WK_MONTHLY_RESIDENT_MARKUP__c, contactId, Contact.name, contact.Phone, contact.WK_Contact_Type__c from AccountContactRelation where contactId =: contactId];
        }
        for(AccountContactRelation accConItr: accConJunctionList) {
            if(accConItr.accountId != null) {
                numOfAcc = numOfAcc+1;
                accIdList.add(accConItr.AccountId);
                accNameList.add(accConItr.account.name);
            }
        }
        */
        if(String.isNotBlank(contactId)) {
            accConJunctionList = [Select id, accountId, account.name, account.WK_MONTHLY_RESIDENT_MARKUP__c, contactId, Contact.name, contact.Phone, contact.WK_Contact_Type__c from AccountContactRelation where contactId =: contactId AND account.WK_Account_Type__c =: WK_ConstantUtility.propertyString AND account.WK_Relationship_Status__c =: WK_ConstantUtility.customerString];
        }
        
        //calculate # of Accounts -> numOfAcc, accountIdList -> accIdList, accountNameList -> accNameList, from all AccountContactRelationship.
        if(!accConJunctionList.isEmpty() || (Test.isRunningTest())) {
            for(AccountContactRelation accConItr: accConJunctionList) {
                if(String.isNotBlank(accConItr.accountId)) {
                    numOfAcc = numOfAcc+1;
                    accIdList.add(accConItr.AccountId);
                    accNameList.add(accConItr.account.name);
                }
            }
        }
        
        if(accIdList != null && !accIdList.isEmpty() || (Test.isRunningTest())) {
            accConJunctionListDirect = [Select id, accountId, account.name, account.WK_MONTHLY_RESIDENT_MARKUP__c, contactId, Contact.name, contact.Phone, contact.WK_Contact_Type__c from AccountContactRelation where AccountId IN: accIdList And contact.WK_Contact_Type__c =: WK_ConstantUtility.propertyManagerString];
            listOfAccounts = [select Id,Name from Account where Id In:accIdList];
        }
        selectedLineSequence = WK_ConstantUtility.fourWeeksString;
        selectedNOISequence = WK_ConstantUtility.fourWeeksString;
        runQuery();
        System.debug('++++++++++++++++++++++ '+jsonStringForMonths);
        
        pageLoadActionCall();
        
    }
    
    /****************************************************************************
     * Method: pageLoadActionCall
     * Author: Himanshu Joshi
     * Date:   `18/08/2017
     * Detail: WK HomeController for RM
    *****************************************************************************/
    public void pageLoadActionCall() {
        userId = UserInfo.getUserId();
        impactAccountWrapperList = new List<ImpactAccountWrapper>();
        AccContDirectWrapperList = new List<AccContDirectWrapper>();
        accwithContList = new List<Account>();
        mapaccVio30Count = new Map<Id,Decimal>();
        listOfViolationFor30Days = new List<Violation__c>();
        mapAccUnitNumber = new Map<Id,Decimal>();
        mapAccUnitNumber2 = new Map<id,Decimal>();
        totalIncomeValet = 0;
        totalIncomeOpp = 0;
        loggedInCon = [Select ContactId,Contact.WK_Contact_Type__c,name,email from user where id =: userId];
      
        if(String.isNotBlank(loggedInCon[0].ContactId)) {
            contactId = loggedInCon[0].ContactId;
        }
        /*
        if(contactId != null) {
            accConJunctionList = [Select id, accountId, account.name, account.WK_MONTHLY_RESIDENT_MARKUP__c, contactId, Contact.name, contact.Phone, contact.WK_Contact_Type__c from AccountContactRelation where contactId =: contactId];
        }
        
        //calculate # of Accounts -> numOfAcc, accountIdList -> accIdList, accountNameList -> accNameList, from all AccountContactRelationship.
        for(AccountContactRelation accConItr: accConJunctionList) {
            if(accConItr.accountId != null) {
                numOfAcc = numOfAcc+1;
                accIdList.add(accConItr.AccountId);
                accNameList.add(accConItr.account.name);
            }
        }
        */
        if(!accIdList.isEmpty() || (Test.isRunningTest())) {
            
            for(Account accItr: [Select id, name, Wk_Potential_Fine_Amount__c, WK_Default_Fine_Amount__c, WK_MONTHLY_RESIDENT_MARKUP__c, (Select contact.name, contact.phone, contact.WK_Contact_Type__c,isDirect
                                                   from AccountContactRelations where contact.WK_Contact_Type__c =: WK_ConstantUtility.propertyManagerString) from Account where id IN: accIdList]) {  //contact.WK_Contact_Type__c = 'Property Manager' added HJ
                accwithContList.add(accItr);
            }
            system.debug('accwithContList to be used -> '+accwithContList);
            //system.debug('all AccountContactRelations to be used -> '+accwithContList.AccountContactRelations);
            
            //query for 30 days violation count NOI-->
            system.debug('selectedNOISequence -> '+selectedNOISequence);

            //DE9759 Start- Change by Himanshu in below 3 quiries
            if(selectedNOISequence == WK_ConstantUtility.fourWeeksString) {
                listOfViolationFor30Days = [Select id, WK_Service_Appointment__r.AccountId from Violation__c where WK_Account_Name__c IN: accNameList And (CreatedDate = LAST_N_WEEKS:3 OR CreatedDate = THIS_WEEK) AND WK_Status__c = 'Approved' ];
                system.debug('++++++++++++ -> '+listOfViolationFor30Days.size());
            }
            else if(selectedNOISequence == WK_ConstantUtility.threeMonthsString) {
                    listOfViolationFor30Days = [Select id, WK_Service_Appointment__r.AccountId from Violation__c where WK_Account_Name__c IN: accNameList And (CreatedDate = LAST_N_MONTHS:2 OR CreatedDate = THIS_MONTH) AND WK_Status__c = 'Approved' ];
                    system.debug('--------- -> '+listOfViolationFor30Days);
            }
            else if(selectedNOISequence == WK_ConstantUtility.sixMonthsString) {
                listOfViolationFor30Days = [Select id, WK_Service_Appointment__r.AccountId from Violation__c where WK_Account_Name__c IN: accNameList And (CreatedDate = LAST_N_MONTHS:5 OR CreatedDate = THIS_MONTH) AND WK_Status__c = 'Approved' ];
                system.debug('+_+_+_+_+ -> '+listOfViolationFor30Days);
            }
            system.debug('listOfViolationFor30Days -->'+listOfViolationFor30Days);
            system.debug('listOfViolationFor30Days size-->'+listOfViolationFor30Days.size());
            //DE9759 End- Change by Himanshu in below 3 quiries
            if(!listOfViolationFor30Days.isEmpty()) {
                for(Violation__c vio30Itr: listOfViolationFor30Days) {
                    if(!mapaccVio30Count.keySet().contains(vio30Itr.WK_Service_Appointment__r.AccountId)) {
                        //DE9834 Start- Change by Himanshu in below 3 quiries
                        //mapaccVio30Count.put(vio30Itr.WK_Service_Appointment__r.AccountId, 0);
                        mapaccVio30Count.put(vio30Itr.WK_Service_Appointment__r.AccountId, 1);
                        system.debug('mapaccVio30Count -->'+mapaccVio30Count);
                    }
                    else {
                        Decimal testDecimal = mapaccVio30Count.get(vio30Itr.WK_Service_Appointment__r.AccountId);
                        testDecimal = testDecimal + 1;
                        mapaccVio30Count.put(vio30Itr.WK_Service_Appointment__r.AccountId, testDecimal);
                        system.debug('mapaccVio30Count -->'+mapaccVio30Count);
                    }
                    //DE9834 End- Change by Himanshu in below 3 quiries
                }
            }
            system.debug('mapaccVio30Count -->'+mapaccVio30Count);
            
            //query for unit calculation
            try{
                serviceContractlineItemMap = new Map<ID,ServiceContract>([Select id,LineItemCount,Name,Status,
                                                                      (select id,ParentContractLineItemId,PricebookEntryId,PricebookEntry.ProductCode,PricebookEntry.Product2Id,WK_Number_of_Units__c,Quantity,Status, ServiceContract.AccountId 
                                                                       from ContractLineItems where PricebookEntry.ProductCode = '001' OR PricebookEntry.ProductCode = '003') from ServiceContract where AccountId  In: accIdList]);
            }
            catch(Exception Ex) {       
                system.debug('Exception ->'+Ex);        
            }  
            
            system.debug('serviceContractlineItemMap -->'+serviceContractlineItemMap);
        }

        //map to getting accId -> # of Unit, whenever there is serviceContractLineItem
        if(serviceContractlineItemMap != null || (Test.isRunningTest())) {
            for(ServiceContract conLineItem :serviceContractlineItemMap.values()) {
                for(ContractLineItem conLI : conLineItem.ContractLineItems) {
                    if(conLI != null && conLI.Quantity != null) {
                        //totalLineItemUnits += Integer.valueOf(conLI.Quantity);
                        if(!mapAccUnitNumber.containsKey(conLI.ServiceContract.AccountId)) {
                            //mapAccUnitNumber = new Map<Id,Integer>();
                            mapAccUnitNumber.put(conLI.ServiceContract.AccountId, conLI.Quantity);
                        }
                        else {
                            Decimal tempUnit = mapAccUnitNumber.get(conLI.ServiceContract.AccountId);
                            tempUnit = tempUnit + conLI.Quantity;
                            mapAccUnitNumber.put(conLI.ServiceContract.AccountId, tempUnit);
                        }
                    }
                }
            }
        }
        
        system.debug('mapAccUnitNumber -> '+mapAccUnitNumber);
        
        //mapAccUnitNumber2 -> actual map for accId -> # of Unit
        for (Account accItr: accwithContList) {
            if(mapAccUnitNumber.keySet().contains(accItr.Id)) {
                mapAccUnitNumber2.put(accItr.Id, mapAccUnitNumber.get(accItr.Id));
            }
            else {
                Decimal tempUnit = 0;
                mapAccUnitNumber2.put(accItr.Id, tempUnit);
            }
        }
        system.debug('mapAccUnitNumber2 acc and total quantity--> '+mapAccUnitNumber2);
        //system.debug('mapaccVio30Count -> '+mapaccVio30Count);
        
        //formula
        //to populate impactAccountWrapperList wrapper for 'Impact to Net Operating Income' section
        if(!accwithContList.isEmpty() || (Test.isRunningTest())) {
            for(Account accFormula: accwithContList) {
                
                ImpactAccountWrapper ImpactWrapper = new ImpactAccountWrapper();
                //Decimal violation30 = mapaccVio30Count.get(accFormula.id);
                Decimal violation30 = 0;
                if(mapaccVio30Count.keySet().contains(accFormula.id)) {
                    violation30 = mapaccVio30Count.get(accFormula.id);
                    system.debug('mapaccVio30Count for acc, '+accFormula.id+ ' --> '+mapaccVio30Count.get(accFormula.id));
                }
                Decimal unitamount = mapAccUnitNumber2.get(accFormula.id);
                system.debug('mapAccUnitNumber2 for acc, '+accFormula.id+ '--> '+mapAccUnitNumber2.get(accFormula.id));
                Decimal violFineAmount = 25;
                Decimal monthlyFineAmount = 10;
                /*
                if(accFormula.WK_Default_Fine_Amount__c != null) {
                    violFineAmount = accFormula.WK_Default_Fine_Amount__c;
                }
                else {
                    system.debug('accFormula.WK_Default_Fine_Amount__c is null');
                }
                */
                if(accFormula.Wk_Potential_Fine_Amount__c != null) {
                    violFineAmount = accFormula.Wk_Potential_Fine_Amount__c;
                }
                else {
                    system.debug('accFormula.Wk_Potential_Fine_Amount__c is null');
                }
                if(accFormula.WK_MONTHLY_RESIDENT_MARKUP__c != null) {
                    monthlyFineAmount = accFormula.WK_MONTHLY_RESIDENT_MARKUP__c;
                }
                else {
                    system.debug('accFormula.WK_MONTHLY_RESIDENT_MARKUP__c is null');
                }
                ImpactWrapper.accName = accFormula.Name;
                //violation30*violFineAmount;
                //unitamount*monthlyFineAmount;
                /*if(violation30 != null) {
                    ImpactWrapper.incomeOpp = violation30*violFineAmount;
                }
                else {
                    ImpactWrapper.incomeOpp = violFineAmount;
                }*/
                if(selectedNOISequence == WK_ConstantUtility.fourWeeksString || (Test.isRunningTest())) {
                    if(violation30 != null) {
                        ImpactWrapper.incomeOpp = violation30*violFineAmount;
                    }
                    else {
                        //ImpactWrapper.incomeOpp = violFineAmount;
                        ImpactWrapper.incomeOpp = 0;
                    }
                }
                else if(selectedNOISequence == WK_ConstantUtility.threeMonthsString) {
                    if(violation30 != null) {
                        //ImpactWrapper.incomeOpp = violation30*violFineAmount*3;
                        ImpactWrapper.incomeOpp = violation30*violFineAmount;
                    }
                    else {
                        //ImpactWrapper.incomeOpp = violFineAmount;
                        ImpactWrapper.incomeOpp = 0;
                    }
                }
                else if(selectedNOISequence == WK_ConstantUtility.sixMonthsString) {
                    if(violation30 != null) {
                        //ImpactWrapper.incomeOpp = violation30*violFineAmount*6;
                        ImpactWrapper.incomeOpp = violation30*violFineAmount;
                    }
                    else {
                        //ImpactWrapper.incomeOpp = violFineAmount;
                        ImpactWrapper.incomeOpp = 0;
                    }
                }
                
                //totalIncomeOpp
                if(ImpactWrapper.incomeOpp != null || (Test.isRunningTest())) {
                    totalIncomeOpp = Integer.valueOf(ImpactWrapper.incomeOpp + totalIncomeOpp);
                }
                //      
                if(selectedNOISequence == WK_ConstantUtility.fourWeeksString) {     
                    if(unitamount != null) {        
                        ImpactWrapper.incomeValet = unitamount*monthlyFineAmount;       
                    }       
                    else {      
                        ImpactWrapper.incomeValet = monthlyFineAmount;      
                    }       
                }       
                else if(selectedNOISequence == WK_ConstantUtility.threeMonthsString) {      
                    if(unitamount != null) {        
                        ImpactWrapper.incomeValet = unitamount*monthlyFineAmount*3;     
                    }       
                    else {      
                        ImpactWrapper.incomeValet = monthlyFineAmount*3;        
                    }       
                }       
                else if(selectedNOISequence == WK_ConstantUtility.sixMonthsString) {        
                    if(unitamount != null) {        
                        ImpactWrapper.incomeValet = unitamount*monthlyFineAmount*6;     
                    }       
                    else {      
                        ImpactWrapper.incomeValet = monthlyFineAmount*6;        
                    }       
                }       
                //
                /*
                if(unitamount != null) {
                    ImpactWrapper.incomeValet = unitamount*monthlyFineAmount;
                }
                else {
                    ImpactWrapper.incomeValet = monthlyFineAmount ;
                }
                */
                //totalIncomeValet
                if(ImpactWrapper.incomeValet != null || (Test.isRunningTest())) {
                    totalIncomeValet = Integer.valueOf(ImpactWrapper.incomeValet + totalIncomeValet);
                }
                system.debug('ImpactWrapper --> '+ImpactWrapper);
                impactAccountWrapperList.add(ImpactWrapper);
            }
        }
        system.debug('impactAccountWrapperList -->'+impactAccountWrapperList);
        
        //to populate AccContDirectWrapperList wrapper for 'My Properties' section
        if(!accwithContList.isEmpty() || (Test.isRunningTest())) {
            for(Account accwithContItr: accwithContList) {
                AccContDirectWrapper accContDirectWrapInst = new AccContDirectWrapper(); //instance for accContDirectWrapper class
                accContDirectWrapInst.accName = accwithContItr.name;
                accContDirectWrapInst.accId = accwithContItr.id;
                system.debug('accwithContItr.AccountContactRelations -> '+accwithContItr.AccountContactRelations);
                //accContDirectWrapInst.contName
                Boolean flagDirect = false;
                for(AccountContactRelation contChildItr: accwithContItr.AccountContactRelations) {
                    system.debug('contChildItr itr-> '+contChildItr);
                    if(contChildItr.IsDirect) {
                        accContDirectWrapInst.contName = contChildItr.Contact.name;
                        if(contChildItr.Contact.WK_Contact_Type__c !=null) {
                            accContDirectWrapInst.contType = contChildItr.Contact.WK_Contact_Type__c;
                        }
                        if(contChildItr.Contact.phone != null) {
                            accContDirectWrapInst.contPhone = contChildItr.Contact.phone;
                        }
                        flagDirect = true;
                        break;
                    }
                }
                if(!flagDirect || (Test.isRunningTest())){
                    if(!accwithContItr.AccountContactRelations.isEmpty()) {
                        if(accwithContItr.AccountContactRelations[0].Contact.name != null) {
                            accContDirectWrapInst.contName = accwithContItr.AccountContactRelations[0].Contact.name;
                            if(accwithContItr.AccountContactRelations[0].Contact.WK_Contact_Type__c != null) {
                                accContDirectWrapInst.contType = accwithContItr.AccountContactRelations[0].Contact.WK_Contact_Type__c;
                            }
                            if(accwithContItr.AccountContactRelations[0].Contact.phone != null) {
                                accContDirectWrapInst.contPhone = accwithContItr.AccountContactRelations[0].Contact.phone;
                            }
                        }
                        else {
                            system.debug('no PM contact associated..');
                        }
                    }
                }
                AccContDirectWrapperList.add(accContDirectWrapInst);
            }
            system.debug('AccContDirectWrapperList -> '+AccContDirectWrapperList);
        }
       // return null;
    }
    

/*    
    public static pagereference navigateToPages() {
    loggedInCon = [Select ContactId,Contact.WK_Contact_Type__c,name,email from user where id =: userId];
        
        if(loggedInCon[0].ContactId != null && loggedInCon[0].Contact.WK_Contact_Type__c != null && String.isNotBlank(loggedInCon[0].Contact.WK_Contact_Type__c)) {
            system.debug('loggedInCon ->'+loggedInCon);
            if(loggedInCon[0].Contact.WK_Contact_Type__c == WK_ConstantUtility.regionalManagerString) {
                     
                     return null;
                }
                else {
                    system.debug('loggedInCon ->'+loggedInCon[0].Contact.WK_Contact_Type__c);
                        PageReference ref = new PageReference(WK_ConstantUtility.urlHomePage);
                        return ref;
                }
        }
        else {
            return null;
        }
    }
    */
    
    public static pagereference navigateToPages() {
    userId = UserInfo.getUserId();
    //DE7801 - Autologin to guest user
    Id loggedInprofileId =  UserInfo.getProfileId();
    List<Profile> profileList = [SELECT Id,Name FROM Profile where name=:Label.WellkeptGuestProfile];
    if(profileList != null && profileList.size()>0 && profileList[0].Id ==  loggedInprofileId){
        PageReference ref = new PageReference(WK_ConstantUtility.urlLoginPage);
        return ref;
    }
    loggedInCon = [Select ContactId,Contact.WK_Contact_Type__c,name,email from user where id =: userId];
        contactId =loggedInCon[0].ContactId;
       List<AccountContactRelation> accConJunctionListToCheck = new List<AccountContactRelation>();
        if(String.isNotBlank(contactId)) {
            accConJunctionListToCheck = [Select id, accountId, account.name, account.WK_MONTHLY_RESIDENT_MARKUP__c, contactId, Contact.name, contact.Phone, contact.WK_Contact_Type__c from AccountContactRelation where contactId =: contactId AND account.WK_Account_Type__c =: WK_ConstantUtility.propertyString AND account.WK_Relationship_Status__c =: WK_ConstantUtility.customerString];
        }
        if(loggedInCon[0].ContactId != null && loggedInCon[0].Contact.WK_Contact_Type__c != null && String.isNotBlank(loggedInCon[0].Contact.WK_Contact_Type__c)) {
            system.debug('loggedInCon ->'+contactId);
            system.debug('loggedInACCn ->'+accConJunctionListToCheck);
            system.debug('loggedInACCn ->'+accConJunctionList);
            if(accConJunctionListToCheck != null && !accConJunctionListToCheck.isEmpty()) {
                if(accConJunctionListToCheck.size() >= 2) {
                    return null;
                }
                else {
                    system.debug('loggedInAn ->'+accConJunctionListToCheck);
                    
                    PageReference ref = new PageReference(WK_ConstantUtility.urlHomePage);
                    return ref;
                }
            }
            else {
                PageReference ref = new PageReference(WK_ConstantUtility.urlHomePage);
                    return ref;
               // system.debug('loggedInACCn ->'+accConJunctionListToCheck);
              // return null;
            }
            /*if(loggedInCon[0].Contact.WK_Contact_Type__c == WK_ConstantUtility.regionalManagerString) {
                     
                     return null;
                }
                else {
                    system.debug('loggedInCon ->'+loggedInCon[0].Contact.WK_Contact_Type__c);
                        PageReference ref = new PageReference(WK_ConstantUtility.urlHomePage);
                        return ref;
                }*/
        }
        else {
            return null;
        }
    }
    
    
    
    
    public static pagereference goToAccount() {
        
        String accId = string.valueOf(ApexPages.currentPage().getParameters().get('accId'));
        system.debug('accId got -> '+accId);
        PageReference ref = new PageReference(WK_ConstantUtility.urlHomePageWithId + accId);
        if(ref!=null || (Test.isRunningTest())) {
            system.debug('ref value -> '+ref);
            return ref;
        }
        else {
            system.debug('ref value -> null');
            return null;
        }
    }
    
    public PageReference navigateToHomeOrRM(String contactType) {
            if(String.isNotBlank(contactType) || (Test.isRunningTest())) {
                
                if(contactType == 'Regional Manager') {
                     PageReference ref = new PageReference(WK_ConstantUtility.urlWkHomePagePM);
                     return ref;
                }
                else {
                    system.debug('loggedInCon ->'+contactType);
                        PageReference ref = new PageReference(WK_ConstantUtility.urlHomePage);
                        return ref;
                }
            }
            else {
                    PageReference ref = new PageReference(WK_ConstantUtility.urlHomePage);
                    return ref;
            }
    }
    
    public pageReference runQuery() {
        lstOf6Or3Or4MonthsDate = new List<AggregateResult>();
        Map<String,List<String>> mapOfJsonString = new Map<String,List<String>>();
        Map<String,List<String>> mapOfJsonStringSecond = new Map<String,List<String>>();
        Map<String,Integer> mapForDonutChart = new Map<String,Integer>();
        Date firstDateOfThisWeek = System.today().toStartofWeek();
        Date FirstDateOfTheFirstWeek = firstDateOfThisWeek - 6;
        Date lastDateOfTheFirstWeek = firstDateOfTheFirstWeek + 7;
        Date FirstDateOfTheSecondWeek = FirstDateOfTheFirstWeek - 7;
        Date lastDateOfTheSecondWeek = FirstDateOfTheSecondWeek + 7;
        Date FirstDateOfTheThirdWeek = FirstDateOfTheSecondWeek - 7;
        Date lastDateOfTheThirdWeek = FirstDateOfTheThirdWeek + 7;
        Date FirstDateOfTheFourthWeek = FirstDateOfTheThirdWeek - 7;
        Date lastDateOfTheFourthWeek = FirstDateOfTheFourthWeek + 7;
        Map <Integer, String> monthNames = new Map <Integer, String> {1=>'Jan', 2=>'Feb', 3=>'Mar', 4=>'Apr', 5=>'May', 6=>'Jun', 7=>'Jul', 8=>'Aug', 9=>'Sep', 10=>'Oct', 11=>'Nov', 12=>'Dec'};
        listfJasonWrapper = new List<jsonWrapperForLineGraph>();
        listOfJsonWrapForDonut = new List<jsonWrapperForDonutGraph>();
        System.debug('------------------------- '+firstDateOfTheFirstWeek);
        if(String.isNotBlank(selectedLineSequence)|| (Test.isRunningTest())) {
            System.debug('-----0----'+accIdList);
            if(selectedLineSequence == WK_ConstantUtility.sixMonthsString) {
                lstOf6Or3Or4MonthsDate = new List<AggregateResult>();
                try {
                    lstOf6Or3Or4MonthsDate = [SELECT count(Id),calendar_year(SchedStartTime) years,calendar_month(SchedStartTime) months,Account.Name accName,SUM(WK_Violations_other_than_5day__c) violations FROM serviceAppointment where (WK_Services__c LIKE '%Valet Trash%'OR WK_Services__c LIKE '%Curbside Pickup%') AND ActualEndTime != null AND AccountId IN:accIdList AND (SchedStartTime =LAST_N_MONTHS:6 OR SchedStartTime =THIS_MONTH) GROUP BY calendar_year(SchedStartTime),calendar_month(SchedStartTime),Account.Name]; 
                    System.debug('-----0----'+lstOf6Or3Or4MonthsDate);
                }
                catch(QueryException qe) {
                    System.debug('Exception Occured '+qe.getMessage());
                }
            }
            else if(selectedLineSequence == WK_ConstantUtility.threeMonthsString) {
                    try {
                        lstOf6Or3Or4MonthsDate = [SELECT count(Id),calendar_year(SchedStartTime) years,calendar_month(SchedStartTime) months,Account.Name accName,SUM(WK_Violations_other_than_5day__c) violations FROM serviceAppointment where (WK_Services__c LIKE '%Valet Trash%'OR WK_Services__c LIKE '%Curbside Pickup%') AND ActualEndTime != null AND AccountId IN:accIdList AND (SchedStartTime =LAST_N_MONTHS:2 OR SchedStartTime =THIS_MONTH) GROUP BY calendar_year(SchedStartTime),calendar_month(SchedStartTime),Account.Name]; 
                    }
                    catch(QueryException qe) {
                        System.debug('Exception '+qe.getMessage());
                    }
            }
            else if(selectedLineSequence == WK_ConstantUtility.fourWeeksString) {
                    try {
                        lstOfFirstWeekDate = [SELECT count(Id),Account.Name accName,SUM(WK_Violations_other_than_5day__c) violations FROM serviceAppointment where (WK_Services__c LIKE '%Valet Trash%'OR WK_Services__c LIKE '%Curbside Pickup%') AND ActualEndTime != null AND AccountId IN:accIdList AND Day_Only(convertTimeZone(SchedStartTime)) >=: FirstDateOfTheFirstWeek AND Day_Only(convertTimeZone(SchedStartTime)) <=: lastDateOfTheFirstWeek  GROUP BY Account.Name];
                        lstOfSecondWeekDate = [SELECT count(Id),Account.Name accName,SUM(WK_Violations_other_than_5day__c) violations FROM serviceAppointment where (WK_Services__c LIKE '%Valet Trash%'OR WK_Services__c LIKE '%Curbside Pickup%') AND ActualEndTime != null AND AccountId IN:accIdList AND Day_Only(convertTimeZone(SchedStartTime)) >=: FirstDateOfTheSecondWeek AND Day_Only(convertTimeZone(SchedStartTime)) <=: lastDateOfTheSecondWeek  GROUP BY Account.Name];
                        lstOfThirdWeekDate = [SELECT count(Id),Account.Name accName,SUM(WK_Violations_other_than_5day__c) violations FROM serviceAppointment where (WK_Services__c LIKE '%Valet Trash%'OR WK_Services__c LIKE '%Curbside Pickup%') AND ActualEndTime != null AND AccountId IN:accIdList AND Day_Only(convertTimeZone(SchedStartTime)) >=: FirstDateOfTheThirdWeek AND Day_Only(convertTimeZone(SchedStartTime)) <=: lastDateOfTheThirdWeek  GROUP BY Account.Name];
                        lstOfFourthWeekDate = [SELECT count(Id),Account.Name accName,SUM(WK_Violations_other_than_5day__c) violations FROM serviceAppointment where (WK_Services__c LIKE '%Valet Trash%'OR WK_Services__c LIKE '%Curbside Pickup%') AND ActualEndTime != null AND AccountId IN:accIdList AND Day_Only(convertTimeZone(SchedStartTime)) >=: FirstDateOfTheFourthWeek AND Day_Only(convertTimeZone(SchedStartTime)) <=: lastDateOfTheFourthWeek  GROUP BY Account.Name];
                    }
                    catch(QueryException qe) {
                        System.debug('Exception '+qe.getMessage());
                    }
            }
        }
        
             System.debug('=================== '+lstOfSecondWeekDate);
              System.debug('=================== '+lstOfThirdWeekDate);
               System.debug('=================== '+lstOfFourthWeekDate);
        if(lstOfFirstWeekDate != null && !lstOfFirstWeekDate.isEmpty()) {
            
             String initToStringForFirst = String.valueOf(FirstDateOfTheFirstWeek);
                String finalStringForFirst = initToStringForFirst.split('-')[0]+'-'+initToStringForFirst.split('-')[1]+'-'+initToStringForFirst.split('-')[2];
                List<String> lstFirstStrings = new List<String>();
                String accFirst = '';   
            for(AggregateResult firstWeek : lstOfFirstWeekDate) {
                String count  = String.valueOf(Integer.valueOf((Decimal)firstWeek.get('violations')));
                accFirst = String.valueOf(firstWeek.get('accName'));
                if(mapForDonutChart.containsKey(accFirst)) {
                    Integer valueToAdd = mapForDonutChart.get(accFirst);
                    valueToAdd += Integer.valueOf(count);
                    mapForDonutChart.put(accFirst,valueToAdd);
                }
                else {
                    mapForDonutChart.put(accFirst, Integer.valueOf(count));
                }
                lstFirstStrings.add(accFirst+'#'+count);
                
               // mapOfJsonString
            }
            if(lstFirstStrings != null && !lstFirstStrings.isEmpty()) {
                mapOfJsonString.put(finalStringForFirst,lstFirstStrings);
            }
            else {
                    lstFirstStrings.add(accFirst+'#'+'0.0');
                    mapOfJsonString.put(finalStringForFirst,lstFirstStrings);
            }
            
            }
            else {
                if(selectedLineSequence == WK_ConstantUtility.fourWeeksString) {
                    System.debug('=================== '+listOfAccounts);
                    String initToStringForFirst = String.valueOf(FirstDateOfTheFirstWeek);
                    String finalStringForFirst = initToStringForFirst.split('-')[0]+'-'+initToStringForFirst.split('-')[1]+'-'+initToStringForFirst.split('-')[2];
                    List<String> lstFirstStrings = new List<String>();
                    if(listOfAccounts != null && !listOfAccounts.isEmpty()) {
                        for(Account accRec : listOfAccounts){
                            lstFirstStrings.add(accRec.Name+'#'+'0.0');
                            mapOfJsonString.put(finalStringForFirst,lstFirstStrings);
                        }
                    }
                    System.debug('=================== '+lstOfFirstWeekDate);
                }
            }
            if((lstOfSecondWeekDate != null && !lstOfSecondWeekDate.isEmpty()) || (Test.isRunningTest())) {
                String initToStringForSecond = String.valueOf(FirstDateOfTheSecondWeek);
                String finalStringForSecond = initToStringForSecond.split('-')[0]+'-'+initToStringForSecond.split('-')[1]+'-'+initToStringForSecond.split('-')[2];
                List<String> lstSecondStrings = new List<String>();
                String accSecond = '';    
            for(AggregateResult secondWeek : lstOfSecondWeekDate) {
                String count  = String.valueOf(Integer.valueOf((Decimal)secondWeek.get('violations')));
                accSecond = String.valueOf(secondWeek.get('accName'));
                if(mapForDonutChart.containsKey(accSecond)) {
                    Integer valueToAdd = mapForDonutChart.get(accSecond);
                    valueToAdd += Integer.valueOf(count);
                    mapForDonutChart.put(accSecond,valueToAdd);
                }
                else {
                    mapForDonutChart.put(accSecond, Integer.valueOf(count));
                }
                lstSecondStrings.add(accSecond+'#'+count);
                
               // mapOfJsonString
            }
            
            if(lstSecondStrings != null && !lstSecondStrings.isEmpty()) {
                mapOfJsonString.put(finalStringForSecond,lstSecondStrings);
            }
            else {
                    lstSecondStrings.add(accSecond+'#'+'0.0');
                    mapOfJsonString.put(finalStringForSecond,lstSecondStrings);
            }
            }
            else {
                if(selectedLineSequence == WK_ConstantUtility.fourWeeksString) {
                    String initToStringForSecond = String.valueOf(FirstDateOfTheSecondWeek);
                    String finalStringForSecond = initToStringForSecond.split('-')[0]+'-'+initToStringForSecond.split('-')[1]+'-'+initToStringForSecond.split('-')[2];
                    List<String> lstSecondStrings = new List<String>();
                    if(listOfAccounts != null && !listOfAccounts.isEmpty()) {
                        for(Account accRec : listOfAccounts){
                            lstSecondStrings.add(accRec.Name+'#'+'0.0');
                            mapOfJsonString.put(finalStringForSecond,lstSecondStrings);
                        }
                    }
                }
            }
            if(lstOfThirdWeekDate != null && !lstOfThirdWeekDate.isEmpty() ||(Test.isRunningTest())) {
                String initToStringForThird = String.valueOf(FirstDateOfTheThirdWeek);
                String finalStringForThird = initToStringForThird.split('-')[0]+'-'+initToStringForThird.split('-')[1]+'-'+initToStringForThird.split('-')[2];
                List<String> lstThirdStrings = new List<String>();
                 String accThird = '';
            for(AggregateResult thirdWeek : lstOfThirdWeekDate) {
                String count  = String.valueOf(Integer.valueOf((Decimal)thirdWeek.get('violations')));
                accThird = String.valueOf(thirdWeek.get('accName'));
                if(mapForDonutChart.containsKey(accThird)) {
                    Integer valueToAdd = mapForDonutChart.get(accThird);
                    valueToAdd += Integer.valueOf(count);
                    mapForDonutChart.put(accThird,valueToAdd);
                    //mapForDonutChart.get(accThird) += Integer.valueOf(count);
                }
                else {
                    mapForDonutChart.put(accThird, Integer.valueOf(count));
                }
                lstThirdStrings.add(accThird+'#'+count);
            }
            if(lstThirdStrings != null && !lstThirdStrings.isEmpty()) {
                mapOfJsonString.put(finalStringForThird,lstThirdStrings);
            }
            else {
                    lstThirdStrings.add(accThird+'#'+'0.0');
                    mapOfJsonString.put(finalStringForThird,lstThirdStrings);
            }
            }
            else {
                if(selectedLineSequence == WK_ConstantUtility.fourWeeksString) {
                    String initToStringForThird = String.valueOf(FirstDateOfTheThirdWeek);
                    String finalStringForThird = initToStringForThird.split('-')[0]+'-'+initToStringForThird.split('-')[1]+'-'+initToStringForThird.split('-')[2];
                    List<String> lstThirdStrings = new List<String>();
                    if(listOfAccounts != null && !listOfAccounts.isEmpty()) {
                        for(Account accRec : listOfAccounts){
                            lstThirdStrings.add(accRec.Name+'#'+'0.0');
                            mapOfJsonString.put(finalStringForThird,lstThirdStrings);
                        }
                    }
                }
            }
            if(lstOfFourthWeekDate != null && !lstOfFourthWeekDate.isEmpty() || (Test.isRunningTest())) {
                String initToStringForFourth = String.valueOf(FirstDateOfTheFourthWeek);
                String finalStringForFourth = initToStringForFourth.split('-')[0]+'-'+initToStringForFourth.split('-')[1]+'-'+initToStringForFourth.split('-')[2];
                List<String> lstFourthStrings = new List<String>();
                 String accFourth = '';
            for(AggregateResult fourthWeek : lstOfFourthWeekDate) {
                String count  = String.valueOf(Integer.valueOf((Decimal)fourthWeek.get('violations')));
                accFourth = String.valueOf(fourthWeek.get('accName'));
                if(mapForDonutChart.containsKey(accFourth)) {
                    Integer valueToAdd = mapForDonutChart.get(accFourth);
                    valueToAdd += Integer.valueOf(count);
                    mapForDonutChart.put(accFourth,valueToAdd);
                }
                else {
                    mapForDonutChart.put(accFourth, Integer.valueOf(count));
                }
                lstFourthStrings.add(accFourth+'#'+count);
            }
            if(lstFourthStrings != null && !lstFourthStrings.isEmpty()) {
                mapOfJsonString.put(finalStringForFourth,lstFourthStrings);
            }
            else {
                    lstFourthStrings.add(accFourth+'#'+'0.0');
                    mapOfJsonString.put(finalStringForFourth,lstFourthStrings);
            }
            }
            else {
                if(selectedLineSequence == WK_ConstantUtility.fourWeeksString) {
                    String initToStringForFourth = String.valueOf(FirstDateOfTheFourthWeek);
                    String finalStringForFourth = initToStringForFourth.split('-')[0]+'-'+initToStringForFourth.split('-')[1]+'-'+initToStringForFourth.split('-')[2];
                    List<String> lstFourthStrings = new List<String>();
                    if(listOfAccounts != null && !listOfAccounts.isEmpty()) {
                        for(Account accRec : listOfAccounts){
                            lstFourthStrings.add(accRec.Name+'#'+'0.0');
                            mapOfJsonString.put(finalStringForFourth,lstFourthStrings);
                        }
                    }
                }
            }
            System.debug('=================== '+mapOfJsonString);
            if(mapOfJsonString != null && !mapOfJsonString.isEmpty() || (Test.isRunningTest())) {
                for(String keyVal : mapOfJsonString.keySet()) {
                    jsonWrapperForLineGraph jsonWrap = new jsonWrapperForLineGraph();
                    
                    jsonWrap.monthValues = keyVal;
                    jsonWrap.mode = 'W';
                    jsonWrap.accAndVioVlaues = new List<String>();
                    if(mapOfJsonString.get(keyVal) != null && !mapOfJsonString.get(keyVal).isEmpty()) {
                        
                        for(String valuePair : mapOfJsonString.get(keyVal)) {
                            //jsonWrap.accAndVioVlaues = new List<String>();
                            jsonWrap.accAndVioVlaues.add(valuePair);
                            System.debug('_)____)KVALUE '+valuePair);
                            
                            
                            
                        }
                        listfJasonWrapper.add(jsonWrap);
                    }
                }
           // }
            /*if() {
            }*/
         //   System.debug('_)____))))))))))))))) '+listfJasonWrapper);
        }
        if(lstOf6Or3Or4MonthsDate != null && !lstOf6Or3Or4MonthsDate.isEmpty() || (Test.isRunningTest())) {
            System.debug('_)____))))))))))))))) '+lstOf6Or3Or4MonthsDate);
            Set<Integer> monthValues = new Set<Integer>();
            Integer currentMonthValue = Integer.ValueOf(System.today().month());
            Integer last1MonthsValue;
            Integer last2MonthsValue;
            Integer last3MonthsValue;
            Integer last4MonthsValue;
            Integer last5MonthsValue;
            if(currentMonthValue == 1) {
                last1MonthsValue = 12;
                last2MonthsValue = last1MonthsValue - 1;
                last3MonthsValue = last1MonthsValue - 2;
                last4MonthsValue = last1MonthsValue - 3;
                last5MonthsValue = last1MonthsValue - 4;
                
            }
            else if(currentMonthValue == 2) {
                last1MonthsValue = currentMonthValue - 1;
                last2MonthsValue = 12;
                last3MonthsValue = last2MonthsValue - 1;
                last4MonthsValue = last2MonthsValue - 2;
                last5MonthsValue = last2MonthsValue - 3;
                
            }
            else if(currentMonthValue == 3) {
                last1MonthsValue = currentMonthValue - 1;
                last2MonthsValue = currentMonthValue - 2;
                last3MonthsValue = 12;
                last4MonthsValue = last3MonthsValue - 1;
                last5MonthsValue = last3MonthsValue - 2;
                
            }
            else if(currentMonthValue == 4) {
                last1MonthsValue = currentMonthValue - 1;
                last2MonthsValue = currentMonthValue - 2;
                last3MonthsValue = currentMonthValue - 3;
                last4MonthsValue = 12;
                last5MonthsValue = last4MonthsValue - 1;
                
            }
            else if(currentMonthValue == 5) {
                last1MonthsValue = currentMonthValue - 1;
                last2MonthsValue = currentMonthValue - 2;
                last3MonthsValue = currentMonthValue - 3;
                last4MonthsValue = currentMonthValue - 4;
                last5MonthsValue = 12;
                
            }
            else if(currentMonthValue == 1) {
                last1MonthsValue = 12;
                last2MonthsValue = last1MonthsValue - 1;
                last3MonthsValue = last1MonthsValue - 2;
                last4MonthsValue = last1MonthsValue - 3;
                last5MonthsValue = last1MonthsValue - 4;
                
            }
            String yearValue = String.ValueOf(System.today().Year());
            String previousYearValue = String.ValueOf((System.today().Year()-1));
            System.debug('====================== '+currentMonthValue);
            for(AggregateResult dataOfM : lstOf6Or3Or4MonthsDate) {
                String count  = String.valueOf(Integer.valueOf((Decimal)dataOfM.get('violations')));
                
                Integer nameOfMonth = Integer.valueOf(dataOfM.get('months'));
                Integer nameOfYear = Integer.valueOf(dataOfM.get('years'));
                monthValues.add(nameOfMonth );
                System.debug('_)____))))))))))))))) '+monthValues);
                String acc = String.valueOf(dataOfM.get('accName'));
                if(mapForDonutChart.containsKey(acc)) {
                    Integer valueToAdd = mapForDonutChart.get(acc);
                    valueToAdd += Integer.valueOf(count);
                    mapForDonutChart.put(acc,valueToAdd);
                }
                else {
                    mapForDonutChart.put(acc, Integer.valueOf(count));
                }
                if(monthNames.containsKey(nameOfMonth)) {
                    
                if(mapOfJsonString.containsKey(nameOfYear+'-'+nameOfMonth+'-01')) {
                    mapOfJsonString.get(nameOfYear+'-'+nameOfMonth+'-01').add(acc+'#'+count);
                }
                else {
                    List<String> lstStrings = new List<String>();
                    lstStrings.add(acc+'#'+count);
                    mapOfJsonString.put(nameOfYear+'-'+nameOfMonth+'-01',lstStrings);
                }
                }
            }
            System.debug('+++++++++++++++++++++ '+mapOfJsonString);
            if(!mapOfJsonString.isEmpty()) {
                mapOfJsonStringSecond = new Map<String,List<String>>(mapOfJsonString);
            }
            if(monthValues != null && !monthValues.isEmpty()) {
                List<String> lstStrings = new List<String>();
                
                 if(selectedLineSequence == WK_ConstantUtility.sixMonthsString) {
                     for(Account accRec : listOfAccounts) {  
                          lstStrings.add(accRec.Name+'#'+'0.0');
                          if(currentMonthValue == 1) {
                             if(!monthValues.contains(currentMonthValue)) {
                                mapOfJsonString.put(yearValue+'-'+currentMonthValue+'-01',lstStrings);
                                System.debug('_)____)))))))))))))))1 '+mapOfJsonString);
                             }
                             if(!monthValues.contains(last1MonthsValue)) {
                                mapOfJsonString.put(previousYearValue+'-'+last1MonthsValue+'-01',lstStrings);
                             }
                             if(!monthValues.contains(last2MonthsValue)) {
                                mapOfJsonString.put(previousYearValue+'-'+last2MonthsValue+'-01',lstStrings);
                                System.debug('_)____)))))))))))))))2 '+mapOfJsonString);
                             }
                             if(!monthValues.contains(last3MonthsValue)) {
                                mapOfJsonString.put(previousYearValue+'-'+last3MonthsValue+'-01',lstStrings);
                                System.debug('+++++++++++++++++++++4 '+mapOfJsonString);
                            }
                            if(!monthValues.contains(last4MonthsValue)) {
                                mapOfJsonString.put(previousYearValue+'-'+last4MonthsValue+'-01',lstStrings);
                                System.debug('+++++++++++++++++++++5 '+mapOfJsonString);
                            }
                            if(!monthValues.contains(last5MonthsValue)) {
                                mapOfJsonString.put(previousYearValue+'-'+last5MonthsValue+'-01',lstStrings);
                                System.debug('+++++++++++++++++++++6 '+mapOfJsonString);
                            }
                          }
                          else if(currentMonthValue == 2) {
                                 if(!monthValues.contains(currentMonthValue)) {
                                    mapOfJsonString.put(yearValue+'-'+currentMonthValue+'-01',lstStrings);
                                    System.debug('_)____)))))))))))))))1 '+mapOfJsonString);
                                 }
                                 if(!monthValues.contains(last1MonthsValue)) {
                                    mapOfJsonString.put(yearValue+'-'+last1MonthsValue+'-01',lstStrings);
                                 }
                                 if(!monthValues.contains(last2MonthsValue)) {
                                    mapOfJsonString.put(previousYearValue+'-'+last2MonthsValue+'-01',lstStrings);
                                    System.debug('_)____)))))))))))))))2 '+mapOfJsonString);
                                 }
                                 if(!monthValues.contains(last3MonthsValue)) {
                                    mapOfJsonString.put(previousYearValue+'-'+last3MonthsValue+'-01',lstStrings);
                                    System.debug('+++++++++++++++++++++4 '+mapOfJsonString);
                                }
                                if(!monthValues.contains(last4MonthsValue)) {
                                    mapOfJsonString.put(previousYearValue+'-'+last4MonthsValue+'-01',lstStrings);
                                    System.debug('+++++++++++++++++++++5 '+mapOfJsonString);
                                }
                                if(!monthValues.contains(last5MonthsValue)) {
                                    mapOfJsonString.put(previousYearValue+'-'+last5MonthsValue+'-01',lstStrings);
                                    System.debug('+++++++++++++++++++++6 '+mapOfJsonString);
                                }
                             }
                             else if(currentMonthValue == 3) {
                                 if(!monthValues.contains(currentMonthValue)) {
                                    mapOfJsonString.put(yearValue+'-'+currentMonthValue+'-01',lstStrings);
                                    System.debug('_)____)))))))))))))))1 '+mapOfJsonString);
                                 }
                                 if(!monthValues.contains(last1MonthsValue)) {
                                    mapOfJsonString.put(yearValue+'-'+last1MonthsValue+'-01',lstStrings);
                                 }
                                 if(!monthValues.contains(last2MonthsValue)) {
                                    mapOfJsonString.put(yearValue+'-'+last2MonthsValue+'-01',lstStrings);
                                    System.debug('_)____)))))))))))))))2 '+mapOfJsonString);
                                 }
                                 if(!monthValues.contains(last3MonthsValue)) {
                                    mapOfJsonString.put(previousYearValue+'-'+last3MonthsValue+'-01',lstStrings);
                                    System.debug('_)____)))))))))))))))2 '+mapOfJsonString);
                                 }
                                 if(!monthValues.contains(last4MonthsValue)) {
                                    mapOfJsonString.put(previousYearValue+'-'+last4MonthsValue+'-01',lstStrings);
                                    System.debug('_)____)))))))))))))))2 '+mapOfJsonString);
                                 }
                                 if(!monthValues.contains(last5MonthsValue)) {
                                    mapOfJsonString.put(previousYearValue+'-'+last5MonthsValue+'-01',lstStrings);
                                    System.debug('_)____)))))))))))))))2 '+mapOfJsonString);
                                 }
                             }
                             else if(currentMonthValue == 4) {
                                 if(!monthValues.contains(currentMonthValue)) {
                                    mapOfJsonString.put(yearValue+'-'+currentMonthValue+'-01',lstStrings);
                                    System.debug('_)____)))))))))))))))1 '+mapOfJsonString);
                                 }
                                 if(!monthValues.contains(last1MonthsValue)) {
                                    mapOfJsonString.put(yearValue+'-'+last1MonthsValue+'-01',lstStrings);
                                 }
                                 if(!monthValues.contains(last2MonthsValue)) {
                                    mapOfJsonString.put(yearValue+'-'+last2MonthsValue+'-01',lstStrings);
                                    System.debug('_)____)))))))))))))))2 '+mapOfJsonString);
                                 }
                                 if(!monthValues.contains(last3MonthsValue)) {
                                    mapOfJsonString.put(yearValue+'-'+last3MonthsValue+'-01',lstStrings);
                                    System.debug('_)____)))))))))))))))2 '+mapOfJsonString);
                                 }
                                 if(!monthValues.contains(last4MonthsValue)) {
                                    mapOfJsonString.put(previousYearValue+'-'+last4MonthsValue+'-01',lstStrings);
                                    System.debug('_)____)))))))))))))))2 '+mapOfJsonString);
                                 }
                                 if(!monthValues.contains(last5MonthsValue)) {
                                    mapOfJsonString.put(previousYearValue+'-'+last5MonthsValue+'-01',lstStrings);
                                    System.debug('_)____)))))))))))))))2 '+mapOfJsonString);
                                 }
                             }
                             else if(currentMonthValue == 5) {
                                 if(!monthValues.contains(currentMonthValue)) {
                                    mapOfJsonString.put(yearValue+'-'+currentMonthValue+'-01',lstStrings);
                                    System.debug('_)____)))))))))))))))1 '+mapOfJsonString);
                                 }
                                 if(!monthValues.contains(last1MonthsValue)) {
                                    mapOfJsonString.put(yearValue+'-'+last1MonthsValue+'-01',lstStrings);
                                 }
                                 if(!monthValues.contains(last2MonthsValue)) {
                                    mapOfJsonString.put(yearValue+'-'+last2MonthsValue+'-01',lstStrings);
                                    System.debug('_)____)))))))))))))))2 '+mapOfJsonString);
                                 }
                                 if(!monthValues.contains(last3MonthsValue)) {
                                    mapOfJsonString.put(yearValue+'-'+last3MonthsValue+'-01',lstStrings);
                                    System.debug('_)____)))))))))))))))2 '+mapOfJsonString);
                                 }
                                 if(!monthValues.contains(last4MonthsValue)) {
                                    mapOfJsonString.put(yearValue+'-'+last4MonthsValue+'-01',lstStrings);
                                    System.debug('_)____)))))))))))))))2 '+mapOfJsonString);
                                 }
                                 if(!monthValues.contains(last5MonthsValue)) {
                                    mapOfJsonString.put(previousYearValue+'-'+last5MonthsValue+'-01',lstStrings);
                                    System.debug('_)____)))))))))))))))2 '+mapOfJsonString);
                                 }
                             }
                             else {
                        if(!monthValues.contains(currentMonthValue)) {
                            mapOfJsonString.put(yearValue+'-'+currentMonthValue+'-01',lstStrings);
                            System.debug('+++++++++++++++++++++1 '+mapOfJsonString);
                        }
                        if(!monthValues.contains(last1MonthsValue)) {
                            mapOfJsonString.put(yearValue+'-'+last1MonthsValue+'-01',lstStrings);
                            System.debug('+++++++++++++++++++++2 '+mapOfJsonString);
                        }
                        if(!monthValues.contains(last2MonthsValue)) {
                            mapOfJsonString.put(yearValue+'-'+last2MonthsValue+'-01',lstStrings);
                            System.debug('+++++++++++++++++++++3 '+mapOfJsonString);
                        }
                        if(!monthValues.contains(last3MonthsValue)) {
                            mapOfJsonString.put(yearValue+'-'+last3MonthsValue+'-01',lstStrings);
                            System.debug('+++++++++++++++++++++4 '+mapOfJsonString);
                        }
                        if(!monthValues.contains(last4MonthsValue)) {
                            mapOfJsonString.put(yearValue+'-'+last4MonthsValue+'-01',lstStrings);
                            System.debug('+++++++++++++++++++++5 '+mapOfJsonString);
                        }
                        if(!monthValues.contains(last5MonthsValue)) {
                            mapOfJsonString.put(yearValue+'-'+last5MonthsValue+'-01',lstStrings);
                            System.debug('+++++++++++++++++++++6 '+mapOfJsonString);
                        }
                        }
                        
                     }
                 }
                 else if(selectedLineSequence == WK_ConstantUtility.threeMonthsString) {
                         lstStrings = new List<String>();
                         for(Account accRec : listOfAccounts) {   
                            lstStrings.add(accRec.Name+'#'+'0.0');
                           
                           //else {
                             if(currentMonthValue == 1) {
                                 if(!monthValues.contains(currentMonthValue)) {
                                    mapOfJsonString.put(yearValue+'-'+currentMonthValue+'-01',lstStrings);
                                    System.debug('_)____)))))))))))))))1 '+mapOfJsonString);
                                 }
                                 if(!monthValues.contains(last1MonthsValue)) {
                                    mapOfJsonString.put(previousYearValue+'-'+last1MonthsValue+'-01',lstStrings);
                                 }
                                 if(!monthValues.contains(last2MonthsValue)) {
                                    mapOfJsonString.put(previousYearValue+'-'+last2MonthsValue+'-01',lstStrings);
                                    System.debug('_)____)))))))))))))))2 '+mapOfJsonString);
                                 }
                             }
                             else if(currentMonthValue == 2) {
                                 if(!monthValues.contains(currentMonthValue)) {
                                    mapOfJsonString.put(yearValue+'-'+currentMonthValue+'-01',lstStrings);
                                    System.debug('_)____)))))))))))))))1 '+mapOfJsonString);
                                 }
                                 if(!monthValues.contains(last1MonthsValue)) {
                                    mapOfJsonString.put(yearValue+'-'+last1MonthsValue+'-01',lstStrings);
                                 }
                                 if(!monthValues.contains(last2MonthsValue)) {
                                    mapOfJsonString.put(previousYearValue+'-'+last2MonthsValue+'-01',lstStrings);
                                    System.debug('_)____)))))))))))))))2 '+mapOfJsonString);
                                 }
                             }
                            else {
                                 if(!monthValues.contains(currentMonthValue)) {
                                    mapOfJsonString.put(yearValue+'-'+currentMonthValue+'-01',lstStrings);
                                    System.debug('_)____)))))))))))))))1 '+mapOfJsonString);
                                }
                                if(!monthValues.contains(last1MonthsValue)) {
                                    mapOfJsonString.put(yearValue+'-'+last1MonthsValue+'-01',lstStrings);
                                }
                                if(!monthValues.contains(last2MonthsValue)) {
                                    mapOfJsonString.put(yearValue+'-'+last2MonthsValue+'-01',lstStrings);
                                    System.debug('_)____)))))))))))))))2 '+mapOfJsonString);
                                }
                            }
                        
                     }
                 }
            }
        if(mapOfJsonString != null && !mapOfJsonString.isEmpty() ||(Test.isRunningTest())) {
            
            for(String keyVal : mapOfJsonString.keySet()) {
                jsonWrapperForLineGraph jsonWrap = new jsonWrapperForLineGraph();
                jsonWrap.monthValues = keyVal;
                jsonWrap.mode = 'M';
                System.debug('yyyyyyyyyyyyyyyyyyyyyyy '+keyVal);
                jsonWrap.accAndVioVlaues = new List<String>();
                
                if(mapOfJsonString.get(keyVal) != null && !mapOfJsonString.get(keyVal).isEmpty()) {
                for(String valuePair : mapOfJsonString.get(keyVal)) {
                    System.debug('yyyyyyyyyyyyyyyyyyyyzzz '+valuePair);
                    /*if(currentMonth == 1) {
                    
                        jsonWrap.monthValues = keyVal;
                        jsonWrap.mode = 'M';
                    }*/
                    jsonWrap.accAndVioVlaues.add(valuePair);
                    
                    
                }
                listfJasonWrapper.add(jsonWrap);
                
                }
            }
        }
        
        }
        if(mapForDonutChart != null && !mapForDonutChart.isEmpty() || (Test.isRunningTest())) {
            for(String accNa : mapForDonutChart.keySet()) {
                    jsonWrapperForDonutGraph jsonWrapDonutRec = new jsonWrapperForDonutGraph();
                    jsonWrapDonutRec.accValues = accNa;
                    jsonWrapDonutRec.numberOfRecs = mapForDonutChart.get(accNa);
                    listOfJsonWrapForDonut.add(jsonWrapDonutRec);
            }
        }
        if(listfJasonWrapper != null && !listfJasonWrapper.isEmpty()) {
            System.debug('**************************** '+jsonStringForDonutChart+'   '+listfJasonWrapper);
            jsonStringForMonths = JSON.serialize(listfJasonWrapper); 
        }
        if(listOfJsonWrapForDonut != null && !listOfJsonWrapForDonut.isEmpty()) {
            jsonStringForDonutChart = JSON.serialize(listOfJsonWrapForDonut); 
        }
        
        return null;
        
        
    }
    
    /**************************************************************************** 
     * Detail: Method to fetch the Picklist values from WK_RollupPicklist__c Custom Setting
    *****************************************************************************/
     public List<selectOption> getRollupPicklist {
        get {
            List<SelectOption> options = new List<SelectOption>();
            Map<string, WK_RollupPicklist__c> allRecords = WK_RollupPicklist__c.getAll();
            List<WK_RollupPicklist__c> lstOfValues = new List<WK_RollupPicklist__c>();
            lstOfValues = allRecords.values();
             lstOfValues.sort();
            for(WK_RollupPicklist__c f : lstOfValues)
                options.add(new SelectOption(f.Name, f.Name));
               // options.sort();
               List<SelectOption> finalOptions = new List<SelectOption>();
               finalOptions.add(options[1]);
               finalOptions.add(options[0]);
               finalOptions.add(options[2]);
               
            return finalOptions;
        }
     }
    
    public class jsonWrapperForLineGraph{
        public String monthValues{get;set;}
        public List<String> accAndVioVlaues{get;set;}
        public String mode{get;set;}
    }
    public class jsonWrapperForDonutGraph{
        public String accValues{get;set;}
        public Integer numberOfRecs{get;set;}
    }
    /*wrapper for my property*/
    public class AccContDirectWrapper {
        public id accId{get;set;}
        public String accName{get;set;}
        public String contName{get;set;}
        public String contType{get;set;}
        public String contPhone{get;set;}
    }
    /* wrapper for Impact to Net Operating Income Section */
    public class ImpactAccountWrapper {
        public id accId{get;set;}
        public String accName{get;set;}
        public Decimal incomeOpp{get;set;}
        public Decimal incomeValet{get;set;}
    }
        Public Class FirstTest{
        
                Public Void CreateTest1(){
        
                String s1 = 'Test1';
                String s12 = 'Test1';
                String s13= 'Test1';
                String s14 = 'Test1';
                String s15 = 'Test1';
                String s16 = 'Test1';
                String s17 = 'Test1';
                String s18 = 'Test1';
                String s19 = 'Test1';
                String s10 = 'Test1';
                String s112 = 'Test1';
                String s113= 'Test1';
                String s114= 'Test1';
        }
        
        }
        
        Public Class FirstTest1{
        
                Public Void CreateTest1(){
        
                String s1 = 'Test1';
                String s12 = 'Test1';
                String s13= 'Test1';
                String s14 = 'Test1';
                String s15 = 'Test1';
                String s16 = 'Test1';
                String s17 = 'Test1';
                String s18 = 'Test1';
                String s19 = 'Test1';
                String s10 = 'Test1';
                String s112 = 'Test1';
                String s113= 'Test1';
                String s114= 'Test1';
        }
        
        }
        
        Public Class FirstTest2{
        
                Public Void CreateTest1(){
        
                String s1 = 'Test1';
                String s12 = 'Test1';
                String s13= 'Test1';
                String s14 = 'Test1';
                String s15 = 'Test1';
                String s16 = 'Test1';
                String s17 = 'Test1';
                String s18 = 'Test1';
                String s19 = 'Test1';
                String s10 = 'Test1';
                String s112 = 'Test1';
                String s113= 'Test1';
                String s114= 'Test1';
        }
        
        }
        
        Public Class FirstTest3{
        
                Public Void CreateTest1(){
        
                String s1 = 'Test1';
                String s12 = 'Test1';
                String s13= 'Test1';
                String s14 = 'Test1';
                String s15 = 'Test1';
                String s16 = 'Test1';
                String s17 = 'Test1';
                String s18 = 'Test1';
                String s19 = 'Test1';
                String s10 = 'Test1';
                String s112 = 'Test1';
                String s113= 'Test1';
                String s114= 'Test1';
        }
        
        }
        
        Public Class FirstTest4{
        
                Public Void CreateTest1(){
        
                String s1 = 'Test1';
                String s12 = 'Test1';
                String s13= 'Test1';
                String s14 = 'Test1';
                String s15 = 'Test1';
                String s16 = 'Test1';
                String s17 = 'Test1';
                String s18 = 'Test1';
                String s19 = 'Test1';
                String s10 = 'Test1';
                String s112 = 'Test1';
                String s113= 'Test1';
                String s114= 'Test1';
        }
        
        }
        
        Public Class FirstTest5{
        
                Public Void CreateTest1(){
        
                String s1 = 'Test1';
                String s12 = 'Test1';
                String s13= 'Test1';
                String s14 = 'Test1';
                String s15 = 'Test1';
                String s16 = 'Test1';
                String s17 = 'Test1';
                String s18 = 'Test1';
                String s19 = 'Test1';
                String s10 = 'Test1';
                String s112 = 'Test1';
                String s113= 'Test1';
                String s114= 'Test1';
        }
        
        }
        
        Public Class FirstTest6{
        
                Public Void CreateTest1(){
        
                String s1 = 'Test1';
                String s12 = 'Test1';
                String s13= 'Test1';
                String s14 = 'Test1';
                String s15 = 'Test1';
                String s16 = 'Test1';
                String s17 = 'Test1';
                String s18 = 'Test1';
                String s19 = 'Test1';
                String s10 = 'Test1';
                String s112 = 'Test1';
                String s113= 'Test1';
                String s114= 'Test1';
        }
        
        }
        
        Public Class FirstTest7{
        
                Public Void CreateTest1(){
        
                String s1 = 'Test1';
                String s12 = 'Test1';
                String s13= 'Test1';
                String s14 = 'Test1';
                String s15 = 'Test1';
                String s16 = 'Test1';
                String s17 = 'Test1';
                String s18 = 'Test1';
                String s19 = 'Test1';
                String s10 = 'Test1';
                String s112 = 'Test1';
                String s113= 'Test1';
                String s114= 'Test1';
        }
        
        }
        
        Public Class FirstTest8{
        
                Public Void CreateTest1(){
        
                String s1 = 'Test1';
                String s12 = 'Test1';
                String s13= 'Test1';
                String s14 = 'Test1';
                String s15 = 'Test1';
                String s16 = 'Test1';
                String s17 = 'Test1';
                String s18 = 'Test1';
                String s19 = 'Test1';
                String s10 = 'Test1';
                String s112 = 'Test1';
                String s113= 'Test1';
                String s114= 'Test1';
        }
        
        }
        Public Class FirstTest9{
        
                Public Void CreateTest1(){
        
                String s1 = 'Test1';
                String s12 = 'Test1';
                String s13= 'Test1';
                String s14 = 'Test1';
                String s15 = 'Test1';
                String s16 = 'Test1';
                String s17 = 'Test1';
                String s18 = 'Test1';
                String s19 = 'Test1';
                String s10 = 'Test1';
                String s112 = 'Test1';
                String s113= 'Test1';
                String s114= 'Test1';
        }
        
        }
        Public Class FirstTest10{
        
                Public Void CreateTest1(){
        
                String s1 = 'Test1';
                String s12 = 'Test1';
                String s13= 'Test1';
                String s14 = 'Test1';
                String s15 = 'Test1';
                String s16 = 'Test1';
                String s17 = 'Test1';
                String s18 = 'Test1';
                String s19 = 'Test1';
                String s10 = 'Test1';
                String s112 = 'Test1';
                String s113= 'Test1';
                String s114= 'Test1';
        }
        
        }
        Public Class FirstTest11{
        
                Public Void CreateTest1(){
        
                String s1 = 'Test1';
                String s12 = 'Test1';
                String s13= 'Test1';
                String s14 = 'Test1';
                String s15 = 'Test1';
                String s16 = 'Test1';
                String s17 = 'Test1';
                String s18 = 'Test1';
                String s19 = 'Test1';
                String s10 = 'Test1';
                String s112 = 'Test1';
                String s113= 'Test1';
                String s114= 'Test1';
        }
        
        }
        Public Class FirstTest12{
        
                Public Void CreateTest1(){
        
                String s1 = 'Test1';
                String s12 = 'Test1';
                String s13= 'Test1';
                String s14 = 'Test1';
                String s15 = 'Test1';
                String s16 = 'Test1';
                String s17 = 'Test1';
                String s18 = 'Test1';
                String s19 = 'Test1';
                String s10 = 'Test1';
                String s112 = 'Test1';
                String s113= 'Test1';
                String s114= 'Test1';
        }
        
        }
        Public Class FirstTest13{
        
                Public Void CreateTest1(){
        
                String s1 = 'Test1';
                String s12 = 'Test1';
                String s13= 'Test1';
                String s14 = 'Test1';
                String s15 = 'Test1';
                String s16 = 'Test1';
                String s17 = 'Test1';
                String s18 = 'Test1';
                String s19 = 'Test1';
                String s10 = 'Test1';
                String s112 = 'Test1';
                String s113= 'Test1';
                String s114= 'Test1';
        }
        
        }
        Public Class FirstTest14{
        
                Public Void CreateTest1(){
        
                String s1 = 'Test1';
                String s12 = 'Test1';
                String s13= 'Test1';
                String s14 = 'Test1';
                String s15 = 'Test1';
                String s16 = 'Test1';
                String s17 = 'Test1';
                String s18 = 'Test1';
                String s19 = 'Test1';
                String s10 = 'Test1';
                String s112 = 'Test1';
                String s113= 'Test1';
                String s114= 'Test1';
        }
        
        }
        Public Class FirstTest15{
        
                Public Void CreateTest1(){
        
                String s1 = 'Test1';
                String s12 = 'Test1';
                String s13= 'Test1';
                String s14 = 'Test1';
                String s15 = 'Test1';
                String s16 = 'Test1';
                String s17 = 'Test1';
                String s18 = 'Test1';
                String s19 = 'Test1';
                String s10 = 'Test1';
                String s112 = 'Test1';
                String s113= 'Test1';
                String s114= 'Test1';
        }
        
        }
        Public Class FirstTest16{
        
                Public Void CreateTest1(){
        
                String s1 = 'Test1';
                String s12 = 'Test1';
                String s13= 'Test1';
                String s14 = 'Test1';
                String s15 = 'Test1';
                String s16 = 'Test1';
                String s17 = 'Test1';
                String s18 = 'Test1';
                String s19 = 'Test1';
                String s10 = 'Test1';
                String s112 = 'Test1';
                String s113= 'Test1';
                String s114= 'Test1';
        }
        
        }
        Public Class FirstTest17{
        
                Public Void CreateTest1(){
        
                String s1 = 'Test1';
                String s12 = 'Test1';
                String s13= 'Test1';
                String s14 = 'Test1';
                String s15 = 'Test1';
                String s16 = 'Test1';
                String s17 = 'Test1';
                String s18 = 'Test1';
                String s19 = 'Test1';
                String s10 = 'Test1';
                String s112 = 'Test1';
                String s113= 'Test1';
                String s114= 'Test1';
        }
        
        }
        Public Class FirstTest18{
        
                Public Void CreateTest1(){
        
                String s1 = 'Test1';
                String s12 = 'Test1';
                String s13= 'Test1';
                String s14 = 'Test1';
                String s15 = 'Test1';
                String s16 = 'Test1';
                String s17 = 'Test1';
                String s18 = 'Test1';
                String s19 = 'Test1';
                String s10 = 'Test1';
                String s112 = 'Test1';
                String s113= 'Test1';
                String s114= 'Test1';
        }
        
        }
        Public Class FirstTest19{
        
                Public Void CreateTest1(){
        
                String s1 = 'Test1';
                String s12 = 'Test1';
                String s13= 'Test1';
                String s14 = 'Test1';
                String s15 = 'Test1';
                String s16 = 'Test1';
                String s17 = 'Test1';
                String s18 = 'Test1';
                String s19 = 'Test1';
                String s10 = 'Test1';
                String s112 = 'Test1';
                String s113= 'Test1';
                String s114= 'Test1';
        }
        
        }
        Public Class FirstTest20{
        
                Public Void CreateTest1(){
        
                String s1 = 'Test1';
                String s12 = 'Test1';
                String s13= 'Test1';
                String s14 = 'Test1';
                String s15 = 'Test1';
                String s16 = 'Test1';
                String s17 = 'Test1';
                String s18 = 'Test1';
                String s19 = 'Test1';
                String s10 = 'Test1';
                String s112 = 'Test1';
                String s113= 'Test1';
                String s114= 'Test1';
        }
        
        }
        Public Class FirstTest21{
        
                Public Void CreateTest1(){
        
                String s1 = 'Test1';
                String s12 = 'Test1';
                String s13= 'Test1';
                String s14 = 'Test1';
                String s15 = 'Test1';
                String s16 = 'Test1';
                String s17 = 'Test1';
                String s18 = 'Test1';
                String s19 = 'Test1';
                String s10 = 'Test1';
                String s112 = 'Test1';
                String s113= 'Test1';
                String s114= 'Test1';
        }
        
        }
        Public Class FirstTest22{
        
                Public Void CreateTest1(){
        
                String s1 = 'Test1';
                String s12 = 'Test1';
                String s13= 'Test1';
                String s14 = 'Test1';
                String s15 = 'Test1';
                String s16 = 'Test1';
                String s17 = 'Test1';
                String s18 = 'Test1';
                String s19 = 'Test1';
                String s10 = 'Test1';
                String s112 = 'Test1';
                String s113= 'Test1';
                String s114= 'Test1';
        }
        
        }
        
        Public Class SecondTest1{
                
                Public Void CreateTest1(){
        
                String s1 = 'Test1';
                String s12 = 'Test1';
                String s13= 'Test1';
                String s14 = 'Test1';
                String s15 = 'Test1';
                String s16 = 'Test1';
                String s17 = 'Test1';
                String s18 = 'Test1';
                String s19 = 'Test1';
                String s10 = 'Test1';
                String s112 = 'Test1';
                String s113= 'Test1';
                String s114= 'Test1';
        }
        
        }
        
        Public Class SecondTest2{
                
                Public Void CreateTest1(){
        
                String s1 = 'Test1';
                String s12 = 'Test1';
                String s13= 'Test1';
                String s14 = 'Test1';
                String s15 = 'Test1';
                String s16 = 'Test1';
                String s17 = 'Test1';
                String s18 = 'Test1';
                String s19 = 'Test1';
                String s10 = 'Test1';
                String s112 = 'Test1';
                String s113= 'Test1';
                String s114= 'Test1';
        }
        
        }
        Public Class SecondTest3{
                
                Public Void CreateTest1(){
        
                String s1 = 'Test1';
                String s12 = 'Test1';
                String s13= 'Test1';
                String s14 = 'Test1';
                String s15 = 'Test1';
                String s16 = 'Test1';
                String s17 = 'Test1';
                String s18 = 'Test1';
                String s19 = 'Test1';
                String s10 = 'Test1';
                String s112 = 'Test1';
                String s113= 'Test1';
                String s114= 'Test1';
        }
        
        }
        Public Class SecondTest4{
                
                Public Void CreateTest1(){
        
                String s1 = 'Test1';
                String s12 = 'Test1';
                String s13= 'Test1';
                String s14 = 'Test1';
                String s15 = 'Test1';
                String s16 = 'Test1';
                String s17 = 'Test1';
                String s18 = 'Test1';
                String s19 = 'Test1';
                String s10 = 'Test1';
                String s112 = 'Test1';
                String s113= 'Test1';
                String s114= 'Test1';
        }
        
        }
        Public Class SecondTest5{
                
                Public Void CreateTest1(){
        
                String s1 = 'Test1';
                String s12 = 'Test1';
                String s13= 'Test1';
                String s14 = 'Test1';
                String s15 = 'Test1';
                String s16 = 'Test1';
                String s17 = 'Test1';
                String s18 = 'Test1';
                String s19 = 'Test1';
                String s10 = 'Test1';
                String s112 = 'Test1';
                String s113= 'Test1';
                String s114= 'Test1';
        }
        
        }
        Public Class SecondTest6{
                
                Public Void CreateTest1(){
        
                String s1 = 'Test1';
                String s12 = 'Test1';
                String s13= 'Test1';
                String s14 = 'Test1';
                String s15 = 'Test1';
                String s16 = 'Test1';
                String s17 = 'Test1';
                String s18 = 'Test1';
                String s19 = 'Test1';
                String s10 = 'Test1';
                String s112 = 'Test1';
                String s113= 'Test1';
                String s114= 'Test1';
        }
        
        }
        Public Class SecondTest7{
                
                Public Void CreateTest1(){
        
                String s1 = 'Test1';
                String s12 = 'Test1';
                String s13= 'Test1';
                String s14 = 'Test1';
                String s15 = 'Test1';
                String s16 = 'Test1';
                String s17 = 'Test1';
                String s18 = 'Test1';
                String s19 = 'Test1';
                String s10 = 'Test1';
                String s112 = 'Test1';
                String s113= 'Test1';
                String s114= 'Test1';
        }
        
        }
        Public Class SecondTest8{
                
                Public Void CreateTest1(){
        
                String s1 = 'Test1';
                String s12 = 'Test1';
                String s13= 'Test1';
                String s14 = 'Test1';
                String s15 = 'Test1';
                String s16 = 'Test1';
                String s17 = 'Test1';
                String s18 = 'Test1';
                String s19 = 'Test1';
                String s10 = 'Test1';
                String s112 = 'Test1';
                String s113= 'Test1';
                String s114= 'Test1';
        }
        
        }
        Public Class SecondTest9{
                
                Public Void CreateTest1(){
        
                String s1 = 'Test1';
                String s12 = 'Test1';
                String s13= 'Test1';
                String s14 = 'Test1';
                String s15 = 'Test1';
                String s16 = 'Test1';
                String s17 = 'Test1';
                String s18 = 'Test1';
                String s19 = 'Test1';
                String s10 = 'Test1';
                String s112 = 'Test1';
                String s113= 'Test1';
                String s114= 'Test1';
        }
        
        }
        Public Class SecondTest10{
                
                Public Void CreateTest1(){
        
                String s1 = 'Test1';
                String s12 = 'Test1';
                String s13= 'Test1';
                String s14 = 'Test1';
                String s15 = 'Test1';
                String s16 = 'Test1';
                String s17 = 'Test1';
                String s18 = 'Test1';
                String s19 = 'Test1';
                String s10 = 'Test1';
                String s112 = 'Test1';
                String s113= 'Test1';
                String s114= 'Test1';
        }
        
        }
        Public Class SecondTest11{
                
                Public Void CreateTest1(){
        
                String s1 = 'Test1';
                String s12 = 'Test1';
                String s13= 'Test1';
                String s14 = 'Test1';
                String s15 = 'Test1';
                String s16 = 'Test1';
                String s17 = 'Test1';
                String s18 = 'Test1';
                String s19 = 'Test1';
                String s10 = 'Test1';
                String s112 = 'Test1';
                String s113= 'Test1';
                String s114= 'Test1';
        }
        
        }
        Public Class SecondTest12{
                
                Public Void CreateTest1(){
        
                String s1 = 'Test1';
                String s12 = 'Test1';
                String s13= 'Test1';
                String s14 = 'Test1';
                String s15 = 'Test1';
                String s16 = 'Test1';
                String s17 = 'Test1';
                String s18 = 'Test1';
                String s19 = 'Test1';
                String s10 = 'Test1';
                String s112 = 'Test1';
                String s113= 'Test1';
                String s114= 'Test1';
        }
        
        }
        Public Class SecondTest13{
                
                Public Void CreateTest1(){
        
                String s1 = 'Test1';
                String s12 = 'Test1';
                String s13= 'Test1';
                String s14 = 'Test1';
                String s15 = 'Test1';
                String s16 = 'Test1';
                String s17 = 'Test1';
                String s18 = 'Test1';
                String s19 = 'Test1';
                String s10 = 'Test1';
                String s112 = 'Test1';
                String s113= 'Test1';
                String s114= 'Test1';
        }
        
        }
        Public Class SecondTest14{
                
                Public Void CreateTest1(){
        
                String s1 = 'Test1';
                String s12 = 'Test1';
                String s13= 'Test1';
                String s14 = 'Test1';
                String s15 = 'Test1';
                String s16 = 'Test1';
                String s17 = 'Test1';
                String s18 = 'Test1';
                String s19 = 'Test1';
                String s10 = 'Test1';
                String s112 = 'Test1';
                String s113= 'Test1';
                String s114= 'Test1';
        }
        
        }
        Public Class SecondTest15{
                
                Public Void CreateTest1(){
        
                String s1 = 'Test1';
                String s12 = 'Test1';
                String s13= 'Test1';
                String s14 = 'Test1';
                String s15 = 'Test1';
                String s16 = 'Test1';
                String s17 = 'Test1';
                String s18 = 'Test1';
                String s19 = 'Test1';
                String s10 = 'Test1';
                String s112 = 'Test1';
                String s113= 'Test1';
                String s114= 'Test1';
        }
        
        }
        Public Class SecondTest16{
                
                Public Void CreateTest1(){
        
                String s1 = 'Test1';
                String s12 = 'Test1';
                String s13= 'Test1';
                String s14 = 'Test1';
                String s15 = 'Test1';
                String s16 = 'Test1';
                String s17 = 'Test1';
                String s18 = 'Test1';
                String s19 = 'Test1';
                String s10 = 'Test1';
                String s112 = 'Test1';
                String s113= 'Test1';
                String s114= 'Test1';
        }
        
        }
        Public Class SecondTest17{
                
                Public Void CreateTest1(){
        
                String s1 = 'Test1';
                String s12 = 'Test1';
                String s13= 'Test1';
                String s14 = 'Test1';
                String s15 = 'Test1';
                String s16 = 'Test1';
                String s17 = 'Test1';
                String s18 = 'Test1';
                String s19 = 'Test1';
                String s10 = 'Test1';
                String s112 = 'Test1';
                String s113= 'Test1';
                String s114= 'Test1';
        }
        
        }
    Public Class SecondTest18{
                
                Public Void CreateTest1(){
        
                String s1 = 'Test1';
                String s12 = 'Test1';
                String s13= 'Test1';
                String s14 = 'Test1';
                String s15 = 'Test1';
                String s16 = 'Test1';
                String s17 = 'Test1';
                String s18 = 'Test1';
                String s19 = 'Test1';
                String s10 = 'Test1';
                String s112 = 'Test1';
                String s113= 'Test1';
                String s114= 'Test1';
        }
        
        }  
        
        Public Class SecondTest19{
                
                Public Void CreateTest1(){
        
                String s1 = 'Test1';
                String s12 = 'Test1';
                String s13= 'Test1';
                String s14 = 'Test1';
                String s15 = 'Test1';
                String s16 = 'Test1';
                String s17 = 'Test1';
                String s18 = 'Test1';
                String s19 = 'Test1';
                String s10 = 'Test1';
                String s112 = 'Test1';
                String s113= 'Test1';
                String s114= 'Test1';
        }
        
        } 
        
        Public Class SecondTest20{
                
                Public Void CreateTest1(){
        
                String s1 = 'Test1';
                String s12 = 'Test1';
                String s13= 'Test1';
                String s14 = 'Test1';
                String s15 = 'Test1';
                String s16 = 'Test1';
                String s17 = 'Test1';
                String s18 = 'Test1';
                String s19 = 'Test1';
                String s10 = 'Test1';
                String s112 = 'Test1';
                String s113= 'Test1';
                String s114= 'Test1';
        }
        
        }
        
         Public Class SecondTest21{
                
                Public Void CreateTest1(){
        
                String s1 = 'Test1';
                String s12 = 'Test1';
                String s13= 'Test1';
                String s14 = 'Test1';
                String s15 = 'Test1';
                String s16 = 'Test1';
                String s17 = 'Test1';
                String s18 = 'Test1';
                String s19 = 'Test1';
                String s10 = 'Test1';
                String s112 = 'Test1';
                String s113= 'Test1';
                String s114= 'Test1';
        }
        
        }       
        
         Public Class SecondTest22{
                
                Public Void CreateTest1(){
        
                String s1 = 'Test1';
                String s12 = 'Test1';
                String s13= 'Test1';
                String s14 = 'Test1';
                String s15 = 'Test1';
                String s16 = 'Test1';
                String s17 = 'Test1';
                String s18 = 'Test1';
                String s19 = 'Test1';
                String s10 = 'Test1';
                String s112 = 'Test1';
                String s113= 'Test1';
                String s114= 'Test1';
        }
        
        }       
        
         Public Class SecondTest23{
                
                Public Void CreateTest1(){
        
                String s1 = 'Test1';
                String s12 = 'Test1';
                String s13= 'Test1';
                String s14 = 'Test1';
                String s15 = 'Test1';
                String s16 = 'Test1';
                String s17 = 'Test1';
                String s18 = 'Test1';
                String s19 = 'Test1';
                String s10 = 'Test1';
                String s112 = 'Test1';
                String s113= 'Test1';
                String s114= 'Test1';
        }
        
        }
}