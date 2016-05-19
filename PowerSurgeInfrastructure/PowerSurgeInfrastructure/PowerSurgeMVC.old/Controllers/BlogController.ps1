$BlogController = New-Object –TypeName PSObject

$BlogController | Add-Member -MemberType ScriptMethod -Name "Index" -Value { 
    #if($session['loggedin'] -eq $true) {
	
	$header = Get-View "header"
	$menu = Get-View "menu"

    if(Authorized "Administrator", "Super User") {
		$posts = $blogRepository.Get3MostRecentPosts();
		$mystring = ''	
	
		foreach($post in $posts) { $mystring += "<h3><a href=""$baseURL/Blog/Post/$($post.id)"" >$($post.article_title)</a></h3>"; }
	
		$response = "<div id=""content"">
			<h1>Welcome to your blog!</h1>
			<p>Here are the 3 most recent articles...</p>
			$mystring
		</div>"
	}
	else {
		$response = "<div id=""content"">Only Administrators and Super Users can view the blog section of this site.</div>"
	}
	$footer = Get-View "footer"
	return $header + $menu + $response + $footer;
}

$BlogController | Add-Member -MemberType ScriptMethod -Name "Post" -Value { 
param(
	[int]$postID = 0
)
	$header = Get-View "header"
	$menu = Get-View "menu"

	if(Authorized "Administrator", "Super User") {
		$post = $blogRepository.GetPost($postID);
	
		if ($post -eq $null) { $response = '<div id="content">No post with the given article ID could be found.</div>' }	
		else {$response = "<div id=""content"">
						<h2> $($post.article_title)</h2>
						 <p>Published: $($post.date_published) <br />
						Author: $($post.article_author)</p>
						<p> $($post.article_body)</p></div>"
		}
	}
	else { #i.e user is not authorised!
		$response = '<div id="content">Only Administrators and Super Users can view the blog section of this site.</div>';
	}

	$footer = Get-View 'footer'
    return $header + $menu + $response + $footer;
} 

return $BlogController;