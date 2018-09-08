```
docker pull w303972870/haproxy
```

#### 配置文件路径
```
/data/conf/haproxy.cfg
```

#### 启动命令示例
```
docker run -dit  --net host -p 16001:16001 -p 7777:7777 -p 10001:10001 -v /data/haproxy/:/data/ docker.io/w303972870/haproxy
```


##### 提供一个简单的配置文件/root/twemproxy/redis_master.conf ：
```
global
        log 127.0.0.1   local0
        log 127.0.0.1   local1 notice
        #log loghost    local0 info
        maxconn 4096
        chroot /usr/local/haproxy
        pidfile /usr/data/haproxy/haproxy.pid
        uid 99
        gid 99
        daemon
        #debug
        #quiet

defaults
        log     global
        mode    tcp
        option  httplog
        option  dontlognull
        retries 3
        redispatch
        maxconn 2000
        contimeout      5000
        clitimeout      50000
        srvtimeout      50000

listen  appli1-rewrite 0.0.0.0:10001
        cookie  SERVERID rewrite
        balance roundrobin
        option  abortonclose
        option  redispatch
        retries 3
        maxconn 2000
        timeout connect 5000
        timeout client  50000
        timeout server  50000

listen  proxy_status 
        bind :16001
        mode tcp
        balance roundrobin
        server tw_proxy_1 192.168.125.165:22121 check inter 10s
        server tw_proxy_2 192.168.125.166:22121 check inter 10s
        server tw_proxy_3 192.168.125.167:22121 check inter 10s

frontend admin_stats
        bind :7777
        mode http
        stats enable
        option httplog
        maxconn 10
        stats refresh 30s
        stats uri /admin
        stats auth mldn:java
        stats hide-version
        stats admin if TRUE
```
