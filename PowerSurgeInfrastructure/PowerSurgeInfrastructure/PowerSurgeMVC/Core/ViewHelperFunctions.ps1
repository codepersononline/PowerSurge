function Img {
param ($path)
return ("<img src=""$baseURL/PowerSurgeMVC/static/images/$path"">")
}

function Css {
param ($path)
return ("<link rel=""stylesheet"" href=""$baseURL/PowerSurgeMVC/static/css/$path"">")
}

function Script {
param ($path)
return ("<script src=""$baseURL/PowerSurgeMVC/static/scripts/$path""></script>")
}