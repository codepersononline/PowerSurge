#
# HTTPUtility.psm1
#
add-type -AssemblyName System.Web

function Encode-HTML {
param($str)
    [System.Web.HttpUtility]::HtmlEncode($str)
}

function Decode-HTML {
param($str)
    [System.Web.HttpUtility]::HtmlDecode($str)
}

function Encode-HTMLAttribute {
param($str)
    [System.Web.HttpUtility]::HtmlAttributeEncode($str)
}

function Encode-JavaScriptString {
param($str)
    [System.Web.HttpUtility]::JavaScriptStringEncode($str)
}

function Parse-QueryString {
param($str)
    [System.Web.HttpUtility]::ParseQueryString($str)
}

function Decode-URL {
param($str)
    [System.Web.HttpUtility]::UrlDecode($str)
}

function Decode-URLToBytes {
param($str)
    [System.Web.HttpUtility]::UrlDecodeToBytes($str)
}

function Encode-URL {
param($str)
    [System.Web.HttpUtility]::UrlEncode($str)
}

function Encode-URLToBytes {
param($str)
    [System.Web.HttpUtility]::UrlEncodeToBytes($str)
}

function Encode-URLUnicode {
param($str)
    [System.Web.HttpUtility]::UrlEncodeUnicode($str)
}

function Encode-URLUnicode {
param($str)
    [System.Web.HttpUtility]::UrlEncodeUnicode($str)
}

function Encode-URLUnicodeToBytes {
param($str)
    [System.Web.HttpUtility]::UrlEncodeUnicodeToBytes($str)
}

function Encode-URLPath {
param($str)
    [System.Web.HttpUtility]::UrlPathEncode($str)
}