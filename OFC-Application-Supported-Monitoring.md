# Application Supported Monitoring



# Goals

- Must be as similar as possible across applications
- Must make it easier for Site Operations, Load Balancers and Monitors to monitor the application
- Must have a minimum number of mandatory requirements
- Must be simple to implement (see above)
- Must be contained in a simple directory structure so it is easy to block from external access



# Why?

Monitoring the many applications is quite a complex task. The behaviour of most of our applications is quite complex and it is often hard to find the sweet spot to monitor. It is nearly impossible to make check hit a single URL to give an overall health of the application. These requirements have been designed to allow Site Operations to build a single monitoring check that can be used across the entire suite of applications. This way we can easily configure our LB to drop a misbehaving application server from seeing production traffic, or to automatically page a sysadmin when the application enters a degraded mode.

 

# How?

We propose a set of URLs with defined behaviours across all applications. By defining a singular set of URL SiteOps can reuse the same monitoring scripts across the whole infrastructure and development can reuse the implementation code across multiple applications (via a jar file or gem).

 

# Required Endpoints

 

| **URL**                      | **Hitrate**                          | **Purpose**                                                  |
| ---------------------------- | ------------------------------------ | ------------------------------------------------------------ |
| /diagnostic                  | ad hoc                               | Lists the health check endpoints that this application supports |
| /diagnostic/status/heartbeat | often - tied to the LB configuration | Contains no content and only returns either a 200 if the application is successfully deployed, or 500 if not<br/>This indicates that the service is installed and up and running. <br/>**This should not invoke any external dependencies.** **In AWS, the reaction to failures from this endpoint is for the ELB to terminate the instance and create a new one. <br/>If terminating the instance and creating a new one won't fix the problem, then this endpoint should continue to return 200 OK.** |
| /diagnostic/status/diagnosis | ad hoc                               | Returns a human readable message to aid diagnosis of the above error condition |
| /diagnostic/status/monitor   | every 1 minute                       | Roughly corresponds to the health check.It should be assumed that the result from this check will be sent to the on call technician. |
| /diagnostic/version          | ad hoc                               | Returns the version number of the application                |

 

# Optional Endpoints

| **URL **           | **Hitrate ** | **Purpose **                                                 |
| ------------------ | ------------ | ------------------------------------------------------------ |
| /diagnostic/config | ad hoc       | Returns the configuration settings of the application, for example the database server, the paths and such. |
| /diagnostic/host   | ad hoc       | Returns the name of the host that the service is running on  |



