upstream hello-server {
	%{ for server_name in upstream_servers ~}
	server ${server_name}:${upstream_port};
	%{ endfor ~}
}

server {
	listen       ${nginx_port};
	listen  [::]:${nginx_port};

	server_name localhost;

	location / {
		proxy_pass http://hello-server/;
		proxy_set_header HOST $host;
		proxy_set_header X-Real-IP $remote_addr;
		proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
