using System.Management.Automation.Runspaces;
using System.Web;
using System.Web.Services.Description;

namespace PowerSurgeInfrastructure
{
    class SimplePowerShellHttpBroker : IPowerShellHttpBroker
    {
        private Runspace PowersurgeRunspace { get; set; }
        private Pipeline PowersurgePipeline { get; set; }
        private string FPOfScriptToExecute { get; set; }        //File Path of powershell script to execute. 
        private bool powershellInitialized { get; set; }
        public SimplePowerShellHttpBroker(string psScriptPath)
        {
            PowersurgeRunspace = RunspaceFactory.CreateRunspace();
            FPOfScriptToExecute = psScriptPath;
        }

        public void initializeEnvironment(HttpContext httpcntxt)
        {
            PowersurgeRunspace.Open();
            PowersurgeRunspace.SessionStateProxy.SetVariable("HttpContext", httpcntxt);
            PowersurgeRunspace.SessionStateProxy.SetVariable("AppDomainPath", HttpRuntime.AppDomainAppPath);
            PowersurgeRunspace.SessionStateProxy.SetVariable("Session", HttpContext.Current.Session);
            powershellInitialized =  true;
        }

        public object InvokePowerShell()
        {
            if (powershellInitialized)
            {
                return "Fuck yeah, running powershell";
            }
            else
            {
                throw new System.Exception(
                    "Please call SimplePowerShellHttpBroker.initializeEnvironment before invoking the script.");
            }
           
        }
    }
}