# Chapter 01 - Designing for a Distributed World

1. What is distributed computing?

Distributed computing is a term used to describe the many machines that provide the architecture for applications and services.

2. Describe the three major composition patterns in distributed computing.

A server tree is a pattern where a group of connected servers where one server is the root and branch off into parent servers and leaf servers. Used for large datasets, each server holds a fraction of the dataset. 

A server with multiple backends is a pattern where a server deconstructs a query into multiple independent queries which are then sent to a number of backend servers where the responses are then combined for the response. The work is done in parallel which helps with latency management.

A load balancer with multiple backend replicas is a pattern where requests are sent to the load balancer server which then forwards the requests to a selected backend which may be based on various criteria, such as load. The response is then sent back to the load balancer server and then to the requester. 

3. What are the three patterns discussed for storing state?

State can be stored on an individual machine which is limited by its' processing power and storage. Instead, state can also be stored as shards of the whole on various machines which helps with storage, but it is possible to make an outdated read while all the machines are updating. The simplest pattern is where a root server manages requests and retrieves state by making a request to the shard with the specified state. 

4. Sometimes a master server does not reply with an answer but instead replies with where the answer can be found. What are the benefits of this method?

The size of the response may overload the master server. Thus, the master server will reply with where the answers can be be as opposed to the master receiving and relaying the entire answer.

5. Section 1.4 describes a distributed file system, including an example of how reading terabytes of data would work. How would writing terabytes of data work?

The user makes a write request which is sent to the master server. If the write request is an update, the master server will determine which shard contains the information to be updated and forwards the requests to that shard. If the write requests is new information, the master server will determine which shard has storage and forwards that requests to that shard.

6. Explain each component of the CAP Principle. (If you think the CAP Principle is awesome, read “The Part-Time Parliament” (Lamport & Marzullo 1998) and “Paxos Made Simple” (Lamport 2001).)

The CAP Principle stands for consistency, availability, and partition resistance. Consistency means all nodes or replicas can access the same data at the same time. Availability means the system is always active, meaning there is always a response to every request. Partition resistance means the system can still function despite partial failure of the system. 

7. What does it mean when a system is loosely coupled? What is the advantage of these systems?

A loosely coupled system is a system where each of its' components are separated and has no internal knowledge of the others. This allows replacement of components or subsystems that perform the same function despite having a different interface or implementation. 

8. How do we estimate how fast a system will be able to process a request such as retrieving an email message?

The speed of a transaction such as retrieving an email message can be estimated using the distance from the user to the datacenter and the number of disk seeks required to find the email message.

9. In Section 1.7 three design ideas are presented for how to process email deletion requests. Estimate how long the request will take for deleting an email message for each of the three.

One design idea is to contact the server and delete the message from the storage system and index. Depending on distance between the user and datacenter, the request itself may take up to 150ms to send and receive a response. An index lookup would be required to search for the email to delete which would take 30ms. 

The second design idea is to have the storage system mark the message as deleted in the index. 

The third design idea is to have an asynchronous design where the client sends the request to the server and control returns back to the user despite the request not being completed.
