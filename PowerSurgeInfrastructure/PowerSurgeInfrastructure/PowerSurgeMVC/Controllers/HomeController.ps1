$Controller = New-Module -Name 'HomeController' {
    
    function Index {
        Render-View
    }
    
    function About {
        Render-View
    }

    Export-ModuleMember -Function 'Index', 'About'
} -AsCustomObject;
