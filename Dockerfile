# FROM alpine

# ENV MUSL_LOCPATH=/usr/local/share/i18n/locales/musl
# RUN apk add --update git cmake make musl-dev gcc gettext-dev libintl
# RUN cd /tmp && git clone https://github.com/rilian-la-te/musl-locales.git
# RUN cd /tmp/musl-locales && cmake . && make && make install
# 
# ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

########

# FROM alpine
# 
# RUN apk --no-cache add ca-certificates wget \
#     && wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
#     && wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.31-r0/glibc-2.31-r0.apk \
# 	&& wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.31-r0/glibc-bin-2.31-r0.apk \
#     && wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.31-r0/glibc-i18n-2.31-r0.apk \
#     && apk add glibc-2.31-r0.apk glibc-bin-2.31-r0.apk glibc-i18n-2.31-r0.apk \
#     && /usr/glibc-compat/bin/localedef -i zh_TW -f BIG5 zh_TW.BIG5
# 
# ENV PATH=/usr/glibc-compat/bin:$PATH \
#     LC_ALL=zh_TW.big5 \
#     LANG=zh_TW.big5
# 
# ADD test.tar .


########

# FROM debian:9.11 as TEMP
# 
# RUN apt-get update
# RUN apt-get install -y locales fonts-arphic-uming
# RUN sed -ie 's/# zh_TW.UTF-8 UTF-8/zh_TW.UTF-8 UTF-8/g' /etc/locale.gen
# RUN sed -ie 's/# zh_TW BIG5/zh_TW BIG5/g' /etc/locale.gen
# RUN locale-gen
# ENV LANG zh_TW.BIG5
# 
# FROM gcr.io/distroless/java:11-debug
# 
# COPY --from=TEMP /usr/lib/locale /usr/lib/locale
# COPY --from=TEMP /usr/share/fonts /usr/share/fonts
# 
# SHELL ["/busybox/sh", "-c"]
# ENV LANG=zh_TW.BIG5 \
#     LC_ALL=zh_TW.BIG5
# RUN echo $'\
# public class A {\n\
#     public static void main(String... args) {\n\
#         System.out.println("file.encoding=" + System.getProperty("file.encoding"));\n\
#         System.out.println("sun.jnu.encoding=" + System.getProperty("sun.jnu.encoding"));\n\
#         System.out.println("LANG=" + System.getenv("LANG"));\n\
#         System.out.println("\u65E5");\n\
#     }\n\
# }' > /A.java
# ENTRYPOINT ["java", "/A.java"]
# 
# ADD test.tar .



FROM debian:9.11

RUN apt-get update
RUN apt-get install -y locales fonts-arphic-uming
RUN sed -ie 's/# zh_TW.UTF-8 UTF-8/zh_TW.UTF-8 UTF-8/g' /etc/locale.gen
RUN sed -ie 's/# zh_TW BIG5/zh_TW BIG5/g' /etc/locale.gen
RUN locale-gen
ENV LANG zh_TW.UTF-8

ADD test.tar .
