$BlogRepository = New-Object –TypeName PSObject

$BlogRepository | Add-Member -MemberType ScriptMethod -Name "GetPost" -Value { 
    param( $postID )
	
	return (Invoke-SQL -sqlCommand "SELECT * from dbo.Articles where dbo.Articles.id = $postID")
}

$BlogRepository | Add-Member -MemberType ScriptMethod -Name "Get3MostRecentPosts" -Value { 
	return (Invoke-SQL -sqlCommand "SELECT TOP 3 * from dbo.Articles order by date_published desc")
}
