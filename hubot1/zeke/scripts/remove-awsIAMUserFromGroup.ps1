<#
.Synopsis
    Removes an IAM user from a group
.DESCRIPTION
    http://docs.aws.amazon.com/powershell/latest/reference/Index.html?page=Remove-IAMUserFromGroup.html&tocid=Remove-IAMUserFromGroup
.EXAMPLE
    remove-awsIAMUserToGroup -username "foo" -GroupName "bar" -Profile "hl-dev"
#>
function remove-awsIAMUserFromGroup
{
    [CmdletBinding()]
    Param
    (
        #ProfileName must be setup outside the script.  
        [Parameter(Mandatory=$true)]
        [string]$UserName,
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

        remove-IAMUserFromGroup -UserName $username -GroupName $groupname -ProfileName $ProfileName -Region us-east-1 -Force
        $group = Get-IAMGroup -GroupName $groupname -ProfileName $ProfileName -Region us-east-1
        $found = $false
        Foreach ($u in $group.users){
            if($u.username -eq $username){$found = $true}
        }
        if($found){
            $result.output = "Something went wrong"  
            $result.success = $false
        }
        else{
            $result.output = "User successfully removed from $groupname"  
            $result.success = $true
        }       
        
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
