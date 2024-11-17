FROM docker.io/eclipse-temurin:21 AS jre-build

ARG MODULES="java.base,java.logging,java.management,java.naming,java.sql,java.desktop,java.security.jgss,java.instrument,java.xml,jdk.unsupported,java.net.http,java.prefs,jdk.crypto.ec,java.compiler,java.rmi,jdk.management,java.transaction.xa"

RUN $JAVA_HOME/bin/jlink \
         --add-modules $MODULES \ 
         --strip-debug \
         --no-man-pages \
         --no-header-files \
         --output /javaruntime

FROM docker.io/debian:stable-slim
ENV JAVA_HOME=/opt/java/openjdk
ENV PATH="${JAVA_HOME}/bin:${PATH}"
COPY --from=jre-build /javaruntime $JAVA_HOME

# Install curl
RUN apt-get update && apt-get install -y --no-install-recommends curl && apt-get clean && rm -rf /var/lib/apt/lists/*

LABEL maintainer="jorge1b3@hotmail.es" \
      version="2.0" 

LABEL org.opencontainers.image.source = "https://github.com/La-masa-critica/jre-spring"
LABEL org.opencontainers.image.description = "Custom JRE for Spring Boot microservices" 
LABEL org.opencontainers.image.licenses = "MIT"

CMD ["java", "-version"]
