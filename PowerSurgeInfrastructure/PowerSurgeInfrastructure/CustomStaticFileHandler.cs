using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.IO;

namespace PowerSurgeInfrastructure
{
    public class CustomStaticFileHandler : IHttpHandler
    {
        public CustomStaticFileHandler() { }
        bool IHttpHandler.IsReusable
        {
            get
            {
                return false;
            }
        }

        void IHttpHandler.ProcessRequest(HttpContext context)
        {
            string fileExtention = Path.GetExtension(context.Request.PhysicalPath);
            
            if(fileExtention == ".ps1" || fileExtention == ".psm1" || fileExtention == ".psd1") {
                context.Response.StatusCode = 403;
            }
            else {
                context.Response.ContentType = getContentType(fileExtention);
                context.Response.WriteFile(context.Request.PhysicalPath);
                context.Response.End();
            }
        }

        string getContentType(String extension) {
            switch (extension) {
                case ".bmp": return "Image/bmp";
                case ".gif": return "Image/gif";
                case ".jpg": return "Image/jpeg";
                case ".png": return "Image/png";
                case ".js": return "text/javascript;charset=UTF-8";
                case ".css": return "text/css;charset=UTF-8";
                default: break;
            }
            return "text/html";
        }
    }
}