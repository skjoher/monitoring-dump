Jmxtrans: https://github.com/jmxtrans/jmxtrans

This is effectively the missing connector between speaking to a JVM via JMX on one end and whatever logging / monitoring / graphing package that you can dream up on the other end.

jmxtrans is very powerful tool which uses easily generated JSON (or YAML) based configuration files and then outputs the data in whatever format you desire. It does this with a very efficient engine design that will scale to communicating with thousands of machines from a single jmxtrans instance.

jmxtrans is a tool which allows you to connect to any number of Java Virtual Machines (JVMs) and query them for their attributes without writing a single line of Java code. The attributes are exported from the JVM via Java Management Extensions (JMX). Most Java applications have made their statistics available via this protocol and it is possible to add this to any codebase without a lot of effort

The query language is based on the easy to write JSON format. This allows non-programmers access to JMX without having to know how to write Java. 

```sh

history | grep jmxtrans
cd /var/lib/jmxtrans/
cp tomcat.10.1.1.50.json /root/tomcat.10.1.1.132.json
vi /root/tomcat.10.1.1.132.json
#change ip in json file
cp /root/tomcat.10.1.1.132.json /var/lib/jmxtrans
tailf /var/log/jmxtrans/jmxtrans.log

```
