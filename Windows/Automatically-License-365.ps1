## Script to automatically pull the UPN of users from staff and then assign the correct licence for ## Office 365 using the UPN's. This will run every night ## to keep Office 365 and AD in sync with regards to licensed users.

Import-Module ActiveDirectory

## Variables containing Organization Unit FQDN
$staffou1 = "OU=User Accounts,OU=WEMS,DC=WEMS,DC=local"
$staffou2 =

## A variable containing an array of the above OU FQDN's
$ouarray = @($staffou1)

## Using a for each loop to get the UPN of the users in each of the above defined OU's and then exporting this to a ## CSV file
$ouarray | ForEach {Get-ADUser -SearchBase $_ -Filter * -Properties *| Select-Object -Property UserPrincipalName} | Export-Csv "C:\365 Licensing Script\Office365-AllStaff.csv" -NoTypeInformation

## Sleep 60 Seconds for CSV creation
Start-Sleep -sec 60

## Azure AD Creds
$user = "adminuser@fqdn"
$pword = ConvertTo-SecureString –String 'Password' –AsPlainText -Force
$creds = New-Object –TypeName System.Management.Automation.PSCredential –ArgumentList $user, $pword

## Connect to Azure AD using above creds
Connect-MsolService -Credential $creds

## Shows license information
Get-MsolAccountSku

## Adds the staff license sku to a variable
$StaffAccountSkuId = "wemsint:SMB_BUSINESS_PREMIUM"

## Adds the service licence to disable into a variable
$disabledPlans= @()
$disabledPlans +=

## Adds the new staff license package to a variable
$StaffLicenseOptions = New-MsolLicenseOptions -AccountSkuId $StaffAccountSkuId -DisabledPlans $disabledPlans

## Imports the staff users from the above UPN export script into a variable
$StaffUsers = Import-Csv "C:\365 Licensing Script\Office365-AllStaff.csv"

## Gets all unlicensed users on 365
$UnlicensedUsers = Get-MsolUser -UnlicensedUsersOnly -All

## Build hash of unlicenced UPN's
$u_hash = @{}
$UnlicensedUsers | ForEach { $u_hash.Add($_.UserPrincipalName,"1") }

## For each loop through the staff users CSV
$StaffUsers | ForEach-Object {
  If ( $u_hash.Contains($_.userPrincipalName) ) {
      ## Sets the new license package and location to each users
      Set-MsolUser -UserPrincipalName $_.UserPrincipalName -UsageLocation GB
        Set-MsolUserLicense -UserPrincipalName $_.UserPrincipalName -AddLicenses $StaffAccountSkuId -LicenseOptions $StaffLicenseOptions
  }
}
