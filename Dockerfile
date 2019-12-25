FROM maven:3.5.2-jdk-8-alpine AS MAVEN_BUILD

LABEL author="Rahul Ravindran"

ARG JAVA_OPTS
ENV JAVA_OPTS_ENV $JAVA_OPTS
COPY pom.xml /build/

COPY src /build/src/

WORKDIR /build/

RUN mvn package

FROM openjdk:8-jre-alpine

WORKDIR /app

COPY --from=MAVEN_BUILD /build/target/eureka-service-0.0.1-SNAPSHOT.jar /app/

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar eureka-service-0.0.1-SNAPSHOT.jar"]