#see redmine Feature #50
<#
Class BusController{
[int] $speed = 50;

     [int] getSpeed() {
        return $this.speed
     }

	[int] increaseSpeed([int] $increment) {
        return $this.speed + $increment
     }
}
$BusController = 
    New-Object BusController

return $BusController

#>