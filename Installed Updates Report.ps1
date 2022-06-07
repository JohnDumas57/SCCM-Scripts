Param(
[Parameter(Mandatory=$True)]
[string]$ToAddress = 'firstname.lastname@yourcompany' # ******update this to reflect your org. set up*****
)

$smtpServer = 'yourcompany.com'          # ******update this to reflect your org. set up*****

$FromAddress = 'noreply@yourcompany.com' #there should be a noreply mailbox set up in your organisation. Enter it here.

$Comp_Name = $(hostname)
$subject = "InstalledUpdates Report on $Comp_Name run at $(Get-Date -format 'dd/MM/yyyy hh:mm:ss') - $((Get-Date).DayOfWeek)"
$body = "Please find the attached InstalledUpdates Report from the machine $Comp_Name"

$TxtFileName = "C:\Temp\$Comp_Name-InstalledUpdates.txt" #this is the txt file which will contain the InstalledUpdates reports to email
Remove-Item $TxtFileName -Force -ErrorAction SilentlyContinue #delete it if it exists from the previous run

$InstalledUpdatesComputerReport = "C:\Temp\$Comp_Name-InstalledUpdates.txt" # This will contain the Computer InstalledUpdates Report
Remove-Item $InstalledUpdatesComputerReport -Force -ErrorAction SilentlyContinue #delete it if it exists from the previous run

Get-Hotfix  > C:\Temp\$Comp_Name-InstalledUpdates.txt 

If((Test-path $InstalledUpdatesComputerReport)) { #if the InstalledUpdatesComputerReport is successfully generated, mail the report.
        Send-MailMessage -SmtpServer $smtpServer -to $ToAddress -From $FromAddress -BodyAsHtml -Subject $subject -Body $body -Attachments $TxtFileName
    Remove-Item $InstalledUpdatesComputerReport -Force -ErrorAction SilentlyContinue
       
           "The InstalledUpdatesComputerReport is now sent to $ToAddress. Please check mail..."
 }Else {
    "InstalledUpdatesComputerReport task failed! Please contact your administrator"
    }