<#
    .DESCRIPTION
         start VMs created in resoucemanger mode

         one parameter
		 $ResourceGroupName
		 
    .NOTES
        AUTHOR: David Yang
        LASTEDIT: Nov 4, 2015
#>
workflow Start-AzureRMVMs
{
	param(

  	[string]$ResourceGroupName

 	)
	 
	#The name of the Automation Credential Asset this runbook will use to authenticate to Azure.
	# $ResourceGroupName='RealSuite'
    $CredentialAssetName = 'DefaultAzureCredential'

    #Get the credential with the above name from the Automation Asset store
    $Cred = Get-AutomationPSCredential -Name $CredentialAssetName

    if(!$Cred) {
        Throw "Could not find an Automation Credential Asset named '${CredentialAssetName}'. Make sure you have created one in this Automation Account."
    }

    #Connect to your Azure Account
    $Account = Add-AzureAccount -Credential $Cred
    
    if(!$Account) {
        Throw "Could not authenticate to Azure using the credential asset '${CredentialAssetName}'. Make sure the user name and password are correct."
    }
	
    #TODO (optional): pick the right subscription to use. Without this line, the default subscription for your Azure Account will be used.
    
        #Select-AzureSubscription -SubscriptionName <add your Azure subscription name here>

        $VMs = Get-AzureVM -ResourceGroupName "$ResourceGroupName"

    # Start VMs in parallel
     if(!$VMs) {

        Write-Output "No VMs were found in your subscription."

     } else {

		Foreach -parallel ($VM in $VMs) {
		Start-AzureVM -ResourceGroupName "$ResourceGroupName" -Name $VM.Name -ErrorAction SilentlyContinue
		 Write-Output $VM.Name " started"
		}
     }
}