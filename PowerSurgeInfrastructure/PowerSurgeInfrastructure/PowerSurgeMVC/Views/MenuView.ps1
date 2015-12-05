@"
<nav id="nav">
  <ul id="menu">
    <li><a href="/Mock/SimpleForm">A simple Form!</a></li>
    <li><a href="/Mock/ShowAjaxForm">An AJAX Form using POST</a></li>
	<li><a href="/Blog">Blog</a></li>
    <li><a href="#">$($blogController.Steve)</a></li>
$(
	for($i = 0; $i -lt 3;$i++) {
		'<li><a href="#">dynamically generated</a></li>'
	}
)<li><a href="/Mock/Login">Login</a></li>
</ul>
</nav>
"@