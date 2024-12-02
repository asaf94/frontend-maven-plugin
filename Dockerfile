# Build stage
# FROM maven:3.9-eclipse-temurin-17-alpine AS builder
# Build stage
FROM maven:3.8-eclipse-temurin-11 AS builder
WORKDIR /build
COPY . .
RUN mvn clean install -DskipTests

# Runtime stage
FROM eclipse-temurin:11-jre
WORKDIR /app

# Add non-root user
RUN groupadd -r appgroup && useradd -r -g appgroup appuser

# Copy the plugin jar
COPY --from=builder /build/frontend-maven-plugin/target/frontend-maven-plugin-*.jar ./
RUN chown -R appuser:appgroup /app

USER appuser
# No EXPOSE needed as this is a Maven plugin, not a web app
# No ENTRYPOINT needed as this is a Maven plugin