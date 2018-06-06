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
$name = Get-Attr $params "name" -failifempty $true

C:\Windows\System32\inetsrv\appcmd.exe recycle apppool /apppool.name:$name

Set-Attr $result "changed" $true;

Exit-Json $result;