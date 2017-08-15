$Controller = New-Module -Name 'SamplesController' {

	function Index {
	 "Samples Controller Index"
	}

	function Map {
		Render-PartialView
	}

	Function GeoJSON {
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

	Export-ModuleMember -Function *
} -AsCustomObject








