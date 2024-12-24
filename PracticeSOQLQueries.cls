public with sharing class PracticeSOQLQueries {

    //Basic Query on Account
    public static void executeQuery() {
        for (Account acc : [SELECT Id, Name, Industry FROM Account LIMIT 10]) {
            System.debug(acc);
        }
    }

       /**
     * Retrieves a list of accounts based on the specified industry.
     * 
     * @param industry The industry to filter accounts by (e.g., 'Technology').
     * @return A list of Account records containing the Id and Name fields.
     */
    public static List<Account> getAccountsByIndustry(String industry) {
        List<Account> accountsByIndustry = [SELECT Id, Name FROM Account WHERE Industry = :industry];
        System.debug('Accounts in ' + industry + ' Industry: ' + accountsByIndustry);
        return accountsByIndustry;
    }

      /**
     * Retrieves a list of contacts where the first name starts with 'A'
     * and the last name is not null.
     * 
     * @return A list of Contact records containing the Id, FirstName, and LastName fields.
     */
    public static List<Contact> getContactsStartingWithA() {
        List<Contact> contacts = [SELECT Id, FirstName, LastName 
                                  FROM Contact 
                                  WHERE FirstName LIKE 'A%' 
                                  AND LastName != NULL];
        System.debug('Contacts with A% FirstName and non-null LastName: ' + contacts);
        return contacts;
    }

    /**
     * Relationship Query (Child-to-Parent)
     * Retrieves a list of contacts along with their account names 
     * where the account's industry is 'Banking'.
     * 
     * @return A list of Contact records containing Id, FirstName, LastName, and Account.Name fields.
     */
    public static List<Contact> getContactsWithAccountInBankingIndustry() {
        List<Contact> contactsWithAccount = [SELECT Id, FirstName, LastName, Account.Name 
                                             FROM Contact 
                                             WHERE Account.Industry = 'Technology'];
        
        System.debug('Contacts with their Account Name: ' + contactsWithAccount);
        return contactsWithAccount;
    }

    /**
     * Relationship Query (Parent-to-Child)
     * Retrieves a list of accounts along with their related contacts
     * 
     * @return A list of Account records, each containing a related Contacts subquery with Id, FirstName, and LastName.
     */
    public static List<Account> getAccountsWithContacts() {
        List<Account> accountsWithContacts = [SELECT Id, Name, 
                                             (SELECT Id, FirstName, LastName FROM Contacts) 
                                             FROM Account LIMIT 10];
        
                for (Account acc : accountsWithContacts) {
                System.debug('Account Name: ' + acc.Name + ' | Account Id: ' + acc.Id);
                
                if (acc.Contacts != null && !acc.Contacts.isEmpty()) {
                    for (Contact con : acc.Contacts) {
                        System.debug('Contact Name: ' + con.FirstName + ' ' + con.LastName + 
                                        ' | Contact Id: ' + con.Id);
                    }
                } else {
                    System.debug('No contacts associated with this account.');
                }
            }
        return accountsWithContacts;
    }

 
        /**
         * Aggregate Query
         * Retrieves the count of Account records grouped by their Industry and logs the results.
         * 
         * This method performs an aggregate query on the Account object to count the number of Accounts
         * in each Industry and logs the Industry with its corresponding count.
         */
        public static void logIndustryCounts() {
            AggregateResult[] industryCounts = [SELECT Industry, COUNT(Id) 
                                                 FROM Account 
                                                 GROUP BY Industry];
            System.debug(industryCounts);
            if (industryCounts.isEmpty()) {
                System.debug('No accounts found.');
                return;
            }
    
            for (AggregateResult result : industryCounts) {
                String industry = (String)result.get('Industry');
                Integer count = (Integer)result.get('expr0');
                System.debug('Industry: ' + industry + ' | Account Count: ' + count);
            }
        }

        /**
         * Query on Opportunities
     * Retrieves all Opportunity records where the StageName is 'Closed Won' 
     * and logs the Opportunity details (Id, Name, Stage, Amount).
     * 
     * This method runs a SOQL query to fetch Opportunities that have been 
     * closed successfully ('Closed Won' stage) and logs the relevant details 
     * of these Opportunities.
     */
    public static void logClosedWonOpportunities() {
        List<Opportunity> opportunities = [SELECT Id, Name, StageName, Amount 
                                          FROM Opportunity 
                                          WHERE StageName = 'Closed Won'];
        
        if (opportunities.isEmpty()) {
            System.debug('No Closed Won Opportunities found.');
            return;
        }

        for (Opportunity opp : opportunities) {
            System.debug('Opportunity Id: ' + opp.Id + 
                         ' | Name: ' + opp.Name + 
                         ' | Stage: ' + opp.StageName + 
                         ' | Amount: ' + opp.Amount);
        }
    }

}