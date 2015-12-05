function Img {
param ($path)
return ("<img src=""$baseURL/LeslieMVC/static/images/$path"">")
}

function Css {
param ($path)
return ("<link rel=""stylesheet"" href=""$baseURL/LeslieMVC/static/css/$path"">")
}

function Script {
param ($path)
return ("<script src=""$baseURL/LeslieMVC/static/scripts/$path""></script>")
}