<#
.Synopsis
    Remove an IAM user in Profile
.DESCRIPTION
    http://docs.aws.amazon.com/powershell/latest/reference/Index.html?page=Remove-IAMUserFromGroup.html&tocid=Remove-IAMUserFromGroup
.EXAMPLE
    remove-awsIAMUser -username "foo" -Profile "hl-dev"
#>
function remove-awsIAMUser
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

        $name = $username

        # find any groups and remove user from them
        $groups = Get-IAMGroupForUser -UserName $name
        foreach ($group in $groups) { Remove-IAMUserFromGroup -GroupName $group.GroupName -UserName $name -Force -ProfileName $profilename -Region us-east-1}

        # find any inline policies and delete them
        $inlinepols = Get-IAMUserPolicies -UserName $name
        foreach ($pol in $inlinepols) { Remove-IAMUserPolicy -PolicyName $pol -UserName $name -Force -ProfileName $profilename -Region us-east-1}

        # find any managed polices and detach them
        $managedpols = Get-IAMAttachedUserPolicies -UserName $name
        foreach ($pol in $managedpols) { Unregister-IAMUserPolicy -PolicyArn $pol.PolicyArn -UserName $name -ProfileName $profilename -Region us-east-1}

        # find any signing certificates and delete them
        $certs = Get-IAMSigningCertificate -UserName $name
        foreach ($cert in $certs) { Remove-IAMSigningCertificate -CertificateId $cert.CertificateId -UserName $name -Force -ProfileName $profilename -Region us-east-1}

        # find any access keys and delete them
        $keys = Get-IAMAccessKey -UserName $name
        foreach ($key in $keys) { Remove-IAMAccessKey -AccessKeyId $key.AccessKeyId -UserName $name -Force -ProfileName $profilename -Region us-east-1}

        # delete the user's login profile, if one exists - note: need to use try/catch to suppress not found error
        try { $prof = Get-IAMLoginProfile -UserName bab -ea 0 -ProfileName $profilename -Region us-east-1 } catch { out-null }
        if ($prof) { Remove-IAMLoginProfile -UserName $name -Force -ProfileName $profilename -Region us-east-1}

        # find any MFA device, detach it, and if virtual, delete it.
        $mfa = Get-IAMMFADevice -UserName $name -ProfileName $profilename -Region us-east-1
        if ($mfa) { 
            Disable-IAMMFADevice -SerialNumber $mfa.SerialNumber -UserName $name -ProfileName $profilename -Region us-east-1
            if ($mfa.SerialNumber -like "arn:*") { Remove-IAMVirtualMFADevice -SerialNumber $mfa.SerialNumber -ProfileName $profilename -Region us-east-1}
        }

        # finally, remove the user
        Remove-IAMUser -UserName $name -Force -ProfileName $profilename -Region us-east-1
        
        #Do a get-IAMUser and make sure the user was delete?
        $result.output = "User successfully deleted"  
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
