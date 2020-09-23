

sfdx force:data:bulk:upsert -s Account -f ./data/Account.csv -i Id -u One2020
sfdx force:data:bulk:upsert -s opportunity -f ./data/Opportunity.csv -i Id -u One2020

sfdx force:data:bulk:upsert -s AnlyTxHack__Covid19WHOStats__c  -f ./data/Covid19WHOData.csv -i Id -u EA1Final1
sfdx force:apex:execute -f config/dataload.apex