<#
.Synopsis
    Gets a new IAM AccessKey for a user
.DESCRIPTION
    Uses New-IAMAccessKey to create a new key for a user.  Returns the results in JSON.
.EXAMPLE
    new-awsIAMAccessKey -username "foo"  -Profile "hl-dev"
#>
function new-awsIAMAccessKey
{
    [CmdletBinding()]
    Param
    (
        #ProfileName must be setup outside the script.  
        [Parameter(Mandatory=$true)]
        [string]$UserName,
        [Parameter(Mandatory=$false)]
        [string]$ProfileName
    )

    # Use try/catch block
    try
    {
		#######################################
        Import-Module AWSPowershell
        $result = @{}

        $result.output = New-IAMAccessKey -UserName $username -ProfileName $ProfileName -Region us-east-1 | Select UserName, AccessKeyID, SecretAccessKey 
        $result.success = $true       
        
        #######################################
    }
    catch
    {
        $result = @{}

        # If this script fails we can assume the service did not exist
        $result.output = "Sorry bossman, something went wrong.  I will try to do better in the future, but you should talk to Matt McLane so he can fix me first."
        # Set a failed result
        $result.success = $false
        Write-host $_.Exception.Message
    }
    # Return the result and conver it to json
    #remove-pssession $session
    return $result | ConvertTo-Json
}
