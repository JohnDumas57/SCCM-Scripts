Param(
[Parameter(Mandatory=$True)]
[string]$ToAddress = 'firstname.lastname@yourcompany.com' # ******update this to reflect your org. set up*****
)

$smtpServer = 'yourcompany.com'
$FromAddress = 'noreply@yourcompany.com' #there should be a noreply mailbox set up in your organisation. Enter it here.

$Comp_Name = $(hostname)
$subject = "RunningProcesses Report on $Comp_Name run at $(Get-Date -format 'dd/MM/yyyy hh:mm:ss') - $((Get-Date).DayOfWeek)"
$body = "Please find the attached RunningProcesses Report from the machine $Comp_Name"

$TxtFileName = "C:\Temp\$Comp_Name-RunningProcesses.txt" #this is the txt file which will contain the RunningProcesses reports to email
Remove-Item $TxtFileName -Force -ErrorAction SilentlyContinue #delete it if it exists from the previous run

$RunningProcessesReport = "C:\Temp\$Comp_Name-RunningProcesses.txt" # This will contain the Computer RunningProcesses Report
Remove-Item $RunningProcessesReport -Force -ErrorAction SilentlyContinue #delete it if it exists from the previous run

Get-Process > C:\Temp\$Comp_Name-RunningProcesses.txt 

If((Test-path $RunningProcessesReport)) { #if the RunningProcessesReport is successfully generated, mail the report.
        Send-MailMessage -SmtpServer $smtpServer -to $ToAddress -From $FromAddress -BodyAsHtml -Subject $subject -Body $body -Attachments $TxtFileName
    Remove-Item $RunningProcessesReport -Force -ErrorAction SilentlyContinue
       
           "The RunningProcessesReport is now sent to $ToAddress. Please check mail..."
 }Else {
    "RunningProcessesReport task failed! Please contact your administrator"
}
