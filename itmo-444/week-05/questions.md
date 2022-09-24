# Chapter 2 Designing for Operations

Place your answers below each question.  Answer are found directly in the text.

1. Why is design for operations so important?

Software development is usually more focused on developing user features rather than for operations. Functions in the infrastructure life cycle, such as configuration or debugging tools, which help with operational tasks are usually left out until needed. As such, it is important to design for operations, especially from the beginning, in order to help automate tasks and help operations run more smoothly. 

2. How is automated configuration typically supported?

Automated configuration is typically supported through generating a text file, which are easy to parse and archive, and analyzed with text comparison tools.

3. List the important factors for redundancy through replication.

Redundancy, where data is stored on multiple machines and able to be accessed, is supported through replication where there multiple copies of a service that share and produce the same data. To further support redundancy, having multiple replicas allows for operations to continue even if one machine or service fails. 

4. Why might you not want to solve an issue by coding the solution yourself?

It might not be a good idea to code solutions on your own because your code might not be accepted for a variety of reasons (e.g. coding standards). It also sets a bad precedent because developers will assume they do not need to work on operational feature if you are willing to work on them yourself. 

5. Which type of problems should appear first on your priority list?

All issues regarding the absence or faultly implementation of operational functions need to be prioritized. Operational features are needed to help automate tasks and help operations run more smoothly. As long as the operations team have the necessary tools, any other issues can be properly addressed.

6. Which factors can you bring to an outside vendor to get the vendor to take your issue seriously?

It may help to discuss the mutual benefits of a solution or feature may bring to your company and the vender's. It might also help to bring in the vendor and include them in the process so the vendor can understand why a particular issue needs to be addressed so the vendor can help resolve the issue while keeping their vision of their product. 
