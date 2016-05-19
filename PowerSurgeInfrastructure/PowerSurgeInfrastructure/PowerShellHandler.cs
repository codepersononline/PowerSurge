using System;
using System.Web;
using System.Web.SessionState;

namespace PowerSurgeInfrastructure {
    public class PowerShellHandler : IHttpHandler, IRequiresSessionState {
        /// <summary>
        /// You will need to configure this handler in the Web.config file of your 
        /// web and register it with IIS before being able to use it. For more information
        /// see the following link: http://go.microsoft.com/?linkid=8101007
        /// </summary>
        #region IHttpHandler Members

        public bool IsReusable {
            // Return false in case your Managed Handler cannot be reused for another request.
            // Usually this would be false in case you have some state information preserved per request.
            get { return false; }
        }

        public void ProcessRequest(HttpContext context) {
            IPowerShellHttpBroker psBroker = new SimplePowerShellHttpBroker(HttpRuntime.AppDomainAppPath + @"PowerSurgeMVC\PowerSurgeMVC\core\init.ps1");
            //IPowerShellHttpBroker psBroker = new SimplePowerShellHttpBroker(@"C:\Users\steve\Documents\GitHub\PowerSurge\PowerSurgeInfrastructure\PowerSurgeInfrastructure\bbbPowershellProj\bbbPowershellProj\somescript.ps1");
            
            psBroker.initializeEnvironment(context);
            context.Response.ContentType = "text/html";
            context.Response.Write(psBroker.InvokePowerShell(context));
        }

        #endregion
    }
}
