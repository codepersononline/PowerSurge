function Script:Debug($message) {
    if($AppConfig.debugging) {
        return "<p>$message</p>";
    }
}
