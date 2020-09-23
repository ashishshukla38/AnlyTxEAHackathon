Map<id,Id> mapAccount =  new map<id,id>();
for(Account acc:[SELECT id, AnlyTxHack__Account_External_Id__c from account ])
{
    mapAccount.put(acc.AnlyTxHack__Account_External_Id__c,acc.id);
}
 
List<opportunity> lstOpportunity = [SELECT id, AnlyTxHack__ExternalAccountId__c, Accountid from Opportunity ];
for(opportunity opp: lstOpportunity)
{
    if(opp.AnlyTxHack__ExternalAccountId__c != null && mapAccount.containsKey(opp.AnlyTxHack__ExternalAccountId__c))
    opp.accountId = mapAccount.get(opp.AnlyTxHack__ExternalAccountId__c);
}
Update lstOpportunity;