FROM openjdk:8-jre-slim AS TEMP

RUN apt-get update \
    && apt-get install -y locales \
    && sed -ie 's/# zh_TW BIG5/zh_TW BIG5/g' /etc/locale.gen \
    && locale-gen

FROM openjdk:8-jre-slim

COPY --from=TEMP /usr/lib/locale /usr/lib/locale
ENV LC_ALL=zh_TW.big5 \
    LANG=zh_TW.big5 \
    TZ=Asia/Taipei \
    JAVA_OPTS="-Ddb2.jcc.charsetDecoderEncoder=3 -Djavax.servlet.request.encoding=CP950 -Dfile.encoding=CP950"

ADD apache-tomcat-8.5.54.tar.gz /usr/local/

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && mv /usr/local/apache-tomcat-8.5.54 /usr/local/tomcat \
    && groupadd -g 3001 -r wasgrp \
    && useradd -g wasgrp -d /home/wasadmin -u 3001 -m wasadmin \
    && chown -R wasadmin:wasgrp /usr/local/tomcat

ADD ./redisson.conf /usr/local/tomcat/
ADD ./tomcat-jar/ /usr/local/tomcat/lib/
ADD ./charsets.jar /usr/lib/jvm/java-8-openjdk-jre/jre/lib/charsets.jar

USER wasadmin
WORKDIR /usr/local/tomcat
EXPOSE 8080
ENTRYPOINT /usr/local/tomcat/bin/startup.sh && tail -f /usr/local/tomcat/logs/catalina.out