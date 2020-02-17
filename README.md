# MEMConnectors
Location to develop the MEMConnectors

## Importing Connectors
Importing connectors relies on a tool called paconn written by Microsoft in the Python language. This means you'll need Python installed on the computer you are using to import and the tool pre-installed.

### Prerequisites

1. [Download and install Python](https://www.python.org/downloads/)
    1. Ensure you check the box to add Python to your path variable. You'll need both the /Python install folder and /Python/Scripts in your path (if you manually add).
    2. You don't have to reboot, but it's easiest to just reboot after Python is installed and in your path.
2. [Install paconn](https://pypi.org/project/paconn/)
    1. You can install paconn with the command ```pip install paconn``` this will download paconn and put it in your Python\Scripts folder.
3. Create an Azure AD Application with necessary permissions (Only required for Intune and ConfigMgr-Azure)
    1. Go to the Azure Portal and create an Application. You can follow the instructions [here](https://docs.microsoft.com/en-us/azure/active-directory/develop/quickstart-register-app)
    2. Configure (Update) your Azure AD application to access the Azure Active Directory API
This step will ensure that your application can successfully retrieve an access token to invoke Azure Active Directory rest APIs on behalf of your users.  To do this, follow the steps [here](https://docs.microsoft.com/en-us/azure/active-directory/develop/quickstart-configure-app-access-web-apis).
    - For redirect URI, use "https://global.consent.azure-apim.net/redirect"
    - For the credentials, use a client secret (and not certificates).  Remember to note the secret down, you will need this later and it is shown only once.
    - For API permissions, select all of the Delegated scopes for your connector. Intune will require all DeviceManagement scopes as listed in [apiProperties.json](https://github.com/Ryan2065/MEMConnectors/blob/master/Intune/apiProperties.json) under scopes.

### Importing the connectors

Once the pre-reqs are met, you are ready to run the deploy script!  Simply run the command in PowerShell:

```powershell
. .\deploy.ps1 -ClientId '<ClientId-FromPreReq3>' -ClientSecret '<ClientSecret>' -Connector 'Intune'
```

This will copy the necessary files to the bin folder and run the required paconn commands. Note, paconn *sometimes* will throw a PowerShell error of "updated successfully" so if you see red, read the message.

If you want to update the connector after sucessfully importing it, run the same command as above except throw the -Update switch on it. 

### Future

If you have any issues with the connector import process, file an issue.

If you want any features, file an issue.

