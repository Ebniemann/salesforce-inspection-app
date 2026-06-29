public with sharing class InspectionHandler {

    public static void handle(
        List<Inspection__c> newList,
        Map<Id, Inspection__c> oldMap
    ) {
    
        if (Trigger.isBefore && Trigger.isInsert) {
            InspectionService.beforeInsert(newList);
        }
    
        if (Trigger.isAfter && Trigger.isInsert) {
            InspectionService.afterInsert(newList);
        }
    
        if (Trigger.isAfter && Trigger.isUpdate) {
            InspectionService.afterUpdate(newList, oldMap);
            InspectionService.createAudit(newList, oldMap);
        }
    }
    
}