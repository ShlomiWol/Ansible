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
#$env = Get-Attr $params "env" -failifempty $true
#$version = Get-Attr $params "version" $true
$app_source = Get-Attr $params "app_source" $true
$exclude1 = Get-Attr $params "exclude1" $true
$exclude2 = Get-Attr $params "exclude2" $true
$backup_folder = Get-Attr $params "backup_folder" $true

# Compress folder
#Add-Type -Assembly System.IO.Compression.FileSystem
#$source = $backup_folder
#$zip = "$backup_folder.zip"

# Robocopy to backup foler
robocopy $app_source $backup_folder /E /XF $exclude1 $exclude2

# Remove zip file if exists
#If(Test-path $zip){Remove-item $zip}

#[IO.Compression.ZipFile]::CreateFromDirectory($source, $zip);

Set-Attr $result "changed" $true;

Exit-Json $result;