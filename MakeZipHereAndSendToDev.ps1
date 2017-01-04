<#
.Synopsis
quick and zip and upload to content collection
don't judge me for bad practices - this is not a production script
#>
[System.Collections.ArrayList]$arrVersions= @()
$NewZipName = ""
$zPath = "c:\Program Files\7-Zip\7z.exe"
$curlPath = "C:\apps\Utilities\curl-7.46.0-win64\bin\curl.exe"

# Get the folder name
$NewZipName = (get-item $PSScriptRoot).Name
$NewZipName += "_v"

# find all the zip files ending with v001
ls $PSScriptRoot\* -include *_v???.zip | %{ 
    $zipName = $_.BaseName; 
    $zipNameParts  = $zipName.split('v')
    $zipVersion = $zipNameParts[1]
    $arrVersions += $zipVersion
}

$arrVersions|sort|out-null
$latestVersion = $arrVersions[$arrVersions.Count - 1]
$newVersion = ($latestVersion -as [int]) + 1
$newVersion = $newVersion.ToString("000")
$NewZipName += $newVersion + ".zip"
$NewZipFileName = "$PSScriptRoot" + "\" + "$NewZipName"

ls -path $PSScriptRoot\* -Directory | % {
    $ThemeSubDir = $_.FullName
	& $zpath a -tzip "$PSScriptRoot\$NewZipName" "$ThemeSubDir"
}
write-host "$NewZipName created"

$BbCcUrl = "https://localhost:9877/bbcswebdav/institution/ThemeFiles/"
$BbCcUrl += "$NewZipName"
write-host $BbCcUrl

& "$curlPath" -X PUT -u "administrator:password" --data-binary @$NewZipFileName $BbCcUrl --insecure
