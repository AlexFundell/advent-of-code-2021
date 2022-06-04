[CmdletBinding()]
Param(
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string[]]$file = $(get-childitem input.txt)
)
#get input numbers
$numbers = get-content $file

#initialize counters
$i = 0
$end = $numbers.count -1
$increases = 0
$decreases = 0
$equals = 0
$initials = 0

#Loop each number and compare to previous entry
while ($i -le $end) {
    [int]$current = $numbers[$i]
    [int]$previous = $numbers[($i-1)]
    write-verbose "loop #$($i+1)"
    if ($i -eq 0){
        $result = "(N/A initial)"
        write-verbose "nothing prior to this"
        $initials++
    } elseif ($current -lt $previous) {
        $result = "(decreased)"
        write-verbose "$current is less than $previous"
        $decreases++
        write-verbose "decreases count: $decreases"
    } elseif ($current -gt $previous) {
        $result = "(increased)"
        write-verbose "$current is greater than $previous"
        $increases++
        write-verbose "increases count: $increases"
    } elseif ($current -eq $previous) {
        $result = "(equal)"
        write-verbose "$current is equal to $previous"
        $equals++
        write-verbose "$equals count: $equals"
    }
    
    #output current number and result
    "$current $result"
    $i++
}

$total = $initials+$decreases+$increases+$equals

"number of initials $initials"
"number of increases $increases"
"number of decreases $decreases"
"number of equals $equals"
"total $total"
