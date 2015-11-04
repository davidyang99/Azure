<#
    .DESCRIPTION
         stop VMs created in resoucemanger mode

         one parameter
		 $ResourceGroupName
		 
    .NOTES
        AUTHOR: David Yang
        LASTEDIT: Nov 4, 2015
#>
workflow Stop-AzureRMVMs
{
	param(

  	[string]$ResourceGroupName

 	)
	 #Get the credential with the above name from the Automation Asset store
  #  $ResourceGroupName='RealSuite'
	$CredentialAssetName = 'DefaultAzureCredential'
    $Cred = Get-AutomationPSCredential -Name $CredentialAssetName
    if(!$Cred) {
        Throw "Could not find an Automation Credential Asset named '${CredentialAssetName}'. Make sure you have created one in this Automation Account."
    }

    #Connect to your Azure Account
    $Account = Add-AzureAccount -Credential $Cred
    if(!$Account) {
        Throw "Could not authenticate to Azure using the credential asset '${CredentialAssetName}'. Make sure the user name and password are correct."
    }

	#The name of the Automation Credential Asset this runbook will use to authenticate to Azure.
  
 	 $VMs = Get-AzureVM -ResourceGroupName "$ResourceGroupName"

    #Print out up to 10 of those VMs
     if(!$VMs) {
        Write-Output "No VMs were found in your subscription."

     } else {

		Foreach -parallel ($VM in $VMs) {
		Stop-AzureVM -ResourceGroupName "$ResourceGroupName" -Name $VM.Name -Force -ErrorAction SilentlyContinue
		Write-Output  $VM.Name " is stopped"
		}
     }
}