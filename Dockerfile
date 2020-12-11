#FROM python:3.8.6-slim
FROM debian@sha256:d70fe252be511834ae8f685a90b0a658539c99c4a87f79c41831b09be0fee705
WORKDIR /root
RUN echo "111" > aaa
WORKDIR /root/dir
RUN echo "222" > bbb

RUN chmod -R go+rx /root
RUN apt-get update && apt-get install -y sudo

WORKDIR /

RUN useradd -m -G sudo user \
 && perl -pi -e "s/^%sudo(.*ALL=).*/user\1(ALL) NOPASSWD: ALL/" /etc/sudoers

WORKDIR /home/user
COPY test.sh ./
RUN chown user:user test.sh
USER user
ENTRYPOINT ["./test.sh"]
