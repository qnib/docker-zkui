# docker-zkui
[![](https://badge.imagelayers.io/qnib/zkui:latest.svg)](https://imagelayers.io/?images=qnib/zkui:latest 'Get your own badge on imagelayers.io')

Zookeeper UI which connects automatically to `leader.zookeeper.service.consul,follower.*`.

The login credentials are `admin/manager`.

## External Zookeeper

The service `zkui` is by default disable and waits for a `zookeeper` service to pop up in consul.
Maybe a more common usecase is to spin the container up (independent from consul) to just look into
an zookeeper cluster in your infrastructure.

To do so, just fire up:

```
$ docker run -d --name zkui -p 9090:9090 -e ZKUI_ZK_SERVER=<external_DNS/IP>:2181[,<external_DNS/IP>:2181] qnib/zkui
```

The credentials are
 - `admin/admin` for read/write access, to change the password provide `ZKUI_ADMIN_PW=pass`
 - `user/user` for read-only access, to change the password provide `ZKUI_USER_PW=pass`

 *Security considerations*: As the password is part of the inspectable (`docker inspect`) container it is not really a super secure way. If someone has access as admin he can delete stuff... So handle with care... :) 

This will spin 'em up and point the config to the provided ZK cluster.

## Compose File

To run the stack in a consul environment just spawn the compose file.

```
$ docker-compose up -d
Creating consul
Creating zookeeper
Creating zkui
$
```
After a bit all services should be green within Consul `<docker-host>:8500`.

![](pics/consul.png)

## ZKUI

After the services are up'n'running just head over to the WebUI `<docker-host>:9090`. The login is `admin/admin`.

![](pics/zkui.png)
