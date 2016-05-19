$routes = @(
    @('([0-9])/([a-z])', $DemoController.Index),
    @('Home', $DemoController.Home),
    @('Index/([0-9]){3}/([0-9]){2}', $DemoController.Index),
    @('Shoot/([0-9])/([0-9])',$DemoController.ShootArrow)
)