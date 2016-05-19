
function Get-RegexValues {
# Function takes an input string that looks like a URL such as /home/aboutus and returns all values matched in the brackets '()'.
# an example would be:  
#    Get-RegexValues "cat/3333" '(cat)/(\d{4}$)'
#
# This would return an array of strings, the contents are shown below... (first value is the given string and is omitted when function returns the matches..)
#
# cat/3333 <- removed.
# cat
# 3333

param(
    [Parameter(Mandatory=$true)]
    [AllowEmptyString()]
    [string]$inputString, #inputString represents the raw string that we want to match against the given regex.
    [Parameter(Mandatory=$true)]
    [regex]$regex
)
    Write-Debug "Get-RegexValues: Entered function with `$inputString = $inputString and `$regex = $regex";

    [System.Text.RegularExpressions.Match]$matchResults = $null; # matchResults holds all the details after the given $regex (param) has been evaluated, like whether it passed or failed, and the matched groups.
    [System.Collections.ArrayList]$matchedValues = New-Object System.Collections.ArrayList; # holds all returned values that were matched in the given regular expression.
    
    $matchResults = [regex]::match($inputString,$regex);
    
    Write-Debug "Get-RegexValues: Did regex `"$regex`" match string `"$inputString`"? $($matchResults.Success)"  
    
    if($matchResults.Success) { #i.e. the regex string passed all expression tests.

        if($matchResults.Groups.Count -gt 1) {
            Write-Debug "Get-RegexValues: $($matchResults.Groups.Count) regex groups found!";
            
            return $matchResults.Groups | select -Skip 1 | % {
                $_.Captures.Value # there were matches found, so iterate over them and return them in a list.
            }
        } else { 
            #i.e the input string *exactly* matches the regex verbatim, and there were no '()' provided in the given regular expression.
            # an example of this is when the given string "dog" matches regex "dog", but not regex "(dog)".
            Write-Debug "Get-RegexValues: The given string was matched exactly, however no other values will be returned."
            return $true; #Yuck...
        }

       
         #$matchedValues.remove($inputstring) # first value is the given string and can be omitted here... might be useful to include this later on somewhere...
        return $matchedValues
    }
    Write-Debug "Get-RegexValues: Exited function.";
}