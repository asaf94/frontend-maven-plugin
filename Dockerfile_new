# Step 1: Build the application using Maven
FROM maven:3.8-jdk-8 as builder

# Set the working directory inside the container
COPY . /usr/src/easybuggy/
WORKDIR /usr/src/easybuggy/

# Run Maven to package the application (WAR/JAR)
RUN mvn -B package

# Step 2: Set up the runtime environment with a smaller JDK image
FROM openjdk:8-slim

# Copy the JAR file from the build stage
COPY --from=builder /usr/src/easybuggy/target/easybuggy.jar /

# Configure JVM options for the EasyBuggy app
CMD ["java", "-XX:MaxMetaspaceSize=128m", "-Xloggc:logs/gc_%p_%t.log", "-Xmx256m", 
    "-XX:MaxDirectMemorySize=90m", "-XX:+UseSerialGC", "-XX:+PrintHeapAtGC", 
    "-XX:+PrintGCDetails", "-XX:+PrintGCDateStamps", "-XX:+UseGCLogFileRotation", 
    "-XX:NumberOfGCLogFiles=5", "-XX:GCLogFileSize=10M", "-XX:GCTimeLimit=15", 
    "-XX:GCHeapFreeLimit=50", "-XX:+HeapDumpOnOutOfMemoryError", "-XX:HeapDumpPath=logs/", 
    "-XX:ErrorFile=logs/hs_err_pid%p.log", "-agentlib:jdwp=transport=dt_socket,server=y,address=9009,suspend=n", 
    "-Dderby.stream.error.file=logs/derby.log", "-Dderby.infolog.append=true", 
    "-Dderby.language.logStatementText=true", "-Dderby.locks.deadlockTrace=true", 
    "-Dderby.locks.monitor=true", "-Dderby.storage.rowLocking=true", 
    "-Dcom.sun.management.jmxremote", "-Dcom.sun.management.jmxremote.port=7900", 
    "-Dcom.sun.management.jmxremote.ssl=false", "-Dcom.sun.management.jmxremote.authenticate=false", 
    "-ea", "-jar", "easybuggy.jar"]