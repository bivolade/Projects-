# AWS Cloud Infrastructure & Security — WinLocal Giveaways

## Project Overview

This project involved designing and implementing a secure, scalable and cost-effective cloud infrastructure for a fictional company called WinLocal Giveaways using Amazon Web Services (AWS).

The aim was to demonstrate how AWS could be used to host a web application while improving network security, availability and infrastructure management.

I developed a Proof of Concept (PoC) that included a Virtual Private Cloud (VPC), EC2 instances, an Application Load Balancer, Auto Scaling, an RDS MySQL database and an Amazon S3 backup website.

## Project Objectives

- Design a secure AWS network architecture.
- Separate public-facing services from private application and database resources.
- Configure controlled administrative access using a bastion host.
- Implement load balancing and automatic scaling.
- Deploy a private MySQL database.
- Create a static backup website using Amazon S3.
- Consider additional security measures and cost optimisation.

## Technologies Used

| Technology | Purpose |
|---|---|
| AWS VPC | Network isolation and subnet management |
| Amazon EC2 | Hosting web servers and bastion host |
| Application Load Balancer | Distributing incoming web traffic |
| EC2 Auto Scaling | Managing web server capacity |
| Amazon RDS (MySQL) | Private relational database |
| Amazon S3 | Static backup website |
| AWS Security Groups | Controlling inbound and outbound traffic |
| Amazon Machine Images (AMI) | Creating reusable web server configurations |
| Apache and PHP | Web server environment |
| SSH | Secure administrative access |

## Implementation

### 1. Network Architecture

I created a VPC containing six subnets across two AWS Availability Zones:

- Two public subnets for the bastion host and Application Load Balancer.
- Two private application subnets for EC2 web servers.
- Two private database subnets for Amazon RDS.

This architecture separates internet-facing resources from internal infrastructure.

### 2. Bastion Host and Network Security

I deployed a bastion host in a public subnet to provide administrative SSH access to private EC2 instances.

I configured security groups to restrict access:

- SSH access to the bastion host was restricted to my authorised IP address.
- Web servers accepted HTTP traffic from the load balancer security group.
- SSH access to the web servers was permitted from the bastion security group.
- The database accepted MySQL connections on port 3306 only from the web server security group.

These configurations demonstrate network segmentation and the principle of least privilege.

### 3. Web Server and Load Balancing

I installed Apache and PHP on an EC2 instance and created a custom Amazon Machine Image (AMI).

I configured an internet-facing Application Load Balancer to direct incoming traffic to the web server.

Testing confirmed that the web server was accessible through the load balancer's DNS address and that the registered EC2 instance reported a healthy status.

### 4. Auto Scaling

I configured an EC2 Auto Scaling group with the following capacity settings:

- Minimum instances: 1
- Desired instances: 1
- Maximum instances: 2
- Target CPU utilisation: 60%

The scaling policy was configured to adjust capacity according to CPU demand, helping balance availability and resource costs.

### 5. Private MySQL Database

I deployed an Amazon RDS MySQL database using a `db.t4g.micro` instance.

The database was configured without public accessibility and placed within a database subnet group containing two private subnets.

Its security group restricted MySQL access to the application servers.

### 6. Static Backup Website

I created an Amazon S3 static website displaying a maintenance message when the main application is unavailable.

The backup page was successfully hosted on S3.

Automatic failover using Amazon Route 53 was proposed as a future enhancement but was not implemented in the Proof of Concept.

## Additional Security Recommendations

I investigated two AWS services that could further improve the infrastructure.

**AWS WAF:** Could help protect the web application against common web attacks, including SQL injection and cross-site scripting.

**Amazon GuardDuty:** Could help detect suspicious AWS activity and potential security threats.

These services were researched and recommended but were not deployed because of the project's budget and scope.

## Project Results

The Proof of Concept demonstrated:

- A VPC with six public and private subnets.
- A functioning bastion host with restricted SSH access.
- A working web server accessible through an Application Load Balancer.
- A healthy EC2 target registered with the load balancer.
- An Auto Scaling group with a CPU-based scaling policy.
- A private RDS MySQL database.
- A working S3-hosted backup webpage.
- Security group rules restricting access between infrastructure components.

The project demonstrated how cloud networking, access controls and scalable infrastructure can be combined to support a more secure application environment.

## My Contribution

I was responsible for designing the AWS architecture, configuring the VPC and subnets, deploying the EC2 infrastructure, creating the custom AMI, setting up the load balancer and Auto Scaling group, configuring security groups, deploying the RDS database and creating the S3 backup website.

I also documented the implementation through screenshots, evaluated additional security services and considered ways to reduce infrastructure costs.

## Skills Demonstrated

- AWS cloud infrastructure deployment
- Network architecture and subnetting
- Cloud security and access control
- Linux server administration
- Load balancing and Auto Scaling
- Database network security
- Technical troubleshooting
- Infrastructure documentation
- Cost-aware cloud design

## Project Evidence

The full project report contains the AWS architecture diagram, implementation screenshots, configuration details and testing evidence.

**Project report:** To be added to this repository.

## Future Improvements

- Implement AWS WAF for additional web application protection.
- Enable Amazon GuardDuty for threat detection.
- Configure Route 53 health checks and automatic failover.
- Investigate Multi-AZ RDS deployment for improved database availability.
- Add more extensive monitoring and infrastructure testing.

---

*Academic cloud infrastructure project completed as part of my Cybersecurity studies at TU Dublin.*
