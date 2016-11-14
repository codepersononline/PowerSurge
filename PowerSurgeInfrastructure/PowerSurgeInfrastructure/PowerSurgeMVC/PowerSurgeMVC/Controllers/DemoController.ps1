function GLOBAL:sayHello {
    "hello steve"
}
New-Alias New-Controller New-Module
$DemoController = New-Controller 'DemoController' {
param()
  
    function Index {
    param(
        [Parameter(Mandatory=$false)]
        [int] $CategoryID,
        [Parameter(Mandatory=$false)]
        [int] $BookID
    )

        return "Index function called steve with Category $CategoryID and BookID $BookID"
    }

    function Home {
        return Get-View;
    }

    function ShootArrow {
    param(
        [Parameter(Mandatory=$false)]$target,
        [Parameter(Mandatory=$false)]$distance
    ) 
		return "ShootArrow called, target is: $target, distance is: $distance";
    }
    Export-ModuleMember -Function ('Index','Home','ShootArrow')
} -AsCustomObject

   

