
$subscriptionName = "Puebla Cloud Team Lab"
$rg = "fw-manager"
$location = "eastus"
$Azfw = "AzureFirewall_Hub-01"
$policyname = "Policy-01"
$apprulename = "Allow-msft"
$apprulecollectionname = "App-RC-01"
$natrulename = "Allow-rdp"
$natrulecollectionname = "DNAT-rdp"
$netrulename = "Allow-vnet"
$netrulecollectionname = "vnet-rdp"

Connect-AzAccount

Select-AzSubscription -Subscription $subscriptionName

# Creates empty policy with ThreatIntel mode set to deny
New-AzFirewallPolicy -Name $policyname -ResourceGroupName $rg -Location $location -ThreatIntelMode "Deny"

# Creates application rule collection that allows http/https traffic from any IP to microsoft.com
$AppRule1 = New-AzFirewallPolicyApplicationRule -Name $apprulename -SourceAddress * -Protocol http, https -TargetFqdn *.microsoft.com 
$AppRuleCollection = New-AzFirewallPolicyFilterRuleCollection -Name $apprulecollectionname -Priority 100 -ActionType Allow -Rule $AppRule1

# Creates a DNAT rule collection that sends 3389 traffic to the firewall public IP to Srv-workload-01
$NatRule1 = New-AzFirewallPolicyNatRule -Name $natrulename -Protocol TCP -SourceAddress * -DestinationAddress `
52.224.22.135 -DestinationPort 3389 -TranslatedAddress 10.1.1.4 -TranslatedPort 3389
$NatRuleCollection = New-AzFirewallPolicyNatRuleCollection -Name $natrulecollectionname -Priority 100 -Rule $NatRule1 -ActionType "Dnat"

# Creates a network rule the allows RDP from any vnet IP to Srv-workload-02
# Currently can't find a way to create a netrulecollection object so have to do it via portal
$NetRule1 = New-AzFirewallPolicyNetworkRule -Name $netrulename -Protocol TCP -SourceAddress * -DestinationAddress 10.2.1.4 -DestinationPort 3389
# $NetRuleCollection = New-AzFirewallPolicyFilterCollection -Name $netrulecollectionname -Priority 100 -Rule $NetRule1 -ActionType "Allow"

# Apply collections to firewall

Set-AzFirewallPolicyRuleCollectionGroup -Name $Azfw -ResourceGroupName $rg -FirewallPolicyName $policyname -Priority 100 -RuleCollection $NatRuleCollection, $AppRuleCollection
