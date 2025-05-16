# Import the Active Directory module
Import-Module ActiveDirectory

# Get the current date in MMddyy format
$date = Get-Date -Format "MMddyy"

# Define the dynamic output folder path based on the current date
$outputFolderPath = "C:\checks\$date\"

# Ensure the directory exists (create it if it doesn't)
If (!(Test-Path -Path $outputFolderPath)) {
New-Item -Path $outputFolderPath -ItemType Directory
}

# Define the output file path
$outputFilePath = "$outputFolderPath\ActiveADUsers.csv"

# Get all enabled AD users
$users = Get-ADUser -Filter {Enabled -eq $true} -Property whenCreated, MemberOf, CanonicalName

# Create the CSV header
$output = "UserName,ActivationDate,OUPath,Groups"

# Loop through each user and collect the required data
foreach ($user in $users) {
# Get user properties
$username = $user.SamAccountName
$activationDate = $user.whenCreated.ToString("yyyy-MM-dd")
$ouPath = $user.CanonicalName -replace "/$($user.Name)$", "" # Remove the user name from the canonical name to get the OU path

# Get all groups the user is a member of
$groups = ($user.MemberOf | ForEach-Object {
(Get-ADGroup $_).Name
}) -join "|"

# Create a CSV-formatted line for the user
$output += "`n$($username),$($activationDate),$($ouPath),$($groups)"
}

# Output the results to a CSV file in the dynamic directory
$output | Out-File -FilePath $outputFilePath -Encoding utf8

# Optional: Print the file path to the console
Write-Output "CSV file created at: $outputFilePath"
