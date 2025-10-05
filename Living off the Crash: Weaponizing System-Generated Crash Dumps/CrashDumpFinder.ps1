#Hex encoded crash dump file signatures
#https://github.com/volatilityfoundation/volatility/wiki/Crash-Address-Space
$headerSignatures = @{
    '5041474544554D50' = 'KernelDump (PAGEDUMP - 32-bit)'
    '5041474544553634' = 'KernelDump (PAGEDU64 - 64-bit)'
    '4D444D50'          = 'UserDump (MDMP)'
}

$results = @()
#Loop through all local drives
Get-PSDrive -PSProvider FileSystem | ForEach-Object {
    #Search file system of each drive looking for header signatures
    Get-ChildItem -Path $_.Root -File -Recurse -ErrorAction SilentlyContinue | ForEach-Object {
        try {
            $bytes = New-Object byte[] 8
            $fileStream = [System.IO.File]::Open($_.FullName, 'Open', 'Read', 'ReadWrite')
            $fileStream.Read($bytes, 0, 8) | Out-Null
            $fileStream.Close()

            $fileHex = ($bytes | ForEach-Object { $_.ToString('X2') }) -join ''

            #Append results if signatures match
            foreach ($sig in $headerSignatures.Keys) {
                if ($fileHex.StartsWith($sig)) {
                    $results += [PSCustomObject]@{
                        Path     = $_.FullName
                        SizeMB   = [math]::Round($_.Length / 1MB, 2)
                        Modified = $_.LastWriteTime
                        Type     = $headerSignatures[$sig]
                    }
                    break
                }
            }
        } catch {}
    }
}

#Output results
$results | Sort-Object Type | Format-Table -AutoSize -Wrap
