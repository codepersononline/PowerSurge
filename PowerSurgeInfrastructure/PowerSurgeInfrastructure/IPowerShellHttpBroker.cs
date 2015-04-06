using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Threading.Tasks;
using System.Web;


namespace PowerSurgeInfrastructure
{
    interface IPowerShellHttpBroker
    {
        void initializeEnvironment(HttpContext httpcntxt);
        object InvokePowerShell();
    }
}
