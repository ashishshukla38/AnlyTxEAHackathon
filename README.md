# Salesforce App

This guide helps Salesforce developers who are new to Visual Studio Code go from zero to a deployed app using Salesforce Extensions for VS Code and Salesforce CLI.
This project was created with the analytics template which is configured to work with Einstein Analytics features.

## Pre-requisite:
1. Salesforce CLI along with VS Code should be installed in your system. If not installed, then follow instructions given in the [Set Up Your Workspace and Install Developer Tools](https://trailhead.salesforce.com/content/learn/projects/quickstart-vscode-salesforce/vscode-salesforce-ready?trail_id=set-up-your-workspace-and-install-developer-tools) trailhead.
2. User should have an Winter'21 Dev-Hub org. [Winter'21 Pre-release org](https://www.salesforce.com/form/signup/prerelease-winter21/)

## How to setup org with this project? 
### Option 1 - For direct installation on EADL enabled org
1. Open [package link](https://login.salesforce.com/packaging/installPackage.apexp?p0=04tB0000000cylW) in browser.
2. Login with the EADL enabled org credentials.

### Option 2 - For installation using VS code on scratch org.
1. [Download repo](https://github.com/ashishshukla38/AnlyTxEAHackathon/archive/master.zip) or Clone this repo locally: -- git clone https://github.com/ashishshukla38/AnlyTxEAHackathon.git 
2. Open AnlyTxEAHackathon folder inside VS Code and set the current user as Dev hub user.
3. Run init.sh -- ./init.sh - 
    This shell file will create an scratch org, will install AnlyTx app and open the newly created org in new browser tab.

## Post-install steps
After successfully installing the package, user needs to perform following steps in order to make use of awesome Analytics dashboards.
1. Go to Setup -> Search and click on  Lightning App Builder menu. 
2. Click on New button -> Select App page -> Click on Next -> Enter Label for App Page -> Click on Next -> Select One Region from Left side bar -> Click on Finish.
3. From the left-side drag and drop Einstein Analytics Dashboard to middle component.
4. Click on the newly added Einstein Dashboard -> Select the appropriate wave dashboard and set the component height and click on Save button and later click on Activate button.
5. Go to Setup -> Search and click on Tabs -> Click on New button to create New Lightning Page Tab -> On the new screen, select newly created Lightning app page from drop-down and enter appropriate Label, Name and click on Next -> Select the appropriate profiles that needs to have access to the newly created tabs and click on Save button.
6. Open any app where you want to add the awesome analytics dashboards -> Click on the pencil icon below at top right side -> Click on Addmore items -> Click on All -> Select Newly created tab -> Click on Add Nav Item -> click on Save button.


## Part 1: Choosing a Development Model

There are two types of developer processes or models supported in Salesforce Extensions for VS Code and Salesforce CLI. These models are explained below. Each model offers pros and cons and is fully supported.

### Package Development Model

The package development model allows you to create self-contained applications or libraries that are deployed to your org as a single package. These packages are typically developed against source-tracked orgs called scratch orgs. This development model is geared toward a more modern type of software development process that uses org source tracking, source control, and continuous integration and deployment.

If you are starting a new project, we recommend that you consider the package development model. To start developing with this model in Visual Studio Code, see [Package Development Model with VS Code](https://forcedotcom.github.io/salesforcedx-vscode/articles/user-guide/package-development-model). For details about the model, see the [Package Development Model](https://trailhead.salesforce.com/en/content/learn/modules/sfdx_dev_model) Trailhead module.

If you are developing against scratch orgs, use the command `SFDX: Create Project` (VS Code) or `sfdx force:project:create` (Salesforce CLI) to create your project. If you used another command, you might want to start over with that command.

When working with source-tracked orgs, use the commands `SFDX: Push Source to Org` (VS Code) or `sfdx force:source:push` (Salesforce CLI) and `SFDX: Pull Source from Org` (VS Code) or `sfdx force:source:pull` (Salesforce CLI). Do not use the `Retrieve` and `Deploy` commands with scratch orgs.

### Org Development Model

The org development model allows you to connect directly to a non-source-tracked org (sandbox, Developer Edition (DE) org, Trailhead Playground, or even a production org) to retrieve and deploy code directly. This model is similar to the type of development you have done in the past using tools such as Force.com IDE or MavensMate.

To start developing with this model in Visual Studio Code, see [Org Development Model with VS Code](https://forcedotcom.github.io/salesforcedx-vscode/articles/user-guide/org-development-model). For details about the model, see the [Org Development Model](https://trailhead.salesforce.com/content/learn/modules/org-development-model) Trailhead module.

If you are developing against non-source-tracked orgs, use the command `SFDX: Create Project with Manifest` (VS Code) or `sfdx force:project:create --manifest` (Salesforce CLI) to create your project. If you used another command, you might want to start over with this command to create a Salesforce DX project.

When working with non-source-tracked orgs, use the commands `SFDX: Deploy Source to Org` (VS Code) or `sfdx force:source:deploy` (Salesforce CLI) and `SFDX: Retrieve Source from Org` (VS Code) or `sfdx force:source:retrieve` (Salesforce CLI). The `Push` and `Pull` commands work only on orgs with source tracking (scratch orgs).

## The `sfdx-project.json` File

The `sfdx-project.json` file contains useful configuration information for your project. See [Salesforce DX Project Configuration](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_ws_config.htm) in the _Salesforce DX Developer Guide_ for details about this file.

The most important parts of this file for getting started are the `sfdcLoginUrl` and `packageDirectories` properties.

The `sfdcLoginUrl` specifies the default login URL to use when authorizing an org.

The `packageDirectories` filepath tells VS Code and Salesforce CLI where the metadata files for your project are stored. You need at least one package directory set in your file. The default setting is shown below. If you set the value of the `packageDirectories` property called `path` to `force-app`, by default your metadata goes in the `force-app` directory. If you want to change that directory to something like `src`, simply change the `path` value and make sure the directory you’re pointing to exists.

```json
"packageDirectories" : [
    {
      "path": "force-app",
      "default": true
    }
]
```

## Part 2: Working with Source

For details about developing against scratch orgs, see the [Package Development Model](https://trailhead.salesforce.com/en/content/learn/modules/sfdx_dev_model) module on Trailhead or [Package Development Model with VS Code](https://forcedotcom.github.io/salesforcedx-vscode/articles/user-guide/package-development-model).

For details about developing against orgs that don’t have source tracking, see the [Org Development Model](https://trailhead.salesforce.com/content/learn/modules/org-development-model) module on Trailhead or [Org Development Model with VS Code](https://forcedotcom.github.io/salesforcedx-vscode/articles/user-guide/org-development-model).

## Part 3: Deploying to Production

Don’t deploy your code to production directly from Visual Studio Code. The deploy and retrieve commands do not support transactional operations, which means that a deployment can fail in a partial state. Also, the deploy and retrieve commands don’t run the tests needed for production deployments. The push and pull commands are disabled for orgs that don’t have source tracking, including production orgs.

Deploy your changes to production using [packaging](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_dev2gp.htm) or by [converting your source](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_force_source.htm#cli_reference_convert) into metadata format and using the [metadata deploy command](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_force_mdapi.htm#cli_reference_deploy).


# Part 4: Process to update the Template with Latest Changes
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
