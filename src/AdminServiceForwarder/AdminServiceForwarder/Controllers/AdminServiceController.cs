using AdminServiceForwarder.Models;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Text;
using System.Web.Http;
using System.Web.Http.Results;


namespace AdminServiceForwarder.Controllers
{
    [Route("[controller]")]
    public class AdminServiceController : ApiController
    {
        private AdminServiceHttpRequest _adminServiceRequest;
        public AdminServiceController()
        {
            
        }

        [Route("{*adminServiceGetAll}")]
        public HttpResponseMessage Get(string adminServiceGetAll)
        {
            _adminServiceRequest = new AdminServiceHttpRequest(User, Request.GetQueryNameValuePairs());
            _adminServiceRequest.UrlPath = adminServiceGetAll;
            var json = _adminServiceRequest.InvokeWebRequest();
            var response = Request.CreateResponse(HttpStatusCode.OK);
            response.Content = new StringContent(json, Encoding.UTF8, "application/json");
            return response;
        }
        [Route("{*adminServiceGetAll}")]
        [HttpPost]
        public async System.Threading.Tasks.Task<HttpResponseMessage> PostAsync(string adminServiceGetAll)
        {
            string strBody = "";
            strBody = await Request.Content.ReadAsStringAsync();
            var ct = Request.Content.Headers.ContentType;
            _adminServiceRequest = new AdminServiceHttpRequest(User, Request.GetQueryNameValuePairs());
            _adminServiceRequest.UrlPath = adminServiceGetAll;
            _adminServiceRequest.Body = strBody;
            if(ct != null)
            {
                _adminServiceRequest.ContentType = ct.ToString();
            }
            
            _adminServiceRequest.Method = "POST";
            var json = _adminServiceRequest.InvokeWebRequest();
            var response = Request.CreateResponse(HttpStatusCode.OK);
            response.Content = new StringContent(json, Encoding.UTF8, "application/json");
            return response;
        }
        [Route("{*adminServiceGetAll}")]
        [HttpDelete]
        public HttpResponseMessage Delete(string adminServiceGetAll)
        {
            

            _adminServiceRequest = new AdminServiceHttpRequest(User, Request.GetQueryNameValuePairs());
            _adminServiceRequest.UrlPath = adminServiceGetAll;
            _adminServiceRequest.Method = "DELETE";

            var json = _adminServiceRequest.InvokeWebRequest();
            var response = Request.CreateResponse(HttpStatusCode.OK);
            response.Content = new StringContent(json, Encoding.UTF8, "application/json");
            return response;
        }
        [Route("{*adminServiceGetAll}")]
        [HttpPut]
        public async System.Threading.Tasks.Task<HttpResponseMessage> PutAsync(string adminServiceGetAll)
        {
            string strBody = "";
            strBody = await Request.Content.ReadAsStringAsync();
            var ct = Request.Content.Headers.ContentType;

            _adminServiceRequest = new AdminServiceHttpRequest(User, Request.GetQueryNameValuePairs());
            _adminServiceRequest.UrlPath = adminServiceGetAll;
            _adminServiceRequest.Body = strBody;
            if (ct != null)
            {
                _adminServiceRequest.ContentType = ct.ToString();
            }
            _adminServiceRequest.Method = "PUT";
            var json = _adminServiceRequest.InvokeWebRequest();
            var response = Request.CreateResponse(HttpStatusCode.OK);
            response.Content = new StringContent(json, Encoding.UTF8, "application/json");
            return response;
        }
        [Route("{*adminServiceGetAll}")]
        [HttpPatch]
        public async System.Threading.Tasks.Task<HttpResponseMessage> PatchAsync(string adminServiceGetAll)
        {
            string strBody = "";
            strBody = await Request.Content.ReadAsStringAsync();
            var ct = Request.Content.Headers.ContentType;

            _adminServiceRequest = new AdminServiceHttpRequest(User, Request.GetQueryNameValuePairs());
            _adminServiceRequest.UrlPath = adminServiceGetAll;
            _adminServiceRequest.Body = strBody;
            if (ct != null)
            {
                _adminServiceRequest.ContentType = ct.ToString();
            }
            _adminServiceRequest.Method = "PATCH";
            var json = _adminServiceRequest.InvokeWebRequest();
            var response = Request.CreateResponse(HttpStatusCode.OK);
            response.Content = new StringContent(json, Encoding.UTF8, "application/json");
            return response;
        }
    }
}
