trigger InspectionTrigger on Inspection__c (
    before insert,
    after insert,
    before update,
    after update
) {
    InspectionHandler.handle(
        Trigger.new,
        Trigger.oldMap
    );
}