Map<id,Id> mapAccount =  new map<id,id>();
for(Account acc:[SELECT id, AnlyTxHack__Account_External_Id__c from account ])
{
    mapAccount.put(acc.AnlyTxHack__Account_External_Id__c,acc.id);
}

// If Opportunity + case records exceed 10K DML rows, then run two commands sepertely.
// Map Opportunities with the Account by External Id 
List<opportunity> lstOpportunity = [SELECT id, AnlyTxHack__ExternalAccountId__c, Accountid from Opportunity ];
for(opportunity opp: lstOpportunity)
{
    if(opp.AnlyTxHack__ExternalAccountId__c != null && mapAccount.containsKey(opp.AnlyTxHack__ExternalAccountId__c))
    opp.AccountId = mapAccount.get(opp.AnlyTxHack__ExternalAccountId__c);
}
Update lstOpportunity;

// Map Cases with the Account by External Id
List<Case> lstCases = [SELECT AnlyTxHack__Account_External_Id__c, AccountId FROM Case];
for(Case caseToIterate: lstCases)
{
    if(caseToIterate.AnlyTxHack__Account_External_Id__c != null && mapAccount.ContainsKey(caseToIterate.AnlyTxHack__Account_External_Id__c))
    {
        caseToIterate.AccountId = mapAccount.get(caseToIterate.AnlyTxHack__Account_External_Id__c);
    }
}
UPDATE lstCases;