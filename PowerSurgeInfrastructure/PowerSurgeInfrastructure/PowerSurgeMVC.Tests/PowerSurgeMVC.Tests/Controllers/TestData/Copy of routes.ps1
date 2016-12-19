$routes = @(
    @('^insertcustomheader/([a-z].*)/([a-z].*)', $CustomHeaderController.'Insert-CustomHeader'),
    @('([0-9])/([a-z])$', $DemoController.Index),
    @('Home', $DemoController.Home),
    @('Index/([0-9]{3})/([0-9]{2})', $DemoController.Index),
    @('Shoot/([0-9])/([0-9])',$DemoController.ShootArrow),
    @('Performance/FastRequest',$PerformanceController.FastRequest),
    @('Performance/SlowRequest/([0-9]{2})',$PerformanceController.SlowRequest)
)

function Get-Routes() {
	return $routes;
}