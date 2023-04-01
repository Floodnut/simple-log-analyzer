<div align="center">
<h2> Simple Log Analyzer </h2>
</div>

<h3> Usage </h3>

```
./simple_log.sh access.log.1 
```

<h3> Result </h3>

```
#log.sh __shell_name__

access.log.1 analysis.

------------------result------------------

file: access.log.1.
md5: fbfecc286e19a057021e41beda3b759f  access.log.1
sha1: 030316810ddc12299e92d42fc885e881f9a31d77  access.log.1
total unique log: 110
count per IP: 78
    227 __SAMPLE_IP__
     39 __SAMPLE_IP__
      4 __SAMPLE_IP__
      4 __SAMPLE_IP__
      4 __SAMPLE_IP__
count per http method: 366
  GET: 336
  POST: 6
  PUT: 2
  DELETE: 0
  OPTION: 2
  OTHERS: 20
```
