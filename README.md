# Setting up the AnlyTx - Einstein Analytics App

This guide helps people to understand how "AnlyTxEaHackathon" Einstein Analytics package/template can be setup and enhanced.

## Pre-requisite:
1. User should have an Winter'21 Dev-Hub org. [Winter'21 Pre-release org](https://www.salesforce.com/form/signup/prerelease-winter21/)
2. If the user is going with below Option 1, then the Salesforce CLI along with VS Code should be installed in your system. If not installed, then follow instructions given in the [Set Up Your Workspace and Install Developer Tools](https://trailhead.salesforce.com/content/learn/projects/quickstart-vscode-salesforce/vscode-salesforce-ready?trail_id=set-up-your-workspace-and-install-developer-tools) trailhead.
3. DevHub org generted from Winter21 pre-relese. If you don't have this generate it from here https://www.salesforce.com/form/signup/prerelease-winter21/

## How to setup org with this project? 

### Option 1(Recommended for testing on scratch org) - For installation using VS code on scratch org.
1. [Download repo](https://github.com/ashishshukla38/AnlyTxEAHackathon/archive/master.zip) or Clone this repo locally: -- git clone https://github.com/ashishshukla38/AnlyTxEAHackathon.git 
2. Open AnlyTxEAHackathon folder inside VS Code and set the current user as Dev hub user (Winter 21 pre-release org)
3. Run orgInit.sh -- ./orgInit.sh  
    This shell file will create an scratch org, will install AnlyTx app and open the newly created org in new browser tab.
        
### Option 2(Not recommended for testing) - For direct installation on EADL enabled org. Here you may need to perform some manual steps.
1. Open [package link](https://login.salesforce.com/packaging/installPackage.apexp?p0=04tB0000000cylW) in browser.
2. Login with the EADL enabled org credentials.



## Post-install steps
After successfully installing the package, user needs to perform following steps in order to make use of awesome Analytics dashboards.
1. Go to Setup -> Search and click on  Lightning App Builder menu. 
2. Click on New button -> Select App page -> Click on Next -> Enter Label for App Page -> Click on Next -> Select One Region from Left side bar -> Click on Finish.
3. From the left-side drag and drop Einstein Analytics Dashboard to middle component.
4. Click on the newly added Einstein Dashboard -> Select the appropriate wave dashboard and set the component height and click on Save button and later click on Activate button.
5. Go to Setup -> Search and click on Tabs -> Click on New button to create New Lightning Page Tab -> On the new screen, select newly created Lightning app page from drop-down and enter appropriate Label, Name and click on Next -> Select the appropriate profiles that needs to have access to the newly created tabs and click on Save button.
6. Open any app where you want to add the awesome analytics dashboards -> Click on the pencil icon below at top right side -> Click on Add more items -> Click on All -> Select Newly created tab -> Click on Add Nav Item -> click on Save button.
  ![alt text](https://github.com/ashishshukla38/AnlyTxEAHackathon/blob/master/ReadMdImages/Page%20setup.png) 

## Developer specific guidelines: 

1. Init.sh file - will perform the following operations in the background: 

        1. It will create the scratch org. 
    
        2. Assign the Analytics view only permission set to the user. 
    
        3. Create a standard user with Analytics view only Permission set prior to installing the package so that the newly created user will also have access to the package. 
    
        4. Install the package. 
    
        5. Create dashboard from template. 
    
        6. Open the newly created org in the browser. 
    
        7.Generate sample 1000 records of Account, Contact and Opportunities. 
    
2.Data folder – Data folder will contain the CSV data of Account, Case, Opportunity and Covid19. 
To get latest data for Covid use below URL:
https://covid19.who.int/WHO-COVID-19-global-data.csv

# Process to update the Template with Latest Changes(For developers)

To udpate the template with new changes use below process:

1. Execute Command:
sfdx analytics:app:list
 

 ![alt text](https://github.com/ashishshukla38/AnlyTxEAHackathon/blob/master/ReadMdImages/UpdateTemplateScreenshot.png?raw=true) 



2. Use the Folder ID from the App, where Template Source ID is not null.
sfdx analytics:template:update -f 00l9D000000IFuhQAG  --templatename AnlyTx_COVID19_Impact_Analysis  

3. Make sure your template-info.json file has 
```json
"templateType": "embeddedapp",
```
4. Add, if it is removed after package update. Please add next to "templateType": "embeddedapp",

```json
"autoInstallDefinition": "auto-install.json",
```

5. Make sure you have a file called auto-install.json after updating the template. If not you can create with below content.

```json
{
  "hooks": [
    {
      "type": "PackageInstall",
      "requestName": "Installing/Upgrading AnlyTx App"
    }
  ],
  "configuration": {
    "appConfiguration": {
      "autoShareWithLicensedUsers": true,
      "autoShareWithOriginator": true,
      "deleteAppOnConstructionFailure": true,
      "values": {}
    }
  }
}
 ```

 6. Update folder.json file 's shares attribute as below:
```json
{
  "name": "demoTemplate",
  "label": "demoTemplate",
  "description": "Analytics template with one simple dashboard",
  "featuredAssets": {},
  "shares": [
    {
      "accessType": "View",
      "shareType": "Organization"
    }
  ]
}
```

## Use Cases: 

# Sales Cloud – Use Case
Expected Revenue of won opportunities in different sectors by country.

    • Expected Revenue of Salesforce opportunity decreased when opportunity was related to Travel or Entertainment industry for a Specific country due to COVID and lockdown.
    
    • E.g. Expected Revenue from Salesforce opportunity increased when opportunity was related to Computer Software as due to lockdown more companies needed their presence on Digital Platform.
    
    • Medical Equipment for a specific country due to increase of number of COVID Cases.


## Service Cloud – Use Case
This dashboard shows how COVID impacted cases with below use cases:
    • When Industry is Travel the number of Cases generated were less as compare to Health Care and Computer software
    
    • When Industry is Health Care, the number of cases were more but average CSAT score went down due to limited manpower in Call Centre and on site.
    
    • Due to limited people availability the number of cases solved by Chatbot, Knowledge portal and Self resolution increased.
