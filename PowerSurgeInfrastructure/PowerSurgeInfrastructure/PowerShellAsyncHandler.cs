using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;

namespace PowerSurgeInfrastructure
{
    public class PowerShellAsyncHandler : HttpTaskAsyncHandler
    {
        public override Task ProcessRequestAsync(HttpContext context)
        {
            IPowerShellHttpBroker psBroker = new SimplePowerShellHttpBroker(HttpRuntime.AppDomainAppPath + @"PowerSurgeMVC\PowerSurgeMVC\core\init.ps1");

            psBroker.initializeEnvironment(context);
            context.Response.ContentType = "text/html";
            return Task.Factory.StartNew(() => { context.Response.Write(psBroker.InvokePowerShell(context)); });
            
           
           //context.Response.Write(DateTime.Now.ToString());
        }
    }
}