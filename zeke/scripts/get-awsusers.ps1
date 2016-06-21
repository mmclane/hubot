<#
.Synopsis
    Users users from IAM.  
.DESCRIPTION
    Gets users from IAM and returns usernames.  To begin this will only work in hl-dev.  
	Eventually the person should be able to ask for a specific Account
.EXAMPLE
    Get-AWSUsers -ProfileName hl-dev
#>
function Get-AWSIAMsers
{
    [CmdletBinding()]
    Param
    (
        #ProfileName must be setup outside the script.  
        [Parameter(Mandatory=$false)]
        [string]$ProfileName = "blah"
    )

    # Use try/catch block
    try
    {
		#######################################
        Import-Module AWSPowershell
        if ($ProfileName -ne "blah"){
            #Write-host "Getting usrs from $ProfileName."
            $result = @{}
            $result.success = $true
            $result.profile = $profileName
            $result.output = Get-IAMUsers -ProfileName $ProfileName -Region us-east-1 | Select Username
        }
       # else{
            #Write-host "Getting all users."
        #    $hldevUsers = @{}
         #   $hlprodUsers = @{}
          #  $hldevUsers = Get-IAMUsers -ProfileName "hl-dev" -Region us-east-1 | Select Username
          #  $hlprodUsers = Get-IAMUsers -ProfileName "hl-dev" -Region us-east-1 | Select Username
          #  $outObj = @{"hldev" = $hldevUsers; "hlprod" = $hlprodUsers} 
          #  $result = @{output = $outObj; success = $true}
            #$result.output = $out
            #$result.success = $true
           
        #}
        #######################################
    }
    catch
    {
        $result = @{}

        # If this script fails we can assume the service did not exist
        $result.output = "Sorry bossman, something went wrong.  I will try to do better in the future, but you should talk to Matt McLane so he can fix me first."
        # Set a failed result
        $result.success = $false
        $result.profile = "~"
        Write-host $_.Exception.Message
    }
    # Return the result and conver it to json
    #remove-pssession $session
    return $result | ConvertTo-Json
}

#Get-IAMsers #-ProfileName hl-dev