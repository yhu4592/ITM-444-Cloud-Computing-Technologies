# Exercises - Chapter 04 Application Architecture

1. Describe the single-machine, three-tier, and four-tier web application architectures in detail.

The single-machine web server application architecture is a machine with software that utilizes the HTTP protocol to receive requests, process requests, and generates a result before sending a reply. This architecture is used by many smaller-scaled applications and sites, though they are limited by the capabilities of the machine itself (e.g. CPI, memory, etc.). As the machine needs to run a web and database server, the machine will not be able to tune its' disk cache to improve I/O performance. In addition, being a single machine means if the machine fails, the application or site will be unavailable. 

The three-tier web application pattern is an architecture with three layers: a load balancer, which has multiple types, multiple replica web servers, and a data service. Requests enter the load balancer, which then forwards the request to the data service which will query to a database before the requests is sent back out through the load balancer. The three-tier architecture scales better than the single-machine as more replica web servers can be added.

The four-tier web application pattern consists of four layers: a load balancer, multiple frontends, multiple servers, and a data server. In contrast to the three-tier architecture, the frontend is separate from the server, which helps separate customer-facing interaction, procotols, an security issues though it also requires coordinated with the frontend team. As there are multiple frontends and servers, there is greater reliability. 

2. Describe how a single-machine web server, which uses a database to generate content, might evolve to a three-tier web server. How would this be done with minimal downtime?

3. Describe the common web service architectures, in order from smallest to largest (hint 4 of them remember the Cloud Scale or Cloud tier as number 4).

The single-machine web architecture is where the web and database server is run on a single machine. The three-tier web architecture is a three-layer pattern that utilizes a load-balancer which forwards requests to one-of-many backend server machines which connect to a common data service. The four-tier web architecture is a four-layer pattern that further separates the frontend where it utilizes a load-balancer which forwards the request to one-of-many frontend machines which is forwarded to their own server machines which all connect to a data service. The cloud tier utilizes one of the previous web architectures which is replicated in datacenters around the world where a global load balancer directs requests to datacenters. The cloud tier may also utilize POPs to help direct requests to help connect ISPs to datacenters.

4. Describe how different local load balancer types work and what their pros and cons are. You may choose to make a comparison chart.

| DNS Round Robin | Pros | Cons |
| ------------- | ------------- | ----- |
| Web servers receives all IPs of web servers in DNS entry and will randomly pick one. This allows are almsot even distribution under load. | Easy to implement, free, and no hardware is needed. | Difficult to control, not responsive, and DNS cache will not update immediately if a server dies |

| Layer 3 and 4 Load Balancers | Pros | Cons |
| ------------- | ------------- | ----- |

5. What is “shared state” and how is it maintained between replicas?

Shared state is the ability for replica backends to access the same information despite the requests being made to a specific backend. Shared state is maintain by storing information in a shared area that all backends can access so it doesn't matter which backend receives the request. 

6. What are the services that a four-tier architecture provides in the first tier?



7. What does a reverse proxy do? When is it needed?

A reverse proxy allows web servers to obtain content from other web servers. A reverse proxy is used in an application or services that utilizes multiple different web servers in order to make one cohesive experience for the user.  

8. Suppose you wanted to build a simple image-sharing web site. How would you design it if the site was intended to serve people in one region of the world? How would you then expand it to work globally?



9. What is a message bus architecture and how might one be used?

Message bus architecture is a many-to-many communication mechanism where servers can communicate and access information with other servers. Servers, called publishers, share information with a channel where other servers, subscribers, receive information from. 

10. Who was Christopher Alexander and what was his contribution to architecture?
