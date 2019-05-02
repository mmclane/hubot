<#
.Synopsis
    Lists IAM users in a group
.DESCRIPTION
    http://docs.aws.amazon.com/powershell/latest/reference/Index.html?page=Remove-IAMUserFromGroup.html&tocid=Remove-IAMUserFromGroup
.EXAMPLE
    get-awsIAMGroupMembers -GroupName "bar" -Profile "hl-dev"
#>
function get-awsIAMGroupMembers
{
    [CmdletBinding()]
    Param
    (
        #ProfileName must be setup outside the script.  
        [Parameter(Mandatory=$true)]
        [string]$GroupName,
        [Parameter(Mandatory=$false)]
        [string]$ProfileName
    )

    # Use try/catch block
    try
    {
		#######################################
        Import-Module AWSPowershell
        $result = @{}

        $group = Get-IAMGroup -GroupName $groupname -ProfileName $ProfileName -Region us-east-1
        $result.output = $group.users | select UserName
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
