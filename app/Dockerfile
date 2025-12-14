FROM tomcat:10.1-jdk17-temurin

# Limpiar aplicaciones por defecto
RUN rm -rf /usr/local/tomcat/webapps/*

# Copiar aplicación web
COPY src/main/webapp /usr/local/tomcat/webapps/ROOT

# Copiar driver JDBC a Tomcat lib
COPY src/main/webapp/WEB-INF/lib/mysql-connector-j-8.1.0.jar /usr/local/tomcat/lib/

EXPOSE 8080

CMD ["catalina.sh", "run"]