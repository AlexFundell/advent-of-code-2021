[CmdletBinding()]
Param(
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string[]]$file = $(get-childitem input.txt)
)
#get coordinates from input file
$diagnostics = get-content $file


#create objects to store the bytes in
$bits = 1..12
$collection = @()

Foreach ($row in $diagnostics){
    $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12 = $row -split "\B"

    $entry = [PSCustomObject]@{
        1 = $1
        2 = $2
        3 = $3
        4 = $4
        5 = $5
        6 = $6
        7 = $7
        8 = $8
        9 = $9
        10 = $10
        11 = $11
        12 = $12
    }

    $collection += $entry
}

Foreach ($bit in $bits){
    $result = $collection.$bit | measure-object -Average | Select-Object Average

    write-verbose "average of bit #$bit is $result"
    #Check if the average is below 0.5 or above 0.5. 
    #If below, 0 is the most common bit, while if above, 1 is the most common bit.
    if ($result.Average -lt 0.5) {
        write-verbose "more 0s than 1s"
        $gamma += "0"
        $epsilon += "1"
    } elseif ($result.Average -gt 0.5){
        write-verbose "more 1s than 0s"
        $gamma += "1"
        $epsilon += "0"
    }  elseif ($result.Average -eq 0.5){
        write-verbose "equal number of 1s and 0s"
        write-verbose "inconclusive"
    } 
}

Function get-lifesupport {
    [CmdletBinding()]
    param (
        [Parameter()]
        [ValidateScript({$_ -eq "oxygen" -or "co2"})]
        $type 
    )
    write-verbose "Starting search for $type"
    #goes through the array and for each bit, filters based on the most common/uncommon bit and overwrites the array, then jumps to next bit. 

    $comparison = $collection
    foreach ($bit in $bits) { 
        write-verbose "bit #$bit"
        $filtered = $comparison.$bit | measure-object -Average | Select-Object Average
        write-verbose "average of bit #$bit is: $filtered"
        if ($filtered.Average -lt 0.5) {
            write-verbose "more 0s than 1s"
            $commonbit = "0"
            $uncommonbit =  "1"
        } elseif ($filtered.Average -ge 0.5){
            write-verbose "more 1s than 0s"
            $commonbit = "1"
            $uncommonbit = "0"
        } 

        If ($type -eq "oxygen") {
            write-verbose "filtering by $commonbit"
            $comparison = $comparison | Where-Object {$_.${bit} -eq $commonbit} 
            $count = $comparison.Count
            write-verbose "number of results: $count"
        } 
        If ($type -eq "co2"){
            write-verbose "filtering by $uncommonbit"
            $comparison = $comparison | Where-Object {$_.${bit} -eq $uncommonbit} 
            $count = $comparison.Count
            write-verbose "number of results: $count"
        }
        #if only one result remains, stop.
        If ($comparison.count -eq 1) {break}
    }

    #add the remaining bits together to get binary string
    $result = "" 
    foreach ($bit in $bits) {
        $result += $comparison.$bit
    }
    $result
    write-verbose "result for $type is: $result"
}

$oxygen = get-lifesupport -type "oxygen"
$co2 = get-lifesupport -type "co2"

#convert the binary strings to Int32 in order to get the rates in decimal to calculate power consumption
$gammarate = [convert]::ToInt32($gamma,2)
$epsilonrate = [convert]::ToInt32($epsilon,2)
$powerconsumption = $gammarate * $epsilonrate
$oxygengeneratorrating = [convert]::ToInt32($oxygen,2)
$co2scrubberrating = [convert]::ToInt32($co2,2)
$lifesupportrating = $oxygengeneratorrating * $co2scrubberrating

write-host "Gamma rate: $gammarate"
write-host "Epsilon rate: $epsilonrate"
write-host "power consumption: $powerconsumption"
write-host "Oxygen generator rating: $oxygengeneratorrating"
write-host "CO2 scrubber rating: $co2scrubberrating"
write-host "Life support rating: $lifesupportrating"
 