using System;
using System.Threading;
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
        bool performanceTesting = false;
        bool threadTesting = false;

        public bool IsReusable {
            // Return false in case your Managed Handler cannot be reused for another request.
            // Usually this would be false in case you have some state information preserved per request.
            get { return false; }
        }

        public void ProcessRequest(HttpContext context) {
            IPowerShellHttpBroker psBroker = new SimplePowerShellHttpBroker(HttpRuntime.AppDomainAppPath + @"PowerSurgeMVC\core\init.ps1");
       
            psBroker.initializeEnvironment(context);
            context.Response.ContentType = "text/html";
            if (threadTesting) {
                context.Response.Write("<p>ASP.NET ManagedThreadID: " + Thread.CurrentThread.ManagedThreadId + "</p>");
                context.Response.Write("<p>ASP.NET response hashcode: " + context.Response.GetHashCode() + "</p>");
            }
            if (performanceTesting)
            {
                DateTime before = DateTime.Now;
                context.Response.Write(psBroker.InvokePowerShell(context));
                TimeSpan ts = new TimeSpan();
                ts = before.Subtract(DateTime.Now);
                context.Response.Write("<br/>ASP.NET recieved powershell response in" + ts.Milliseconds);
            }
            else {
                context.Response.Write(psBroker.InvokePowerShell(context));
            }
           
            context.Response.End();
        }

        #endregion
    }
}
