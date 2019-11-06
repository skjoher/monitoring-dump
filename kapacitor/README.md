Kapacitor : https://github.com/influxdata/kapacitor
Open source framework for processing, monitoring, and alerting on time series data

Kapacitor has two binaries:

kapacitor – a CLI program for calling the Kapacitor API.
kapacitord – the Kapacitor server daemon.

Kapacitor use a DSL named TICKscript to define tasks.

#A simple TICKscript that alerts on high cpu usage looks like this:

```sh
stream
    |from()
        .measurement('cpu_usage_idle')
        .groupBy('host')
    |window()
        .period(1m)
        .every(1m)
    |mean('value')
    |eval(lambda: 100.0 - "mean")
        .as('used')
    |alert()
        .message('{{ .Level}}: {{ .Name }}/{{ index .Tags "host" }} has high cpu usage: {{ index .Fields "used" }}')
        .warn(lambda: "used" > 70.0)
        .crit(lambda: "used" > 85.0)

        // Send alert to hander of choice.

        // Slack
        .slack()
        .channel('#alerts')

```

#save into a file cpu_alert.tick

#Define the task

```sh
kapacitor define \            #define
    cpu_alert \               # name of the alert
    -type stream \            # type batch or stream
    -dbrp telegraf.default \  #database retentionPolicy
    -tick ./cpu_alert.tick    #.tick file with full path
```
#start the task

```sh
kapacitor enable cpu_alert
```
#show the task

```sh
kapacitor show cpu_alert
```

#list all tasks

```sh
[root@monitor ~]# kapacitor list tasks
ID                     Type      Status    Executing Databases and Retention Policies
cpu_stream_1           stream    enabled   true      ["telegraf_db"."autogen"]
disk_stream_1          stream    enabled   true      ["telegraf_db"."autogen"]
mem_stream_1           stream    enabled   true      ["telegraf_db"."autogen"]
mysql_max_conn_1       stream    enabled   true      ["telegraf_db"."autogen"]
rabbit_mem_used_1      stream    enabled   true      ["telegraf_db"."autogen"]
redis_mem_used_1       stream    enabled   true      ["telegraf_db"."autogen"]
tomcat_threads_count_1 stream    enabled   true      ["jmx_db"."autogen"]
```
