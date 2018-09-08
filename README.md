```
docker pull w303972870/haproxy
```

#### 配置文件路径
```
/data/conf/haproxy.cfg
```

#### 启动命令示例
```
docker run -dit  --net host -p 16001:16001 -p 7777:7777 -v /data/haproxy/:/data/ docker.io/w303972870/haproxy
```

#### 我的/data/haproxy/目录结构
```
haproxy/
├── conf
│   └── haproxy.cfg
├── haproxy
└── stats
```

##### 提供一个简单的配置文件/data/haproxy/conf/haproxy.cfg ：
```
global
 log 127.0.0.1   local0                     #定义haproxy日志输出设置
 log 127.0.0.1   local1 notice
 #log loghost    local0 info                #定义haproxy 日志级别，日志级别（err，waning，info，debug）
 #ulimit-n 82000                             #设置每个进程的可用的最大文件描述符，默认情况下其会自动进行计算，因此不推荐修改此选项
 maxconn 20480                              #默认最大连接数，此选项等同于linux命令选项”ulimit -n”；
 chroot /data/haproxy/                      #chroot运行路径
 pidfile /data/haproxy/haproxy.pid          #haproxy 进程PID文件
 uid 99                                     #运行haproxy 用户 UID
 gid 99                                     #运行haproxy 用户组gid
 daemon                                     #以后台形式运行harpoxy
 #debug
 #quiet
 stats socket /data/stats                   #定义统计信息保存位置；

defaults
 log     global                             #引入global定义的日志格式
 mode    tcp                                #所处理的类别(7层代理http，4层代理tcp),设置haproxy的运行模式，有三种｛http|tcp|health｝。注意：如果haproxy中还要使用4层的应用（mode tcp）的话，不建议在此定义haproxy的运行模式。
                                            #tcp模式：在此模式下，客户端和服务器端之前将建立一个全双工的连接，不会对七层报文做任何检查，默认为tcp模式，经常用于SSL、SSH、SMTP等应用。
                                            #http模式：在此模式下，客户端请求在转发至后端服务器之前将会被深度分板，所有不与RFC格式兼容的请求都会被拒绝。
                                            #health：已基本不用了。
 option  httplog                            #日志类别为http日志格式
 option  dontlognull                        #不记录健康检查日志信息
 option  forwardfor                         #如果后端服务器需要获得客户端的真实ip，需要配置的参数，可以从http header 中获取客户端的IP
 retries 3                                  #3次连接失败就认为服务器不可用，也可以通过后面设置
 option  redispatch
 maxconn 2000
 timeout connect      5000
 timeout client      50000
 timeout server      50000

listen  proxy_status                      #Frontend和Backend的组合体,监控组的名称，按需自定义名称 
 bind :16001                              #监听端口 
 mode tcp
 option  tcplog                          #日志类别为http日志格式,因为这里是tcp的mode，所以要重写为tcplog
 balance roundrobin
 server tw_proxy_1 192.168.123.2:22121 check inter 10s
 server tw_proxy_2 192.168.123.3:22121 check inter 10s
 server tw_proxy_3 192.168.123.4:22121 check inter 10s

frontend admin_stats
 bind :7777
 mode http
 stats enable
 option httplog
 maxconn 10
 stats refresh 30s
 stats uri /admin                     #http://192.168.123.2:7777/admin
 stats auth eirc_wang:123456          #配置访问这个后台的用户名：密码
 stats hide-version
 stats admin if TRUE
 ```
