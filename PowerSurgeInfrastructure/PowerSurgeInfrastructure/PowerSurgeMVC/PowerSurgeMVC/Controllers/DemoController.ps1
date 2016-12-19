function GLOBAL:sayHello {
    "hello steve"
}

$DemoController = New-Module 'DemoController' {
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

    function TestRoute {
    param(
        [Parameter(Mandatory=$false)]$a,
        [Parameter(Mandatory=$false)]$b
    ) 
		return "TestRoute called, param a is: $a, param b is: $b";
    }
    Export-ModuleMember -Function ('Index','Home','ShootArrow', 'TestRoute')
} -AsCustomObject

   

