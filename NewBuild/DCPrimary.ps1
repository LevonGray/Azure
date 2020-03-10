Add-WindowsFeature -Name "ad-domain-services, dns, gpmc" -IncludeAllSubFeature -IncludeManagementtools
Install-ADDSForest -CreateDnsDelegation:$false`
 -DatabasePath "C:\Windows\NTDS"`
 -DomainMode "WinThreshold"`
 -DomainName $DomainName`
 -DomainNetbiosName $Netbios`
 -SafeModeAdministratorPassword $DAPassword`
 -ForestMode "WinThreshold"`
 -InstallDns:$true`
 -LogPath "C:\Windows\NTDS"`
 -NoRebootOnCompletion:$false`
 -SysvolPath "C:\Windows\SYSVOL"`
 -Force:$true
