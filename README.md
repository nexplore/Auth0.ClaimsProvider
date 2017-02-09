# Auth0.ClaimsProvider (with a webproxy request)

##Prerequisites:
- SharePoint solution development tools for Visual Studio 2015

## Installation

  1. Open solution and enable "NuGet Package Restore"
  2. Compile solution
  3. Right click on project -> Package (that will generate a .wsp file)
  4. Open a SharePoint Powershell session to install and deploy the solution:

  ~~~ps1
  Add-SPSolution -LiteralPath "<path to .wsp file>"
  Install-SPSolution -Identity auth0.claimsprovider.wsp -GACDeployment
  ~~~
  
## Configuration  
  1. When enable Auth0 for the SharePoint application, make sure that "Client ID" (http://schemas.auth0.com/clientID) and       "Connection" (http://schemas.auth0.com/connection) claims are part of the list of required claims  
  2. Associate Auth0 (SP Trusted Identity Token Issuer) with our Claims Provider: 
  
  ~~~ps1
  Set-SPTrustedIdentityTokenIssuer -identity Auth0 -ClaimProvider "Auth0FederatedUsers"  
  ~~~
  
  3. Go to Central Admin -> Security      
    1. Under General Security section, click on "Configure Auth0 Claims Provider"      
    2. Set the required configuration parameters (like domain, client ID, client secret and identifier user field)
  
  4. Set the Webproxy url
  
    ~~~ps1
    $wa = Get-SPWebapplication https://sharepoint.example.ch
    $wa.Properties["ProxyUrl"] = "http://webproxy.example.ch:9055"
    $wa.Update()
    ~~~
    
  5. (Optional) Set the webproxy username + domain + password but you need another solution to set it:
<a href="https://github.com/nexplore/Nx.SharePoint.Auth0" target="_blank">Nx.SharePoint.Auth0</a>

	You can set the password plaintext or set the PassPhrase in the <a href="https://github.com/nexplore/Nx.SharePoint.Auth0/blob/master/Nx.SharePoint.Auth0/Helpers/Constants.cs" target="_blank">Constants.cs line 6 </a> and/or <a href="https://github.com/nexplore/Auth0.ClaimsProvider/blob/master/Auth0.ClaimsProvider/Helper/Crypto.cs" target="_blank">Crypto.cs line 14</a>
