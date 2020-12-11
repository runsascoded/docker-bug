# docker-for-linux file permissions bug repro

```bash
docker run --rm -it runsascoded/docker-bug:debian
```
```
+ ls -la /root
ls: cannot access '/root/dir': Permission denied
total 12
drwxr-xr-x  5 root root  75 Dec 11 20:07 .
drwxr-xr-x 40 root root  79 Dec 11 20:37 ..
-rw-r-xr-x  1 root root 570 Jan 31  2010 .bashrc
-rw-r-xr-x  1 root root 148 Aug 17  2015 .profile
-rw-r-xr-x  1 root root   4 Dec 11 20:07 aaa
??????????  ? ?    ?      ?            ? dir
+ echo Failed
Failed
+ sudo ls -la /root
total 12
drwxr-xr-x  5 root root  75 Dec 11 20:07 .
drwxr-xr-x 40 root root  79 Dec 11 20:37 ..
-rw-r-xr-x  1 root root 570 Jan 31  2010 .bashrc
-rw-r-xr-x  1 root root 148 Aug 17  2015 .profile
-rw-r-xr-x  1 root root   4 Dec 11 20:07 aaa
drwxr-xr-x  2 root root  24 Dec 11 20:07 dir
+ ls -la /root
total 12
drwxr-xr-x  5 root root  75 Dec 11 20:07 .
drwxr-xr-x 40 root root  79 Dec 11 20:37 ..
-rw-r-xr-x  1 root root 570 Jan 31  2010 .bashrc
-rw-r-xr-x  1 root root 148 Aug 17  2015 .profile
-rw-r-xr-x  1 root root   4 Dec 11 20:07 aaa
drwxr-xr-x  2 root root  24 Dec 11 20:07 dir
```

Note the `??????????  ? ?    ?      ?            ? dir` line especially. Everything under `/root` should be world-{readable,executable}, but an erroneous `Permission denied` is emitted on the initial attempt to `ls` (including strange `?`s on the line for `/root/dir`).

After performing an `ls` on the same directory as `root`, the storage layer properly recognizes the permissions, and subsequent `ls`'s as `user` work as intended.

[docker-for-linux#433](https://github.com/docker/for-linux/issues/433) seems to cover this.

Similar behavior can be observed against an Alpine Linux image:
```bash
docker run --rm -it runsascoded/docker-bug:alpine
```

## Building
Build the images as follows:

```bash
os=debian; docker build -f Dockerfile.$os -t runsascoded/docker-bug:$os .
os=alpine; docker build -f Dockerfile.$os -t runsascoded/docker-bug:$os .
```
