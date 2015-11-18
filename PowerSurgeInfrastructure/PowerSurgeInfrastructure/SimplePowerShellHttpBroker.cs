using System.Text;
using System.Management.Automation;
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
            PowersurgeRunspace.SessionStateProxy.SetVariable("request", httpcntxt.Request); // here we are passing in the whole proper asp.net request object into the powershell runspace as '$request'. this hold post data url data and everything else.
            PowersurgeRunspace.SessionStateProxy.SetVariable("response", httpcntxt.Response); // here we are passing in the whole proper asp.net response object into the powershell runspace as '$response'. 
            PowersurgeRunspace.SessionStateProxy.SetVariable("AppDomainPath", HttpRuntime.AppDomainAppPath);
            PowersurgeRunspace.SessionStateProxy.SetVariable("Session", HttpContext.Current.Session);
            powershellInitialized =  true;
        }

        public object InvokePowerShell()
        {
            if (powershellInitialized)
            {
                PowersurgePipeline = PowersurgeRunspace.CreatePipeline();
                PowersurgePipeline.Commands.AddScript("Set-ExecutionPolicy -Scope Process -ExecutionPolicy Unrestricted"); //we need this to give the ASP.NET account script execution priveleges... do we really need this for every request???

                PowersurgePipeline.Commands.AddScript(". " + FPOfScriptToExecute);                                    //add the LeslieMVC core to be executed first..
                PowersurgePipeline.Commands.AddScript("Incoming-Request");            //call the Incoming-Request function to route and render the request. Please note that the $request variable in setupLeslieMVCRunspace() is passing in the rawURL value behind the scenes!. see the Incoming-Request function for more details.

                StringBuilder HTMLOutput = new StringBuilder();
                var results = PowersurgePipeline.Invoke();

                foreach (PSObject obj in results)
                {
                    //join all the results from Leslie MVC, notice how each result is not being cast to string...

                    if (obj.ImmediateBaseObject.GetType().ToString() == "System.String")
                    {
                        //HTMLOutput.Append("String detected");
                        HTMLOutput.Append((string)obj.ImmediateBaseObject);
                    }
                    if (obj.ImmediateBaseObject.GetType().ToString() == "System.Int32")
                    {
                        //HTMLOutput.Append("int detected");
                        HTMLOutput.Append((int)obj.ImmediateBaseObject);
                    }
                }
                return HTMLOutput;
            }
            else
            {
                throw new System.Exception(
                    "Please call SimplePowerShellHttpBroker.initializeEnvironment before invoking the script.");
            }
           
        }
    }
}