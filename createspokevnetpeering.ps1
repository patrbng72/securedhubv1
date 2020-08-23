
$subscriptionName = "Puebla Cloud Team Lab"
$rg = "fw-manager"
$location = "eastus"
$vwanname = "Vwan-01"
$hubprefix = "10.0.0.0/16"
$hubname = "Hub-01"
$spoke1name = "Spoke-01"
$spoke1connectionname = "Hub-to-Spoke01"
$spoke2name = "Spoke-02"
$spoke2connectionname = "Hub-to-Spoke02"

Connect-AzAccount

Select-AzSubscription -Subscription $subscriptionName

$spoke1vnet = Get-AzVirtualNetwork -Name $spoke1name -ResourceGroupName $rg
$spoke2vnet = Get-AzVirtualNetwork -Name $spoke2name -ResourceGroupName $rg

New-AzVirtualHubVnetConnection -ResourceGroupName $rg -VirtualHubName $hubname -Name $spoke1connectionname -RemoteVirtualNetwork $spoke1vnet
New-AzVirtualHubVnetConnection -ResourceGroupName $rg -VirtualHubName $hubname -Name $spoke2connectionname -RemoteVirtualNetwork $spoke2vnet
