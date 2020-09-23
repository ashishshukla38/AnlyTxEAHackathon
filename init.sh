
# Change the variabls to set Scratch org configuration like  
# Package Id, Scrath Org Alias and Validity of Scratch org.
SCRATCH_ORG_ALIAS = 'scratchAnlyTxHack'
PACKAGE_ID = '04t5w000005ubuw'
SCRATCH_ORG_DURATION = 7

start () {	
	#Generate Scratch org, Setup users, Assign permission set & Open Org.
	createScratchOrgAndSetup

	# Generate 1000+ Account records from the CSV available in Data folder.
	generateAccounts
	
	# Generate 1900+ Opportunity records from CSV avalable in Data folder
	generateOpportunity

	# Generate 1600+ Cases recrods from CSV available in Data Folder.
	generateSampleCases

	# Generate the Covid 19 data.
    importCovidDatasetIntoSf
	
	# Map Account objects with child cases and opportunities
	# As the data is large JSON file with more records doesn't work. 
	# For less records you can export Account and child data by using below command
	# sfdx force:data:tree:export -q "SELECT Id, Name, Type, Industry, NumberOfEmployees, Sic, BillingCountry, (Select Id, AccountId, Amount, CloseDate, Company_Size__c, Description, ExpectedRevenue, Industry_Type__c, LeadSource, Name, Opportunity_Source__c, Region__c, StageName, Type,Country__c FROM Opportunities),(SELECT Id, Priority, CaseNumber, Case_ExternalId__c, ClosedDate, CSAT__c, Origin, Product_Family_KB__c, Reason, SLAViolation__c,SLA_Type__c,Status,Subject FROM CASES) FROM Account "
	# For less recods you can import by using JSON 
	# sfdx force:data:tree:import -f Account-Opportunity-Cases.json -u <Your username>
	
	# As our example has more records, we are imprting through bulk api  (CSV) and then mapping the data.
	mapAccoutnsWithChildObjects

  echo "Press any key to exit the script"
  while [ true ] ; do
  read -t 3 -n 1
  if [ $? = 0 ] ; then
  exit ;
  else
  echo "waiting for the keypress"
  fi
  done
}

createScratchOrgAndSetup()
{
	# create scratch org
	sfdx force:org:create -f config/project-scratch-def.json -s -d $SCRATCH_ORG_DURATION  -w 60 -a SCRATCH_ORG_ALIAS

	#Assign Analytics view only permset to user
	sfdx force:user:permset:assign -n AnalyticsViewOnlyUser

	#Setup some extra users
	#Doing this prior to installing package so that this user can also have 
	#access to that package
	sfdx force:apex:execute -f config/setupUsers.apex

	#Sample: https://github.com/skipsauls/eadx
	#Install package
	sfdx force:package:install  -s AllUsers -p $PACKAGE_ID -w 20

	#Create dashboard from template
	sfdx force:apex:execute -f config/setup.apex

	# push the contents of this repo into the scratch org
	#sfdx force:source:push

	#open the org
	sfdx force:org:open
}

#Generate the Test Accounts

generateAccounts(){
sfdx force:data:bulk:upsert -s Account -f ./data/Account.csv -i Id -u $SCRATCH_ORG_ALIAS
}

generateOpportunity(){
sfdx force:data:bulk:upsert -s opportunity -f ./data/Opportunity.csv -i Id -u $SCRATCH_ORG_ALIAS
}

importCovidDatasetIntoSf(){
sfdx force:data:bulk:upsert -s AnlyTxHack__Covid19WHOStats__c  -f ./data/Covid19WHOData.csv -i Id -u $SCRATCH_ORG_ALIAS
}

generateSampleCases(){
  sfdx force:data:bulk:upsert -s Case  -f ./data/Case.csv -i Id -u $SCRATCH_ORG_ALIAS
}

mapAccoutnsWithChildObjects(){
sfdx force:apex:execute -f config/dataload.apex
}