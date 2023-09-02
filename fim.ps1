Function Calculate-File-Hash($filepath) {
    $filehash = Get-FileHash -Path $filepath -Algorithm SHA512
    return $filehash
}

Function Erase-Baseline-If-Already-Exists() {
    $baselinePath = ".\baseline.txt"
    if (Test-Path -Path $baselinePath) {
        Remove-Item -Path $baselinePath
    }
}

Function Validate-User-Input {
    while ($true) {
        $response = Read-Host -Prompt "Please enter 'A' or 'B'"
        if ($response -eq "A" -or $response -eq "B") {
            return $response
        }
        else {
            Write-Host "Invalid input. Please enter 'A' or 'B'."
        }
    }
}

Write-Host ""
Write-Host "What would you like to do?"
Write-Host ""
Write-Host "    A) Collect new Baseline?"
Write-Host "    B) Begin monitoring files with saved Baseline?"
Write-Host ""

$response = Validate-User-Input
Write-Host ""

if ($response -eq "A") {
    # Delete baseline.txt if it already exists
    Erase-Baseline-If-Already-Exists

    # Calculate Hash from the target files and store in baseline.txt
    $baselinePath = ".\baseline.txt"
    $files = Get-ChildItem -Path .\Files

    # Initialize an empty dictionary to store file hashes
    $fileHashDictionary = @{}

    foreach ($f in $files) {
        $hash = Calculate-File-Hash $f.FullName
        $fileHashDictionary[$f.Name] = $hash.Hash
    }

    # Save the file hash dictionary to baseline.txt
    $fileHashDictionary.GetEnumerator() | ForEach-Object {
        $_.Key + "|" + $_.Value
    } | Out-File -FilePath $baselinePath -Encoding UTF8
}
elseif ($response -eq "B") {
    $baselinePath = ".\baseline.txt"
    $fileHashDictionary = @{}

    if (Test-Path -Path $baselinePath) {
        # Load file|hash from baseline.txt and store them in a dictionary
        Get-Content -Path $baselinePath | ForEach-Object {
            $parts = $_.Split("|")
            if ($parts.Length -eq 2) {
                $fileHashDictionary[$parts[0]] = $parts[1]
            }
        }
    }
    else {
        Write-Host "Baseline file not found. Please run option 'A' to create a baseline first." -ForegroundColor Yellow
        exit
    }

    while ($true) {
        Start-Sleep -Seconds 1

        $currentFiles = Get-ChildItem -Path .\Files
        $currentFileNames = $currentFiles | ForEach-Object { $_.Name }

        # Check for deleted files
        $keysToRemove = @()
        foreach ($key in $fileHashDictionary.Keys) {
            if (-not $currentFileNames.Contains($key)) {
                Write-Host "$($key) has been deleted!" -ForegroundColor DarkRed -BackgroundColor Gray
                $keysToRemove += $key
            }
        }

        foreach ($keyToRemove in $keysToRemove) {
            $null = $fileHashDictionary.Remove($keyToRemove)
        }

        # Check for new or changed files
        foreach ($f in $currentFiles) {
            $hash = Calculate-File-Hash $f.FullName
            if (-not $fileHashDictionary.ContainsKey($f.Name)) {
                Write-Host "$($f.Name) has been created!" -ForegroundColor Green
                $fileHashDictionary[$f.Name] = $hash.Hash
            } elseif ($fileHashDictionary[$f.Name] -ne $hash.Hash) {
                Write-Host "$($f.Name) has changed!!!" -ForegroundColor Yellow
                $fileHashDictionary[$f.Name] = $hash.Hash
            }
        }
    }
}
