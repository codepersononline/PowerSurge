$PowerSurgeFolderPath = '..\..\..\PowerSurgeMVC'
$URL = 'http://localhost:60453'

Describe 'Static File Handlers'{

	Context 'When loading a static file' {
        $DiskPathForImages = "$PowerSurgeFolderPath\static\images"
        $DiskPathForCSS = "$PowerSurgeFolderPath\static\css"
        $DiskPathForJS = "$PowerSurgeFolderPath\static\scripts"

		Copy-Item -Path .\resources\meme.jpg -Destination $DiskPathForImages
		
        $webpage = (Invoke-WebRequest "$URL/Module/embeddedstaticfiletest")
		[xml] $HTMLNodes = $webpage.Content;

        It 'Should request the embedded_static_file_test with HTTP status code 200 OK' {
			$webpage.statusCode | Should Be '200'
		}

		It "Should check that the HTML Title tag matches 'embedded_static_file_test'"  {
            $HTMLNodes.html.head.title | Should Be 'embedded_static_file_test'
		}

        It "Should check that the HTML H1 tag matches 'embedded_static_file_test'" {
            $HTMLNodes.html.body.h1 | Should Be 'embedded_static_file_test'
        }
        
		It "Should check that the HTML img tag points to a valid resource on the server" {
            [string] $URLRelativePath = $HTMLNodes.html.body.img.src	 
            $URLRelativePath = $URLRelativePath.TrimStart('/')
			Invoke-WebRequest "$URL/$URLRelativePath" -OutFile 'TestDrive:meme.jpg'
            Test-Path 'TestDrive:meme.jpg' | Should Be $true
			#Invoke-Item 'TestDrive:meme.jpg' #UNCOMMENT TO SEE IMAGE
			#Start-Sleep 5 #THIS NEEDS TO BE HERE OTHERWISE THE THE FILE IS DELETED BEFORE THE PREVIEW IS RENDERED!
		}

        It 'Should check that the CSS file can be loaded, and the file contents is equal to SUCCESS' {
            Copy-Item -Path .\resources\test.css -Destination $DiskPathForCSS\test.css
			
			$csshref = $HTMLNodes.html.head.link |Where-Object rel -eq stylesheet | Select-Object -ExpandProperty href
            $csshref = $csshref.TrimStart('/')
			
			$cssHTTPResponse = Invoke-WebRequest "$URL/$csshref"

            $cssHTTPResponse.statusCode | Should Be '200'
            $cssHTTPResponse.content | Should Be 'SUCCESS'

		}

        It 'Should check that test.js can be loaded, and the file contents is equal to SUCCESS' {
            Copy-Item -Path .\resources\test.js -Destination $DiskPathForJS\test.js
			
            $jshref = $HTMLNodes.html.head.script.src
            $jshref = $jshref.TrimStart('/')
			
            $jsHTTPResponse = Invoke-WebRequest "$URL/$jshref"
            $jsHTTPResponse.statusCode | Should Be '200'
            $jsHTTPResponse.content | Should Be 'SUCCESS'
        }

		#Cleanup
        Remove-Item "$DiskPathForImages\meme.jpg"	
        Remove-Item "$DiskPathForCSS\test.css"	
        Remove-Item "$DiskPathForJS\test.js"	
	}
}