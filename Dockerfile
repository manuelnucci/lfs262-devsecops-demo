# Build Stage
FROM maven:3.8.6-openjdk-18-slim AS build
WORKDIR /app
COPY . .
RUN mvn package -DskipTests

# Run Stage
FROM openjdk:21-jdk-oraclelinux8 AS run
COPY --from=build --chown=devops:devops /app/target/demo-0.0.1-SNAPSHOT.jar /run/demo.jar

ARG USER=devops
ENV HOME /home/$USER

RUN apk add --no-cache curl
HEALTHCHECK --interval=30s --timeout=10s --retries=2 --start-period=20s \ 
    CMD curl -f http://localhost:8080/ || exit 1

USER $USER

EXPOSE 8080

CMD java -jar /run/demo.jar
