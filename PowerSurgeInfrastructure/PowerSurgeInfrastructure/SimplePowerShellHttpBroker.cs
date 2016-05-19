using System.Text;
using System.Management.Automation;
using System.Management.Automation.Runspaces;
using System.Web;
using System.Collections;
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
            
            PowersurgeRunspace = RunspaceFactory.CreateRunspace(InitialSessionState.CreateDefault2());
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
            StringBuilder nonTerminatingErrors = new StringBuilder();
            StringBuilder HTMLOutput = new StringBuilder();

            if (powershellInitialized)
            {
                PowersurgePipeline = PowersurgeRunspace.CreatePipeline();
                PowersurgePipeline.Commands.AddScript("Set-ExecutionPolicy -Scope Process -ExecutionPolicy Unrestricted"); //we need this to give the ASP.NET account script execution priveleges... do we really need this for every request???

                PowersurgePipeline.Commands.AddScript(". " + FPOfScriptToExecute);                                    //add the LeslieMVC core to be executed first..
                PowersurgePipeline.Commands.AddScript("Incoming-Request");            //call the Incoming-Request function to route and render the request. Please note that the $request variable in setupLeslieMVCRunspace() is passing in the rawURL value behind the scenes!. see the Incoming-Request function for more details.

                try {
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
                    
                    var errorArray = (ArrayList)PowersurgeRunspace.SessionStateProxy.GetVariable("error");
                    errorArray.Reverse();


                    foreach (ErrorRecord error in errorArray)
                    {
                        nonTerminatingErrors.Append("<b>Error:</b> " + error.Exception.Message);
                        nonTerminatingErrors.Append("</br>");
                        string[] stArray = error.ScriptStackTrace.Split('\n'); // need to do this so that we can 'html encode' the stack trace string for '<scriptblock>' tags...

                        foreach (string stLine in stArray) //for all the lines in the stacktrace...
                        {
                            string encodedLine = "&emsp;" + HttpUtility.HtmlEncode(stLine) + "</br>"; //once the line has been safely converted to text, we need to append on a proper </br> tag so that the next line in the stacktrace actually jumps to the next line below...
                            nonTerminatingErrors.Append(encodedLine); //add it onto the buffered output string...
                        }

                        nonTerminatingErrors.Append("</br>");
                    }
                    // close the runspace and return the result to IIS to be transmitted back to the user. we are now done.
                    PowersurgeRunspace.Close();
                    return nonTerminatingErrors.ToString() + HTMLOutput.ToString();
                }
                catch (RuntimeException runtimeException)
                {
                    string template =
                        "<!DOCTYPE html>" +
                        "<html>" +
                            "<head>" +
                                "<meta charset=\"UTF-8\">" +
                                "<title>Title of the document</title>" +
                                "<link rel=\"stylesheet\" type=\"text/css\" href=\"http://fonts.googleapis.com/css?family=Inconsolata\">" +
                                "<link rel=\"stylesheet\" type=\"text/css\" href=\"http://fonts.googleapis.com/css?family=Courgette\">" +
                                "<style>body {background:radial-gradient(#386794,#0e1a25);margin:0px;padding:0px;min-height:1000px;} " +
                                "#content {background:white;min-height:500px;width:90%;margin: auto;border-radius:5px;padding:20px;font-family: 'Avant Garde', sans-serif;} " +
                                "h1 {font-family: 'Courgette', serif;} " +
                                "h2 {color:red;} " +
                                "#exceptionstacktrace {font-family: 'Inconsolata', serif;} " +
                                "#exceptionmessage {font-style:italic;color:#661D1F;} " +
                            "</style></head>" +
                            "<body><div id=\"content\">" +
                              "<h1>PowerSurgeMVC</h1>" +
                            "<h2>PowerShell Runtime Exception</h2>" +
                               "<h3 id=\"exceptionmessage\">Reason: " + runtimeException.Message + " </h3>" +
                               "<h4>Stack Trace:</h4>" +
                               "<p id=\"exceptionstacktrace\">" + runtimeException.ErrorRecord.ScriptStackTrace + " </p>" +
                            "</div></body>" +
                        "</html> ";

                    return template;
                }
            }
            else
            {
                throw new System.Exception(
                    "Please call SimplePowerShellHttpBroker.initializeEnvironment before invoking the script.");
            }
           
        }
    }
}