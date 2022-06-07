Param(
[Parameter(Mandatory=$True)]
[string]$ToAddress = 'firstname.lastname@yourcompany' # ******update this to reflect your org. set up*****
)

$smtpServer = 'yourcompany.com'          # ******update this to reflect your org. set up*****
    
$FromAddress = 'noreply@yourcompany.com' #there should be a noreply mailbox set up in your organization. Enter it here.

$Comp_Name = $(hostname)
$subject = "InstalledSoftware Report on $Comp_Name run at $(Get-Date -format 'dd/MM/yyyy hh:mm:ss') - $((Get-Date).DayOfWeek)"
$body = "Please find the attached InstalledSoftware Report from the machine $Comp_Name"

$TxtFileName = "C:\Windows\Temp\$Comp_Name-Software.txt" #this is the txt file which will contain the InstalledSoftware reports to email
Remove-Item $TxtFileName -Force -ErrorAction SilentlyContinue #delete it if it exists from the previous run

$InstalledSoftwareReport = "C:\Windows\Temp\$Comp_Name-Software.txt" # This will contain the Computer InstalledSoftware Report
Remove-Item $InstalledSoftwareReport -Force -ErrorAction SilentlyContinue #delete it if it exists from the previous run

Get-WmiObject Win32_Product  | Sort-Object Name | `
Format-Table -Wrap  Name,  Vendor, Version > C:\windows\Temp\$Comp_Name-Software.txt | Out-Null

If((Test-path $InstalledSoftwareReport)) { #if the InstalledSoftwareReport is successfully generated, mail the report.
        Send-MailMessage -SmtpServer $smtpServer -to $ToAddress -From $FromAddress -BodyAsHtml -Subject $subject -Body $body -Attachments $TxtFileName
    Remove-Item $InstalledSoftwareReport -Force -ErrorAction SilentlyContinue
       
           "The InstalledSoftwareReport is now sent to $ToAddress. Please check mail..."
 }Else {
    "InstalledSoftwareReport task failed! Please contact your administrator"
}


