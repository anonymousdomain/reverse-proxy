# reverse-proxy
In my opinion, understanding how nginx operates as a reverse proxy can provide crucial insights into more complex concepts, such as how Ingress works in Kubernetes. 

A reverse proxy like nginx accepts client connections, forwards them to appropriate backend servers, and returns the server's response to the client, acting as an intermediary for requests from clients seeking resources from other servers. 

Similarly, Ingress in Kubernetes routes external HTTP and HTTPS traffic to the appropriate services within the cluster, based on a set of rules.


[Nginx reverse proxy architecture ![](https://app.eraser.io/workspace/c4xuI3Kt8Xp5NlLqBzOc/preview?elements=pabIq7KzQL9GRReBSZVeqA&type=embed)](https://app.eraser.io/workspace/c4xuI3Kt8Xp5NlLqBzOc?elements=pabIq7KzQL9GRReBSZVeqA)

from the architecture proxy server puts before the backend server act as shield protecting true ipAddress and identities of  backend servers from the  outside  worlds  

Additionally, reverse proxy server consolidate multiple backend servers under a single domain name, simplifying the management of domain resources 

# reverse proxy simulation 

This section demonstrates how to set up an Nginx reverse proxy using Terraform to provision an EC2 instance on AWS. Docker Engine will be configured with Ansible to streamline the process.


#### provision ec2 instance 
``` bash
    terraform plan -out output.tf 
    terraform apply -auto-approve
```    
#### configure docker engine and docker compose 
``` bash
    ansible-playbook -i hosts.ini playbook.yml --check
    ansible-playbook -i hosts.ini playbook.yml 
```
#### confgure nginx as a proxy server 
``` nginx
server {
	server_name ec2-34-217-78-248.us-west-2.compute.amazonaws.com;

	listen 80;
   

	location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }

	location /app1 {
		proxy_pass http://webserver-1/;
	}
	location /app2 {
		proxy_pass http://webserver-2/;
	}
	location /app3 {
		proxy_pass http://webserver-3/;
	}

}
```
### ochestrate the servers in a dockerized enviroment 

for the sake of simplicity you can use simple html template for each server  and mount it as a volume 
then spin up the docker compose 
``` docker compose 
docker-compose up -d
```

finally you can access each servers through reverse proxy  server  as 

``` curl 
https://ec2-34-217-78-248.us-west-2.compute.amazonaws.com/app1

http://ec2-34-217-78-248.us-west-2.compute.amazonaws.com/app2

https://ec2-34-217-78-248.us-west-2.compute.amazonaws.com/app3

```
