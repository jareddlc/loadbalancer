# loadbalancer
Load balancer

`Description`:  Load balancer

`Author`:     Jared De La Cruz

```
$ docker build -t loadbalancer .
$ docker run -d --name load_balancer -p 80:80 -p 443:443 loadbalancer
$ docker service create --replicas 1 --name load_balancer -p 80:80 -p 443:443 --network my_network loadbalancer
```

```
curl --verbose -L --header 'Host: www.circuitron.com.mx' 'http://localhost/'
curl --verbose -L --header 'Host: www.solderbyte.com' 'http://localhost/'
curl --verbose -L --header 'Host: www.jareddlc.com' 'http://localhost/'
curl --verbose -L --header 'Host: www.siddelacruz.com' 'http://localhost/'
```

Updating certs

* Shut down load_balancer service (`$ docker service rm load_balancer`)
* Run the certbot script (`$ . certbot.sh`)
* Copy the certs (`$ . copy-certs.sh`)
* Build the docker image (`$ . docker-build.sh`)
* Start load_balancer service
