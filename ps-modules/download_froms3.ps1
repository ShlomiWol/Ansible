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
$destination_file = Get-Attr $params "destination_file" $true
#$accesskey = Get-Attr $params "accesskey" $true
#$secretkey = Get-Attr $params "secretkey" $true

#Import-Module AWSPowerShell

# Adding credentials to connect to aws account
#Set-AWSCredentials -AccessKey $accesskey -SecretKey $secretkey -StoreAs myAWScredentials
#Set-DefaultAWSRegion -Region eu-west-1
#Initialize-AWSDefaults -ProfileName myAWSCredentials -Region eu-west-1
Set-AWSCredentials myAWSCredentials
#sleep 5

# Downloading the backup from s3
Read-S3Object -BucketName $bucket_name -File $destination_file -Key $env/Backups/$version.zip

Set-Attr $result "changed" $true;

Exit-Json $result;