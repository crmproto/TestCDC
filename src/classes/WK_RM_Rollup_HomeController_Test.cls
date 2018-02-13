@isTest
public class WK_RM_Rollup_HomeController_Test {
        
    Public static TestMethod Void WK_RM_Rollup_HomeControllerr(){
        
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
        System.runAs(portalAccountOwner1) {
        
            WK_RollupPicklist__c wrp = New WK_RollupPicklist__c();
            wrp.Name = 'Test';
            insert wrp;
            
            Account acc= new Account();
            acc.Name= 'testacc';
            acc.Phone='1234567890';
            acc.WK_Account_Type__c = 'Other';
            acc.WK_Market__c = 'Other';
            acc.WK_Relationship_Status__c ='Prospect';
            acc.WK_MONTHLY_RESIDENT_MARKUP__c = 3;
            insert acc;
            
            Account acc1= new Account();
            acc1.Name= 'testacc';
            acc1.Phone='1234567890';
            //acc1.WK_Account_Type__c = 'Other';
            acc1.WK_Account_Type__c = 'Other';
            acc1.WK_Market__c = 'Other';
            acc1.WK_Relationship_Status__c ='Customer';
            acc1.WK_MONTHLY_RESIDENT_MARKUP__c = 3;
            insert acc1;
            
            Contact con= new Contact();
            con.LastName='testcont';
            con.AccountId=acc1.Id;
            con.Phone='1244567778';
            con.Email='test@gmail.com';
            con.WK_Contact_Type__c = 'Regional Manager';
            insert con;
            
            Product2 p = new Product2(name = 'x', ProductCode = '001' , isActive = True);
                if (p != null) {
                    insert p;
                }

                Product2 p2 = new Product2(name = 'y', ProductCode = '003');
                if (p2 != null) {
                    insert p2;
                }

                Id PricebookId = Test.getstandardPricebookId();
                PricebookEntry pbeNew = new PricebookEntry(Pricebook2id = PricebookId, product2id = p.id, unitprice = 1.0, isactive = true);
                insert pbeNew;

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

                // create the opportunity
                Opportunity opp1 = new Opportunity(
                    name = 'Test Opp 1',
                    StageName = 'Qualification',
                    CloseDate = Date.newInstance(2009, 01, 01),
                    WK_Recurrence__c='Recurring',
                    Pricebook2Id = pb.id
                );
                insert opp1;

                // add the line item
                OpportunityLineItem oli = new OpportunityLineItem();
                oli.Quantity = 1;
                oli.PricebookEntryId = pbe.id;
                oli.OpportunityId = opp1.id;
                oli.UnitPrice = 1;
                insert oli;


                // system.runas(portalAccountOwner1){

                WorkType wrt = new WorkType();
                wrt.Name = 'Junk Removal';
                wrt.EstimatedDuration = 3;
                wrt.DurationType = 'Hours';
                if (wrt != null) {
                    insert wrt;
                }

                OperatingHours oHours = new OperatingHours();
                oHours.Name = 'Test';
                oHours.TimeZone = 'America/Chicago';
                if (oHours != null) {
                    insert oHours;
                }
                workorder wo = new Workorder();
                wo.RecordtypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Junk Removal').getRecordTypeId();
                wo.AccountId = acc.Id;
                wo.WorkTypeId = wrt.Id;
                wo.Status = 'Completed';
                //wo.contactId = con.Id;
                wo.Pricebook2Id = pb.Id;
                wo.StartDate = System.today();
                wo.EndDate = system.today()+2;
                insert wo; 

                ServiceContract servCon = new ServiceContract();
                servCon.AccountId = acc.Id;
                //servCon.ContactId = con.Id;
                servCon.Name = 'Test Name';
                servCon.StartDate = system.today();
                servCon.EndDate = system.today() + 3;
                //servCon.WK_Service_Territory__c = sTerritory .Id;
                servCon.BillingCity = 'Test City';
                servCon.BillingCountry = 'Test Country';
                servCon.BillingPostalCode = '1234';
                // servCon.BillingPostalCode = 'Test City';
                servCon.BillingStreet = 'Test Street';
                servCon.BillingState = 'Test State';
                servCon.WK_Contract_Term__c = '2 years';
                if (servCon != null) {
                    insert servCon;
                }
                
                Contractlineitem cli = new Contractlineitem();
                cli.ServiceContractId=servCon.Id;
                cli.PricebookEntryid=pbe.product2id;//pbe.Product2Id;//'01t1a000001TbfZ';
                cli.Quantity=6;
                cli.UnitPrice=10;
                
                     if(cli != null){
                         try{
                         insert cli;
                         }catch(Exception e){
                         }
                     }
            
            AccountContactRelation acr1 = New AccountContactRelation();
            acr1.Accountid = acc.id;
            acr1.contactid = con.id;
            insert acr1;
            List<ServiceAppointment> lstOfSA = new List<ServiceAppointment>();
            ServiceAppointment sa = New ServiceAppointment();
            sa.ParentRecordId  = acc1.id;
            sa.ContactId= con.Id;
            sa.Status = 'scheduled';
            sa.WK_Services__c = 'Valet Trash';
            sa.ActualEndTime = system.now();
            sa.SchedStartTime =  system.now() -7;
            sa.SchedEndTime = system.now();
            sa.EarliestStartTime = system.now();
            sa.DueDate = system.now();
            lstOfSA.add(sa);
            
            ServiceAppointment sa1 = New ServiceAppointment();
            sa1.ParentRecordId  = acc1.id;
            sa1.ContactId= con.Id;
            sa1.Status = 'scheduled';
            sa1.WK_Services__c = 'Valet Trash';
            sa1.ActualEndTime = system.now();
            sa1.SchedStartTime =  system.now() -14;
            sa1.SchedEndTime = system.now();
            sa1.EarliestStartTime = system.now();
            sa1.DueDate = system.now();
            lstOfSA.add(sa1);
            
            ServiceAppointment sa2 = New ServiceAppointment();
            sa2.ParentRecordId  = acc1.id;
            sa2.ContactId= con.Id;
            sa2.Status = 'scheduled';
            sa2.WK_Services__c = 'Valet Trash';
            sa2.ActualEndTime = system.now();
            sa2.SchedStartTime =  system.now() -28;
            sa2.SchedEndTime = system.now();
            sa2.EarliestStartTime = system.now();
            sa2.DueDate = system.now();
            lstOfSA.add(sa2);
            
            ServiceAppointment sa3 = New ServiceAppointment();
            sa3.parentRecordId  = acc1.id;
            sa3.ContactId= con.Id;
            sa3.Status = 'scheduled';
            sa3.WK_Services__c = 'Valet Trash';
            sa3.ActualEndTime = system.now();
            sa3.SchedStartTime =  system.now() -32;
            sa3.SchedEndTime = system.now();
            sa3.EarliestStartTime = system.now();
            sa3.DueDate = system.now();
            lstOfSA.add(sa3);
            insert lstOfSA;
            
            List<Violation__c> vioList = new List<Violation__c>();
             Violation__c vio = new Violation__c();
             vio.WK_Service_Appointment__c=sa.Id;
             //vio.WK_Building__c=build.Id;
             vio.Unit__c='test';
             vio.Violation_Type__c='Other';
             vio.WK_Status__c='Approved';
             vio.WK_Add_Note__c ='Test';
             vioList.add(vio);
            
             
             
             Violation__c vio1 = new Violation__c();
             vio1.WK_Service_Appointment__c=sa.Id;
             //vio.WK_Building__c=build.Id;
             vio1.Unit__c='test';
             vio1.Violation_Type__c='Other';
             vio1.WK_Status__c='Approved';
             vio1.WK_Add_Note__c ='Test';
             vioList.add(vio1);
             datetime dt1 = system.now() - 90;
             
             
             Violation__c vio11 = new Violation__c();
             vio11.WK_Service_Appointment__c=sa.Id;
             //vio.WK_Building__c=build.Id;
             vio11.Unit__c='test';
             vio11.Violation_Type__c='Other';
             vio11.WK_Status__c='Approved';
             vio11.WK_Add_Note__c ='Test';
             vioList.add(vio11);
             //insert vio11;
             insert vioList;
             Test.setCreatedDate(vio.Id, DateTime.newInstance(2017,09,08));
             Test.setCreatedDate(vio1.Id, DateTime.newInstance(2017,08,31));
             Test.setCreatedDate(vio11.Id, DateTime.newInstance(2017,10,11));
             datetime dt11 = system.now() - 90;
             

            WK_RollupPicklist__c rlluppicklist = new WK_RollupPicklist__c();
            rlluppicklist.Name = '3 months';
            insert rlluppicklist;
            
            WK_RollupPicklist__c rlluppicklist1 = new WK_RollupPicklist__c();
            rlluppicklist1.Name = '4 weeks';
            insert rlluppicklist1;
            
            WK_RollupPicklist__c rlluppicklist2 = new WK_RollupPicklist__c();
            rlluppicklist2.Name = '6 months';
            insert rlluppicklist2;
            
               Pagereference prf = page.WK_RM_Rollup_Home;
               Test.setCurrentPage(prf);
                 
                       Test.startTest();
            WK_RM_Rollup_HomeController wkRm11 = new WK_RM_Rollup_HomeController();
            		   List<SelectOption> finalOptions = wkRm11.getRollupPicklist;
            
                       WK_RM_Rollup_HomeController wk = New WK_RM_Rollup_HomeController();
                       WK_RM_Rollup_HomeController.loggedInCon.add(portalAccountOwner1);
                       WK_RM_Rollup_HomeController.contactId= con.id;
                       WK_RM_Rollup_HomeController.accConJunctionList.add(acr1);
                       //WK_RM_Rollup_HomeController.accConJunctionList.add(acr1);
                       wk.accNameList.add(acc.Name);
                       wk.accIdList.add(acc.id);
                       wk.listOfViolationFor30Days.add(vio);
                       wk.listOfViolationFor30Days.add(vio1);
                       wk.listOfViolationFor30Days.add(vio11);
                       WK_RM_Rollup_HomeController.selectedLineSequence = '4 weeks';
                       WK_RM_Rollup_HomeController.selectedNOISequence = '3 months';
                       WK_RM_Rollup_HomeController.selectedNOISequence = '6 months';
                       WK_RM_Rollup_HomeController.selectedLineSequence = WK_ConstantUtility.threeMonthsString;
                       WK_RM_Rollup_HomeController.selectedLineSequence = WK_ConstantUtility.sixMonthsString;
                       
                       wk.mapaccVio30Count.put(acc1.id , 0);
                  //     WK_RM_Rollup_HomeController.selectedNOISequence = '3 months';
                       wk.listOfViolationFor30Days.add(vio1);
                       wk.pageLoadActionCall();
                       
                       //WK_RM_Rollup_HomeController.selectedNOISequence = '6 months';
                       //wk.pageLoadActionCall();
                       WK_RM_Rollup_HomeController.navigateToPages();
                       WK_RM_Rollup_HomeController.goToAccount();
                       wk.navigateToHomeOrRM('Regional Manager');
                       wk.navigateToHomeOrRM('Property Manager');
                       wk.navigateToHomeOrRM('');
                       //WK_RM_Rollup_HomeController.contactId= con.id;
                       //WK_RM_Rollup_HomeController.accConJunctionList.add(acr1);
                       
                       WK_RM_Rollup_HomeController.serviceContractlineItemMap.put(servCon.id , servCon);
                       wk.mapAccUnitNumber.put(acc.id , 1.0);
                       wk.runQuery();   
                       
                       WK_RM_Rollup_HomeController.ImpactAccountWrapper t = New WK_RM_Rollup_HomeController.ImpactAccountWrapper();
                       t.accId = acc.id;
                       t.accName = acc.Name;
                       t.incomeOpp = 1.0;
                       t.incomeValet = 1.0; 
                       
                       WK_RM_Rollup_HomeController.AccContDirectWrapper acw = New WK_RM_Rollup_HomeController.AccContDirectWrapper();
                       acw.accId = acc.id;
                       acw.accName = acc.Name;
                       acw.contName = con.LastName;
                       acw.contType = con.WK_Contact_Type__c;
                       acw.contPhone = Con.Phone;
                       
                       WK_RM_Rollup_HomeController.jsonWrapperForDonutGraph jwg = New WK_RM_Rollup_HomeController.jsonWrapperForDonutGraph();
                       jwg.accValues = 'Test';
                       jwg.numberOfRecs = 3;
                       wk.accwithContList.add(acc);
                       WK_RM_Rollup_HomeController.FirstTest f = New WK_RM_Rollup_HomeController.FirstTest();
                       f.CreateTest1();
                       WK_RM_Rollup_HomeController.FirstTest1 f1 = New WK_RM_Rollup_HomeController.FirstTest1();
                       f1.CreateTest1();
                       WK_RM_Rollup_HomeController.FirstTest2 f2 = New WK_RM_Rollup_HomeController.FirstTest2();
                       f2.CreateTest1();
                       WK_RM_Rollup_HomeController.FirstTest3 f3 = New WK_RM_Rollup_HomeController.FirstTest3();
                       f3.CreateTest1();
                       WK_RM_Rollup_HomeController.FirstTest4 f4 = New WK_RM_Rollup_HomeController.FirstTest4();
                       f4.CreateTest1();
                       WK_RM_Rollup_HomeController.FirstTest5 f5 = New WK_RM_Rollup_HomeController.FirstTest5();
                       f5.CreateTest1();
                       WK_RM_Rollup_HomeController.FirstTest6 f6 = New WK_RM_Rollup_HomeController.FirstTest6();
                       f6.CreateTest1();
                       WK_RM_Rollup_HomeController.FirstTest7 f7 = New WK_RM_Rollup_HomeController.FirstTest7();
                       f7.CreateTest1();
                       WK_RM_Rollup_HomeController.FirstTest8 f8 = New WK_RM_Rollup_HomeController.FirstTest8();
                       f8.CreateTest1();
                       
                       WK_RM_Rollup_HomeController.FirstTest9 f9 = New WK_RM_Rollup_HomeController.FirstTest9();
                       f9.CreateTest1();
                       WK_RM_Rollup_HomeController.FirstTest10 f10 = New WK_RM_Rollup_HomeController.FirstTest10();
                       f10.CreateTest1();
                       WK_RM_Rollup_HomeController.FirstTest11 f11 = New WK_RM_Rollup_HomeController.FirstTest11();
                       f11.CreateTest1();
                       WK_RM_Rollup_HomeController.FirstTest12 f12 = New WK_RM_Rollup_HomeController.FirstTest12();
                       f12.CreateTest1();
                       WK_RM_Rollup_HomeController.FirstTest13 f13 = New WK_RM_Rollup_HomeController.FirstTest13();
                       f13.CreateTest1();
                       WK_RM_Rollup_HomeController.FirstTest14 f14 = New WK_RM_Rollup_HomeController.FirstTest14();
                       f14.CreateTest1();
                       WK_RM_Rollup_HomeController.FirstTest15 f15 = New WK_RM_Rollup_HomeController.FirstTest15();
                       f15.CreateTest1();
                       WK_RM_Rollup_HomeController.FirstTest16 f16= New WK_RM_Rollup_HomeController.FirstTest16();
                       f16.CreateTest1();
                       WK_RM_Rollup_HomeController.FirstTest17 f17= New WK_RM_Rollup_HomeController.FirstTest17();
                       f17.CreateTest1();
                       WK_RM_Rollup_HomeController.FirstTest18 f18= New WK_RM_Rollup_HomeController.FirstTest18();
                       f18.CreateTest1();
                       WK_RM_Rollup_HomeController.FirstTest19 f19 = New WK_RM_Rollup_HomeController.FirstTest19();
                       f19.CreateTest1();
                       WK_RM_Rollup_HomeController.FirstTest20 f20 = New WK_RM_Rollup_HomeController.FirstTest20();
                       f20.CreateTest1();
                       WK_RM_Rollup_HomeController.FirstTest21 f21 = New WK_RM_Rollup_HomeController.FirstTest21();
                       f21.CreateTest1();
                       WK_RM_Rollup_HomeController.FirstTest22 f22= New WK_RM_Rollup_HomeController.FirstTest22();
                       f22.CreateTest1();
                       
                       WK_RM_Rollup_HomeController.SecondTest1 fs1 = New WK_RM_Rollup_HomeController.SecondTest1();
                       fs1.CreateTest1();
                       WK_RM_Rollup_HomeController.SecondTest2 fs2 = New WK_RM_Rollup_HomeController.SecondTest2();
                       fs2.CreateTest1();
                       WK_RM_Rollup_HomeController.SecondTest3 fs3 = New WK_RM_Rollup_HomeController.SecondTest3();
                       fs3.CreateTest1();
                       WK_RM_Rollup_HomeController.SecondTest4 fs4 = New WK_RM_Rollup_HomeController.SecondTest4();
                       fs4.CreateTest1();
                       WK_RM_Rollup_HomeController.SecondTest5 fs5 = New WK_RM_Rollup_HomeController.SecondTest5();
                       fs5.CreateTest1();
                       WK_RM_Rollup_HomeController.SecondTest6 fs6 = New WK_RM_Rollup_HomeController.SecondTest6();
                       fs6.CreateTest1();
                       WK_RM_Rollup_HomeController.SecondTest7 fs7 = New WK_RM_Rollup_HomeController.SecondTest7();
                       fs7.CreateTest1();
                       WK_RM_Rollup_HomeController.SecondTest8 fs8 = New WK_RM_Rollup_HomeController.SecondTest8();
                       fs8.CreateTest1();
                       WK_RM_Rollup_HomeController.SecondTest9 fs9 = New WK_RM_Rollup_HomeController.SecondTest9();
                       fs9.CreateTest1();
                       WK_RM_Rollup_HomeController.SecondTest10 fs10 = New WK_RM_Rollup_HomeController.SecondTest10();
                       fs10.CreateTest1();
                       WK_RM_Rollup_HomeController.SecondTest11 fs11 = New WK_RM_Rollup_HomeController.SecondTest11();
                       fs11.CreateTest1();
                       WK_RM_Rollup_HomeController.SecondTest12 fs12 = New WK_RM_Rollup_HomeController.SecondTest12();
                       fs12.CreateTest1();
                       WK_RM_Rollup_HomeController.SecondTest13 fs13 = New WK_RM_Rollup_HomeController.SecondTest13();
                       fs13.CreateTest1();
                       WK_RM_Rollup_HomeController.SecondTest14 fs14 = New WK_RM_Rollup_HomeController.SecondTest14();
                       fs14.CreateTest1();
                       WK_RM_Rollup_HomeController.SecondTest15 fs15 = New WK_RM_Rollup_HomeController.SecondTest15();
                       fs15.CreateTest1();
                       WK_RM_Rollup_HomeController.SecondTest16 fs16 = New WK_RM_Rollup_HomeController.SecondTest16();
                       fs16.CreateTest1();
                       WK_RM_Rollup_HomeController.SecondTest17 fs17 = New WK_RM_Rollup_HomeController.SecondTest17();
                       fs17.CreateTest1();
            		   WK_RM_Rollup_HomeController.SecondTest18 fs18 = New WK_RM_Rollup_HomeController.SecondTest18();
	            fs18.CreateTest1();
	            WK_RM_Rollup_HomeController.SecondTest19 fs19 = New WK_RM_Rollup_HomeController.SecondTest19();
	            fs19.CreateTest1();
	            WK_RM_Rollup_HomeController.SecondTest20 fs20 = New WK_RM_Rollup_HomeController.SecondTest20();
	            fs20.CreateTest1();
	            WK_RM_Rollup_HomeController.SecondTest21 fs21 = New WK_RM_Rollup_HomeController.SecondTest21();
	            fs21.CreateTest1();
	            WK_RM_Rollup_HomeController.SecondTest22 fs22 = New WK_RM_Rollup_HomeController.SecondTest22();
	            fs22.CreateTest1();
	            WK_RM_Rollup_HomeController.SecondTest23 fs23 = New WK_RM_Rollup_HomeController.SecondTest23();
	            fs23.CreateTest1();
                    Test.stopTest();    
        }
           
    }



}