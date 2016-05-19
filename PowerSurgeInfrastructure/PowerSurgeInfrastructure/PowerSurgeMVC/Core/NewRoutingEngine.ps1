$DebugPreference = "Continue";
Set-StrictMode -Version 2.0
[System.Boolean]$RouteFound = $false;
[System.Boolean]$routeDebugging = $true;

function URL-Path {
param(
    [Parameter(Mandatory=$true,Position=1)]
    [regex]$RegularExpression,
    [Parameter(Mandatory=$true,Position=2)]
    [string]$Path,
    [Parameter(Mandatory=$false,Position=3)]
    [string]$Name
)
    return [tuple]::Create($RegularExpression,$Path,$Name)
}

$routes =  $(
        URL-Path "^$" "Mock/s"
    ),
    
    $(
        URL-Path -RegularExpression "dog" -Path "cat/index"
    ), 
    
    $(
        URL-Path -RegularExpression "^a$" -Path "two"
    ),

    $(
        URL-Path -RegularExpression "(cat)/(\d{4}$)" -Path "two"
    ),
    
    $(
        URL-Path -RegularExpression "(cat)/(\d{4}$)" -Path "two"
    )

    

function Input {
param(
    [Parameter(Mandatory=$true)]
    [AllowEmptyString()]
    [string]$UrlRouteToBeMatched
)
    $regexgroups = $null;   #After each URL regex in '$routes' is compared within Get-RegexValues2 below, the resulting array of values will be stored 
                            #in '$regexgroups'. However, if the '$UrlRouteToBeMatched', and the given regex is exactly the same, then a string will be returned. 
    [int]$routeNumber = 0  #variable is incremented when each route is checked below. 
                            #After the for loop finishes, the value that $routenumber holds the offset of the route that was matched 
    $routeNumber
    Write-Debug "Input: About to loop through routes and compare regexes.";
    for($routeNumber; $routeNumber -lt $routes.Count; $routeNumber++) { #step through each element in the $routes array until we have a match, and then break out of the loop.      
        if ($script:RouteFound -eq $true) { break; }
        else { $regexgroups =  Get-RegexValues2 $UrlRouteToBeMatched $routes[$routeNumber].Item1 }
    }

    $routeNumber--

    # Please, cover your eyes for the horror below... I had some trouble passing back an object collection with only 1 element 
    # in it from 'Get-RegexValues2', so this was the best I could come up with at the time...
    
    # .. dat code smell...
    if ($script:RouteFound -eq $true) { #yeah, i could've put this section into the for loop above (in the if/else block), but i thought it would be harder to read and maintain, so i've duplicated the if statement here... :/
        if ($regexgroups.getType().Name -eq "String") {
            Write-Debug "Input: A match was found, now returning a string.";
            Get-HTMLRouteDisplay $routeNumber
        }
        elseif($regexgroups.getType().Name -eq "Object[]"){
            Write-Debug "Input: A match was found, now returning an array of values.";
            Get-HTMLRouteDisplay $routeNumber
        } else {
            Write-Error "Function Get-RegexValues2 has returned something other than a string or an array."
        }
    } else { #no route was found! better make sure that the developer knows what the fuck is going on! TODO: move into a view..
       
        Get-HTMLRouteDisplay $routeNumber
    }
}


function Get-HTMLRouteDisplay {
param(
[int]$routeOffset
)
return "<!DOCTYPE html>
       <html>
        <body>
            <table>
                <tr>
                    <td>Order</td>
                    <td>Route</td>
                    <td>Path</td>
                    <td>Match?</td>
                </th>
            $(
                for($j=0; $j -lt $routes.Count; $j++) {
                "<tr>
                    <td>$($j+1)</td>
                    <td>$($routes[$j].Item1)</td>
                    <td>$($routes[$j].Item2)</td>
                    <td>$(
                          $routeOffset
                        if($j -eq $routeOffset) {"MATCH"}
                        )</td>
                 </tr>"
                }
            )
            </table>
        <body>
       </html>" 
}


function Get-RegexValues2 {
# Function takes an input string that looks like a URL such as /home/aboutus and returns all values matched in the brackets '()'.
# an example would be:  
#    Get-RegexValues "cat/3333" '(cat)/(\d{4}$)'
#
# This would return an array of strings, the contents are shown below... 
#
# cat/3333
# cat
# 3333

param(
    [Parameter(Mandatory=$true)]
    [AllowEmptyString()]
    [string]$inputString, #inputString represents the raw string that we want to match against the given regex.
    [Parameter(Mandatory=$true)]
    [regex]$regex
)
    Write-Debug "Get-RegexValues2: Entered function with `$inputString = $inputString and `$regex = $regex";

    [System.Text.RegularExpressions.Match]$matchResults = $null; # matchResults holds all the details after the given $regex (param) has been evaluated, like whether it passed or failed, and the matched groups.
    [System.Collections.ArrayList]$matchedValues = New-Object System.Collections.ArrayList; # holds all returned values that were matched in the given regular expression.
     
    $matchResults = [regex]::match($inputString,$regex);
    
    Write-Debug "Get-RegexValues2: Did regex `"$regex`" match string `"$inputString`"? $($matchResults.Success)"  
    
    if($matchResults.Success) { #i.e. the regex string passed all expression tests.
            $script:RouteFound = $true;
            Write-Debug "Get-RegexValues2: $($matchResults.Groups.Count) regex groups found!";
            
            #$matchResults.Groups.Count is the number of groups in the collection .
            for($i=0; $i -lt $matchResults.Groups.Count; ++$i) { #for each match...
                $matchedValues.Add($matchResults.Groups[$i].Captures.Value) | Out-Null;
            }

            return $matchedValues;
    }

    Write-Debug "Get-RegexValues2: Exited function.";
}

function get-404 {
    if($routeDebugging) {
    return
    }
}

#--------------------------------------------
cls
#Input "cat/4444" 

#$RouteFound = $false
Input "dog"

#$RouteFound = $false

#Input "cat/111d1"


#---------------------------------------------- is this needed below..?-----------

<#
function Route-NewRequest {
param([string]$IncomingURL)
	$IncomingURL = $IncomingURL.Substring(1) #trim the first forward slash off the url string.
    $IncomingURLParts = $IncomingURL.Split('/'); #explode the given url into a string array.
	 $controllerSearchString = $IncomingURLParts[0] + "Controller.ps1"
#find the controller...
$fileControllerInfo = ls $LeslieAppBasePath\Controllers -Recurse -Filter $controllerSearchString -ErrorAction SilentlyContinue -Force |  select BaseName,Fullname,Name -First 1
. $fileControllerInfo.FullName
return $homeController.Index()
}

#>