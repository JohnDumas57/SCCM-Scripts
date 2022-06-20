$Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Printers\PointAndPrint"
If((Get-ItemPropertyValue -Path $Path -Name NoWarningNoElevationOnInstall -ErrorAction SilentlyContinue) -eq "1"){
    Set-ItemProperty -Path $Path -Name NoWarningNoElevationOnInstall -Value 0
}
If((Get-ItemPropertyValue -Path $Path -Name UpdatePromptSettings -ErrorAction SilentlyContinue) -eq "1"){
    Set-ItemProperty -Path $Path -Name UpdatePromptSettings -Value 0
}
