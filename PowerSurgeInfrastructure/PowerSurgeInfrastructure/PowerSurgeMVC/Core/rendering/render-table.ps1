$myarr = @(("name","total", "average"),
([string]"Jack","40", "20"),
([string]"Sam","37", "32"),
([string]"Toby","25", "20"))

function Create-HTMLTable {
param ([string[]]$2DArray)

    $numColumns = $2DArray[1].Length;
    $numRows = $2DArray.Length;

    #$numColumns;
   # $numRows;

    $table = "<table>
    <th>"
        for($i = 0; $i -lt $2DArray[0].Length; ++$i){
            $table = [string]::Concat($table, "<td>$($2DArray[0][$i])</td>");
        }
    $table = [string]::Concat($table,"</th>");
    $offset = 1;
    for($j = $offset; $j -lt $2DArray.Length; ++$j) {
        #$table = [string]::concat($table, "<tr>$($2DArray[$j][0])</tr>");
       ([string] $2DArray[$j][1]).Length
       #foreach($chunk in $2DArray){
       # $chunk[1]
       #}
        
    }
    #return $table;
}
Create-HTMLTable $myarr