# Prompts you for the directory path
# I commented out logging because i feel like it defeats the purpose of this script, how ever I may want to use it again someday
$directoryPath = Read-Host "Please enter the path to the directory containing the files you want to rename"

# Checks if the directory exists
if (-Not (Test-Path -Path $directoryPath)) {
    Write-Host "The specified directory does not exist. Please check the path and try again."
    exit
}

# Define the log directory relative to the script's location and create it if it doesn't exist
#$logDirectory = Join-Path -Path $PSScriptRoot -ChildPath "random-rename-logs"
#if (-Not (Test-Path -Path $logDirectory)) {
#    New-Item -Path $logDirectory -ItemType Directory
#}

# Define the path for the log file using a timestamp
#$logFilePath = Join-Path -Path $logDirectory -ChildPath ("rename-log_" + (Get-Date -Format "yyyy-MM-dd_HH-mm-ss") + ".txt")

# Get all files in the directory
$files = Get-ChildItem -Path $directoryPath -File

# Initializes a counter for adding a sequence number to the file name
$counter = 1

foreach ($file in $files) {
    # Generate a random file name. You can adjust the length here.
    $randomNamePart = -join ((65..90) + (97..122) | Get-Random -Count 10 | ForEach-Object { [char]$_ })
    
    # Append a sequence number to the random part to ensure uniqueness
    $randomName = "$randomNamePart" + "_$counter"

    # Create the new file name with the original file extension
    $newFileName = "$randomName" + $file.Extension

    # Create the full path for the new file
    $newFilePath = Join-Path -Path $directoryPath -ChildPath $newFileName

    # Ensure the new file name does not already exist. If it does, increment the counter and try again
    while (Test-Path $newFilePath) {
        $counter++
        $randomName = "$randomNamePart" + "_$counter"
        $newFileName = "$randomName" + $file.Extension
        $newFilePath = Join-Path -Path $directoryPath -ChildPath $newFileName
    }

    # Rename the file and log the operation
    Rename-Item -Path $file.FullName -NewName $newFileName
   # $logEntry = "Renamed `"$($file.Name)`" to `"$newFileName`" on $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")"
  #  Add-Content -Path $logFilePath -Value $logEntry

    # Increment the counter for the next iteration
    $counter++
}

Write-Output "All files have been renamed. "
#Write-Output "Check the log at $logFilePath for details."