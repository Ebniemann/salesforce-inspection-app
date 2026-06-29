public with sharing class InspectionService {

    public static void beforeInsert(List <Inspection__c> newList){

        for(Inspection__c ins : newList){
            System.debug('Fecha inspección: ' + ins.Inspection_Date__c);
            System.debug('Hoy: ' + Date.today());
            System.debug('Es menor: ' + (ins.Inspection_Date__c < Date.today()));
            if(String.isBlank(ins.Status__c)){
                ins.Status__c = 'Pending';
            }
            if(
                ins.Inspection_Date__c != null &&
                ins.Inspection_Date__c < Date.today()
              ){
                ins.addError('la fecha de inspección no puede ser menor a hoy');
            }
        }
    }

    //Metodo que obtiene los inspectores asociados a los IDs recibidos. 
    private static Map<Id, Inspector__c> getInspector(Set<Id> inspectorIds){
        if(inspectorIds == null || inspectorIds.isEmpty()){
            return new Map<Id, Inspector__c>();
        }
            return new Map<Id, Inspector__c>(
                [
                    SELECT Id, Salesforce_User__c
                    FROM Inspector__c
                    WHERE Id IN :inspectorIds
                ]
            );    
    }

    public static void afterInsert(List<Inspection__c> newList){

        List <Task> tasks = new List <Task>();
       
        Set<Id> inspectorIds = new Set<Id>();

        for( Inspection__c ins : newList){
            if(ins.Inspector__c != null){
                inspectorIds.add(ins.Inspector__c);
            }
        }
       
        Map<Id, Inspector__c> inspectorMap = getInspector(inspectorIds);

        for( Inspection__c ins : newList){

            Inspector__c inspect = inspectorMap.get(ins.Inspector__c);
            if(inspect == null || inspect.Salesforce_User__c == null){
              continue;
            }

            Task t = new Task(
                WhatId = ins.Id,
                OwnerId = inspect.Salesforce_User__c,
                Subject = 'Nueva inspección asignada',
                ActivityDate = ins.Inspection_Date__c
            );
         tasks.add(t);
        }

        if(!tasks.isEmpty()){
            insert tasks;
        }
    }

    public static void afterUpdate(List<Inspection__c> newList, Map<Id, Inspection__c> oldMap){
        
        Set<Id> inspectorIds = new Set<Id>(); // 

        for(Inspection__c ins : newList){
            if(ins.Inspector__c != null){
                inspectorIds.add(ins.Inspector__c);
            }
        }

        Map<Id, Inspector__c> inspectorMap = getInspector(inspectorIds);

        List <Task> tasks = new List <Task>();
       
        List<Inspection_Audit__c> audits = new List<Inspection_Audit__c>();

        for(Inspection__c ins : newList){
           
            Inspection__c oldInsp = oldMap.get(ins.Id);

            if( oldInsp != null && ins.Inspector__c != oldInsp.Inspector__c){
                
                Inspector__c inspect = inspectorMap.get(ins.Inspector__c);
                if(inspect == null ){
                    continue;
                  }

                Task t = new Task(
                    WhatId = ins.Id,
                    OwnerId = inspect.Salesforce_User__c,
                    Subject = 'Cambio de inspector en inspeccion',
                    ActivityDate = ins.Inspection_Date__c
                );
                tasks.add(t);

                Inspection_Audit__c audit = new Inspection_Audit__c(
                    Inspection__c = ins.Id,
                    Old_Inspector__c = oldInsp.Inspector__c,
                    New_Inspector__c = ins.Inspector__c,
                    Change_Date__c = System.now()
                );
                 audits.add(audit);
            }     
        }

        if(!tasks.isEmpty()){
            insert tasks;
        }

        if(!audits.isEmpty()){
            insert audits;
        }
    }

    // public static void createAudit(List<Inspection__c> newList, Map<Id, Inspection__c> oldMap){
    //     List<Inspection_Audit__c> audits = new List<Inspection_Audit__c>();

    //     for(Inspection__c ins : newList){
            
    //         Inspection__c oldIns = oldMap.get(ins.Id);
            
    //         if(oldIns != null && ins.Inspector__c != oldIns.Inspector__c){
                
    //             Inspection_Audit__c audit = new Inspection_Audit__c(
    //                 Inspection__c = ins.Id,
    //                 Old_Inspector__c = oldIns.Inspector__c,
    //                 New_Inspector__c = ins.Inspector__c,
    //                 Change_Date__c = System.now()
    //             );
    //             audits.add(audit);
    //         }
    //     }

    //     if(!audits.isEmpty()){
    //         insert audits;
    //     }
    //  }
}