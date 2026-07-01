@isTest
private class InspectionServiceTest {

    @isTest
    static void statusInInspectionCreate(){
        
        //Arrage

        Customer__c customer = new Customer__c(
            Name = 'name'
        );

        insert customer;

        Inspector__c inspector = new Inspector__c(
            Name = 'name',
            Salesforce_User__c = UserInfo.getUserId()
        );

        insert inspector;

        Inspection__c inspection = new Inspection__c(
            Customer__c = customer.Id,
            Inspector__c = inspector.Id,
            Inspection_Date__c = Date.today().addDays(1)
            );        
        
        //Act
        Test.startTest();
            
            insert inspection;
    
        Test.stopTest();
    
        
        //Assert
        Inspection__c ins = [
            SELECT Id, Status__c, Inspection_Date__c, Inspector__c
            FROM Inspection__c
            WHERE Id = :inspection.Id
        ];
    
        System.assertEquals(
            'Pending',
            ins.Status__c,
            'La cuenta no puede tener el Status in blanck'
        );
    }

    @isTest
    static void taskCreatedWhenCreateInspection(){
        //Arrage
        Customer__c customer = new Customer__c(
            Name = 'name'
        );
        insert customer;

        Inspector__c inspector = new Inspector__c(
            Name = 'name',
            Salesforce_User__c = UserInfo.getUserId()
        );
        insert inspector;

        Inspection__c inspection = new Inspection__c(
            Name = 'Inspection test',
            Customer__c = customer.Id,
            Inspector__c = inspector.Id,
            Inspection_Date__c = Date.today().addDays(1)
        );
        

        //Acc
        Test.startTest();
         insert inspection;
        Test.stopTest();

        //Assert
        List<Task> tasks = [
            SELECT Id, Subject, WhatId, OwnerId, ActivityDate
            FROM Task
            WHERE WhatId = :inspection.Id
        ];

        System.assertEquals(
            1,
            tasks.size(),
            'Debe crearse una tarea cuando cambia el inspector.'
        );
        System.assertEquals(
            inspection.Id,
            tasks[0].WhatId,
            'No se creo en la inspeccion correcta'
        );

        System.assertEquals(
           inspector.Salesforce_User__c,
            tasks[0].OwnerId
        );

        System.assertEquals(
           inspection.Inspection_Date__c,
            tasks[0].ActivityDate
        );  
    }

    @isTest
    static void failedDateInInspectionCreate(){
        //Arrage
        Customer__c customer = new Customer__c(
            Name = 'name'
        );

        insert customer;

        Inspector__c inspector = new Inspector__c(
            Name = 'name',
            Salesforce_User__c = UserInfo.getUserId()
        );

        insert inspector;

        Inspection__c inspection = new Inspection__c(
            Name = 'Inspection test',
            Customer__c = customer.Id,
            Inspector__c = inspector.Id,
            Inspection_Date__c = Date.today().addDays(-1)
        );
    
        //Acc
        Test.startTest();
        
        try{
            insert inspection;
            System.assert(false, 'Debio lanzar una excepcion');
        } catch (DmlException e) {
            System.assert(
                e.getMessage().contains('menor a hoy'),
                e.getMessage()
            );
        }
        Test.stopTest();
    }

    @isTest
    static void taskCreatedWhenInspectorChange() {
          
        //Arrage
        Customer__c customer = new Customer__c(
            Name = 'name'
        );
        insert customer;

        Inspector__c inspectorA = new Inspector__c(
            Name = 'name A',
            Salesforce_User__c = UserInfo.getUserId()

        );
        insert inspectorA;

        Inspector__c inspectorB = new Inspector__c(
            Name = 'name B',
            Salesforce_User__c = UserInfo.getUserId()
        );
        insert inspectorB;

        Inspection__c inspection = new Inspection__c(
            Name = 'Inspection test',
            Customer__c = customer.Id,
            Inspector__c = inspectorA.Id,
            Inspection_Date__c = Date.today().addDays(1)
        );
        insert inspection;

        //Act
        Test.startTest();

        inspection.Inspector__c = inspectorB.Id;
        update inspection;

        Test.stopTest();

        //Assert
        List<Task> tasks =[
            SELECT Id, Subject, WhatId, OwnerId
            FROM Task
            WHERE WhatId = :inspection.Id
            AND Subject = 'Cambio de inspector en inspeccion'
        ];

        System.assertEquals(
            1,
            tasks.size(),
            'Debe crearse una tarea cuando cambia el inspector.'
        );

        System.assertEquals(
        inspectorB.Salesforce_User__c,
        tasks[0].OwnerId,
        'La tarea debe asignarse al nuevo inspector'
        );
    }

    @isTest
    static void bulkInspectionInsertCreatesTasks() {

        // Arrange
        Customer__c customer = new Customer__c(
            Name = 'Bulk Customer'
        );
        insert customer;

        Inspector__c inspector = new Inspector__c(
            Name = 'Bulk Inspector',
            Salesforce_User__c = UserInfo.getUserId()
        );
        insert inspector;

        List<Inspection__c> inspections = new List<Inspection__c>();

        for (Integer i = 0; i < 10; i++) {
            inspections.add(new Inspection__c(
                Name = 'Inspection ' + i,
                Customer__c = customer.Id,
                Inspector__c = inspector.Id,
                Inspection_Date__c = Date.today().addDays(1)
            ));
        }

        // Act
        Test.startTest();
        insert inspections;
        Test.stopTest();

        // Assert
        List<Task> tasks = [
            SELECT Id, WhatId
            FROM Task
            WHERE WhatId IN :inspections
        ];

        System.assertEquals(
            inspections.size(),
            tasks.size(),
            'Debe crearse una tarea por cada inspección insertada.'
        );
    }
    @isTest
    static void bulkInspectionInsert (){
        //Arrage 
        Customer__c customer = new Customer__c(
            Name = 'Bulk Customer'
        );
        insert customer;

        Inspector__c inspector = new Inspector__c(
            Name = 'Bulk Inspector',
            Salesforce_User__c = UserInfo.getUserId()
        );
        insert inspector;

        List<Inspection__c> inspections = new List<Inspection__c>();

        for(Integer i = 0; i < 10; i++){
            inspections.add(new Inspection__c(
                Name = 'Bulk Inspection',
                Customer__c = customer.Id,
                Inspector__c = inspector.Id,
                Inspection_Date__c = Date.today().addDays(1)

            ));
        }

        Test.startTest();
        insert inspections;
        Test.stopTest();

        List<Task> task = [
            SELECT id, WhatId
            FROM Task
            WHERE WhatId IN :inspections
        ];
        
        System.assertEquals(
            10, 
            task.size(), 
            'Debe crear una tarea por cada inspeccion en bulk insert'
            );

    }

}