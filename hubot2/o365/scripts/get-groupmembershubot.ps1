<#
.Synopsis
    Gets service status for Hubot Script.
.DESCRIPTION
    Gets service status for Hubot Script.
.EXAMPLE
    Get-ServiceHubot -Name dhcp
#>
function Get-GroupMembers
{
    [CmdletBinding()]
    Param
    (
        # Name of the Service
        [Parameter(Mandatory=$true)]
        $group
    )

    # Create a hashtable for the results
    $result = @{}

    # Use try/catch block
    try
    {
        <#
        $user = "mmclane@onlinetech.com"
        $password = Get-Content C:\psscripts\o365pass.txt | ConvertTo-SecureString
        $UserCredential = New-Object System.Management.Automation.PsCredential($user,$password)

        Import-Module MSOnline

        Connect-MsolService -Credential $UserCredential

        $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
        Import-PSSession $Session -DisableNameChecking > $null
        #$names = Get-DistributionGroupMember -Identity $group | select Name

        $names = Get-DistributionGroupMember -Identity $group | select Name
		#>

        Import-Module RespClient
        Connect-RedisServer 127.0.0.1
        $group = $group.ToLower()

        $cmd = "HGET o365Groups:$group members"
        $response = Send-RedisCommand $cmd

        Disconnect-RedisServer
        $response = $response -replace "_", " "

		    $result.output = $response.split(",")
        $result.success = $true


        # Create a string for sending back to slack. * and ` are used to make the output look nice in Slack. Details: http://bit.ly/MHSlackFormat
#        $result.output = "Service $($service.Name) (*$($service.DisplayName)*) is currently ``$($service.Status.ToString())``."

        # Set a successful result
#        $result.success = $true
    }
    catch
    {
        # If this script fails we can assume the service did not exist
        $result.output = "I've been talking to the main computer and... it doesn't like me."

        # Set a failed result
        $result.success = $false
    }

    # Return the result and conver it to json
    remove-pssession $session
    return $result | ConvertTo-Json
}
