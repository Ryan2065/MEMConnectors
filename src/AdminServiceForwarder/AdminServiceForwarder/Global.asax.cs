using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;
using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;
using Serilog;

namespace AdminServiceForwarder
{
    public class WebApiApplication : System.Web.HttpApplication
    {
        protected void Application_Start()
        {
            AreaRegistration.RegisterAllAreas();
            GlobalConfiguration.Configure(WebApiConfig.Register);
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);

            var logFile = HttpRuntime.AppDomainAppPath + "AdminServiceForwarder.log";
            Log.Logger = new LoggerConfiguration()
                .WriteTo.File(logFile, rollingInterval: RollingInterval.Day, shared: true)
                .CreateLogger();
            Log.Information("Starting up");
        }
    }
}
