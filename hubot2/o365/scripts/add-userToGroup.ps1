function Add-UserToGroup
{
    [CmdletBinding()]
    Param
    (
        # Name of the Service
        [Parameter(Mandatory=$true)]
        $user,
        [Parameter(Mandatory=$true)]
        $groupName
    )

    # Create a hashtable for the results
    $result = @{}
    $Global:ErrorActionPreference = 'Stop'

    $sessionUser = "mmclane@onlinetech.com"
    $password = Get-Content C:\psscripts\o365pass.txt | ConvertTo-SecureString 
    $UserCredential = New-Object System.Management.Automation.PsCredential($sessionUser,$password)
        
    Import-Module MSOnline

    Connect-MsolService -Credential $UserCredential

    $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
    Import-PSSession $Session -DisableNameChecking > $null

    $group = get-distributiongroup -resultsize unlimited -Identity $groupName

    if($group.IsDirSynced){
        #Add user to AD grop
	    $result.location = "AD"
        Write-host "Adding $user to AD group $groupName"
        $ADuser = "mmclanea"
        $password = Get-Content C:\psscripts\adpass.txt | ConvertTo-SecureString 
        $UserCredential = New-Object System.Management.Automation.PsCredential($ADuser,$password)

        Import-Module ActiveDirectory

        if($user.EndsWith("@onlinetech.com") -eq $true){$user = $user.split("@")[0]}    
        Write-host "Getting User: $user"
        try{$userObj = get-aduser $user}
        catch{
            $result.output = $_.Exception.Message
            $result.success = $false
            remove-pssession $session
            return $result | ConvertTo-Json
            #$errorFound = $true
        }
            
        $groupObj = Get-ADGroup -Filter {name -like $groupName} -SearchBase "dc=onlinetech,dc=com"
        if($groupObj -eq $null){
            $result.output = $_.Exception.Message
            $result.success = $false
            remove-pssession $session
            return $result | ConvertTo-Json
            #$errorFound = $true
        }
            
        Try{Add-ADGroupMember -Identity $groupObj -Members $userObj -Credential $UserCredential}
        Catch{
            $result.output = $_.Exception.Message
            $result.success = $false
            remove-pssession $session
            return $result | ConvertTo-Json
            #$errorFound = $true
        }
    }
    else{
        #Add user to O365 group
	    $result.location = "O365"
        Write-Host "Adding $user to O365 Group $groupName"
        if($user.EndsWith("@onlinetech.com") -eq $false){$user = "$user@onlinetech.com"}

        Try{Add-DistributionGroupMember -Identity $groupName -Member $user}
        Catch  [System.Exception] {
            $result.output = $_.Exception.Message
            $result.success = $false
            remove-pssession $session
            return $result | ConvertTo-Json
        }
    }

    $result.output = "$user added to $groupName successfully"
    $result.success = $true
    
    remove-pssession $session
    return $result | ConvertTo-Json
}