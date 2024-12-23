public with sharing class MetroTravelAppController {
    /**
     * Fetches travel logs where Calculated_Fare__c is greater than 0.
     * It retrieves the related records like Customer, Metro Card, Source Station, and Destination Station.
     * 
     * @returns List<Travel_Log__c> - A list of Travel_Log__c records with related fields like Customer, Metro Card, and Station Names.
     * @throws AuraHandledException - Throws a custom error message if there's an issue with the query.
     */
    @AuraEnabled(cacheable=true)
    public static List<Travel_Log__c> getTravelLogs() {
        try {
            return [ SELECT Id, Name, Customer__r.Name,Metro_Card__r.Name,Metro_Station__r.Name, Destination_Station__r.Name, Travel_Date_Time__c, Calculated_Fare__c FROM Travel_Log__c WHERE Calculated_Fare__c > 0 ORDER BY Travel_Date_Time__c DESC];
        }catch(Exception e) {
            throw new AuraHandledException('An error occurred while fetching travel logs. Please try again later.');
        }
    }

    /**
     * Method to test serialization and deserialization in Developer Console.
     */
    public static void testSerializationAndDeserialization() {
        try {
            List<Travel_Log__c> travelLogs = [SELECT Id, Name, Customer__r.Name, Metro_Card__r.Name
                                              FROM Travel_Log__c 
                                              WHERE Calculated_Fare__c > 0 
                                              ORDER BY Travel_Date_Time__c DESC];

            String serializedData = JSON.serialize(travelLogs);

            List<Travel_Log__c> deserializedLogs = (List<Travel_Log__c>) JSON.deserialize(serializedData, List<Travel_Log__c>.class);

            System.debug('Serialized Data: ' + serializedData);
            System.debug('Deserialized Data: ' + deserializedLogs);
        } catch (Exception e) {
            System.debug('Error: ' + e.getMessage());
        }
    }

      /**
     * Deletes travel logs based on the provided list of log IDs.
     * 
     * @param logIds List<Id> - A list of Travel_Log__c record IDs to be deleted.
     * @throws AuraHandledException - Throws a custom error message if there was an issue with the delete operation.
     */
    @AuraEnabled
    public static void deleteTravelLogs(List<Id> logIds) {
        try{
            if (logIds != null && !logIds.isEmpty()) {
                delete [SELECT Id FROM Travel_Log__c WHERE Id IN :logIds];
            }
        }catch(Exception e) {
            System.debug('Error in deleteTravelLogs: ' + e.getMessage());
            throw new AuraHandledException('An error occurred while deleting the selected travel logs. Please try again later.');
        }
    }
}