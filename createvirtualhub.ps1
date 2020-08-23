
$subscriptionName = "Puebla Cloud Team Lab"
$rg = "fw-manager"
$location = "eastus"
$vwanname = "Vwan-01"
$hubprefix = "10.0.0.0/16"
$hubname = "Hub-01"

Connect-AzAccount

Select-AzSubscription -Subscription $subscriptionName

$virtualWan = New-AzVirtualWan -ResourceGroupName $rg -Name $vwanname -Location $location

New-AzVirtualHub -VirtualWan $virtualWan -ResourceGroupName $rg -Name $hubname -AddressPrefix $hubprefix -Location $location
