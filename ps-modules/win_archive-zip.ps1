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

# Getting all the parameters
$params = Parse-Args $args;
$result = New-Object PSObject;
Set-Attr $result "changed" $false;

# Getting every parameter
$env = Get-Attr $params "env" -failifempty $true
$version = Get-Attr $params "version" $true
$bucket_name = Get-Attr $params "bucket_name" $true
$bucket_folder = Get-Attr $params "backup_folder" $true
#$accesskey = Get-Attr $params "accesskey" $true
#$secretkey = Get-Attr $params "secretkey" $true

# Compress folder
Add-Type -Assembly System.IO.Compression.FileSystem
$source = $bucket_folder
$zip = "$bucket_folder.zip"

# Remove zip file if exists
If(Test-path $zip){Remove-item $zip}

[IO.Compression.ZipFile]::CreateFromDirectory($source, $zip);

#Import-Module AWSPowerShell

# Adding credentials to connect to aws account
#Set-AWSCredentials -AccessKey $accesskey -SecretKey $secretkey -StoreAs myAWScredentials
#Initialize-AWSDefaults -Region eu-west-1 -StoredCredentials myAWSCredentials
#Set-AWSCredentials myAWSCredentials
#sleep 5

# Writing the backup to s3
#Write-S3Object -BucketName $bucket_name -File $zip -Key $env/Backups/$version.zip

# Clearing myAWScredentials credentials
#Clear-AWSCredentials -StoredCredentials myAWScredentials

Set-Attr $result "changed" $true;

Exit-Json $result;