
## adjust the following variables to suit
$custcode = "CUST"
$VNetName = "VNET"
$Username = "cspadmin"

## Get VNET and find avilable IPs
$VNET = Get-AzVirtualNetwork -Name $VNetName
$IPAddresses = (Test-AzPrivateIPAddressAvailability -VirtualNetwork $VNET -IPAddress ($VNET.Subnets.addressprefix.Split("/")[0])).AvailableIPAddresses
$DC1IP = [string]$Ipaddresses[0]
$DC2IP = [string]$Ipaddresses[1]

## Create a new resource group for the domain controllers in the same region as the VNET created.
$RG = New-AzResourceGroup -Name "RG-$($custcode)-DomainControllers" -Location $VNET.Location

## Deploy the template for standard Domain Controllers you will be prompted to set the local admin password
new-AzResourceGroupDeployment -TemplateUri "https://raw.githubusercontent.com/LevonGray/Azure/master/NewBuild/DC_1_2_Deployment_noNSG.json" `
 -custcode $Custcode `
 -ResourceGroupName $RG.ResourceGroupName `
 -subnetname $VNET.Subnets.name `
 -virtualnetworkid $VNET.id `
 -dc1ipaddress $DC1IP `
 -dc2ipaddress $DC2IP `
 -adminusername $Username

## Set the IP Addresses of the DNS Servers as the DNS on the VNET
 $array = @($DC1IP,$DC2IP)
 $object = new-object -type PSObject -Property @{"DnsServers" = $array}
 $VNET.DhcpOptions = $object
 $VNET | Set-AzVirtualNetwork

## Now ready to configure the VMs as Domain Controllers