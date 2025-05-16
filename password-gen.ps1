# Set working directory
$scriptPath = "C:\scripts"
Set-Location $scriptPath

# Load words from file
$wordList = Get-Content "$scriptPath\wordlist.txt"

if ($wordList.Count -lt 3) {
    Write-Error "Not enough words in wordlist.txt. Need at least 3."
    exit
}

function Get-RandomPassword {
    $words = Get-Random -InputObject $wordList -Count 3
    $first = ($words[0].Substring(0,1).ToUpper()) + $words[0].Substring(1)
    $password = "$first-$($words[1])-$($words[2])-" + (Get-Random -Minimum 100 -Maximum 1000)
    return $password
}

# Default to 1 password unless user provides a number as an argument
$numberToGenerate = 1
if ($args.Count -gt 0 -and ($args[0] -as [int])) {
    $numberToGenerate = [int]$args[0]
}

1..$numberToGenerate | ForEach-Object {
    Write-Output (Get-RandomPassword)
}
