

start () {
  read -p "Please Enter a Scratch Org name (Alias) that you recently created : " SCRATCH_ORG_NAME
  echo "Starting generation of test data on scratch org, $SCRATCH_ORG_NAME. It will take sometime."
	
	createScratchOrgAndSetup
	generateAccounts
	generateContacts
    importCovidDatasetIntoSf
    mapAccoutnsWithContacts
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
	sfdx force:org:create -f config/project-scratch-def.json -s -d 7 -w 60 -a scratchAnlyTxHack

	#Assign Analytics view only permset to user
	sfdx force:user:permset:assign -n AnalyticsViewOnlyUser

	#Setup some extra users
	#Doing this prior to installing package so that this user can also have 
	#access to that package
	sfdx force:apex:execute -f config/setupUsers.apex

	#Sample: https://github.com/skipsauls/eadx
	#Install package
	sfdx force:package:install  -s AllUsers -p 04t5w000005ubuw -w 20

	#Create dashboard from template
	sfdx force:apex:execute -f config/setup.apex

	# push the contents of this repo into the scratch org
	#sfdx force:source:push

	#open the org
	sfdx force:org:open
}

#Generate the Test Accounts

generateAccounts(){
sfdx force:data:bulk:upsert -s Account -f ./data/Account.csv -i Id -u $SCRATCH_ORG_NAME
}

generateContacts(){
sfdx force:data:bulk:upsert -s opportunity -f ./data/Opportunity.csv -i Id -u $SCRATCH_ORG_NAME
}

importCovidDatasetIntoSf(){
sfdx force:data:bulk:upsert -s AnlyTxHack__Covid19WHOStats__c  -f ./data/Covid19WHOData.csv -i Id -u $SCRATCH_ORG_NAME
}

mapAccoutnsWithContacts(){
sfdx force:apex:execute -f config/dataload.apex
}