# Script to read data from ASPS and output it to Stellarium

# Global Variables listed below! Change these as needed for your specific system

# The path to the ASPS installation folder
# default = 'C:\Program Files (x86)\PlateSolver\PlateSolver.exe'
$pathToPlateSolverExe = 'C:\Program Files (x86)\PlateSolver\PlateSolver.exe'

# The path to the folder with this script
$pathToScriptFolder = 'C:\Users\nujra\OneDrive\Desktop\plateSolvingASPS+Stellarium'

# The path to the folder with the images which will be used for analysis
# By default, is located within an 'Images' folder within the script folder
$pathToImagesFolder = $pathToScriptFolder + '\Images'


# BEGINNING OF THE SCRIPT

# If the ASPS path is different than the path specified above, the code below will prompt you to enter the
# alternative path, which will be used for the current session.

$plateSolverExePathConfirm = 'n'

while ($plateSolverExePathConfirm -eq 'n')
{
    Write-Host "Current path to plate solver: $pathtoPlateSolverExe" 
    $plateSolverExePathConfirm = Read-Host "Is this correct? [Y,n]"
    if ($plateSolverExePathConfirm = '')
    {
        $plateSolverExePathConfirm = 'y'
    }
    if ($plateSolverExePathConfirm -eq 'n')
    {
        $pathToPlateSolverExe = Read-Host "Enter the path to the plate solver software. This will only be active for the current session."
    }
}

# if the Images path is different than the path specified above, the code below will prompt you to enter
# the alternative path, which will be used for the current session.

$imagesPathConfirm = 'n'

while ($imagesPathConfirm -eq 'n')
{
    Write-Host "Current path to Images Folder: $pathToImagesFolder" 
    $imagesPathConfirm = Read-Host "Is this correct? [Y,n]"
    if ($imagesPathConfirm = '')
    {
        $imagesPathConfirm = 'y'
    }
    if ($imagesPathConfirm -eq 'n')
    {
        $pathToImagesFolder = Read-Host "Enter the path to the Images Folder. This will only be active for the current session."
    }
}

# Prompts the user to enter the name of image s/he would like to plate solve
# List of all images is provided

Write-Host "`n"
Write-Host "What is the name of the image you wish to plate solve?`nInclude the name of the file as well as the extension.`nThe following file types are supported: JPG"

Get-ChildItem $pathToImagesFolder  # Lists images for the user to choose

$imageToTest = Read-Host "Image Name"

$pathOfImageToTest = $pathToImagesFolder + '\' + $imageToTest

# The platesolver works by outputting the results to an output file. This code removes the output file if
# it already exists because we don't want to use the old data.

$pathToOutputFile = $pathToImagesFolder + '\output.txt'
$outputFileExists = Test-Path -Path $pathToOutputFile

if ($outputFileExists)
{
    rm .\Images\output.txt
}

# Executes the plate solver with the parameters provided.
# The script moves to the next section when the output file is created (meaning an output has been generated)

& $pathToPlateSolverExe /solvefile $pathOfImageToTest $pathToOutputFile 0 0

$outputFileExists = Test-Path -Path $pathToOutputFile
while (! $outputFileExists)
{
    Write-Host "The plate solver is thinking."
    Start-Sleep -Seconds 1
    $outputFileExists = Test-Path -Path $pathToOutputFile
}

# Checks if the output is a success or failure

$imageSolveSuccess = $false
$matchingResultSuccess = Get-Content -Path $pathToOutputFile -totalcount 1

Write-Host "`n"
if ($matchingResultSuccess -eq "OK")
{
    Write-Host "Success! The plate solver found a match :)"
    $imageSolveSuccess = $true
}
else
{
    Write-Host "Won won won :( - The plate solver did not find a match for your image"
}

# If the image search was successful, we want to output the results to the terminal and then launch stellarium!

if ($imageSolveSuccess)
{
    # Compiled data from the generated output file 
    $calculatedRA = (Get-Content -Path $pathToOutputFile -TotalCount 2)[-1]
    $calculatedDec = (Get-Content -Path $pathToOutputFile -TotalCount 3)[-1]
    $FOVx =  (Get-Content -Path $pathToOutputFile -TotalCount 4)[-1]
    $FOVy =  (Get-Content -Path $pathToOutputFile -TotalCount 5)[-1]
    $calculatedRotation = (Get-Content -Path $pathToOutputFile -TotalCount 7)[-1]

    # writing the data from the generated output file to the terminal window
    Write-Host "RA - " $calculatedRA
    Write-Host "Dec - " $calculatedDec
    Write-Host $FOVx,"' x ",$FOVy,"'"
    Write-Host "Rotation - " $calculatedRotation

    
}


