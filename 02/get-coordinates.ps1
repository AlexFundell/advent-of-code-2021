[CmdletBinding()]
Param(
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string[]]$file = $(get-childitem input.txt)
)
#get coordinates from input file
$coordinates = get-content $file

#horizontal position
$h_pos = 0
#depth position 
$d_pos = 0


foreach ($coordinate in $coordinates){
    
    $distance = ($coordinate) -replace '\D+(\d+)','$1'
    $distance = $distance.trim()
    $direction = ($coordinate) -replace '\d'
    $direction = $direction.trim()

    write-verbose "going $direction by ""$distance"" units" 
 
    If ($direction -eq 'forward') {
        $h_pos = $h_pos + $distance 
    } elseif ($direction -eq 'down') {
        $d_pos = $d_pos + $distance 
    } elseif ($direction -eq 'up') {
        $d_pos = $d_pos - $distance
    }

    write-verbose "horizontal position: $h_pos"
    write-verbose "depth: $d_pos"

}

#final results
$result = $h_pos * $d_pos
"-----------------------------------------"
"Final horizontal position: $h_pos"
"Final depth: $d_pos"
"Horizontal position times Depth: $result"