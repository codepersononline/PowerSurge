$appconfig.UseGlobalView = $false;

$SamplesController = New-Object –TypeName PSObject;

$SamplesController | Add-Member -MemberType ScriptMethod -Name "Index" -Value {
	return "Samples Controller Index"

}

$SamplesController | Add-Member -MemberType ScriptMethod -Name "Map" -Value {
   get-View
}

$SamplesController | Add-Member -MemberType ScriptMethod -Name "GeoJSON" -Value {
    $locations = @(
        @{lat = '102.0'; lon ="-42.0"},
        @{lat = '30.0'; lon ="0.5"}
        @{lat = '20.0'; lon ="0.5"}
    )

    $RenderedJSON = ""

        $locCount = $locations.Count
        
        $i = 0
        while ($i -lt $locCount) {
            $RenderedJSON += @"
            {"type": "Feature",
                "geometry": {"type": "Point", "coordinates": [$($locations[$i].lat), $($locations[$i].lon)]},
                "properties": {"prop0": "Steve"}
            },
"@
            $i++;
        }

        $RenderedJSON += @"
            {"type": "Feature",
                "geometry": {"type": "Point", "coordinates": [$($locations[$locCount-1].lat), $($locations[$locCount-1].lon)]},
                "properties": {"prop0": "Steve"}
            }
"@

         


    return @"
      { "type": "FeatureCollection",
        "features": [
            $RenderedJSON
       ]
    }
"@
           
}



