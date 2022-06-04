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
#aim 
$aim = 0

foreach ($coordinate in $coordinates){
    
    $distance = ($coordinate) -replace '\D+(\d+)','$1'
    $distance = $distance.trim()
    $direction = ($coordinate) -replace '\d'
    $direction = $direction.trim()

    

    If ($direction -eq 'forward') {
        $h_pos = $h_pos + $distance 
        If ($aim -eq 0){
            write-verbose "aim is 0, just going forward"
        }
        Else {
            $depthrate = ($aim * $distance)
            $d_pos = $d_pos + $depthrate
            write-verbose "going forward by $distance"
            write-verbose "aim is $aim, going down by $depthrate units"
        }
    } elseif ($direction -eq 'down') {
        write-verbose "aim increasing by $distance"
        $aim = $aim + $distance
        write-verbose "aim now at $aim"
    } elseif ($direction -eq 'up') {
        write-verbose "aim decreasing by $distance"
        $aim = $aim - $distance
        write-verbose "aim now at $aim"

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