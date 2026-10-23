FROM eclipse-temurin:21-jre
RUN groupadd --system appgroup && \
    useradd --system --gid appgroup appuser
WORKDIR /app
COPY --chown=appuser:appgroup target/*.jar /app/app.jar
USER appuser:appgroup
EXPOSE 8080
ENTRYPOINT ["java","-jar","app.jar"]
