class ConcreteAlbum {
    [string] $Title
}
function New-Album {
[cmdletbinding()]
param([string] $AlbumTitle)
    $a = [ConcreteAlbum]::new();
    $a.Title =$AlbumTitle;
    
    $a;
}

function Get-Album {
[cmdletbinding()]
param([string] $Title)
    
    # Get data from file or SQL DB, 
    # Otherwise construct in memory for demo purposes...
    
    $albums = New-Object System.Collections.ArrayList;
    
    $albums.Add((New-Object psobject -Property @{
        'Id'=1;
        'Title'='Clarity';
        'Artist'='Jimmy Eat World';
        'Year'=1999;
    })) | Out-Null;

    $albums.Add((New-Object psobject -Property @{
        'Id'=2;
        'Title'='Static Prevails';
        'Artist'='Jimmy Eat World';
        'Year'=1996;
    })) | Out-Null;
    
    $albums.Add((New-Object psobject -Property @{
        'Id'=3;
        'Title'='Dark Side Of The Moon';
        'Artist'='Pink Floyd';
        'Year'=1973;
    })) | Out-Null;

    $albums.Add((New-Object psobject -Property @{
        'Id'=4;
        'Title'='Animals';
        'Artist'='Pink Floyd';
        'Year'=1977;
    }))| Out-Null;

    $albums.Add((New-Object psobject -Property @{
        'Id'=5;
        'Title'='Selected Ambient Works Volume II';
        'Artist'='Aphex Twin';
        'Year'=1994;
    })) | Out-Null;
    
    # If no Album title given as a parameter, then return the entire list...
    if([string]::IsNullOrEmpty($Title)) {
        $albums;
    }
    else {  # return only the one that matches...
        , ($albums | Where-Object -Property Title -eq $Title)
    }
}

function Update-Album {
    [cmdletbinding()]
    param()
    # code not finished...
    throw [System.NotImplementedException]::new()
}

function Delete-Album {
    [cmdletbinding()]
    param()
    # code not finished...
    [System.NotImplementedException]::new()
}
Export-ModuleMember -Function *