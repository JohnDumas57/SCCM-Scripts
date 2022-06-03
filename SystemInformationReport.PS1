Param(
[Parameter(Mandatory=$True)]
[string]$ToAddress = 'firstname.lastname@yourcompany' # ******update this to reflect your org. set up*****
)

$smtpServer = 'SMTPservername.yourcompany.com' #enter your company SMTP server information here
$FromAddress = 'noreply@yourcompany.com' #there should be a noreply mailbox set up in your organization. Enter it here.

$Comp_Name = $(hostname)
$subject = "SystemInformation Report on $Comp_Name run at $(Get-Date -format 'dd/MM/yyyy hh:mm:ss') - $((Get-Date).DayOfWeek)"
$body = "Please find the attached SystemInformation Report from the machine $Comp_Name"

$TxtFileName = "C:\Windows\Temp\$Comp_Name-SysInfo.txt" #this is the txt file which will contain the SystemInformation reports to email
Remove-Item $TxtFileName -Force -ErrorAction SilentlyContinue #delete it if it exists from the previous run

$SystemInformationComputerReport = "C:\Windows\Temp\$Comp_Name-SysInfo.txt" # This will contain the Computer SystemInformation Report
Remove-Item $SystemInformationComputerReport -Force -ErrorAction SilentlyContinue #delete it if it exists from the previous run

systeminfo.exe > C:\windows\Temp\$Comp_Name-SysInfo.txt | Out-Null

If((Test-path $SystemInformationComputerReport)) { #if the SystemInformationComputerReport is successfully generated, mail the report.
        Send-MailMessage -SmtpServer $smtpServer -to $ToAddress -From $FromAddress -BodyAsHtml -Subject $subject -Body $body -Attachments $TxtFileName
    Remove-Item $SystemInformationComputerReport -Force -ErrorAction SilentlyContinue
       
           "The SystemInformationComputerReport is now sent to $ToAddress. Please check mail..."
 }Else {
    "SystemInformationComputerReport task failed! Please contact your administrator"
    }