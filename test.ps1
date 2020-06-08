

#Copy the Exempted path here
$ExemptedPath = "D:\Powershell\client\packages";

#Copy the Backup Directory Path Here
$DestinationDirectory = "D:\Powershell\client\packages\BackUP";

$ExtensionType = '*.ps1';

$ErrorLog = '.\'+$(Get-Date -Format "dd-MM-yyyy HH-mm-ss")+'_Errorlog.txt';

$Drives = @(gwmi win32_logicaldisk|Select-Object -expand DeviceId);

foreach($drive in $Drives)
{
    write-host "Working on $drive";
    $FilesToCopy = @();
    $FilesToCopy = @(gci $drive -Recurse -Include $ExtensionType -ErrorAction SilentlyContinue|?{$_.FullName -notlike "*$ExemptedPath*"});
    foreach($File in $FilesToCopy)
    {
        Try
        {
        $ErrCopy = @();
        write-host "Copying $file";
        Copy-Item -Path $File -Destination $DestinationDirectory -Force -Confirm:$false -ErrorAction SilentlyContinue -ErrorVariable ErrCopy;
        if($ErrCopy.count -gt 0)
        {
            $ErrCopy|Out-string|out-file -FilePath $ErrorLog -Append -Confirm:$false -Force;
        }
        }
        Catch [System.Exception]
        {
            $_|Out-string|out-file -FilePath $ErrorLog -Append -Confirm:$false -Force;
        }   
    }
}