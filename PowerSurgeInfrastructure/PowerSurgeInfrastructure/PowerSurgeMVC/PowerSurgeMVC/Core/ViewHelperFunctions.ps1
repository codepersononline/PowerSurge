function Img {
param ([string] $path)
	return ("<img src=""$baseURL/PowerSurgeMVC/PowerSurgeMVC/static/images/$path"">")
}

function Css {
param ([string] $path)
	return ("<link rel=""stylesheet"" href=""$baseURL/PowerSurgeMVC/PowerSurgeMVC/static/css/$path"">")
}

function Script {
param ([string] $path)
	return ("<script src=""$baseURL/PowerSurgeMVC/PowerSurgeMVC/static/scripts/$path""></script>")
}