public with sharing class DynamicSOQLQueries {
    /** 8. Dynamic SOQL
     * This method demonstrates the use of dynamic SOQL to query Account records 
     * where the BillingCountry is 'USA'. It uses a dynamic query string and 
     * executes the query using Database.query().
     * 
     * Dynamic SOQL allows you to build and execute a query as a string at runtime,
     * which is useful when the query conditions are variable or not known at compile time.
     */
    public static void logAccountsInUSA() {
        String queryString = 'SELECT Id, Name FROM Account WHERE BillingCountry = \'USA\'';
        System.debug(queryString);
        List<Account> usAccounts = Database.query(queryString);
        if (usAccounts.isEmpty()) {
            System.debug('No Accounts found in USA.');
            return;
        }
        
        for (Account acc : usAccounts) {
            // Log the Id and Name of each Account
            System.debug('Account Id: ' + acc.Id + ' | Account Name: ' + acc.Name);
        }
    }

    /**
     * This method demonstrates how to dynamically query the Account object.
     * The query is constructed based on input criteria for Country and selected fields.
     */
    public static void logAccounts(String country, List<String> fields) {
        String fieldList = String.join(fields, ', ');
        String queryString = 'SELECT ' + fieldList + ' FROM Account WHERE BillingCountry = :country';        
        List<Account> accounts = Database.query(queryString);
        
        if (accounts.isEmpty()) {
            System.debug('No Accounts found in ' + country);
            return;
        }
        
        for (Account acc : accounts) {
            System.debug('Account Id: ' + acc.Id + ' | Account Name: ' + acc.Name);
        }
    }

    /**
 * This method dynamically constructs and executes a SOQL query based on the provided parameters.
 * 
 * @param sObjectName  The name of the sObject to query (e.g., 'Account').
 * @param whereClause  The WHERE clause condition for filtering records (e.g., 'BillingCountry = \'USA\'').
 * @param fields       A list of field names to include in the SELECT clause of the SOQL query (e.g., ['Id', 'Name', 'Industry']).
 * @param limitValue      The number of records to retrieve (e.g., 10).
 * 
 * This method uses dynamic SOQL to query the sObject and log the results to the debug log. If no records
 * are found, it will log a message indicating that no records matched the query.
 */
    public static void logRecords(String sObjectName, String whereClause, List<String> fields, Integer limitValue) {
        String fieldList = String.join(fields, ', ');
        String queryString = 'SELECT ' + fieldList + ' FROM ' + sObjectName ;

        if (String.isNotEmpty(whereClause)) {
            queryString += ' WHERE ' + whereClause;
        }

        if (limitValue != null && limitValue > 0 && limitValue != 1) {
            queryString += ' LIMIT ' + String.valueOf(limitValue);
        }
    
        List<SObject> records = Database.query(queryString);
        if (records.isEmpty()) {
            System.debug('No records found for ' + sObjectName + ' with condition: ' + whereClause);
            return;
        }
        
        // for (SObject record : records) {
        //     String recordDetails = '';
            
        //     for (String field : fields) {
        //         recordDetails += field + ': ' + record.get(field) + ' | ';
        //     }
            
        //     System.debug(recordDetails);
        // }

        for(SObject record : records) {
            Map<String, Object> recordDetailsMap = new Map<String, Object>();
            for(String field : fields) {
                if(recordDetailsMap.containsKey(field)){
                    return ;
                }else {
                    recordDetailsMap.put(field , record.get(field));
                }
            }

            String recordDetails = String.join(recordDetailsMap.keySet(), ' | ') + ': ' + String.join(recordDetailsMap.values(), ' | ');
            System.debug(recordDetails);
        }
    }
}