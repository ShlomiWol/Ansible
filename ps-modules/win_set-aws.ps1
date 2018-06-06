#!powershell
# This file is part of Ansible
#
# Copyright 2014, Chris Hoffman <choffman@chathamfinancial.com>
#
# Ansible is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ansible is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Ansible.  If not, see <http://www.gnu.org/licenses/>.
# $1 = env (PROD/PROD-PCI)
# $2 = version
# $3 = bucket name
# $4 = backup folder

# WANT_JSON
# POWERSHELL_COMMON

$url = "http://sdk-for-net.amazonwebservices.com/latest/AWSToolsAndSDKForNet.msi"
$sdkdest = "C:\AWSPowerShell.msi"

# Getting all the parameters
$params = Parse-Args $args;
$result = New-Object PSObject;
Set-Attr $result "changed" $false;

# Getting every parameter
$accesskey = Get-Attr $params "accesskey" $true
$secretkey = Get-Attr $params "secretkey" $true
$env = Get-Attr $params "env" -failifempty $true
$version = Get-Attr $params "version" $true
$bucket_name = Get-Attr $params "bucket_name" $true
$bucket_folder = Get-Attr $params "backup_folder" $true

# Check if AWS SDK is installed
$list = Get-Module -ListAvailable

# If not download it and install
If (-Not ($list -match "AWSPowerShell")){
    Try{
        $client = New-Object System.Net.WebClient
        $client.DownloadFile($url, $sdkdest)
    }
    Catch {
        Fail-Json $result "Error downloading AWS-SDK from $url and saving as $sdkdest"
    }
    Try{
        Start-Process -FilePath msiexec.exe -ArgumentList "/i $sdkdest /qb" -Verb Runas -PassThru -Wait | out-null
    }
    Catch {
        Fail-Json $result "Error installing $sdkdest"
    }
    Set-Attr $result.win_s3 "aws_sdk_status" "aws_sdk was installed"
}
Else {
    Set-Attr $result.win_s3 "aws_sdk_status" "present"
}

# Import Module
Try {
    Try {
        Import-Module 'C:\Program Files (x86)\AWS Tools\PowerShell\AWSPowerShell\AWSPowerShell.psd1'
    }
    Catch {
        Import-Module AWSPowerShell
    }
}
Catch {
    Fail-Json $result "Error importing module AWSPowerShell"
}


#Import-Module AWSPowerShell

# Adding creden.tials to connect to aws account
Set-AWSCredentials -AccessKey $accesskey -SecretKey $secretkey -StoreAs myAWScredentials
Set-DefaultAWSRegion -Region eu-west-1
#Initialize-AWSDefaults -ProfileName myAWSCredentials -Region eu-west-1
Set-AWSCredentials myAWSCredentials

Write-S3Object -BucketName $bucket_name -File $zip -Key $env/Backups/$version.zip

Set-Attr $result "changed" $true;

Exit-Json $result;