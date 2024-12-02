# Build stage
FROM maven:3.9-eclipse-temurin-17-alpine AS builder
WORKDIR /build
COPY . .
RUN mvn clean package -DskipTests

# Runtime stage
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# Add non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Copy jar from build stage
COPY --from=builder /build/frontend-maven-plugin/target/*.jar app.jar
RUN chown -R appuser:appgroup /app

USER appuser
EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]