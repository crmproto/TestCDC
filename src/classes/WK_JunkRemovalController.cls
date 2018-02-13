/****************************************************************************
 * Class: WK_JunkRemovalController

 * Author: Anush Shivanna (Anush S himanshu)

 * Date:   `25/07/2017
 * Detail: Class to create WorkOrder and WOLI on Portal.

/******Suchet Comment ***********/

*****************************************************************************/
global without sharing class WK_JunkRemovalController {

 public static Date woliScheduledDate{get;set;}
 public static String selectedPreferenceForNotification{get;set;}
 public static String typeOfServiceOrder{get;set;}
 public static String selectedAuth{get;set;}
 public static String pickupMode{get;set;}
 public static String detailAddress{get;set;}
 public static String stateAndCountryAddress{get;set;}
 public static String finalAddress{get;set;}
 public static Decimal halfTrailerValue{get;set;}
 public static Decimal fullTrailerValue{get;set;}
 public static String costEstimate{get;set;}
 public static Id workOrderIdToNextPage{get;set;}
 public static String addressLine1{get;set;}
 public static String city{get;set;}
 public static String contactLastName{get;set;}
 public static String contactFirstName{get;set;}
 public static String contactPhoneName{get;set;}
 public static String contactEmail{get;set;}
 public User UserRec {get;set;}
 public Contact contactRec {get;set;}
 public static Boolean redeemFreePointsCheck {get;set;}
 public static String numberOfRedeemAvailable {get;set;}
 public static String defaultnumbOfRedeemAvailable {get;set;}
 public static String selectedState{get;set;}
 public static String zipCode{get;set;}
 public static String previousAddressLine1 = '';
 public static Boolean fifteenFeet{get;set;}
 public static Boolean tenFeet{get;set;}
 public static String previousCity = '';
 public static String previousSelectedState = '';
 public static String previousZipCode = '';
 public static String itemLocationDetails{get;set;}
 public static String specialInstructions{get;set;}
 public static String phoneNumber{get;set;}
 public static String latForOther{get;set;}
 public static String longForOther{get;set;}
 public static String previousPhoneNumber{get;set;}
 public  String accountId{get;set;}
 public List<Account> accNameRec;
 public Id loggedConAccId;
 public Decimal costValues{get;set;}
 public List<Contact> loggedInContact = new List<Contact>();
 
 
  /**************************************************************************** 
     * Detail: Construtor for WK_JunkRemovalController
    *****************************************************************************/
  public WK_JunkRemovalController(){    
      selectedPreferenceForNotification = '';
      typeOfServiceOrder = '';
      addressLine1 = '';
      //loggedConAccId = '';
      city = '';
      fifteenFeet = false;
      tenFeet = false;
      zipCode = '';
      detailAddress = '';
      stateAndCountryAddress = '';
      selectedAuth = '';
      contactLastName = '';
      contactFirstName = '';
      contactPhoneName = '';
      contactEmail = '';
      costValues = 0.0;
      finalAddress = '';
      UserRec = new User();
      contactRec = new Contact();
      selectedState = '';
      phoneNumber = '';
      itemLocationDetails = '';
      specialInstructions = '';
      pickupMode = '';
      redeemFreePointsCheck = false;
      accNameRec = new List<Account>();
      //accNameRec = new List<Account>();
      List<WK_States__c> lstOfStates = WK_States__c.getAll().values();
      Map<string, WK_States__c> mapOfStates = new Map<String,WK_States__c>();
      Map<string, WK_States__c> mapOfStatesWithNames = new Map<String,WK_States__c>();
      if(lstOfStates != null && !lstOfStates.isEmpty()) {
          for(WK_States__c state : lstOfStates) {
              if(!mapOfStates.containsKey(state.Abbreviations__c)) {
                  mapOfStates.put(state.Abbreviations__c,state);
                  mapOfStatesWithNames.put(state.Name,state);
              }
          }
      }
      
      
      List<User> loggedUser = new List<User>();
      Id ownerId = UserInfo.getUserId();
        try{
            loggedUser = [SELECT Id, ContactId,FirstName, LastName, Username,WK_Frequency__c, Email, phone,WK_Emergency_Contact__c, MobilePhone from User Where Id=: ownerId];
                UserRec = loggedUser[0];
                loggedInContact = [Select Id,Name,FirstName,LastName,Email,MobilePhone,AccountId,Account.WK_Available_Free_Pick_Ups__c,Account.WK_Default_Free_Pickups__c,Account.WK_Contracted_Quote_Amount__c,Account.Name,Account.OwnerID,Account.Phone,Account.ShippingLatitude,Account.ShippingLongitude,Account.ShippingAddress,Account.ShippingStreet,Account.ShippingCity,Account.ShippingState,Account.ShippingPostalCode from Contact where Id =: loggedUser[0].ContactId];   
        }
        catch(QueryException qe) {
            System.debug('Query Failed '+ qe.getMessage());
        }
        accountId = ApexPages.currentPage().getParameters().get('Id');
        if(String.isNotBlank(accountId)) {
            accNameRec = [Select id, name,phone, WK_Available_Free_Pick_Ups__c,WK_Default_Free_Pickups__c, WK_Contracted_Quote_Amount__c,OwnerID,ShippingLatitude,ShippingLongitude,ShippingAddress,ShippingStreet,ShippingCity,ShippingState,ShippingPostalCode from Account where id =: accountId];
        }
        if(loggedInContact != null && !loggedInContact.isEmpty()) {
            contactRec = loggedInContact[0];
            Location locRe = new Location();
            Decimal lat;
            Decimal longi;
			if(!accNameRec.isEmpty()) {
                phoneNumber = accNameRec[0].Phone;
            }
            else {
                phoneNumber = contactRec.Account.Phone;
            }
			contactFirstName = 
            contactLastName = contactRec.LastName;
            
            previousPhoneNumber = contactRec.MobilePhone;
            
            if(accNameRec != null && !accNameRec.isEmpty()) {
                lat = accNameRec[0].Shippinglatitude;
                longi = accNameRec[0].shippinglongitude;
                if(lat != null && longi != null) {
                    locRe = Location.newInstance(lat,longi);
                }
                if(locRe != null) {
                    if(locRe.getLatitude() != null && locRe.getLongitude() != null) {
                         if(!Test.isRunningTest()) {
                             halfTrailerValue = WK_JunkRemovalFormula.calculateJunkRemoval(WK_ConstantUtility.halfTrailer,locRe).round(System.RoundingMode.HALF_UP);
                             if(accNameRec[0].WK_Contracted_Quote_Amount__c != null) {
                                 fullTrailerValue = (accNameRec[0].WK_Contracted_Quote_Amount__c).round(System.RoundingMode.HALF_UP);
                                 costValues = (accNameRec[0].WK_Contracted_Quote_Amount__c).round(System.RoundingMode.HALF_UP);
                            }
                            else {
                                fullTrailerValue = WK_JunkRemovalFormula.calculateJunkRemoval(WK_ConstantUtility.fullTrailer,locRe).round(System.RoundingMode.HALF_UP);
                            }
                         }
                    }
                }
            if(String.isNotBlank(accNameRec[0].ShippingStreet)) {
                addressLine1 = accNameRec[0].ShippingStreet;
                previousAddressLine1 = accNameRec[0].ShippingStreet;
            }
            if(accNameRec[0].WK_Available_Free_Pick_Ups__c != null) {
                numberOfRedeemAvailable = String.valueOf(accNameRec[0].WK_Available_Free_Pick_Ups__c);
            }
             if(accNameRec[0].WK_Default_Free_Pickups__c != null) {
                defaultnumbOfRedeemAvailable = String.valueOf(accNameRec[0].WK_Default_Free_Pickups__c);
            }
            if(String.isNotBlank(accNameRec[0].ShippingCity)) {
                city = accNameRec[0].ShippingCity;
                previousCity = accNameRec[0].ShippingCity;
            }
            if(String.isNotBlank(accNameRec[0].ShippingState)) {
                if(accNameRec[0].ShippingState == WK_ConstantUtility.texasCity || accNameRec[0].ShippingState == WK_ConstantUtility.texasAbbreviation) {
                    fifteenFeet = true;
                }
                else if(accNameRec[0].ShippingState == WK_ConstantUtility.floridaCity || accNameRec[0].ShippingState == WK_ConstantUtility.gorgiaCity || accNameRec[0].ShippingState == WK_ConstantUtility.gorgiaAbbreviation || accNameRec[0].ShippingState == WK_ConstantUtility.floridaAbbreviation) {
                        tenFeet = true;
                }
                if(String.isNotBlank(accNameRec[0].ShippingState)) {
                    if(mapOfStates.containsKey(accNameRec[0].ShippingState)) {
                        selectedState = mapOfStates.get(accNameRec[0].ShippingState).Name;
                        previousSelectedState = mapOfStates.get(accNameRec[0].ShippingState).Name;
                        //detailAddress = accNameRec[0].ShippingStreet+', '+accNameRec[0].ShippingCity+', '+selectedState+', '+accNameRec[0].ShippingPostalCode;
                        detailAddress = accNameRec[0].ShippingStreet;
                        stateAndCountryAddress = accNameRec[0].ShippingCity+', '+selectedState+', '+accNameRec[0].ShippingPostalCode;
                    }
                    else if(mapOfStatesWithNames.containsKey(accNameRec[0].ShippingState)) {
                        selectedState = mapOfStatesWithNames.get(accNameRec[0].ShippingState).Name;
                        previousSelectedState = mapOfStatesWithNames.get(accNameRec[0].ShippingState).Name;
                        //detailAddress = accNameRec[0].ShippingStreet+', '+accNameRec[0].ShippingCity+', '+selectedState+', '+accNameRec[0].ShippingPostalCode;
                        detailAddress = accNameRec[0].ShippingStreet;
                        stateAndCountryAddress = accNameRec[0].ShippingCity+', '+selectedState+', '+accNameRec[0].ShippingPostalCode;
                    }
                
                }
                
            }
            if(String.isNotBlank(accNameRec[0].ShippingPostalCode)) {
                zipCode = accNameRec[0].ShippingPostalCode;
                previousZipCode = accNameRec[0].ShippingPostalCode;
            }
            /*if(loggedInContact != null && !loggedInContact.isEmpty()) {
                phoneNumber = contactRec.MobilePhone;
                contactLastName = contactRec.LastName;
                previousPhoneNumber = contactRec.MobilePhone;
            }*/
            finalAddress = addressLine1+','+city+','+selectedState+','+zipCode;
            }
            else {
                loggedConAccId = loggedInContact[0].AccountId;
                if(lat != null && longi != null) {
                    lat = loggedInContact[0].Account.Shippinglatitude;
                    longi = loggedInContact[0].Account.shippinglongitude;
                }
            locRe = Location.newInstance(lat,longi);
            if(locRe != null) {
                    if(locRe.getLatitude() != null && locRe.getLongitude() != null) {
                         if(!Test.isRunningTest()) {
                             halfTrailerValue = WK_JunkRemovalFormula.calculateJunkRemoval(WK_ConstantUtility.halfTrailer,locRe).round(System.RoundingMode.HALF_UP);
                             if(loggedInContact[0].Account.WK_Contracted_Quote_Amount__c != null) {
                                 costValues = (loggedInContact[0].Account.WK_Contracted_Quote_Amount__c).round(System.RoundingMode.HALF_UP);
                                 fullTrailerValue = (loggedInContact[0].Account.WK_Contracted_Quote_Amount__c).round(System.RoundingMode.HALF_UP);
                             }
                             else {
                                fullTrailerValue = WK_JunkRemovalFormula.calculateJunkRemoval(WK_ConstantUtility.fullTrailer,locRe).round(System.RoundingMode.HALF_UP);
                             }
                        }
                    }
            }
            if(String.isNotBlank(loggedInContact[0].Account.ShippingStreet)) {
                addressLine1 = loggedInContact[0].Account.ShippingStreet;
                previousAddressLine1 = loggedInContact[0].Account.ShippingStreet;
            }
            if(loggedInContact[0].Account.WK_Available_Free_Pick_Ups__c != null) {
                numberOfRedeemAvailable = String.valueOf(loggedInContact[0].Account.WK_Available_Free_Pick_Ups__c);
            }
            if(loggedInContact[0].Account.WK_Default_Free_Pickups__c != null) {
                defaultnumbOfRedeemAvailable = String.valueOf(loggedInContact[0].Account.WK_Default_Free_Pickups__c);
            }
            if(String.isNotBlank(loggedInContact[0].Account.ShippingCity)) {
                city = loggedInContact[0].Account.ShippingCity;
                previousCity = loggedInContact[0].Account.ShippingCity;
            }
            if(String.isNotBlank(loggedInContact[0].Account.ShippingState)) {
                if(loggedInContact[0].Account.ShippingState == WK_ConstantUtility.texasCity || loggedInContact[0].Account.ShippingState == WK_ConstantUtility.texasAbbreviation) {
                    fifteenFeet = true;
                }
                else if(loggedInContact[0].Account.ShippingState == WK_ConstantUtility.floridaCity || loggedInContact[0].Account.ShippingState == WK_ConstantUtility.gorgiaCity || loggedInContact[0].Account.ShippingState == WK_ConstantUtility.gorgiaAbbreviation || loggedInContact[0].Account.ShippingState == WK_ConstantUtility.floridaAbbreviation) {
                        tenFeet = true;
                }
                if(String.isNotBlank(loggedInContact[0].Account.ShippingState)) {
                    if(mapOfStates.containsKey(loggedInContact[0].Account.ShippingState)) {
                        selectedState = mapOfStates.get(loggedInContact[0].Account.ShippingState).Name;
                        previousSelectedState = mapOfStates.get(loggedInContact[0].Account.ShippingState).Name;
                        //detailAddress = loggedInContact[0].Account.ShippingStreet+', '+loggedInContact[0].Account.ShippingCity+', '+selectedState+', '+loggedInContact[0].Account.ShippingPostalCode;
                        detailAddress = loggedInContact[0].Account.ShippingStreet;
                        stateAndCountryAddress = loggedInContact[0].Account.ShippingCity+', '+selectedState+', '+loggedInContact[0].Account.ShippingPostalCode;
                    }
                    else if(mapOfStatesWithNames.containsKey(loggedInContact[0].Account.ShippingState)) {
                        selectedState = mapOfStatesWithNames.get(loggedInContact[0].Account.ShippingState).Name;
                        previousSelectedState = mapOfStatesWithNames.get(loggedInContact[0].Account.ShippingState).Name;
                       // detailAddress = loggedInContact[0].Account.ShippingStreet+', '+loggedInContact[0].Account.ShippingCity+', '+selectedState+', '+loggedInContact[0].Account.ShippingPostalCode;
                       detailAddress = loggedInContact[0].Account.ShippingStreet;
                        stateAndCountryAddress = loggedInContact[0].Account.ShippingCity+', '+selectedState+', '+loggedInContact[0].Account.ShippingPostalCode;
                    }
                
                }
                
            }
            if(String.isNotBlank(loggedInContact[0].Account.ShippingPostalCode)) {
                zipCode = loggedInContact[0].Account.ShippingPostalCode;
                previousZipCode = loggedInContact[0].Account.ShippingPostalCode;
            }
           /* if(loggedInContact != null && !loggedInContact.isEmpty()) {
                phoneNumber = contactRec.MobilePhone;
                contactLastName = contactRec.LastName;
                previousPhoneNumber = contactRec.MobilePhone;
            }*/
            finalAddress = addressLine1+','+city+','+selectedState+','+zipCode;
            }
        }
  
  }
  
    /**************************************************************************** 
     * Detail: Method to redirect to Home Page
    *****************************************************************************/
    
  public PageReference redirectToHomePage(){
       Id accId;
          if(loggedConAccId != null) {
              accId = loggedConAccId;
          }
          else {
              accId = accountId;
          }
       Pagereference ref = new Pagereference(WK_ConstantUtility.urlHomePage+'?'+WK_ConstantUtility.urlContainingId+'='+accId);       
     //  ref.setRedirect(true);
        return ref;
  }
  
  
  /**************************************************************************** 
     * Detail: Method to fetch the State values from WK_States Custom Setting
    *****************************************************************************/
   public List<selectOption> getStatesPicklist {
        get {
            List<SelectOption> options = new List<SelectOption>();
            Map<string, WK_States__c> allRecords = WK_States__c.getAll();
            List<WK_States__c> lstOfStates = new List<WK_States__c>();
            lstOfStates = allRecords.values();
             lstOfStates.sort();
            for( WK_States__c f : lstOfStates)
                options.add(new SelectOption(f.Name, f.Name));
                options.sort();
            return options;
        }
    }
  
  /**************************************************************************** 
     * Detail: Method to Save the Work Order , WOLI and Case
    *****************************************************************************/
    
  public  PageReference saveWOWOLIRecords() {
  List<WorkOrder> listOfWorkOrders = new List<WorkOrder>();
  List<WorkOrderLineItem> listOfWOLIs = new List<WorkOrderLineItem>();
  List<WorkType> listOfWTs = new List<WorkType>();
  List<PriceBook2> lstOfPriceBooks = new List<PriceBook2>();
  List<PricebookEntry> lstOfProducts = new List<PricebookEntry>();
  List<Case> lstOfCases = new List<Case>();
  Case caseRecToInsert = new Case();
  User userRec = new User();
  Account accRecToUpdate = new Account();
  List<Database.SaveResult> result;
  List<Database.SaveResult> finalResult;    
  userRec.Id = userInfo.getUserId();
  Decimal trailerValue;
  WorkOrder workOrderRec = new WorkOrder();
  WorkOrderLineItem workOrderLineItem = new WorkOrderLineItem();
  Id caseRecordTypeId;
  if(Schema.SObjectType.Case.getRecordTypeInfosByName().get('WK Junk Removal Case') != null) {
      caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('WK Junk Removal Case').getRecordTypeId();
  }
  WorkType workTyRec = new WorkType();
  try {
      lstOfPriceBooks = [Select Id, Name from PriceBook2 Where Name=: WK_ConstantUtility.wkPrieBookName];
      if(lstOfPriceBooks != null && !lstOfPriceBooks.isEmpty()) {
          lstOfProducts = [Select Id, Name from PricebookEntry Where Name =: WK_ConstantUtility.wkProductName AND Pricebook2Id =:lstOfPriceBooks[0].Id];
      }
      listOfWTs = [Select Id,Name from WorkType where Name=: WK_ConstantUtility.wkProductName];
  }
  catch(Exception ex) {
      System.debug('Exception Occured '+ex.getMessage());
  }
  if(String.isNotBlank(latForOther) && String.isNotBlank(longForOther)) {
      Location locRec = new Location();
      try{
      locRec = Location.newInstance(Decimal.valueOf(latForOther), Decimal.valueOf(longForOther));
      }
      catch(Exception ex) {
          System.debug('Exception '+ex.getMessage());
      }
      if(locRec != null) {
          if(typeOfServiceOrder == WK_ConstantUtility.half) {
              trailerValue = WK_JunkRemovalFormula.calculateJunkRemoval(WK_ConstantUtility.fullTrailer,locRec);
              if(trailerValue != null) {
                  workOrderRec.WK_Quote_Amount_Full_Trailer__c = trailerValue.round(System.RoundingMode.HALF_UP);
              }
          }
          else if(typeOfServiceOrder == WK_ConstantUtility.full) {
                  trailerValue = WK_JunkRemovalFormula.calculateJunkRemoval(WK_ConstantUtility.halfTrailer,locRec);
                  if(trailerValue != null) {
                      workOrderRec.WK_Quote_Half_Trailer__c = trailerValue.round(System.RoundingMode.HALF_UP);
                  }
          }
      
      }
  }
  if(accNameRec != null && !accNameRec.isEmpty() ) {
      workOrderRec.AccountId = accNameRec[0].Id;
      caseRecToInsert.AccountId = accNameRec[0].Id;
      accRecToUpdate.Id = accNameRec[0].Id;
      accRecToUpdate.WK_Available_Free_Pick_Ups__c = accNameRec[0].WK_Available_Free_Pick_Ups__c;
  }
  else {
      workOrderRec.AccountId = loggedInContact[0].AccountId;
      accRecToUpdate.Id = loggedInContact[0].AccountId;
      caseRecToInsert.AccountId = loggedInContact[0].AccountId;
      accRecToUpdate.WK_Available_Free_Pick_Ups__c = loggedInContact[0].Account.WK_Available_Free_Pick_Ups__c;
  }
  if(redeemFreePointsCheck == true) {
      
    /*  if(numberOfRedeemAvailable != '0') {
          System.debug('0000000000000000000000000000 '+numberOfRedeemAvailable);    
          accRecToUpdate.WK_Available_Free_Pick_Ups__c = Integer.valueOf(numberOfRedeemAvailable) - 1;
      
      }
      else {
          accRecToUpdate.WK_Available_Free_Pick_Ups__c =Integer.valueOf(numberOfRedeemAvailable);
      }*/
      
  }
  
  workOrderRec.ContactId = loggedInContact[0].Id;
  caseRecToInsert.Origin = WK_ConstantUtility.contactUsPropertyManagerPortal;
  caseRecToInsert.Type = WK_ConstantUtility.contactUsAddService;
  caseRecToInsert.Sub_Type__c = WK_ConstantUtility.contactUsJunkRemoval;
  if(loggedInContact != null && !loggedInContact.isEmpty()) {
      caseRecToInsert.ContactId = loggedInContact[0].Id;
      if(accNameRec != null && !accNameRec.isEmpty() ) {
          caseRecToInsert.OwnerID = accNameRec[0].OwnerId;
      }
      else {
          caseRecToInsert.OwnerID = loggedInContact[0].Account.OwnerID;
      }
      if(caseRecordTypeId != null) {
          caseRecToInsert.RecordTypeId = caseRecordTypeId;
      }
  }
  if(String.isNotBlank(typeOfServiceOrder)) {
      if(typeOfServiceOrder ==  WK_ConstantUtility.half) {
          caseRecToInsert.WK_Trailer_Type__c = WK_ConstantUtility.halfTrailer;
      }
      else {
          caseRecToInsert.WK_Trailer_Type__c = WK_ConstantUtility.fullTrailer; 
      }
    }
  lstOfCases.add(caseRecToInsert); 
  if(lstOfCases != null && !lstOfCases.isEmpty()) {
                     //  try {
                               
                           finalResult = Database.insert(lstOfCases,false);
                    /*   }
                       catch(Exception ex) {
                           System.debug('Exception Occured '+ ex.getMessage());
                       }*/
                   }
  if(finalResult != null && finalResult[0].isSuccess()) {   
      workOrderIdToNextPage = lstOfCases[0].Id;             
      workOrderRec.Status =  WK_ConstantUtility.contactUsNew;
      workOrderRec.CaseId = lstOfCases[0].Id;
      workOrderRec.RecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get(WK_ConstantUtility.wkProductName).getRecordTypeId();
  if(lstOfPriceBooks != null && !lstOfPriceBooks.isEmpty()) {
      workOrderRec.Pricebook2Id = lstOfPriceBooks[0].Id;
  }
  if(listOfWTs != null && !listOfWTs.isEmpty()) {
      workOrderRec.WorkTypeId = listOfWTs[0].Id;
  }
  System.debug('******** '+addressLine1+' '+city+' '+selectedPreferenceForNotification +' '+typeOfServiceOrder+' '+selectedAuth+ ' '+woliScheduledDate );
  if(String.isNotBlank(addressLine1)) {
      if(previousAddressLine1 != addressLine1) {
          workOrderRec.Street = addressLine1;
      }
  }
  if(String.isNotBlank(city)) {
      if(previousCity != city) {
          workOrderRec.City = city;
      }
  }
  if(String.isNotBlank(selectedState)) {
      if(previousSelectedState != city) {
          workOrderRec.State= selectedState;
      }
  }
  if(String.isNotBlank(zipCode)) {
      if(previousZipCode != zipCode) {
          workOrderRec.PostalCode = zipCode;
      }
  }
  if(String.isNotBlank(costEstimate)) {
      if(typeOfServiceOrder == WK_ConstantUtility.half) {
          workOrderRec.WK_Quote_Half_Trailer__c = Decimal.valueOf(costEstimate.substring(1));
      }
      else if(typeOfServiceOrder == WK_ConstantUtility.full){
              if(redeemFreePointsCheck == true) {
                  workOrderRec.WK_Quote_Amount_Full_Trailer__c = 0;
                  workOrderRec.WK_Redeem_Free_Pick_Up__c = true;
                  System.debug('0000000000000000000000000000 '+workOrderRec.WK_Quote_Amount_Full_Trailer__c);
                  if(accRecToUpdate.WK_Available_Free_Pick_Ups__c != null) {
                      if(accRecToUpdate.WK_Available_Free_Pick_Ups__c > 0) {
                          accRecToUpdate.WK_Available_Free_Pick_Ups__c -= 1;
                      }
                  }
              }
              else {
                  if(accNameRec != null && !accNameRec.isEmpty()) {
                      if(accNameRec[0].WK_Contracted_Quote_Amount__c != null) {
                          workOrderRec.WK_Quote_Amount_Full_Trailer__c = accNameRec[0].WK_Contracted_Quote_Amount__c;
                      }
                      else {
                          workOrderRec.WK_Quote_Amount_Full_Trailer__c = Decimal.valueOf(costEstimate.substring(1));
                      }
                  }
                  else {
                      if(loggedInContact[0].Account.WK_Contracted_Quote_Amount__c != null) {
                          workOrderRec.WK_Quote_Amount_Full_Trailer__c = loggedInContact[0].Account.WK_Contracted_Quote_Amount__c;
                      }
                      else {
                      workOrderRec.WK_Quote_Amount_Full_Trailer__c = Decimal.valueOf(costEstimate.substring(1));
                      }
                  }
              }
      }
  }
  if(String.isNotBlank(typeOfServiceOrder)) {
      if(typeOfServiceOrder ==  WK_ConstantUtility.half) {
          workOrderRec.WK_Trailer_typeWO__c = WK_ConstantUtility.halfTrailer;
      }
      else {
          workOrderRec.WK_Trailer_typeWO__c = WK_ConstantUtility.fullTrailer; 
      }
    }
  if(String.isNotBlank(itemLocationDetails)) {
      workOrderRec.Description = WK_ConstantUtility.locatonString+itemLocationDetails;
  }
  if(String.isNotBlank(specialInstructions)) {
      workOrderRec.Description = workOrderRec.Description+WK_ConstantUtility.WK_SEMICOLON+WK_ConstantUtility.specialInstString+specialInstructions;
  }
  if(String.isNotBlank(selectedAuth)) {
      if(selectedAuth == WK_ConstantUtility.stringForNo) {
         workOrderRec.Preferred_Contact__c = contactRec.FirstName + contactLastName;
         if(String.isNotBlank(phoneNumber)) {
             workOrderRec.Phone__c = phoneNumber;
         }
         workOrderRec.Phone__c = contactRec.MobilePhone;
         workOrderRec.Email__c = contactRec.Email;
      }
  }
  if(workOrderRec != null) {
  System.debug('0000000000---------- '+workOrderRec.WK_Quote_Amount_Full_Trailer__c);
      listOfWorkOrders.add(workOrderRec);
  }
  if(String.isNotBlank(phoneNumber)) {
      if(previousPhoneNumber != phoneNumber) {
          workOrderRec.Phone__c = phoneNumber;
      }
  }
  
  if(listOfWorkOrders != null && !listOfWorkOrders.isEmpty()) {
      try {
         // insert listOfWorkOrders;
          result = Database.insert(listOfWorkOrders,false);
          System.debug('++++++++++++ b '+ accRecToUpdate.WK_Available_Free_Pick_Ups__c);
          if(accRecToUpdate.WK_Available_Free_Pick_Ups__c != null) {
              update accRecToUpdate;
          }
      }
      catch(Exception ex) {
      }
      }
      if(result != null && result[0].isSuccess()) {
               Id workOrderId = result[0].getId();
               if(workOrderId != null) {
                //   workOrderIdToNextPage = workOrderId;
                   workOrderLineItem.WorkOrderId = workOrderId;
                   workOrderLineItem.Status = WK_ConstantUtility.contactUsNew;
                   workOrderLineItem.WK_Frequency__c = WK_ConstantUtility.woliFrequency;
                  /* if(typeOfServiceOrder != null && typeOfServiceOrder != '') {
                       workOrderLineItem.WK_Trailer_type__c = typeOfServiceOrder;
                   }*/
                   
                   System.debug('++++++ Testing '+pickupMode);
                   if(String.isNotBlank(pickupMode)) {
                       if(pickupMode  == WK_ConstantUtility.futurePickUp) {
                          if(woliScheduledDate != null) {
                               System.debug('-------- Notification '+selectedPreferenceForNotification);
                               if(String.isNotBlank(selectedPreferenceForNotification)) {
                                   if(selectedPreferenceForNotification == WK_ConstantUtility.morningRange || selectedPreferenceForNotification == WK_ConstantUtility.noPreference) {
                                       Time startTime = Time.newInstance(8, 0, 0, 0);
                                       Time endTime = Time.newInstance(12, 0, 0, 0);
                                      // System.debug('+-+-+-+- Date '+DateTime.newInstanceGMT(woliScheduledDate, startTime)+'  ))) '+startTime);
                                       workOrderLineItem.Preferred_Start_DateTime__c = DateTime.newInstance(woliScheduledDate, startTime);
                                       workOrderLineItem.Preferred_End_DateTime__c = DateTime.newInstance(woliScheduledDate, endTime);
                                   }
                                   else if(selectedPreferenceForNotification == WK_ConstantUtility.afterNoonRange) {
                                           Time startTime = Time.newInstance(12, 0, 0, 0);
                                           Time endTime = Time.newInstance(14, 0, 0, 0);
                                           workOrderLineItem.Preferred_Start_DateTime__c = DateTime.newInstance(woliScheduledDate, startTime);
                                           workOrderLineItem.Preferred_End_DateTime__c = DateTime.newInstance(woliScheduledDate, endTime);
                                   }
                               }
                           }
                       }
                       else  if(pickupMode  == WK_ConstantUtility.earlyPickUp) {
                               System.debug('-------- Notification '+selectedPreferenceForNotification);
                               Date todayDate = System.today()+1;
                               if(String.isNotBlank(selectedPreferenceForNotification)) {
                                   if(selectedPreferenceForNotification == WK_ConstantUtility.morningRange || selectedPreferenceForNotification == WK_ConstantUtility.noPreference) {
                                       Time startTime = Time.newInstance(8, 0, 0, 0);
                                       Time endTime = Time.newInstance(10, 0, 0, 0);
                                       //System.debug('+-+-+-+- Date '+DateTime.newInstanceGMT(woliScheduledDate, startTime)+'  ))) '+startTime);
                                       workOrderLineItem.Preferred_Start_DateTime__c = DateTime.newInstance(todayDate, startTime);
                                       workOrderLineItem.Preferred_End_DateTime__c = DateTime.newInstance(todayDate, endTime);
                                   }
                                   else if(selectedPreferenceForNotification == WK_ConstantUtility.afterNoonRange) {
                                           Time startTime = Time.newInstance(12, 0, 0, 0);
                                           Time endTime = Time.newInstance(14, 0, 0, 0);
                                           workOrderLineItem.Preferred_Start_DateTime__c = DateTime.newInstance(todayDate, startTime);
                                           workOrderLineItem.Preferred_End_DateTime__c = DateTime.newInstance(todayDate, endTime);
                                   }
                               }
                       }
                   }
                   if(lstOfProducts != null && !lstOfProducts.isEmpty()) {
                       workOrderLineItem.PricebookEntryId = lstOfProducts[0].Id;
                   }
                   
                   if(workOrderLineItem != null) {
                       listOfWOLIs.add(workOrderLineItem);
                   }
                   
                   if(listOfWOLIs != null && !listOfWOLIs.isEmpty()) {
                      // try {
                           insert listOfWOLIs;
                    /*   }
                       catch(Exception ex) {
                           System.debug('Exception occured '+ex.getMessage());
                       }*/
                   }
                   
               }
      }
      if(finalResult != null && finalResult[0].isSuccess() && workOrderIdToNextPage != null && String.isNotBlank(typeOfServiceOrder)) {
          Id accId;
          if(loggedConAccId != null) {
              accId = loggedConAccId;
          }
          else {
              accId = accountId;
          }
          Pagereference ref = new Pagereference(WK_ConstantUtility.urlJunkRemovalConfirmationPage+'?Id='+accId+'&cid='+workOrderIdToNextPage+'&sizeTrailer='+typeOfServiceOrder); 
          return ref;
      }
      else {
      return null;
      }
  }
  else {
      return null;
  }
  }
  
  
  /**************************************************************************** 
     * Detail: Remote Action Method To Calculate the Cost Estimate
    *****************************************************************************/
  @RemoteAction
  global static Decimal calculateFormula(String lat,String longi,String trailerSize,String costV) {
  Location locRec = new Location();
  Decimal total;
  if(lat != null  && longi != null  && String.isNotBlank(trailerSize)) {
      latForOther = lat;
      longForOther = longi;
      locRec = Location.newInstance(Decimal.valueOf(lat), Decimal.valueOf(longi));
      if(locRec != null) {
          if(trailerSize == WK_ConstantUtility.half) {
              trailerSize = WK_ConstantUtility.halfTrailer;
              total = WK_JunkRemovalFormula.calculateJunkRemoval(trailerSize,locRec);
          }
          else {
              trailerSize = WK_ConstantUtility.fullTrailer;
              if(redeemFreePointsCheck == true) {
                  total = 0.0;
              }
              else {
                  if(costV != null && costV != '0.0') {
                      
                         total = (Decimal.valueOf(costV)).round(System.RoundingMode.HALF_UP);
                      }
                      else {
                          total = WK_JunkRemovalFormula.calculateJunkRemoval(trailerSize,locRec);
                      }
                 }
               /*  else {
                     if(loggedInContact[0].Account.WK_Contracted_Quote_Amount__c != null) {
                         total = (loggedInContact[0].Account.WK_Contracted_Quote_Amount__c).round(System.RoundingMode.HALF_UP);
                          
                      }
                      else {
                          total = WK_JunkRemovalFormula.calculateJunkRemoval(trailerSize,locRec);
                      }
                  }
              }*/
          }
          
         
         
      }
  }
   if(total != null) {
        return total;
   }
   else {
         return 0;
   }
  }
}