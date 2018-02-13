@isTest
Public Class WK_ReportsControllerTest{

    private static User testPortalUser;
    private static Violation__c viol;
    private static Case inquiry;
    private static ServiceAppointment serviceapp;

    /**
     * @author: NSebastian@Deloitte
     * @description: Create testdata
     * @param: String selectedType, String duration
     * @returntype:    void
    */
    public static void createTestData(String selectedType, String duration) {
        testPortalUser = WK_TestClassUtility.createPortalUser('None', 'WK Property Manager', 'testportaluser@testorg.com.test', 'testportaluser@testorg.com');
        insert testPortalUser;
        User loggedInUser = [SELECT Id, ContactId, Contact.AccountId,Contact.Account.OwnerId FROM User WHERE Id = :testPortalUser.Id LIMIT 1];
        User admin = [SELECT Id FROM User WHERE Id = :loggedInUser.Contact.Account.OwnerId LIMIT 1];
        System.runAs(admin){
            if(selectedType.equals(WK_ConstantUtility.reports5dayViolationsTSys)) {
                viol = WK_TestClassUtility.createViolation(WK_ConstantUtility.VIOAPPROVED, loggedInUser.Contact.AccountId,'5-Day violation tracking system', loggedInUser.ContactId, 'sample note');
                insert viol;
                Attachment att = new Attachment ( Name = 'sample attachment', Body = Blob.valueOf('Sample Attachment Body'), ParentID = viol.Id);
                insert att;
                Attachment att2 = new Attachment ( Name = 'sample attachment2', Body = Blob.valueOf('Sample Attachment Body 2'), ParentID = viol.Id);
                insert att2;
            }
            else if(selectedType.equals(WK_ConstantUtility.reportsValetTrashViolations)) {
                viol = WK_TestClassUtility.createViolation(WK_ConstantUtility.VIOAPPROVED, loggedInUser.Contact.AccountId,'Bag(s) on floor', loggedInUser.ContactId, 'sample note');
                insert viol;
                Attachment att = new Attachment ( Name = 'sample attachment', Body = Blob.valueOf('Sample Attachment Body'), ParentID = viol.Id);
                insert att;
                Attachment att2 = new Attachment ( Name = 'sample attachment2', Body = Blob.valueOf('Sample Attachment Body 2'), ParentID = viol.Id);
                insert att2;
            }
            else if(selectedType.equals(WK_ConstantUtility.reportsOpenInquiries)) {
                inquiry = WK_TestClassUtility.createInquiry('New', loggedInUser.Contact.AccountId, loggedInUser.ContactId, 'Request Information', 'Valet Trash');
                insert inquiry;
            }
            else if(selectedType.equals(WK_ConstantUtility.reportsClosedInquiries)) {
                inquiry = WK_TestClassUtility.createInquiry(WK_ConstantUtility.CASE_CLOSED_STATUS, loggedInUser.Contact.AccountId, loggedInUser.ContactId, 'Request Information', 'Valet Trash');
                insert inquiry;
            }
            else if(selectedType.equals(WK_ConstantUtility.reportsServiceHistory)) {
                serviceapp = WK_TestClassUtility.createServiceAppointment('Canceled', loggedInUser.Contact.AccountId, loggedInUser.ContactId, System.now()-50, System.now()+5, System.now(), System.now()+8);
                insert serviceapp;
            }
            else if(selectedType.equals(WK_ConstantUtility.reportsUpcomingServices)) {
                serviceapp = WK_TestClassUtility.createServiceAppointment('In Progress', loggedInUser.Contact.AccountId, loggedInUser.ContactId, System.now()+1, System.now()+5, System.now(), System.now()+8);
                insert serviceapp;
            }
            else if(selectedType.equals(WK_ConstantUtility.reportsValetTrashCheckinCheckout)) {
                serviceapp = WK_TestClassUtility.createServiceAppointment('Canceled', loggedInUser.Contact.AccountId, loggedInUser.ContactId, System.now()-50, System.now()+5, System.now(), System.now()+8);
                serviceapp.ActualEndTime = System.now()+10;
                serviceapp.WK_Services__c  = 'Valet Trash';
                insert serviceapp;
            }
        }
            
    }

    public static testMethod void controllerTest(){        
        String      aliasString = 'testred';
        Id sysAdminId  = [Select Id,Name from Profile Where Name= 'WK Property Manager' Limit 1].Id;
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User portalAccountOwner1 = new User(
        UserRoleId = portalRole.Id,
        ProfileId = profile1.Id,
        Username = System.now().millisecond() + 'test21@test.com',
        Alias = 'ba1tman',
        Email='bruceq.wayne@wayneenterprises.com',
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
                acc.BillingCity='test';
                acc.BillingStreet='test';
                acc.BillingCountry='ind';
                acc.WK_Has_Duplicate_Units__c='yes';
                insert acc;
                
                Contact con =New contact();
                con.LastName='test23';
                con.AccountId= acc.id;
                con.Phone='1234455667';
                con.Email='test1@gmail.com';
                insert con;
                
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
                
                WorkType wrt = new WorkType();
                wrt.Name = 'Junk Removal';
                wrt.EstimatedDuration = 3;
                wrt.DurationType = 'Hours';
                if (wrt != null) {
                   insert wrt;
                }
                workorder wo=new workorder();
                wo.RecordtypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Junk Removal').getRecordTypeId();
                wo.AccountId=acc.Id;
                wo.WorkTypeId = wrt.Id;
                wo.ContactId=con.Id;
                insert wo;
            
                Building__c build= new Building__c();
                build.Name='testbuilding';
                build.Account__c=acc.Id;
                insert build;
                system.debug('build inserted - >'+build);
                
                ServiceAppointment serApp= new ServiceAppointment();
                serApp.ParentRecordId=wo.Id;
                serApp.SchedStartTime=system.now();
                serApp.ContactId = con.Id;
                serApp.SchedEndTime=system.now()+2;
                serApp.status='NONE';
                serApp.EarliestStartTime=system.now();
                serApp.dueDate=system.now()+2;
                insert serApp;
                system.debug('serApp inserted - >'+serApp);
            
                Violation__c vio = new Violation__c();
                vio.WK_Service_Appointment__c=serApp.Id;
                vio.WK_Building__c=build.Id;
                vio.Unit__c='test';
                vio.Violation_Type__c='Other';
                vio.WK_Status__c='Approved';
                vio.WK_Add_Note__c ='Test';
                insert vio;
                system.debug('vio inserted - >'+vio);
            
                test.StartTest();
                    System.RunAs(user1) {
                        List<Violation__c> lstOfVio = new List<VIolation__c>();
                        lstOfVio = [Select Id,Name from Violation__c where Id =: vio.Id];
                        //PageReference ref = page.WK_Reports;
                        //test.setCurrentPage(ref);
                        Test.setCurrentPageReference(new PageReference('Page.WK_Reports')); 
                        System.currentPageReference().getParameters().put('Type', 'Violations');
                        System.currentPageReference().getParameters().put('param1', 'Valet Trash Violations');
                        System.currentPageReference().getParameters().put('param2', 'Last 30 Days');
                        System.currentPageReference().getParameters().put('param3', 'Thu May 04 00:00:00 GMT 2017');
                        System.currentPageReference().getParameters().put('param4', 'Thu May 06 00:00:00 GMT 2017');
                        System.currentPageReference().getParameters().put('param5', 'Test');
                        system.debug('System.currentPageReference().getParameters() ->'+System.currentPageReference().getParameters());
                        WK_ReportsController controller=new WK_ReportsController();
                        //controller.goToPage();
                        controller.runReport();
                        controller.violationName = lstOfVio[0].Name;
                        controller.navigateToVioRec();
                        //WK_ReportsController.fetchViolationRecords();
                    }
                test.stopTest(); 
        }
    }

    public static testMethod void controllerTest1(){
        
        String      aliasString = 'testred';
        Id sysAdminId  = [Select Id,Name from Profile Where Name= 'WK Property Manager' Limit 1].Id;
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User portalAccountOwner1 = new User(
        UserRoleId = portalRole.Id,
        ProfileId = profile1.Id,
        Username = System.now().millisecond() + 'testy21@test.com',
        Alias = 'ba1ytman',
        Email='bruceq.waynye@wayneenterprises.com',
        EmailEncodingKey='UTF-8',
        Firstname='Bruce',
        Lastname='Wayynew',
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
                acc.BillingCity='test';
                acc.BillingStreet='test';
                acc.BillingCountry='ind';
                acc.WK_Has_Duplicate_Units__c='yes';
                insert acc;
                
                Contact con =New contact();
                con.LastName='test23';
                con.AccountId= acc.id;
                con.Phone='1234455667';
                con.Email='test1@gmail.com';
                insert con;
                
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
                
                WorkType wrt = new WorkType();
                wrt.Name = 'Junk Removal';
                wrt.EstimatedDuration = 3;
                wrt.DurationType = 'Hours';
                if (wrt != null) {
                   insert wrt;
                }
                workorder wo=new workorder();
                wo.RecordtypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Junk Removal').getRecordTypeId();
                wo.AccountId=acc.Id;
                wo.WorkTypeId = wrt.Id;
                wo.ContactId=con.Id;
                insert wo;
            
                Building__c build= new Building__c();
                build.Name='testbuilding';
                build.Account__c=acc.Id;
                insert build;
            
                ServiceAppointment serApp= new ServiceAppointment();
                serApp.ParentRecordId=wo.Id;
                serApp.SchedStartTime=system.now();
                serApp.ContactId = con.Id;
                serApp.SchedEndTime=system.now()+2;
                serApp.status='NONE';
                serApp.EarliestStartTime=system.now();
                serApp.dueDate=system.now()+2;
                insert serApp;
            
                Violation__c vio = new Violation__c();
                vio.WK_Service_Appointment__c=serApp.Id;
                vio.WK_Building__c=build.Id;
                vio.Unit__c='test';
                vio.Violation_Type__c='Other';
                vio.WK_Status__c='Approved';
                vio.WK_Add_Note__c ='Test';
                insert vio;
            
                test.StartTest();
                System.RunAs(user1) {
                List<Violation__c> lstOfVio = new List<VIolation__c>();
                lstOfVio = [Select Id,Name from Violation__c where Id =: vio.Id];
                //PageReference ref = page.WK_Reports;
                //test.setCurrentPage(ref);
                Test.setCurrentPageReference(new PageReference('Page.WK_Reports')); 
                System.currentPageReference().getParameters().put('Type', 'Violations');
                WK_ReportsController controller=new WK_ReportsController();
                WK_ReportsController.duration = 'Last 60 Days';
                WK_ReportsController.selectedType = 'Valet Trash Violations';
                controller.runReport();
                //WK_ReportsController.fetchViolationRecords();
                WK_ReportsController.duration = 'Last 90 Days';
                WK_ReportsController.selectedType = 'Valet Trash Violations';
                controller.runReport();
                
                WK_ReportsController.duration = 'Past 12 months';
                WK_ReportsController.selectedType = 'Valet Trash Violations';
                controller.runReport();
                
                 WK_ReportsController.duration = 'Select Date Range';
                 WK_ReportsController.startDate = System.today()-1;
                 WK_ReportsController.endDate = System.today();
                WK_ReportsController.selectedType = 'Valet Trash Violations';
                controller.runReport();
                }
                test.stopTest(); 
        }
    }


    public static testMethod void controllerTest2(){
        
        String      aliasString = 'testred';
        Id sysAdminId  = [Select Id,Name from Profile Where Name= 'WK Property Manager' Limit 1].Id;
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User portalAccountOwner1 = new User(
        UserRoleId = portalRole.Id,
        ProfileId = profile1.Id,
        Username = System.now().millisecond() + 'test21@test.com',
        Alias = 'ba1tman',
        Email='bruceq.wayne@wayneenterprises.com',
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
                acc.BillingCity='test';
                acc.BillingStreet='test';
                acc.BillingCountry='ind';
                acc.WK_Has_Duplicate_Units__c='yes';
                insert acc;
                
                Contact con =New contact();
                con.LastName='test23';
                con.AccountId= acc.id;
                con.Phone='1234455667';
                con.Email='test1@gmail.com';
                insert con;
                
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
                
                WorkType wrt = new WorkType();
                wrt.Name = 'Junk Removal';
                wrt.EstimatedDuration = 3;
                wrt.DurationType = 'Hours';
                if (wrt != null) {
                   insert wrt;
                }
                
                workorder wo=new workorder();
                wo.RecordtypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Junk Removal').getRecordTypeId();
                wo.AccountId=acc.Id;
                wo.WorkTypeId = wrt.Id;
                wo.ContactId=con.Id;
                insert wo;
            
                Building__c build= new Building__c();
                build.Name='testbuilding';
                build.Account__c=acc.Id;
                insert build;
            
                ServiceAppointment serApp= new ServiceAppointment();
                serApp.ParentRecordId=wo.Id;
                serApp.SchedStartTime=system.now();
                serApp.ContactId = con.Id;
                serApp.SchedEndTime=system.now()+2;
                serApp.status='Canceled';
                serApp.EarliestStartTime=system.now();
                serApp.dueDate=system.now()+2;
                insert serApp;
            
                Violation__c vio = new Violation__c();
                vio.WK_Service_Appointment__c=serApp.Id;
                vio.WK_Building__c=build.Id;
                vio.Unit__c='test';
                vio.Violation_Type__c='Other';
                vio.WK_Status__c='Approved';
                vio.WK_Add_Note__c ='Test';
                insert vio;
            
                test.StartTest();
                System.RunAs(user1) {
                Test.setCurrentPageReference(new PageReference('Page.WK_Reports')); 
                System.currentPageReference().getParameters().put('Type', 'Services');
                WK_ReportsController controller=new WK_ReportsController();
                //controller.goToPage();
                controller.runReport();
                //WK_ReportsController.fetchViolationRecords();
                }
                test.stopTest(); 
        }
    }  
        
    public static testMethod void controllerTest3(){
        
        String      aliasString = 'testred';
        Id sysAdminId  = [Select Id,Name from Profile Where Name= 'WK Property Manager' Limit 1].Id;
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User portalAccountOwner1 = new User(
        UserRoleId = portalRole.Id,
        ProfileId = profile1.Id,
        Username = System.now().millisecond() + 'test21@test.com',
        Alias = 'ba1tman',
        Email='bruceq.wayne@wayneenterprises.com',
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
                acc.BillingCity='test';
                acc.BillingStreet='test';
                acc.BillingCountry='ind';
                acc.WK_Has_Duplicate_Units__c='yes';
                insert acc;
                
                Contact con =New contact();
                con.LastName='test23';
                con.AccountId= acc.id;
                con.Phone='1234455667';
                con.Email='test1@gmail.com';
                insert con;
                
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
                
                WorkType wrt = new WorkType();
                wrt.Name = 'Junk Removal';
                wrt.EstimatedDuration = 3;
                wrt.DurationType = 'Hours';
                if (wrt != null) {
                   insert wrt;
                }
    
                workorder wo=new workorder();
                wo.RecordtypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Junk Removal').getRecordTypeId();
                wo.AccountId=acc.Id;
                wo.WorkTypeId = wrt.Id;
                wo.ContactId=con.Id;
                insert wo;
            
                Building__c build= new Building__c();
                build.Name='testbuilding';
                build.Account__c=acc.Id;
                insert build;
            
                ServiceAppointment serApp= new ServiceAppointment();
                serApp.ParentRecordId=wo.Id;
                serApp.SchedStartTime=system.now();
                serApp.ContactId = con.Id;
                serApp.SchedEndTime=system.now()+2;
                serApp.status='Canceled';
                serApp.EarliestStartTime=system.now();
                serApp.dueDate=system.now()+2;
                insert serApp;
            
                Violation__c vio = new Violation__c();
                vio.WK_Service_Appointment__c=serApp.Id;
                vio.WK_Building__c=build.Id;
                vio.Unit__c='test';
                vio.Violation_Type__c='Other';
                vio.WK_Status__c='Approved';
                vio.WK_Add_Note__c ='Test';
                insert vio;
            
                test.StartTest();
                System.RunAs(user1) {
                Test.setCurrentPageReference(new PageReference('Page.WK_Reports')); 
                WK_ReportsController controller=new WK_ReportsController();
                WK_ReportsController.duration = 'Last 60 Days';
                WK_ReportsController.selectedType = 'Service History';
                controller.runReport();
                
                WK_ReportsController.duration = 'Last 90 Days';
                WK_ReportsController.selectedType = 'Service History';
                controller.runReport();
                
                WK_ReportsController.duration = 'Past 12 months';
                WK_ReportsController.selectedType = 'Service History';
                controller.runReport();
                
                 WK_ReportsController.duration = 'Select Date Range';
                 WK_ReportsController.startDate = System.today()-1;
                 WK_ReportsController.endDate = System.today();
                WK_ReportsController.selectedType = 'Service History';
                controller.runReport();
                
                }
                test.stopTest(); 
        }
    }  
        
    public static testMethod void controllerTest4(){
        
        String      aliasString = 'testred';
        Id sysAdminId  = [Select Id,Name from Profile Where Name= 'WK Property Manager' Limit 1].Id;
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User portalAccountOwner1 = new User(
        UserRoleId = portalRole.Id,
        ProfileId = profile1.Id,
        Username = System.now().millisecond() + 'test21@test.com',
        Alias = 'ba1tman',
        Email='bruceq.wayne@wayneenterprises.com',
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
                acc.BillingCity='test';
                acc.BillingStreet='test';
                acc.BillingCountry='ind';
                acc.WK_Has_Duplicate_Units__c='yes';
                insert acc;
                
                Contact con =New contact();
                con.LastName='test23';
                con.AccountId= acc.id;
                con.Phone='1234455667';
                con.Email='test1@gmail.com';
                insert con;
                
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
                
                WorkType wrt = new WorkType();
                wrt.Name = 'Junk Removal';
                wrt.EstimatedDuration = 3;
                wrt.DurationType = 'Hours';
                if (wrt != null) {
                   insert wrt;
                }
                
                workorder wo=new workorder();
                wo.RecordtypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Junk Removal').getRecordTypeId();
                wo.AccountId=acc.Id;
                wo.WorkTypeId = wrt.Id;
                wo.ContactId=con.Id;
                insert wo;
            
                Building__c build= new Building__c();
                build.Name='testbuilding';
                build.Account__c=acc.Id;
                insert build;
            
                ServiceAppointment serApp= new ServiceAppointment();
                serApp.ParentRecordId=wo.Id;
                serApp.SchedStartTime=system.now();
                serApp.ContactId = con.Id;
                serApp.SchedEndTime=system.now()+2;
                serApp.status='NONE';
                serApp.EarliestStartTime=system.now();
                serApp.dueDate=system.now()+2;
                insert serApp;
            
                Violation__c vio = new Violation__c();
                vio.WK_Service_Appointment__c=serApp.Id;
                vio.WK_Building__c=build.Id;
                vio.Unit__c='test';
                vio.Violation_Type__c='Other';
                vio.WK_Status__c='Approved';
                vio.WK_Add_Note__c ='Test';
                insert vio;
            
                test.StartTest();
                System.RunAs(user1) {
                //PageReference ref = page.WK_Reports;
                //test.setCurrentPage(ref);
                List<Account> lstAcc = new List<Account>();
                lstAcc= [Select Id,Name from Account where Id=:acc.Id];
                Test.setCurrentPageReference(new PageReference('Page.WK_Reports')); 
                System.currentPageReference().getParameters().put('param1', 'Valet Trash Violations');
                System.currentPageReference().getParameters().put('param2', 'Weekly');
                System.currentPageReference().getParameters().put('param5', lstAcc[0].Name);
                WK_ReportsController controller = new WK_ReportsController();
                
                System.currentPageReference().getParameters().put('param1', 'Valet Trash Violations');
                System.currentPageReference().getParameters().put('param2', 'Daily');
                System.currentPageReference().getParameters().put('param5', lstAcc[0].Name);
                WK_ReportsController controller1 = new WK_ReportsController();
                }
                test.stopTest(); 
        }
    }                 
      
    public static testMethod void controllerTest5(){
        
        String      aliasString = 'testred';
        Id sysAdminId  = [Select Id,Name from Profile Where Name= 'WK Property Manager' Limit 1].Id;
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User portalAccountOwner1 = new User(
        UserRoleId = portalRole.Id,
        ProfileId = profile1.Id,
        Username = System.now().millisecond() + 'test21@test.com',
        Alias = 'ba1tman',
        Email='bruceq.wayne@wayneenterprises.com',
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
                acc.BillingCity='test';
                acc.BillingStreet='test';
                acc.BillingCountry='ind';
                acc.WK_Has_Duplicate_Units__c='yes';
                insert acc;
                
                Contact con =New contact();
                con.LastName='test23';
                con.AccountId= acc.id;
                con.Phone='1234455667';
                con.Email='test1@gmail.com';
                insert con;
                
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
                
                WorkType wrt = new WorkType();
                wrt.Name = 'Junk Removal';
                wrt.EstimatedDuration = 3;
                wrt.DurationType = 'Hours';
                if (wrt != null) {
                   insert wrt;
                }
                
                workorder wo=new workorder();
                wo.RecordtypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Junk Removal').getRecordTypeId();
                wo.AccountId=acc.Id;
                wo.WorkTypeId = wrt.Id;
                wo.ContactId=con.Id;
                insert wo;
            
                Building__c build= new Building__c();
                build.Name='testbuilding';
                build.Account__c=acc.Id;
                insert build;
            
                ServiceAppointment serApp= new ServiceAppointment();
                serApp.ParentRecordId=wo.Id;
                serApp.SchedStartTime=system.now();
                serApp.ContactId = con.Id;
                serApp.SchedEndTime=system.now()+2;
                serApp.status='Completed';
                serApp.EarliestStartTime=system.now();
                serApp.dueDate=system.now()+2;
                insert serApp;
            
                Violation__c vio = new Violation__c();
                vio.WK_Service_Appointment__c=serApp.Id;
                vio.WK_Building__c=build.Id;
                vio.Unit__c='test';
                vio.Violation_Type__c='Other';
                vio.WK_Status__c='Approved';
                vio.WK_Add_Note__c ='Test';
                insert vio;
            
                test.StartTest();
                System.RunAs(user1) {
                //PageReference ref = page.WK_Reports;
                //test.setCurrentPage(ref);
                List<Account> lstAcc = new List<Account>();
                lstAcc= [Select Id,Name from Account where Id=:acc.Id];
                Test.setCurrentPageReference(new PageReference('Page.WK_Reports')); 
                System.currentPageReference().getParameters().put('Type', 'CheckIn');
                WK_ReportsController controller = new WK_ReportsController();
                }
                test.stopTest(); 
        }
    } 
        
    public static testMethod void controllerTest6(){
        
        String      aliasString = 'testred';
        Id sysAdminId  = [Select Id,Name from Profile Where Name= 'WK Property Manager' Limit 1].Id;
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User portalAccountOwner1 = new User(
        UserRoleId = portalRole.Id,
        ProfileId = profile1.Id,
        Username = System.now().millisecond() + 'test21@test.com',
        Alias = 'ba1tman',
        Email='bruceq.wayne@wayneenterprises.com',
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
                acc.BillingCity='test';
                acc.BillingStreet='test';
                acc.BillingCountry='ind';
                acc.WK_Has_Duplicate_Units__c='yes';
                insert acc;
                
                Contact con =New contact();
                con.LastName='test23';
                con.AccountId= acc.id;
                con.Phone='1234455667';
                con.Email='test1@gmail.com';
                insert con;
                
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
                
                WorkType wrt = new WorkType();
                wrt.Name = 'Junk Removal';
                wrt.EstimatedDuration = 3;
                wrt.DurationType = 'Hours';
                if (wrt != null) {
                   insert wrt;
                }
    
                workorder wo=new workorder();
                wo.AccountId=acc.Id;
                 wo.RecordtypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Junk Removal').getRecordTypeId();
                wo.WorkTypeId = wrt.Id;
                wo.ContactId=con.Id;
                insert wo;
            
                Building__c build= new Building__c();
                build.Name='testbuilding';
                build.Account__c=acc.Id;
                insert build;
            
                ServiceAppointment serApp= new ServiceAppointment();
                serApp.ParentRecordId=wo.Id;
                serApp.SchedStartTime=system.now();
                serApp.ContactId = con.Id;
                serApp.SchedEndTime=system.now()+2;
                serApp.status='Completed';
                serApp.EarliestStartTime=system.now();
                serApp.dueDate=system.now()+2;
                insert serApp;
            
                Violation__c vio = new Violation__c();
                vio.WK_Service_Appointment__c=serApp.Id;
                vio.WK_Building__c=build.Id;
                vio.Unit__c='test';
                vio.Violation_Type__c='Other';
                vio.WK_Status__c='Approved';
                vio.WK_Add_Note__c ='Test';
                insert vio;
            
                test.StartTest();
                System.RunAs(user1) {
                //PageReference ref = page.WK_Reports;
                //test.setCurrentPage(ref);
                List<Account> lstAcc = new List<Account>();
                lstAcc= [Select Id,Name from Account where Id=:acc.Id];
                Test.setCurrentPageReference(new PageReference('Page.WK_Reports')); 
                WK_ReportsController.duration = 'Last 60 Days';
                WK_ReportsController.selectedType = 'Valet Trash Check-in/Check-out';
                WK_ReportsController controller = new WK_ReportsController();
                controller.runReport();
                
                WK_ReportsController.duration = 'Last 90 Days';
                WK_ReportsController.selectedType = 'Valet Trash Check-in/Check-out';
                controller.runReport();
                
                WK_ReportsController.duration = 'Past 12 months';
                WK_ReportsController.selectedType = 'Valet Trash Check-in/Check-out';
                controller.runReport();
                
                 WK_ReportsController.duration = 'Select Date Range';
                 WK_ReportsController.startDate = System.today()-1;
                 WK_ReportsController.endDate = System.today();
                WK_ReportsController.selectedType = 'Valet Trash Check-in/Check-out';
                controller.runReport();
                }
                test.stopTest(); 
        }
    } 

    /**
     * @author: NSebastian@Deloitte
     * @description: TEst method to check 5 day violations
     * @param: 
     * @returntype: void   
    */
    public static testmethod void test5DayViolations() {
        List<WK_ReportsController.ViolationWrapper> result = new List<WK_ReportsController.ViolationWrapper>();
        createTestData(WK_ConstantUtility.reports5dayViolationsTSys,WK_ConstantUtility.reportsPast12months);
        PageReference myVfPage = Page.WK_Reports;
        Test.setCurrentPage(myVfPage);
        System.runAs(testPortalUser) {
            Test.setCreatedDate(viol.Id, System.now() - 3);
            Test.startTest();
                //ApexPages.currentPage().getParameters().put('Type',WK_ConstantUtility.reports5dayViolationsTSys);
                //WK_ReportsController controller = new WK_ReportsController();
                ApexPages.currentPage().getParameters().put(WK_ConstantUtility.reportsParam1,WK_ConstantUtility.reports5dayViolationsTSys);
                ApexPages.currentPage().getParameters().put(WK_ConstantUtility.reportsParam2,WK_ConstantUtility.reportsLast30Days);
                WK_ReportsController controller = new WK_ReportsController();
                //controller = new WK_ReportsController();              
                ApexPages.currentPage().getParameters().put(WK_ConstantUtility.reportsParam2,WK_ConstantUtility.reportsLast7Days);
                controller = new WK_ReportsController();
                ApexPages.currentPage().getParameters().put(WK_ConstantUtility.reportsParam2,WK_ConstantUtility.reportsYesterday );
                controller = new WK_ReportsController();
                ApexPages.currentPage().getParameters().put(WK_ConstantUtility.reportsParam2,WK_ConstantUtility.reportsLast60Days);
                controller = new WK_ReportsController();
                ApexPages.currentPage().getParameters().put(WK_ConstantUtility.reportsParam2,WK_ConstantUtility.reportsLast90Days );
                controller = new WK_ReportsController();
                ApexPages.currentPage().getParameters().put(WK_ConstantUtility.reportsParam2,WK_ConstantUtility.reportsPast12months );
                controller = new WK_ReportsController();
                result = WK_ReportsController.listOf5DayViolationsWrapper;

            Test.stopTest();
        }
        System.assert(!result.isEmpty());
        System.assertEquals(result[0].vioId, viol.Id);
    }

    /**
     * @author: NSebastian@Deloitte
     * @description: TEst method to check other violations
     * @param: 
     * @returntype: void   
    */
    public static testmethod void testOtherViolations() {
        List<WK_ReportsController.ViolationWrapper> result = new List<WK_ReportsController.ViolationWrapper>();
        createTestData(WK_ConstantUtility.reportsValetTrashViolations,WK_ConstantUtility.reportsPast12months);
        PageReference myVfPage = Page.WK_Reports;
        Test.setCurrentPage(myVfPage);
        System.runAs(testPortalUser) {
            Test.setCreatedDate(viol.Id, System.now() - 3);
            Test.startTest();
                //ApexPages.currentPage().getParameters().put('Type',WK_ConstantUtility.reportsValetTrashViolations);
                //WK_ReportsController controller = new WK_ReportsController();
                ApexPages.currentPage().getParameters().put(WK_ConstantUtility.reportsParam1,WK_ConstantUtility.reportsValetTrashViolations);
                ApexPages.currentPage().getParameters().put(WK_ConstantUtility.reportsParam2,WK_ConstantUtility.reportsLast30Days);
                WK_ReportsController controller = new WK_ReportsController();
                //controller = new WK_ReportsController();
                ApexPages.currentPage().getParameters().put(WK_ConstantUtility.reportsParam2,WK_ConstantUtility.reportsLast7Days);
                controller = new WK_ReportsController();
                ApexPages.currentPage().getParameters().put(WK_ConstantUtility.reportsParam2,WK_ConstantUtility.reportsYesterday );
                controller = new WK_ReportsController();
                ApexPages.currentPage().getParameters().put(WK_ConstantUtility.reportsParam2,WK_ConstantUtility.reportsLast60Days);
                controller = new WK_ReportsController();
                ApexPages.currentPage().getParameters().put(WK_ConstantUtility.reportsParam2,WK_ConstantUtility.reportsLast90Days );
                controller = new WK_ReportsController();
                ApexPages.currentPage().getParameters().put(WK_ConstantUtility.reportsParam2,WK_ConstantUtility.reportsPast12months );
                controller = new WK_ReportsController();
                result = WK_ReportsController.listOfViolationWrapper;
            Test.stopTest();
        }
        System.assert(!result.isEmpty());
        System.assertEquals(result[0].vioId, viol.Id);
    }

     /**
     * @author: NSebastian@Deloitte
     * @description: TEst method to test Open Inquiries
     * @param: 
     * @returntype: void   
    */
    public static testmethod void testOpenInquiries() {
        List<WK_ReportsController.OpenInquiriesWrapper> result = new List<WK_ReportsController.OpenInquiriesWrapper>();
        PageReference redirect;
        createTestData(WK_ConstantUtility.reportsOpenInquiries,WK_ConstantUtility.reportsPast12months);
        PageReference myVfPage = Page.WK_Reports;
        Test.setCurrentPage(myVfPage);
        System.runAs(testPortalUser) {
            Test.setCreatedDate(inquiry.Id, System.now() - 3);
            Test.startTest();
                //ApexPages.currentPage().getParameters().put('Type',WK_ConstantUtility.reportsOpenInquiries);
                //WK_ReportsController controller = new WK_ReportsController();
                ApexPages.currentPage().getParameters().put(WK_ConstantUtility.reportsParam1,WK_ConstantUtility.reportsOpenInquiries);
                ApexPages.currentPage().getParameters().put(WK_ConstantUtility.reportsParam2,WK_ConstantUtility.reportsLast30Days);
                WK_ReportsController controller = new WK_ReportsController();
                //controller = new WK_ReportsController();
                ApexPages.currentPage().getParameters().put(WK_ConstantUtility.reportsParam2,WK_ConstantUtility.reportsLast7Days  );
                controller = new WK_ReportsController();
                ApexPages.currentPage().getParameters().put(WK_ConstantUtility.reportsParam2,WK_ConstantUtility.reportsYesterday );
                controller = new WK_ReportsController();
                ApexPages.currentPage().getParameters().put(WK_ConstantUtility.reportsParam2,WK_ConstantUtility.reportsLast60Days);
                controller = new WK_ReportsController();
                ApexPages.currentPage().getParameters().put(WK_ConstantUtility.reportsParam2,WK_ConstantUtility.reportsLast90Days );
                controller = new WK_ReportsController();
                ApexPages.currentPage().getParameters().put(WK_ConstantUtility.reportsParam2,WK_ConstantUtility.reportsPast12months );
                controller = new WK_ReportsController();
                result = WK_ReportsController.listOpenInquiriesWrapper;
                controller.selectedInquiryId = inquiry.id;
                controller.returnURL = ApexPages.currentPage().getUrl();
                redirect = controller.navigateToInquiryDetails();
            Test.stopTest();
        }
        System.assert(!result.isEmpty());
        System.assertEquals(result[0].inquirySFId, inquiry.Id);
        System.assert(redirect.getUrl().containsIgnoreCase(WK_ConstantUtility.INQUIRYDETAIL_PAGE));

    }

     /**
     * @author: NSebastian@Deloitte
     * @description: TEst method to test Closed Inquiries
     * @param: 
     * @returntype: void   
    */
    public static testmethod void testClosedInquiries() {
        List<WK_ReportsController.ClosedInquiriesWrapper> result = new List<WK_ReportsController.ClosedInquiriesWrapper>();
        PageReference redirect;
        createTestData(WK_ConstantUtility.reportsClosedInquiries,WK_ConstantUtility.reportsPast12months);
        PageReference myVfPage = Page.WK_Reports;
        Test.setCurrentPage(myVfPage);
        System.runAs(testPortalUser) {
            Test.setCreatedDate(inquiry.Id, System.now() - 3);
            Test.startTest();
                //ApexPages.currentPage().getParameters().put('Type',WK_ConstantUtility.reportsClosedInquiries);
                //WK_ReportsController controller = new WK_ReportsController();
                ApexPages.currentPage().getParameters().put(WK_ConstantUtility.reportsParam1,WK_ConstantUtility.reportsClosedInquiries);
                ApexPages.currentPage().getParameters().put(WK_ConstantUtility.reportsParam2,WK_ConstantUtility.reportsLast30Days);
                WK_ReportsController controller = new WK_ReportsController();
                //controller = new WK_ReportsController();
                ApexPages.currentPage().getParameters().put(WK_ConstantUtility.reportsParam2,WK_ConstantUtility.reportsLast7Days  );
                controller = new WK_ReportsController();
                ApexPages.currentPage().getParameters().put(WK_ConstantUtility.reportsParam2,WK_ConstantUtility.reportsYesterday );
                controller = new WK_ReportsController();
                ApexPages.currentPage().getParameters().put(WK_ConstantUtility.reportsParam2,WK_ConstantUtility.reportsLast60Days);
                controller = new WK_ReportsController();
                ApexPages.currentPage().getParameters().put(WK_ConstantUtility.reportsParam2,WK_ConstantUtility.reportsLast90Days );
                controller = new WK_ReportsController();
                ApexPages.currentPage().getParameters().put(WK_ConstantUtility.reportsParam2,WK_ConstantUtility.reportsPast12months );
                controller = new WK_ReportsController();
                result = WK_ReportsController.listClosedInquiriesWrapper;
                redirect = WK_ReportsController.printingCancel();
            Test.stopTest();
        }
        System.assert(!result.isEmpty());
        System.assertEquals(result[0].inquirySFId, inquiry.Id);
        System.assert(redirect.getUrl().containsIgnoreCase(WK_ConstantUtility.urlWkReportsTypeViolations));
    }

     /**
     * @author: NSebastian@Deloitte
     * @description: TEst method to test Service History report
     * @param: 
     * @returntype: void   
    */
    public static testmethod void testServiceHistory() {
        List<WK_ReportsController.serviceHistroyWrapper> result = new List<WK_ReportsController.serviceHistroyWrapper>();
        PageReference redirect;
        createTestData(WK_ConstantUtility.reportsServiceHistory,WK_ConstantUtility.reportsPast12months);
        PageReference myVfPage = Page.WK_Reports;
        Test.setCurrentPage(myVfPage);
        System.runAs(testPortalUser) {
            Test.setCreatedDate(serviceapp.Id, System.now() - 3);
            Test.startTest();
                //ApexPages.currentPage().getParameters().put('Type',WK_ConstantUtility.reportsServiceHistory);
                //WK_ReportsController controller = new WK_ReportsController();
                ApexPages.currentPage().getParameters().put(WK_ConstantUtility.reportsParam1,WK_ConstantUtility.reportsServiceHistory);
                ApexPages.currentPage().getParameters().put(WK_ConstantUtility.reportsParam2,WK_ConstantUtility.reportsLast30Days);
                WK_ReportsController controller = new WK_ReportsController();
                //controller = new WK_ReportsController();
                ApexPages.currentPage().getParameters().put(WK_ConstantUtility.reportsParam2,WK_ConstantUtility.reportsLast7Days  );
                controller = new WK_ReportsController();
                ApexPages.currentPage().getParameters().put(WK_ConstantUtility.reportsParam2,WK_ConstantUtility.reportsYesterday );
                controller = new WK_ReportsController();
                ApexPages.currentPage().getParameters().put(WK_ConstantUtility.reportsParam2,WK_ConstantUtility.reportsLast60Days);
                controller = new WK_ReportsController();
                ApexPages.currentPage().getParameters().put(WK_ConstantUtility.reportsParam2,WK_ConstantUtility.reportsLast90Days );
                controller = new WK_ReportsController();
                ApexPages.currentPage().getParameters().put(WK_ConstantUtility.reportsParam2,WK_ConstantUtility.reportsPast12months );
                controller = new WK_ReportsController();
                result = WK_ReportsController.listOfServiceHistoryWrapper;
            Test.stopTest();
        }
        System.assert(!result.isEmpty());
        System.assertEquals(result[0].serviceAppRecordWrapper.Id, serviceapp.Id);
        //ServiceAppointment sa = [SELECT AppointmentNumber FROM ServiceAppointment WHERE Id = :serviceapp.Id LIMIT 1];
        //System.assertEquals(result[0].serviceAppAppointNo, sa.AppointmentNumber);
    }

    /**
     * @author: NSebastian@Deloitte
     * @description: TEst method to test Upcoming services report
     * @param: 
     * @returntype: void   
    */
    public static testmethod void testUpcomingServices() {
        List<WK_ReportsController.upcomingServicesWrapper> result = new List<WK_ReportsController.upcomingServicesWrapper>();
        PageReference redirect;
        createTestData(WK_ConstantUtility.reportsUpcomingServices,WK_ConstantUtility.reportsNext30Days);
        PageReference myVfPage = Page.WK_Reports;
        Test.setCurrentPage(myVfPage);
        System.runAs(testPortalUser) {
            Test.setCreatedDate(serviceapp.Id, System.now() - 3);
            Test.startTest();
                //ApexPages.currentPage().getParameters().put('Type',WK_ConstantUtility.reportsUpcomingServices);
                //WK_ReportsController controller = new WK_ReportsController();
                ApexPages.currentPage().getParameters().put(WK_ConstantUtility.reportsParam1,WK_ConstantUtility.reportsUpcomingServices);
                ApexPages.currentPage().getParameters().put(WK_ConstantUtility.reportsParam2,WK_ConstantUtility.reportsNext30Days);
                WK_ReportsController controller = new WK_ReportsController();
                //controller = new WK_ReportsController();
                
                result = WK_ReportsController.upcomingServicesWrapperList;
            Test.stopTest();
        }
        System.assert(!result.isEmpty());
        //ServiceAppointment sa = [SELECT AppointmentNumber FROM ServiceAppointment WHERE Id = :serviceapp.Id LIMIT 1];
        System.assertEquals(result[0].serviceAppRecordWrapper.Id, serviceapp.Id);
        //System.assertEquals(result[0].serviceAppAppointNo, sa.AppointmentNumber);
    }

    /**
     * @author: NSebastian@Deloitte
     * @description: TEst method to test Valet Trash Checkin/Checkout
     * @param: 
     * @returntype: void   
    */
    public static testmethod void testValetTrashCheckInOut() {
        List<WK_ReportsController.assigResWrapper> result = new List<WK_ReportsController.assigResWrapper>();
        PageReference redirect;
        createTestData(WK_ConstantUtility.reportsValetTrashCheckinCheckout,WK_ConstantUtility.reportsPast12months);
        PageReference myVfPage = Page.WK_Reports;
        Test.setCurrentPage(myVfPage);
        System.runAs(testPortalUser) {
            Test.setCreatedDate(serviceapp.Id, System.now() - 3);
            Test.startTest();
                //ApexPages.currentPage().getParameters().put('Type',WK_ConstantUtility.reportsValetTrashCheckinCheckout);
                //WK_ReportsController controller = new WK_ReportsController();
                ApexPages.currentPage().getParameters().put(WK_ConstantUtility.reportsParam1,WK_ConstantUtility.reportsValetTrashCheckinCheckout);
                ApexPages.currentPage().getParameters().put(WK_ConstantUtility.reportsParam2,WK_ConstantUtility.reportsLast30Days);
                WK_ReportsController controller = new WK_ReportsController();
                //controller = new WK_ReportsController();
                ApexPages.currentPage().getParameters().put(WK_ConstantUtility.reportsParam2,WK_ConstantUtility.reportsLast7Days  );
                controller = new WK_ReportsController();
                ApexPages.currentPage().getParameters().put(WK_ConstantUtility.reportsParam2,WK_ConstantUtility.reportsYesterday );
                controller = new WK_ReportsController();
                ApexPages.currentPage().getParameters().put(WK_ConstantUtility.reportsParam2,WK_ConstantUtility.reportsLast60Days);
                controller = new WK_ReportsController();
                ApexPages.currentPage().getParameters().put(WK_ConstantUtility.reportsParam2,WK_ConstantUtility.reportsLast90Days );
                controller = new WK_ReportsController();
                ApexPages.currentPage().getParameters().put(WK_ConstantUtility.reportsParam2,WK_ConstantUtility.reportsPast12months );
                controller = new WK_ReportsController();
                result = WK_ReportsController.listOfCheckinWrapper;
            Test.stopTest();
        }
        System.assert(!result.isEmpty());
        System.assertEquals(result[0].assignedResRecordWrapper.Id, serviceapp.Id);
    }

    /**
     * @author: NSebastian@Deloitte
     * @description: test the passing of parameters on navigating from homepage with View button
     * @param: 
     * @returntype:    void
    */    
    public static testmethod void testTypeParamValue() {
        String result ;
        createTestData(WK_ConstantUtility.reportsOpenInquiries,WK_ConstantUtility.reportsLast30Days);
        User loggedInUser = [SELECT Id, ContactId, Contact.AccountId,Contact.Account.OwnerId FROM User WHERE Id = :testPortalUser.Id LIMIT 1];
        PageReference myVfPage = Page.WK_Reports;
        Test.setCurrentPage(myVfPage);
        ApexPages.currentPage().getParameters().put(WK_ConstantUtility.reportsType,WK_ConstantUtility.reportOpenInqParam);
        ApexPages.currentPage().getParameters().put(WK_ConstantUtility.URL_PARAM_ID, loggedInUser.Contact.AccountId);
        System.runAs(testPortalUser) {
            Test.startTest();
                WK_ReportsController controller = new WK_ReportsController();
                ApexPages.currentPage().getParameters().put(WK_ConstantUtility.reportsType,WK_ConstantUtility.reportClosedInqParam);
                controller = new WK_ReportsController();
                ApexPages.currentPage().getParameters().put(WK_ConstantUtility.reportsType,WK_ConstantUtility.reportsUpcoming);
                controller = new WK_ReportsController();
                result= WK_ReportsController.duration;
            Test.stopTest();
        }
        System.assertEquals(result,WK_ConstantUtility.reportsNext30Days);
    }   

    /**
     * @author: NSebastian@Deloitte
     * @description: test custom date range reports
     * @param: 
     * @returntype:    void
    */    
    public static testmethod void testCustomDateRange() {
        List<WK_ReportsController.ClosedInquiriesWrapper> result = new List<WK_ReportsController.ClosedInquiriesWrapper>();
        createTestData(WK_ConstantUtility.reportsClosedInquiries,WK_ConstantUtility.reportsLast30Days);
        User loggedInUser = [SELECT Id, ContactId, Contact.AccountId,Contact.Account.OwnerId FROM User WHERE Id = :testPortalUser.Id LIMIT 1];
        PageReference myVfPage = Page.WK_Reports;
        Test.setCurrentPage(myVfPage);
        ApexPages.currentPage().getParameters().put(WK_ConstantUtility.reportsType,WK_ConstantUtility.reportClosedInqParam);
        ApexPages.currentPage().getParameters().put(WK_ConstantUtility.URL_PARAM_ID, loggedInUser.Contact.AccountId);
        System.runAs(testPortalUser) {
            Test.startTest();
                WK_ReportsController controller = new WK_ReportsController();
                WK_ReportsController.duration = WK_ConstantUtility.reportsSelectDateRange ;
                WK_ReportsController.selectedType = WK_ConstantUtility.reportsClosedInquiries;
                WK_ReportsController.startDate = System.today() - 1;
                WK_ReportsController.endDate = System.today() ;
                controller.runReport();
                result = WK_ReportsController.listClosedInquiriesWrapper;
                WK_ReportsController.selectedType = WK_ConstantUtility.reports5dayViolationsTSys ;
                controller.runReport();
                WK_ReportsController.selectedType = WK_ConstantUtility.reportsOpenInquiries ;
                controller.runReport();
            Test.stopTest();
        }
        //System.assert(!result.isEmpty());
        //System.assertEquals(result[0].inquirySFId, inquiry.Id);
    }  

    /**
     * @author: NSebastian@Deloitte
     * @description: test custom datetime range reports
     * @param: 
     * @returntype:    void
    */    
    public static testmethod void testCustomDateTimeRange() {
        List<WK_ReportsController.ClosedInquiriesWrapper> result = new List<WK_ReportsController.ClosedInquiriesWrapper>();
        createTestData(WK_ConstantUtility.reportsClosedInquiries,WK_ConstantUtility.reportsLast30Days);
        User loggedInUser = [SELECT Id, ContactId, Contact.AccountId,Contact.Account.OwnerId FROM User WHERE Id = :testPortalUser.Id LIMIT 1];
        PageReference myVfPage = Page.WK_Reports;
        Test.setCurrentPage(myVfPage);
        ApexPages.currentPage().getParameters().put(WK_ConstantUtility.reportsType,WK_ConstantUtility.reportClosedInqParam);
        ApexPages.currentPage().getParameters().put(WK_ConstantUtility.URL_PARAM_ID, loggedInUser.Contact.AccountId);
        System.runAs(testPortalUser) {
            Test.startTest();
                WK_ReportsController controller = new WK_ReportsController();
                WK_ReportsController.duration = WK_ConstantUtility.reportsSelectDateRange ;
                WK_ReportsController.selectedType = WK_ConstantUtility.reportsClosedInquiries;
                WK_ReportsController.startDateTime = DateTime.newInstance(System.today()-1, Time.newInstance(1, 0, 0, 0));
                WK_ReportsController.endDateTime = DateTime.newInstance(System.today(), Time.newInstance(23, 59, 59, 0));
                controller.runReport();
                result = WK_ReportsController.listClosedInquiriesWrapper;
                WK_ReportsController.selectedType = WK_ConstantUtility.reportsServiceHistory;
                controller.runReport();
                WK_ReportsController.selectedType = WK_ConstantUtility.reportsValetTrashViolations ;
                controller.runReport();
                WK_ReportsController.selectedType = WK_ConstantUtility.reportsValetTrashCheckinCheckout ;
                controller.runReport();
                WK_ReportsController.selectedType = WK_ConstantUtility.reports5dayViolationsTSys ;
                controller.runReport();
                WK_ReportsController.selectedType = WK_ConstantUtility.reportsOpenInquiries ;
                controller.runReport();
            Test.stopTest();
        }
        System.assert(!result.isEmpty());
        System.assertEquals(result[0].inquirySFId, inquiry.Id);
    }   
      
}