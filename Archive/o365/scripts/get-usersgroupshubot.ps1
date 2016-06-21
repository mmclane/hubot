<#
.Synopsis
    Gets service status for Hubot Script.
.DESCRIPTION
    Gets service status for Hubot Script.
.EXAMPLE
    Get-ServiceHubot -Name dhcp
#>
function Get-UsersGroups
{
    [CmdletBinding()]
    Param
    (
        # Name of the Service
        [Parameter(Mandatory=$true)]
        $user
    )

    # Create a hashtable for the results
    $result = @{}

    # Use try/catch block
    try
    {
        Import-Module RespClient
        Connect-RedisServer 127.0.0.1
        $user = $user.ToLower()
        
        if($user -notcontains "*@onlinetech.com"){$user = "$user@onlinetech.com"}

        $cmd = "HGET o365users:$user groups"
        $response = Send-RedisCommand $cmd
        
        Disconnect-RedisServer

        $response = $response -replace "_", " "

		$result.output = $response.split(",")
        $result.success = $true


    <#
        $sessionUser = "mmclane@onlinetech.com"
        $password = Get-Content C:\psscripts\o365pass.txt | ConvertTo-SecureString
        $UserCredential = New-Object System.Management.Automation.PsCredential($sessionUser,$password)

        Import-Module MSOnline

        Connect-MsolService -Credential $UserCredential

        $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
        Import-PSSession $Session -DisableNameChecking > $null
        #$names = Get-DistributionGroupMember -Identity $group | select Name

        #######################################
        #put your script here.

        $user = "$user@onlinetech.com"
        #Write-host "Getting Groups"
        $user_dn = (get-mailbox $user).distinguishedname

        $names = @()
        foreach ($group in get-distributiongroup -resultsize unlimited){
         #   write-host $group
            if ((get-distributiongroupmember $group.identity | select -expand distinguishedname) -contains $user_dn){
                $names += ,$group.name
            }
        }

		    $result.output = $names # $output
        $result.success = $true

        #######################################
      #>
    }
    catch
    {
        # If this script fails we can assume the service did not exist
        $result.output = "I`'ve been talking to the main computer and... it doesn`'t like me."

        # Set a failed result
        $result.success = $false
    }

    # Return the result and conver it to json
    remove-pssession $session
    return $result | ConvertTo-Json
}
