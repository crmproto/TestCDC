@isTest
Public Class WK_JunkRemovalControllerTest{
    
    public static testMethod void controllerTest(){
        
        String aliasString = 'testred';
        Id sysAdminId  = [Select Id,Name from Profile Where Name= 'WK Property Manager' Limit 1].Id;
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User portalAccountOwner1 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = System.now().millisecond() + 'test212@test.com',
            Alias = 'ba1tman',
            Email='bruceq.wayne@wayneenterprises234.com',
            EmailEncodingKey='UTF-8',
            Firstname='Bruce',
            Lastname='Waynew',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Chicago'
        );
        Database.insert(portalAccountOwner1);
        
        //User u1 = [Select ID From User Where Id =: portalAccountOwner1.Id];
        
        System.runAs ( portalAccountOwner1 ) {        
            Account acc= new Account();
            acc.Name ='test1';
            acc.Phone='1233456678';
            acc.BillingCity='The Colony';
            acc.BillingStreet='6740 Davidson St #1000';
            acc.BillingState='TX';
            acc.BillingCountry='United States';
            acc.BillingPostalCode = '75056';
            acc.ShippingCity='The Colony';
            acc.ShippingStreet='6740 Davidson St #1000';
            acc.ShippingState='TX';
            acc.ShippingCountry='United States';
            acc.ShippingPostalCode = '75056';
            acc.WK_Has_Duplicate_Units__c='yes';
            acc.WK_Available_Free_Pick_Ups__c = 4;
            acc.WK_Default_Free_Pickups__c = 4;
            insert acc;
            
            Contact con =New contact();
            con.LastName='test23';
            con.AccountId= acc.id;
            con.Phone='1234455667';
            con.Email='test1@gmail.com';
            insert con;
            
            //
            Product2 p = new Product2(name = 'Junk Removal');
            if (p != null) {
                insert p;
            }
            
            Id PricebookId = Test.getstandardPricebookId();
            insert new PricebookEntry(Pricebook2id = PricebookId, product2id = p.id, unitprice = 1.0, isactive = true);
            
            Pricebook2 pb = new Pricebook2(name = 'wellkept price book');
            if (pb != null) {
                insert pb;
            }
            
            PricebookEntry pbe = new PricebookEntry();
            pbe.Pricebook2Id = pb.id;
            pbe.product2id = p.id;
            pbe.unitprice = 1.0;
            pbe.isactive = true;
            if (pbe != null) {
                insert pbe;
            }
            //
            
            List<WK_States__c> lstStates = new List<WK_States__c>();
            WK_States__c state = new WK_States__c();
            state.name = 'Georgia';
            state.Abbreviations__c = 'GA';
            lstStates.add(state);
            
            WK_States__c state1 = new WK_States__c();
            state1.name = 'Texas';
            state1.Abbreviations__c = 'TX';
            lstStates.add(state1);
            
            WK_States__c state2 = new WK_States__c();
            state2.name = 'Florida';
            state2.Abbreviations__c = 'FL';
            lstStates.add(state2);
            insert lstStates;
            
            List<WK_WellKept_Rates__c> lstRates = new List<WK_WellKept_Rates__c>();
            WK_WellKept_Rates__c wk = new WK_WellKept_Rates__c();
            wk.Name = 'Texas Full Trailer Rates';
            wk.Labor_Hours__c = 0.50;
            wk.Labor_Rate__c = 33.15;
            wk.Markup__c = 30;
            wk.Mileage_Rate__c = 60.00;
            wk.WK_Number_of_Valets__c = 2;
            wk.Threshold_Amount__c = 450.00;
            wk.WK_Tons_on_Average__c =2 ;
            wk.WK_Trailer_Size__c = 'Full Trailer';
            lstRates .add(wk);
            
            WK_WellKept_Rates__c wk2 = new WK_WellKept_Rates__c();
            wk2.Name = 'Texas Half Trailer Rates';
            wk2.Labor_Hours__c = 0.25;
            wk2.Labor_Rate__c = 33.15;
            wk2.Markup__c = 30;
            wk2.Mileage_Rate__c = 60.00;
            wk2.WK_Number_of_Valets__c = 2;
            wk2.Threshold_Amount__c = 275.00;
            wk2.WK_Tons_on_Average__c = 1;
            wk2.WK_Trailer_Size__c = 'Half Trailer';
            lstRates .add(wk2);
            insert lstRates;
            
            List<WK_Disposal_Location__c> lstOfLoc = new List<WK_Disposal_Location__c>();
            WK_Disposal_Location__c disLoc = new WK_Disposal_Location__c();
            disLoc.Name = 'Lewisville Landfill';
            disLoc.City__c = 'Lewisville';
            disLoc.WK_IC_Rate__c = 19.88;
            disLoc.Location_Coordinates__Latitude__s = 33.04919042;
            disLoc.Location_Coordinates__Longitude__s = -96.98007613;
            disLoc.State__c = 'TX';
            disLoc.Street__c = '801 East College Street Ext';
            disLoc.Zip_Postal_Code__c = '75057';
            lstOfLoc.add(disLoc);
            
            WK_Disposal_Location__c disLoc1 = new WK_Disposal_Location__c();
            disLoc1.Name = 'Abilene Regional Landfill';
            disLoc1.City__c = 'Abilene';
            disLoc1.WK_IC_Rate__c = 23.11;
            disLoc1.Location_Coordinates__Latitude__s = 32.45200798;
            disLoc1.Location_Coordinates__Longitude__s = -99.73274879;
            disLoc1.State__c = 'TX';
            disLoc1.Street__c = 'FM 3034, off 277';
            disLoc1.Zip_Postal_Code__c = '79604';
            lstOfLoc.add(disLoc1);
            insert lstOfLoc;
            
            
            User user1 = new User(
                Username = System.now().millisecond() + 'test12345@test.com',
                ContactId = con.Id,
                ProfileId = sysAdminId,
                Alias = 'test123',
                Email = 'test12345@test.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'McTesty',
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'en_US'
            );
            insert user1;
            
            test.StartTest();
            System.RunAs(user1) {
                Case casRec = new Case();
                casRec.Status = WK_ConstantUtility.contactUsNew;
                casRec.Origin = WK_ConstantUtility.contactUsPropertyManagerPortal;
                casRec.Type = WK_ConstantUtility.contactUsAddService;
                casRec.Sub_Type__c = WK_ConstantUtility.contactUsJunkRemoval;
                casRec.ContactId = con.Id;
                casRec.AccountId = acc.Id;
                insert casRec;
                Test.setCurrentPageReference(new PageReference('Page.WK_JunkRemovalPage')); 
                
                
                WK_JunkRemovalController controller = new WK_JunkRemovalController();
                controller.redirectToHomePage();
                Decimal dd =  WK_JunkRemovalController.calculateFormula('33.057072','-96.849463','120.00','1.1');
                WK_JunkRemovalController.typeOfServiceOrder = 'half';
                WK_JunkRemovalController.itemLocationDetails = 'Loc Details';
                WK_JunkRemovalController.specialInstructions = 'Instruct';
                WK_JunkRemovalController.selectedAuth = 'No';
                WK_JunkRemovalController.phoneNumber = '9885647567';
                WK_JunkRemovalController.pickupMode = 'Earliest Available';
                WK_JunkRemovalController.selectedPreferenceForNotification = '8AM-12PM';
                WK_JunkRemovalController.costEstimate = '275';
                controller.saveWOWOLIRecords();
            }
            test.stopTest();
        }
    }
    
    public static testMethod void controllerTest5(){
        
        String aliasString = 'testred';
        Id sysAdminId  = [Select Id,Name from Profile Where Name= 'WK Property Manager' Limit 1].Id;
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User portalAccountOwner1 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = System.now().millisecond() + 'test212@test.com',
            Alias = 'ba1tman',
            Email='bruceq.wayne@wayneenterprises234.com',
            EmailEncodingKey='UTF-8',
            Firstname='Bruce',
            Lastname='Waynew',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Chicago'
        );
        Database.insert(portalAccountOwner1);
        
        //User u1 = [Select ID From User Where Id =: portalAccountOwner1.Id];
        
        System.runAs ( portalAccountOwner1 ) {        
            Account acc= new Account();
            acc.Name ='test1';
            acc.Phone='1233456678';
            acc.BillingCity='The Colony';
            acc.BillingStreet='6740 Davidson St #1000';
            acc.BillingState='TX';
            acc.BillingCountry='United States';
            acc.BillingPostalCode = '75056';
            acc.ShippingCity='The Colony';
            acc.ShippingStreet='6740 Davidson St #1000';
            acc.ShippingState='TX';
            acc.ShippingCountry='United States';
            acc.ShippingPostalCode = '75056';
            acc.WK_Has_Duplicate_Units__c='yes';
            acc.WK_Available_Free_Pick_Ups__c = 4;
            acc.WK_Default_Free_Pickups__c = 4;
            insert acc;
            
            Contact con =New contact();
            con.LastName='test23';
            con.AccountId= acc.id;
            con.Phone='1234455667';
            con.Email='test1@gmail.com';
            insert con;
			     //
            Product2 p = new Product2(name = 'Junk Removal');
            if (p != null) {
                insert p;
            }
            
            Id PricebookId = Test.getstandardPricebookId();
            insert new PricebookEntry(Pricebook2id = PricebookId, product2id = p.id, unitprice = 1.0, isactive = true);
            
            Pricebook2 pb = new Pricebook2(name = 'wellkept price book');
            if (pb != null) {
                insert pb;
            }
            
            PricebookEntry pbe = new PricebookEntry();
            pbe.Pricebook2Id = pb.id;
            pbe.product2id = p.id;
            pbe.unitprice = 1.0;
            pbe.isactive = true;
            if (pbe != null) {
                insert pbe;
            }
            //
            
            List<WK_States__c> lstStates = new List<WK_States__c>();
            WK_States__c state = new WK_States__c();
            state.name = 'Georgia';
            state.Abbreviations__c = 'GA';
            lstStates.add(state);
            
            WK_States__c state1 = new WK_States__c();
            state1.name = 'Texas';
            state1.Abbreviations__c = 'TX';
            lstStates.add(state1);
            
            WK_States__c state2 = new WK_States__c();
            state2.name = 'Florida';
            state2.Abbreviations__c = 'FL';
            lstStates.add(state2);
            insert lstStates;
            
            List<WK_WellKept_Rates__c> lstRates = new List<WK_WellKept_Rates__c>();
            WK_WellKept_Rates__c wk = new WK_WellKept_Rates__c();
            wk.Name = 'Texas Full Trailer Rates';
            wk.Labor_Hours__c = 0.50;
            wk.Labor_Rate__c = 33.15;
            wk.Markup__c = 30;
            wk.Mileage_Rate__c = 60.00;
            wk.WK_Number_of_Valets__c = 2;
            wk.Threshold_Amount__c = 450.00;
            wk.WK_Tons_on_Average__c =2 ;
            wk.WK_Trailer_Size__c = 'Full Trailer';
            lstRates .add(wk);
            
            WK_WellKept_Rates__c wk2 = new WK_WellKept_Rates__c();
            wk2.Name = 'Texas Half Trailer Rates';
            wk2.Labor_Hours__c = 0.25;
            wk2.Labor_Rate__c = 33.15;
            wk2.Markup__c = 30;
            wk2.Mileage_Rate__c = 60.00;
            wk2.WK_Number_of_Valets__c = 2;
            wk2.Threshold_Amount__c = 275.00;
            wk2.WK_Tons_on_Average__c = 1;
            wk2.WK_Trailer_Size__c = 'Half Trailer';
            lstRates .add(wk2);
            insert lstRates;
            
            List<WK_Disposal_Location__c> lstOfLoc = new List<WK_Disposal_Location__c>();
            WK_Disposal_Location__c disLoc = new WK_Disposal_Location__c();
            disLoc.Name = 'Lewisville Landfill';
            disLoc.City__c = 'Lewisville';
            disLoc.WK_IC_Rate__c = 19.88;
            disLoc.Location_Coordinates__Latitude__s = 33.04919042;
            disLoc.Location_Coordinates__Longitude__s = -96.98007613;
            disLoc.State__c = 'TX';
            disLoc.Street__c = '801 East College Street Ext';
            disLoc.Zip_Postal_Code__c = '75057';
            lstOfLoc.add(disLoc);
            
            WK_Disposal_Location__c disLoc1 = new WK_Disposal_Location__c();
            disLoc1.Name = 'Abilene Regional Landfill';
            disLoc1.City__c = 'Abilene';
            disLoc1.WK_IC_Rate__c = 23.11;
            disLoc1.Location_Coordinates__Latitude__s = 32.45200798;
            disLoc1.Location_Coordinates__Longitude__s = -99.73274879;
            disLoc1.State__c = 'TX';
            disLoc1.Street__c = 'FM 3034, off 277';
            disLoc1.Zip_Postal_Code__c = '79604';
            lstOfLoc.add(disLoc1);
            insert lstOfLoc;
            
            
            User user1 = new User(
                Username = System.now().millisecond() + 'test12345@test.com',
                ContactId = con.Id,
                ProfileId = sysAdminId,
                Alias = 'test123',
                Email = 'test12345@test.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'McTesty',
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'en_US'
            );
            insert user1;
            
            test.StartTest();
            System.RunAs(user1) {
                Case casRec = new Case();
                casRec.Status = WK_ConstantUtility.contactUsNew;
                casRec.Origin = WK_ConstantUtility.contactUsPropertyManagerPortal;
                casRec.Type = WK_ConstantUtility.contactUsAddService;
                casRec.Sub_Type__c = WK_ConstantUtility.contactUsJunkRemoval;
                casRec.ContactId = con.Id;
                casRec.AccountId = acc.Id;
                insert casRec;
                Test.setCurrentPageReference(new PageReference('Page.WK_JunkRemovalPage')); 
                
                System.currentPageReference().getParameters().put('Id', acc.Id);
                WK_JunkRemovalController controller = new WK_JunkRemovalController();
                controller.redirectToHomePage();
                Decimal dd =  WK_JunkRemovalController.calculateFormula('33.057072','-96.849463','120.00','1.1');
                WK_JunkRemovalController.typeOfServiceOrder = 'half';
                WK_JunkRemovalController.itemLocationDetails = 'Loc Details';
                WK_JunkRemovalController.specialInstructions = 'Instruct';
                
                WK_JunkRemovalController.selectedAuth = 'No';
                WK_JunkRemovalController.phoneNumber = '9885647567';
                WK_JunkRemovalController.pickupMode = 'Earliest Available';
                WK_JunkRemovalController.selectedPreferenceForNotification = '8AM-12PM';
                WK_JunkRemovalController.costEstimate = '275';
                controller.saveWOWOLIRecords();
            }
            test.stopTest(); 
        }
    }
    
    
    
    public static testMethod void controllerTest1(){
        
        String aliasString = 'testred';
        Id sysAdminId  = [Select Id,Name from Profile Where Name= 'WK Property Manager' Limit 1].Id;
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User portalAccountOwner1 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = System.now().millisecond() + 'test212@test.com',
            Alias = 'ba1tman',
            Email='bruceq.wayne@wayneenterprises234.com',
            EmailEncodingKey='UTF-8',
            Firstname='Bruce',
            Lastname='Waynew',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Chicago'
        );
        Database.insert(portalAccountOwner1);
        
        //User u1 = [Select ID From User Where Id =: portalAccountOwner1.Id];
        
        System.runAs ( portalAccountOwner1 ) {        
            Account acc= new Account();
            acc.Name ='test1';
            acc.Phone='1233456678';
            acc.BillingCity='The Colony';
            acc.BillingStreet='6740 Davidson St #1000';
            acc.BillingState='Texas';
            acc.BillingCountry='United States';
            acc.BillingPostalCode = '75056';
            acc.ShippingCity='The Colony';
            acc.ShippingStreet='6740 Davidson St #1000';
            acc.ShippingState='Texas';
            acc.ShippingCountry='United States';
            acc.ShippingPostalCode = '75056';
            acc.WK_Has_Duplicate_Units__c='yes';
            acc.WK_Available_Free_Pick_Ups__c = 4;
            acc.WK_Default_Free_Pickups__c = 4;
            insert acc;
            
            Contact con =New contact();
            con.LastName='test23';
            con.AccountId= acc.id;
            con.Phone='1234455667';
            con.Email='test1@gmail.com';
            insert con;
            
            //
            Product2 p = new Product2(name = 'Junk Removal');
            if (p != null) {
                insert p;
            }
            
            Id PricebookId = Test.getstandardPricebookId();
            insert new PricebookEntry(Pricebook2id = PricebookId, product2id = p.id, unitprice = 1.0, isactive = true);
            
            Pricebook2 pb = new Pricebook2(name = 'wellkept price book');
            if (pb != null) {
                insert pb;
            }
            
            PricebookEntry pbe = new PricebookEntry();
            pbe.Pricebook2Id = pb.id;
            pbe.product2id = p.id;
            pbe.unitprice = 1.0;
            pbe.isactive = true;
            if (pbe != null) {
                insert pbe;
            }
            //
            
            List<WK_States__c> lstStates = new List<WK_States__c>();
            WK_States__c state = new WK_States__c();
            state.name = 'Georgia';
            state.Abbreviations__c = 'GA';
            lstStates.add(state);
            
            WK_States__c state1 = new WK_States__c();
            state1.name = 'Texas';
            state1.Abbreviations__c = 'TX';
            lstStates.add(state1);
            
            WK_States__c state2 = new WK_States__c();
            state2.name = 'Florida';
            state2.Abbreviations__c = 'FL';
            lstStates.add(state2);
            insert lstStates;
            
            List<WK_WellKept_Rates__c> lstRates = new List<WK_WellKept_Rates__c>();
            WK_WellKept_Rates__c wk = new WK_WellKept_Rates__c();
            wk.Name = 'Texas Full Trailer Rates';
            wk.Labor_Hours__c = 0.50;
            wk.Labor_Rate__c = 33.15;
            wk.Markup__c = 30;
            wk.Mileage_Rate__c = 60.00;
            wk.WK_Number_of_Valets__c = 2;
            wk.Threshold_Amount__c = 450.00;
            wk.WK_Tons_on_Average__c =2 ;
            wk.WK_Trailer_Size__c = 'Full Trailer';
            lstRates .add(wk);
            
            WK_WellKept_Rates__c wk2 = new WK_WellKept_Rates__c();
            wk2.Name = 'Texas Half Trailer Rates';
            wk2.Labor_Hours__c = 0.25;
            wk2.Labor_Rate__c = 33.15;
            wk2.Markup__c = 30;
            wk2.Mileage_Rate__c = 60.00;
            wk2.WK_Number_of_Valets__c = 2;
            wk2.Threshold_Amount__c = 275.00;
            wk2.WK_Tons_on_Average__c = 1;
            wk2.WK_Trailer_Size__c = 'Half Trailer';
            lstRates .add(wk2);
            insert lstRates;
            
            List<WK_Disposal_Location__c> lstOfLoc = new List<WK_Disposal_Location__c>();
            WK_Disposal_Location__c disLoc = new WK_Disposal_Location__c();
            disLoc.Name = 'Lewisville Landfill';
            disLoc.City__c = 'Lewisville';
            disLoc.WK_IC_Rate__c = 19.88;
            disLoc.Location_Coordinates__Latitude__s = 33.04919042;
            disLoc.Location_Coordinates__Longitude__s = -96.98007613;
            disLoc.State__c = 'TX';
            disLoc.Street__c = '801 East College Street Ext';
            disLoc.Zip_Postal_Code__c = '75057';
            lstOfLoc.add(disLoc);
            
            WK_Disposal_Location__c disLoc1 = new WK_Disposal_Location__c();
            disLoc1.Name = 'Abilene Regional Landfill';
            disLoc1.City__c = 'Abilene';
            disLoc1.WK_IC_Rate__c = 23.11;
            disLoc1.Location_Coordinates__Latitude__s = 32.45200798;
            disLoc1.Location_Coordinates__Longitude__s = -99.73274879;
            disLoc1.State__c = 'TX';
            disLoc1.Street__c = 'FM 3034, off 277';
            disLoc1.Zip_Postal_Code__c = '79604';
            lstOfLoc.add(disLoc1);
            insert lstOfLoc;
            
            
            User user1 = new User(
                Username = System.now().millisecond() + 'test12345@test.com',
                ContactId = con.Id,
                ProfileId = sysAdminId,
                Alias = 'test123',
                Email = 'test12345@test.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'McTesty',
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'en_US'
            );
            insert user1;
            
            test.StartTest();
            System.RunAs(user1) {
                Case casRec = new Case();
                casRec.Status = WK_ConstantUtility.contactUsNew;
                casRec.Origin = WK_ConstantUtility.contactUsPropertyManagerPortal;
                casRec.Type = WK_ConstantUtility.contactUsAddService;
                casRec.Sub_Type__c = WK_ConstantUtility.contactUsJunkRemoval;
                casRec.ContactId = con.Id;
                casRec.AccountId = acc.Id;
                insert casRec;
                Test.setCurrentPageReference(new PageReference('Page.WK_JunkRemovalPage')); 
                
                WK_JunkRemovalController controller = new WK_JunkRemovalController();
                controller.redirectToHomePage();
                
                Decimal dd1 = WK_JunkRemovalController.calculateFormula('33.057072','-96.849463','full','1.1');
                WK_JunkRemovalController.typeOfServiceOrder = 'full';
                WK_JunkRemovalController.itemLocationDetails = 'Loc Details';
                WK_JunkRemovalController.specialInstructions = 'Instruct';
                WK_JunkRemovalController.selectedAuth = 'No';
                WK_JunkRemovalController.phoneNumber = '9885647567';
                WK_JunkRemovalController.pickupMode = 'future-date';
                WK_JunkRemovalController.woliScheduledDate = System.today()+3;
                WK_JunkRemovalController.selectedPreferenceForNotification = '8AM-12PM';
                WK_JunkRemovalController.costEstimate = '450';
                controller.saveWOWOLIRecords();
            }
            test.stopTest(); 
        }
    }
    
    
    public static testMethod void controllerTest2(){
        
        String aliasString = 'testred';
        Id sysAdminId  = [Select Id,Name from Profile Where Name= 'WK Property Manager' Limit 1].Id;
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User portalAccountOwner1 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = System.now().millisecond() + 'test212@test.com',
            Alias = 'ba1tman',
            Email='bruceq.wayne@wayneenterprises234.com',
            EmailEncodingKey='UTF-8',
            Firstname='Bruce',
            Lastname='Waynew',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Chicago'
        );
        Database.insert(portalAccountOwner1);
        
        //User u1 = [Select ID From User Where Id =: portalAccountOwner1.Id];
        
        System.runAs ( portalAccountOwner1 ) {        
            Account acc= new Account();
            acc.Name ='test1';
            acc.Phone='1233456678';
            acc.BillingCity='The Colony';
            acc.BillingStreet='6740 Davidson St #1000';
            acc.BillingState='TX';
            acc.BillingCountry='United States';
            acc.BillingPostalCode = '75056';
            acc.ShippingCity='The Colony';
            acc.ShippingStreet='6740 Davidson St #1000';
            acc.ShippingState='TX';
            acc.ShippingCountry='United States';
            acc.ShippingPostalCode = '75056';
            acc.WK_Has_Duplicate_Units__c='yes';
            acc.WK_Available_Free_Pick_Ups__c = 4;
            acc.WK_Default_Free_Pickups__c = 4;
            insert acc;
            
            Contact con =New contact();
            con.LastName='test23';
            con.AccountId= acc.id;
            con.Phone='1234455667';
            con.Email='test1@gmail.com';
            insert con;
            
            //
            Product2 p = new Product2(name = 'Junk Removal');
            if (p != null) {
                insert p;
            }
            
            Id PricebookId = Test.getstandardPricebookId();
            insert new PricebookEntry(Pricebook2id = PricebookId, product2id = p.id, unitprice = 1.0, isactive = true);
            
            Pricebook2 pb = new Pricebook2(name = 'wellkept price book');
            if (pb != null) {
                insert pb;
            }
            
            PricebookEntry pbe = new PricebookEntry();
            pbe.Pricebook2Id = pb.id;
            pbe.product2id = p.id;
            pbe.unitprice = 1.0;
            pbe.isactive = true;
            if (pbe != null) {
                insert pbe;
            }
            //
            
            List<WK_States__c> lstStates = new List<WK_States__c>();
            WK_States__c state = new WK_States__c();
            state.name = 'Georgia';
            state.Abbreviations__c = 'GA';
            lstStates.add(state);
            
            WK_States__c state1 = new WK_States__c();
            state1.name = 'Texas';
            state1.Abbreviations__c = 'TX';
            lstStates.add(state1);
            
            WK_States__c state2 = new WK_States__c();
            state2.name = 'Florida';
            state2.Abbreviations__c = 'FL';
            lstStates.add(state2);
            insert lstStates;
            
            List<WK_WellKept_Rates__c> lstRates = new List<WK_WellKept_Rates__c>();
            WK_WellKept_Rates__c wk = new WK_WellKept_Rates__c();
            wk.Name = 'Texas Full Trailer Rates';
            wk.Labor_Hours__c = 0.50;
            wk.Labor_Rate__c = 33.15;
            wk.Markup__c = 30;
            wk.Mileage_Rate__c = 60.00;
            wk.WK_Number_of_Valets__c = 2;
            wk.Threshold_Amount__c = 450.00;
            wk.WK_Tons_on_Average__c =2 ;
            wk.WK_Trailer_Size__c = 'Full Trailer';
            lstRates .add(wk);
            
            WK_WellKept_Rates__c wk2 = new WK_WellKept_Rates__c();
            wk2.Name = 'Texas Half Trailer Rates';
            wk2.Labor_Hours__c = 0.25;
            wk2.Labor_Rate__c = 33.15;
            wk2.Markup__c = 30;
            wk2.Mileage_Rate__c = 60.00;
            wk2.WK_Number_of_Valets__c = 2;
            wk2.Threshold_Amount__c = 275.00;
            wk2.WK_Tons_on_Average__c = 1;
            wk2.WK_Trailer_Size__c = 'Half Trailer';
            lstRates .add(wk2);
            insert lstRates;
            
            List<WK_Disposal_Location__c> lstOfLoc = new List<WK_Disposal_Location__c>();
            WK_Disposal_Location__c disLoc = new WK_Disposal_Location__c();
            disLoc.Name = 'Lewisville Landfill';
            disLoc.City__c = 'Lewisville';
            disLoc.WK_IC_Rate__c = 19.88;
            disLoc.Location_Coordinates__Latitude__s = 33.04919042;
            disLoc.Location_Coordinates__Longitude__s = -96.98007613;
            disLoc.State__c = 'TX';
            disLoc.Street__c = '801 East College Street Ext';
            disLoc.Zip_Postal_Code__c = '75057';
            lstOfLoc.add(disLoc);
            
            WK_Disposal_Location__c disLoc1 = new WK_Disposal_Location__c();
            disLoc1.Name = 'Abilene Regional Landfill';
            disLoc1.City__c = 'Abilene';
            disLoc1.WK_IC_Rate__c = 23.11;
            disLoc1.Location_Coordinates__Latitude__s = 32.45200798;
            disLoc1.Location_Coordinates__Longitude__s = -99.73274879;
            disLoc1.State__c = 'TX';
            disLoc1.Street__c = 'FM 3034, off 277';
            disLoc1.Zip_Postal_Code__c = '79604';
            lstOfLoc.add(disLoc1);
            insert lstOfLoc;
            
            
            User user1 = new User(
                Username = System.now().millisecond() + 'test12345@test.com',
                ContactId = con.Id,
                ProfileId = sysAdminId,
                Alias = 'test123',
                Email = 'test12345@test.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'McTesty',
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'en_US'
            );
            insert user1;
            
            test.StartTest();
            System.RunAs(user1) {
                Case casRec = new Case();
                casRec.Status = WK_ConstantUtility.contactUsNew;
                casRec.Origin = WK_ConstantUtility.contactUsPropertyManagerPortal;
                casRec.Type = WK_ConstantUtility.contactUsAddService;
                casRec.Sub_Type__c = WK_ConstantUtility.contactUsJunkRemoval;
                casRec.ContactId = con.Id;
                casRec.AccountId = acc.Id;
                insert casRec;
                Test.setCurrentPageReference(new PageReference('Page.WK_JunkRemovalPage')); 
                
                
                WK_JunkRemovalController controller = new WK_JunkRemovalController();
                controller.redirectToHomePage();
                Decimal dd12 = WK_JunkRemovalController.calculateFormula('33.057072','-96.849463','half','1.1');
                WK_JunkRemovalController.typeOfServiceOrder = 'half';
                WK_JunkRemovalController.itemLocationDetails = 'Loc Details';
                WK_JunkRemovalController.specialInstructions = 'Instruct';
                WK_JunkRemovalController.selectedAuth = 'No';
                WK_JunkRemovalController.phoneNumber = '9885647567';
                WK_JunkRemovalController.pickupMode = 'Earliest Available';
                WK_JunkRemovalController.selectedPreferenceForNotification = '12PM-3PM';
                WK_JunkRemovalController.costEstimate = '275';
                controller.saveWOWOLIRecords();
            }
            test.stopTest(); 
        }
    }
    
    public static testMethod void controllerTest4(){
        
        String aliasString = 'testred';
        Id sysAdminId  = [Select Id,Name from Profile Where Name= 'WK Property Manager' Limit 1].Id;
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User portalAccountOwner1 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = System.now().millisecond() + 'test212@test.com',
            Alias = 'ba1tman',
            Email='bruceq.wayne@wayneenterprises234.com',
            EmailEncodingKey='UTF-8',
            Firstname='Bruce',
            Lastname='Waynew',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Chicago'
        );
        Database.insert(portalAccountOwner1);
        
        //User u1 = [Select ID From User Where Id =: portalAccountOwner1.Id];
        
        System.runAs ( portalAccountOwner1 ) {        
            Account acc= new Account();
            acc.Name ='test1';
            acc.Phone='1233456678';
            acc.BillingCity='The Colony';
            acc.BillingStreet='6740 Davidson St #1000';
            acc.BillingState='Texas';
            acc.BillingCountry='United States';
            acc.BillingPostalCode = '75056';
            acc.ShippingCity='The Colony';
            acc.ShippingStreet='6740 Davidson St #1000';
            acc.ShippingState='Texas';
            acc.ShippingCountry='United States';
            acc.ShippingPostalCode = '75056';
            acc.WK_Has_Duplicate_Units__c='yes';
            acc.WK_Available_Free_Pick_Ups__c = 4;
            acc.WK_Default_Free_Pickups__c = 4;
            insert acc;
            
            Contact con =New contact();
            con.LastName='test23';
            con.AccountId= acc.id;
            con.Phone='1234455667';
            con.Email='test1@gmail.com';
            insert con;
            
            //
            Product2 p = new Product2(name = 'Junk Removal');
            if (p != null) {
                insert p;
            }
            
            Id PricebookId = Test.getstandardPricebookId();
            insert new PricebookEntry(Pricebook2id = PricebookId, product2id = p.id, unitprice = 1.0, isactive = true);
            
            Pricebook2 pb = new Pricebook2(name = 'wellkept price book');
            if (pb != null) {
                insert pb;
            }
            
            PricebookEntry pbe = new PricebookEntry();
            pbe.Pricebook2Id = pb.id;
            pbe.product2id = p.id;
            pbe.unitprice = 1.0;
            pbe.isactive = true;
            if (pbe != null) {
                insert pbe;
            }
            //
            
            List<WK_States__c> lstStates = new List<WK_States__c>();
            WK_States__c state = new WK_States__c();
            state.name = 'Georgia';
            state.Abbreviations__c = 'GA';
            lstStates.add(state);
            
            WK_States__c state1 = new WK_States__c();
            state1.name = 'Texas';
            state1.Abbreviations__c = 'TX';
            lstStates.add(state1);
            
            WK_States__c state2 = new WK_States__c();
            state2.name = 'Florida';
            state2.Abbreviations__c = 'FL';
            lstStates.add(state2);
            insert lstStates;
            
            List<WK_WellKept_Rates__c> lstRates = new List<WK_WellKept_Rates__c>();
            WK_WellKept_Rates__c wk = new WK_WellKept_Rates__c();
            wk.Name = 'FL/GA Full Trailer Rates';
            wk.Labor_Hours__c = 0.50;
            wk.Labor_Rate__c = 33.15;
            wk.Markup__c = 30;
            wk.Mileage_Rate__c = 60.00;
            wk.WK_Number_of_Valets__c = 2;
            wk.Threshold_Amount__c = 400.00;
            wk.WK_Tons_on_Average__c =1 ;
            wk.WK_Trailer_Size__c = 'Full Trailer';
            lstRates.add(wk);
            
            WK_WellKept_Rates__c wk2 = new WK_WellKept_Rates__c();
            wk2.Name = 'FL/GA Half Trailer Rates';
            wk2.Labor_Hours__c = 0.50;
            wk2.Labor_Rate__c = 33.15;
            wk2.Markup__c = 30;
            wk2.Mileage_Rate__c = 60.00;
            wk2.WK_Number_of_Valets__c = 2;
            wk2.Threshold_Amount__c = 250.00;
            wk2.WK_Tons_on_Average__c = 0.50;
            wk2.WK_Trailer_Size__c = 'Half Trailer';
            lstRates.add(wk2);
            insert lstRates;
            
            List<WK_Disposal_Location__c> lstOfLoc = new List<WK_Disposal_Location__c>();
            WK_Disposal_Location__c disLoc = new WK_Disposal_Location__c();
            disLoc.Name = 'Metro Recycling Transfer Station';
            disLoc.City__c = 'Tampa';
            disLoc.WK_IC_Rate__c = 60.48;
            disLoc.Location_Coordinates__Latitude__s = 27.95659089;
            disLoc.Location_Coordinates__Longitude__s = -82.42932516;
            disLoc.State__c = 'FL';
            disLoc.Street__c = '2702 East 2nd Avenue';
            disLoc.Zip_Postal_Code__c = '33605';
            lstOfLoc.add(disLoc);
            
            WK_Disposal_Location__c disLoc1 = new WK_Disposal_Location__c();
            disLoc1.Name = 'Abilene Regional Landfill';
            disLoc1.City__c = 'Abilene';
            disLoc1.WK_IC_Rate__c = 23.11;
            disLoc1.Location_Coordinates__Latitude__s = 32.45200798;
            disLoc1.Location_Coordinates__Longitude__s = -99.73274879;
            disLoc1.State__c = 'TX';
            disLoc1.Street__c = 'FM 3034, off 277';
            disLoc1.Zip_Postal_Code__c = '79604';
            lstOfLoc.add(disLoc1);
            insert lstOfLoc;
            
            
            User user1 = new User(
                Username = System.now().millisecond() + 'test12345@test.com',
                ContactId = con.Id,
                ProfileId = sysAdminId,
                Alias = 'test123',
                Email = 'test12345@test.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'McTesty',
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'en_US'
            );
            insert user1;
            
            test.StartTest();
            System.RunAs(user1) {
                Case casRec = new Case();
                casRec.Status = WK_ConstantUtility.contactUsNew;
                casRec.Origin = WK_ConstantUtility.contactUsPropertyManagerPortal;
                casRec.Type = WK_ConstantUtility.contactUsAddService;
                casRec.Sub_Type__c = WK_ConstantUtility.contactUsJunkRemoval;
                casRec.ContactId = con.Id;
                casRec.AccountId = acc.Id;
                insert casRec;
                Test.setCurrentPageReference(new PageReference('Page.WK_JunkRemovalPage')); 
                
                
                WK_JunkRemovalController controller = new WK_JunkRemovalController();
                controller.redirectToHomePage();
                Decimal dd13= WK_JunkRemovalController.calculateFormula('27.95659089','-82.42932516','full','1.1');
                WK_JunkRemovalController.typeOfServiceOrder = 'half';
                WK_JunkRemovalController.itemLocationDetails = 'Loc Details';
                WK_JunkRemovalController.specialInstructions = 'Instruct';
                WK_JunkRemovalController.selectedAuth = 'No';
                WK_JunkRemovalController.phoneNumber = '9885647567';
                WK_JunkRemovalController.pickupMode = 'future-date';
                WK_JunkRemovalController.woliScheduledDate = System.today()+3;
                WK_JunkRemovalController.selectedPreferenceForNotification = '12PM-3PM';
                WK_JunkRemovalController.costEstimate = '275';
                controller.saveWOWOLIRecords();
            }
            test.stopTest(); 
        }
    }        
    
    public static testMethod void controllerTest3(){
        
        String aliasString = 'testred';
        Id sysAdminId  = [Select Id,Name from Profile Where Name= 'WK Property Manager' Limit 1].Id;
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User portalAccountOwner1 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = System.now().millisecond() + 'test212@test.com',
            Alias = 'ba1tman',
            Email='bruceq.wayne@wayneenterprises234.com',
            EmailEncodingKey='UTF-8',
            Firstname='Bruce',
            Lastname='Waynew',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Chicago'
        );
        Database.insert(portalAccountOwner1);
        
        //User u1 = [Select ID From User Where Id =: portalAccountOwner1.Id];
        
        System.runAs ( portalAccountOwner1 ) {        
            Account acc= new Account();
            acc.Name ='test1';
            acc.Phone='1233456678';
            acc.BillingCity='The Colony';
            acc.BillingStreet='6740 Davidson St #1000';
            acc.BillingState='Texas';
            acc.BillingCountry='United States';
            acc.BillingPostalCode = '75056';
            acc.ShippingCity='The Colony';
            acc.ShippingStreet='6740 Davidson St #1000';
            acc.ShippingState='Texas';
            acc.ShippingCountry='United States';
            acc.ShippingPostalCode = '75056';
            acc.WK_Has_Duplicate_Units__c='yes';
            acc.WK_Available_Free_Pick_Ups__c = 4;
            acc.WK_Default_Free_Pickups__c = 4;
            insert acc;
            
            Contact con =New contact();
            con.LastName='test23';
            con.AccountId= acc.id;
            con.Phone='1234455667';
            con.Email='test1@gmail.com';
            insert con;
            
            //
            Product2 p = new Product2(name = 'Junk Removal');
            if (p != null) {
                insert p;
            }
            
            Id PricebookId = Test.getstandardPricebookId();
            insert new PricebookEntry(Pricebook2id = PricebookId, product2id = p.id, unitprice = 1.0, isactive = true);
            
            Pricebook2 pb = new Pricebook2(name = 'wellkept price book');
            if (pb != null) {
                insert pb;
            }
            
            PricebookEntry pbe = new PricebookEntry();
            pbe.Pricebook2Id = pb.id;
            pbe.product2id = p.id;
            pbe.unitprice = 1.0;
            pbe.isactive = true;
            if (pbe != null) {
                insert pbe;
            }
            //
            
            List<WK_States__c> lstStates = new List<WK_States__c>();
            WK_States__c state = new WK_States__c();
            state.name = 'Georgia';
            state.Abbreviations__c = 'GA';
            lstStates.add(state);
            
            WK_States__c state1 = new WK_States__c();
            state1.name = 'Texas';
            state1.Abbreviations__c = 'TX';
            lstStates.add(state1);
            
            WK_States__c state2 = new WK_States__c();
            state2.name = 'Florida';
            state2.Abbreviations__c = 'FL';
            lstStates.add(state2);
            insert lstStates;
            
            List<WK_WellKept_Rates__c> lstRates = new List<WK_WellKept_Rates__c>();
            WK_WellKept_Rates__c wk = new WK_WellKept_Rates__c();
            wk.Name = 'Texas Full Trailer Rates';
            wk.Labor_Hours__c = 0.50;
            wk.Labor_Rate__c = 33.15;
            wk.Markup__c = 30;
            wk.Mileage_Rate__c = 60.00;
            wk.WK_Number_of_Valets__c = 2;
            wk.Threshold_Amount__c = 450.00;
            wk.WK_Tons_on_Average__c =2 ;
            wk.WK_Trailer_Size__c = 'Full Trailer';
            lstRates .add(wk);
            
            WK_WellKept_Rates__c wk2 = new WK_WellKept_Rates__c();
            wk2.Name = 'Texas Half Trailer Rates';
            wk2.Labor_Hours__c = 0.25;
            wk2.Labor_Rate__c = 33.15;
            wk2.Markup__c = 30;
            wk2.Mileage_Rate__c = 60.00;
            wk2.WK_Number_of_Valets__c = 2;
            wk2.Threshold_Amount__c = 275.00;
            wk2.WK_Tons_on_Average__c = 1;
            wk2.WK_Trailer_Size__c = 'Half Trailer';
            lstRates .add(wk2);
            insert lstRates;
            
            List<WK_Disposal_Location__c> lstOfLoc = new List<WK_Disposal_Location__c>();
            WK_Disposal_Location__c disLoc = new WK_Disposal_Location__c();
            disLoc.Name = 'Lewisville Landfill';
            disLoc.City__c = 'Lewisville';
            disLoc.WK_IC_Rate__c = 19.88;
            disLoc.Location_Coordinates__Latitude__s = 33.04919042;
            disLoc.Location_Coordinates__Longitude__s = -96.98007613;
            disLoc.State__c = 'TX';
            disLoc.Street__c = '801 East College Street Ext';
            disLoc.Zip_Postal_Code__c = '75057';
            lstOfLoc.add(disLoc);
            
            WK_Disposal_Location__c disLoc1 = new WK_Disposal_Location__c();
            disLoc1.Name = 'Abilene Regional Landfill';
            disLoc1.City__c = 'Abilene';
            disLoc1.WK_IC_Rate__c = 23.11;
            disLoc1.Location_Coordinates__Latitude__s = 32.45200798;
            disLoc1.Location_Coordinates__Longitude__s = -99.73274879;
            disLoc1.State__c = 'TX';
            disLoc1.Street__c = 'FM 3034, off 277';
            disLoc1.Zip_Postal_Code__c = '79604';
            lstOfLoc.add(disLoc1);
            insert lstOfLoc;
            
            
            User user1 = new User(
                Username = System.now().millisecond() + 'test12345@test.com',
                ContactId = con.Id,
                ProfileId = sysAdminId,
                Alias = 'test123',
                Email = 'test12345@test.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'McTesty',
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'en_US'
            );
            insert user1;
            
            test.StartTest();
            System.RunAs(user1) {
                Case casRec = new Case();
                casRec.Status = WK_ConstantUtility.contactUsNew;
                casRec.Origin = WK_ConstantUtility.contactUsPropertyManagerPortal;
                casRec.Type = WK_ConstantUtility.contactUsAddService;
                casRec.Sub_Type__c = WK_ConstantUtility.contactUsJunkRemoval;
                casRec.ContactId = con.Id;
                casRec.AccountId = acc.Id;
                insert casRec;
                Test.setCurrentPageReference(new PageReference('Page.WK_JunkRemovalPage')); 
                
                
                WK_JunkRemovalController controller = new WK_JunkRemovalController();
                controller.redirectToHomePage();
                Decimal dd13= WK_JunkRemovalController.calculateFormula('33.057072','-96.849463','full','1.1');
                WK_JunkRemovalController.typeOfServiceOrder = 'half';
                WK_JunkRemovalController.itemLocationDetails = 'Loc Details';
                WK_JunkRemovalController.specialInstructions = 'Instruct';
                WK_JunkRemovalController.selectedAuth = 'No';
                WK_JunkRemovalController.phoneNumber = '9885647567';
                WK_JunkRemovalController.pickupMode = 'future-date';
                WK_JunkRemovalController.woliScheduledDate = System.today()+3;
                WK_JunkRemovalController.selectedPreferenceForNotification = '12PM-3PM';
                WK_JunkRemovalController.costEstimate = '275';
                controller.saveWOWOLIRecords();
            }
            test.stopTest(); 
        }
    }      
    
}