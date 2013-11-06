# JazzHands
# Author: Jeremy Brayton
# Created: 11/05/2013 @ 9:32PM

# Describe the problem
# ---
# Write a program that prints the numbers from 1 to 100. 
# But for multiples of three print "Jazz" instead of the number and for the multiples of five print "Hands".
# For numbers which are multiples of both three and five print "JazzHands".
# ---

# To check our work, we want to print all numbers and the output in a CSV format to have the test verify something uniform between all languages.
# This may be overkill or useless, so I'm welcoming better ideas if you have them.

$outputArray = @()

# Range it out then iterate
$range = 1..100 | ForEach-Object {
    $jazz = $_ % 3; # Multiples of 3
    $hands = $_ % 5; # Multiples of 5
    $jazzHands = $_ % 15; # Both multiples of 3 and 5
    
    # Create our custom object to handle all numbers for checking our work
    $objectOutput = New-Object PSObject -Property @{
        Number = $_
        Print = ""
    }
    if ($jazz -eq 0) {
        $objectOutput.Print = "Jazz"
    }
    if ($hands -eq 0) {
        $objectOutput.Print = "Hands"
    }
    if ($jazzHands -eq 0) {
        $objectOutput.Print = "JazzHands"
    }
    $outputArray += $objectOutput
}

$outputArray | Select-Object Number, Print | Write-Host # Because hash order isn't kept cleanly until PSv3

# This part isn't really required but I'm anal about automation
$scriptDirectory = $MyInvocation.MyCommand.Path | Split-Path
$outputDirectory = $scriptDirectory | Split-Path | Split-Path # Eww
$buildDirectory = $outputDirectory + "\build\powershell";

if(!(Test-Path -Path $buildDirectory)){
   New-Item -ItemType directory -Path $buildDirectory
}

# Pipt our array, show expected values in specified order, export to CSV without the annoying type information header and in UTF8 for portability
$outputArray | Select-Object Number, Print | Export-CSV -Path $buildDirectory\output.csv -Encoding UTF8 -NoTypeInformation