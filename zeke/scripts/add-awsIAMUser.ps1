<#
.Synopsis
    Creates a new IAM User  
.DESCRIPTION
    Creates a new IAM User
.EXAMPLE
    create-IAMUser -Username "Foo" -ProfileName "hl-dev"
#>
function create-IAMUser
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

        $result.output = New-IAMUser -UserName $username -ProfileName $ProfileName -Region us-east-1 | Select UserName, UserID, Arn, CreateDate 
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
