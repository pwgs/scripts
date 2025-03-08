                                                                               #

$touchpad1 = (Get-WmiObject -Class Win32_PnPEntity | `
             Where-Object {$_.Name -eq "HID-compliant touch pad"}).DeviceID

$touchpad2 = (Get-WmiObject -Class Win32_PnPEntity | `
             Where-Object {$_.Name -eq "HID-compliant mouse" `
	     -And $_.DeviceID -Match "ELAN"}).DeviceID

$cmd1 = @("-NoProfile"
	  "-ExecutionPolicy Bypass"
          "-Command & { sc.exe config i8042prt start= disabled;"+
          "pnputil.exe /disable-device '$touchpad1';"+
	  "pnputil.exe /disable-device '$touchpad2';"+
	  "Restart-Computer -Force }"
)
$cmd2 = @("-NoProfile"
	  "-ExecutionPolicy Bypass"
          "-Command & { sc.exe config i8042prt start= auto;"+
          "pnputil.exe /enable-device '$touchpad1';"+
	  "pnputil.exe /enable-device '$touchpad2';"+
	  "Stop-Computer -Force }"
)
if ((Get-Service i8042prt).Status -ne "Stopped") {
    Start-Process powershell.exe -Verb RunAs -ArgumentList $cmd1 
} else {
    Start-Process powershell.exe -Verb RunAs -ArgumentList $cmd2
}
