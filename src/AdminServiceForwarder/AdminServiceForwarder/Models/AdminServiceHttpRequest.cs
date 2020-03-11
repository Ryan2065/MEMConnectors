using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Principal;
using System.Web;
using System.Net;
using System.IO;
using Serilog;

namespace AdminServiceForwarder.Models
{
    public class AdminServiceHttpRequest
    {
        private string _serverName;
        private IEnumerable<KeyValuePair<string, string>> _queryParams;
        private IPrincipal _user;
        public AdminServiceHttpRequest(IPrincipal user, IEnumerable<KeyValuePair<string,string>> queryParams)
        {
            _user = user;
            
            _serverName = System.Configuration.ConfigurationManager.AppSettings["AdminServiceServer"];
            _queryParams = queryParams;
            Method = "GET";
        }

        public string Method { get; set; }

        public string UrlPath { get; set; }

        public string Body { get; set; }

        public string ContentType { get; set; }

        private string GetUrl
        {
            get
            {
                
                string baseString = $"https://{_serverName}/{UrlPath}";
                var uriBuilder = new UriBuilder(baseString);
                var query = HttpUtility.ParseQueryString(uriBuilder.Query);
                foreach (var instance in _queryParams)
                {
                    query[instance.Key] = instance.Value;
                }
                uriBuilder.Query = query.ToString();
                return uriBuilder.ToString();
            }
        }

        public string InvokeWebRequest()
        {
            var wi = (System.Security.Principal.WindowsIdentity)_user.Identity;
            using (var wic = wi.Impersonate())
            {
                var wr = WebRequest.Create(GetUrl);
                wr.Proxy = null;
                wr.Credentials = CredentialCache.DefaultCredentials;
                wr.Method = Method;

                if(!String.IsNullOrEmpty(Body))
                {
                    Log.Information($"Found a body of {Body}");
                    var bytes = System.Text.Encoding.UTF8.GetBytes(Body);
                    wr.ContentType = "application/json";
                    if (!String.IsNullOrEmpty(ContentType))
                    {
                        wr.ContentType = ContentType;
                    }
                    wr.ContentLength = bytes.Length;
                    var wrStream = wr.GetRequestStream();
                    wrStream.Write(bytes, 0, bytes.Length);
                    wrStream.Close();
                }

                if (GetUrl.Contains("localhost"))
                {
                    ServicePointManager.ServerCertificateValidationCallback = new System.Net.Security.RemoteCertificateValidationCallback(delegate { return true; });
                }
                Log.Information($"Calling request {GetUrl}");
                using (var response = wr.GetResponse() as HttpWebResponse)
                {
                    var reader = new StreamReader(response.GetResponseStream());
                    return reader.ReadToEnd();
                }
            }

        }

    }
}