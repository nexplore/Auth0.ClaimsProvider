If ((Get-PSSnapIn -Name Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue) -eq $null )  
{ Add-PSSnapIn -Name Microsoft.SharePoint.PowerShell } 

$extranetUrlKey = 'ExtranetWebAppUrl'; #Do not change the key!
$extranetUrlValue = 'https://extranet.gmaare.migros.ch';
$identityTokenIssuerName = "Auth0" #Do not change the key!
$claimsProviderInternalName = "Auth0FederatedUsers" #Do not change the key!


$spfFarm=Get-SPFarm;

if($spfFarm.Properties.ContainsKey($extranetUrlKey)){
    $spfFarm.Properties.Remove($extranetUrlKey);
}

$spfFarm.Properties.Add($extranetUrlKey,$extranetUrlValue);
$spfFarm.Update();






function Enable-ClaimsProvider($identityTokenIssuerName, $claimsProviderInternalName) {
	
	try {
        Write-Host "Disabling feature..."
        Disable-SPFeature -Identity "Auth0ClaimsProvider" -Confirm:$false -ErrorAction SilentlyContinue
	}
	catch [system.exception] {
        Write-Host "Warning: Disabling the feature failed (maybe it was already disabled)"
    }
    
	try {
        Write-Host "Enabling feature..."
        Enable-SPFeature -Identity "Auth0ClaimsProvider" -Confirm:$false -ErrorAction SilentlyContinue
	}
	catch [system.exception] {
        Write-Host "Warning: Enabling the feature failed (maybe it was already enabled)"
    }

    # Update
	Write-Host "Associating SP Trusted Identity Token Issuer (Auth0) with the Claims Provider ($claimsProviderInternalName)"
	$spti = Get-SPTrustedIdentityTokenIssuer -identity $identityTokenIssuerName 
	$spti.ClaimProviderName = $claimsProviderInternalName
	$spti.Update();
	
    # Done.
    Write-Host "Done. Please, go to 'SharePoint Central Admin' -> 'Security':"
    Write-Host " 1. Under General Security section, click on 'Configure Auth0 Claims Provider'"
    Write-Host " 2. Set the required configuration parameters"
    Write-Host ""
}

Enable-ClaimsProvider $identityTokenIssuerName $claimsProviderInternalName