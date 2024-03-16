#create network for the apps to resolve eachother
docker network create connect

# Run nginx by mounting the webserver1.html to the container 
docker run -d -v $PWD/server1:/usr/share/nginx/html --network connect --name webserver-1 nginx



docker run -d -v $PWD/server2:/usr/share/nginx/html --network connect --name webserver-2 nginx


docker run -d -v $PWD/server3:/usr/share/nginx/html --network connect --name webserver-3 nginx


docker run -dp 8080:80  -v $PWD/conf:/etc/nginx/conf.d --network connect --name reverse-proxy-server nginx
