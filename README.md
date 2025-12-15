# Java & VSCode
Proyecto Java Web con Docker y Tomcat

🚀 **EMV 1: Entorno de Desarrollo Java Web con Docker**  
Este proyecto proporciona un Entorno Mínimo Viable (EMV) para el desarrollo de aplicaciones Java web usando JSP, completamente aislado y configurable gracias a Docker y Tomcat. Incluye una base de datos MySQL para pruebas y desarrollo local.

---

## 📁 Estructura del Proyecto
```text
proyecto-docker-java/
├── app/
│   ├── Dockerfile
│   └── src/
│       └── main/
│           └── webapp/
│               ├── index.jsp
│               ├── hola.jsp
│               └── WEB-INF/
│                   └── lib/
│                       └── mysql-connector-java-8.1.0.jar
├── db/
│   └── init.sql
├── docker-compose.yml
└── README.md
```

---

## 🛠️ Requisitos

- Docker Desktop
- Visual Studio Code (opcional, para edición)

---
## ⚙️ Pasos para la Configuración y Ejecución
### 1️⃣ Clonar el Repositorio
```bash
git clone [URL_DE_TU_REPOSITORIO]
```
---
### 2️⃣ Levantar el Entorno
```bash
docker-compose down -v       # opcional: limpia datos antiguos de MySQL
docker-compose up -d --build
```

---
### 3️⃣ Acceder a Tomcat
Abre en tu navegador: http://localhost:8085

---
### 4️⃣ Acceder a MySQL
Desde tu PC abre Workbench y crea una nueva conexión.
```text
Host: localhost
Puerto: 3309
Usuario: appuser
Contraseña: apppass
Base de datos: appdb
```

---
### 🧪 Prueba de funcionamiento (Hola Mundo JSP)

-Accede en el navegador: http://localhost:8085/hola.jsp

-Debes ver un mensaje "Hola Mundo JSP con Docker"

-También se muestran los datos de la tabla prueba desde MySQL

---
### 📄 Composición de Archivos Importantes
#### docker-compose.yml
```yaml
version: '3.9'

services:
  app:
    build: ./app
    container_name: java-tomcat
    ports:
      - "8085:8080"
    environment:
      DB_HOST: bd-mysql
      DB_NAME: appdb
      DB_USER: appuser
      DB_PASSWORD: apppass
    depends_on:
      - bd-mysql
    networks:
      - java-net

  bd-mysql:
    image: mysql:8.0
    container_name: bd-mysql
    restart: always
    ports:
      - "3309:3306"
    environment:
      MYSQL_ROOT_PASSWORD: rootpass
      MYSQL_DATABASE: appdb
      MYSQL_USER: appuser
      MYSQL_PASSWORD: apppass
    volumes:
      - mysql_data:/var/lib/mysql
      - ./db/init.sql:/docker-entrypoint-initdb.d/init.sql

    networks:
      - java-net

volumes:
  mysql_data:

networks:
  java-net:
    driver: bridge
```
---
#### Dockerfile
```dockerfile
FROM tomcat:10.1-jdk17-temurin

# Limpiar aplicaciones por defecto
RUN rm -rf /usr/local/tomcat/webapps/*

# Copiar aplicación web
COPY src/main/webapp /usr/local/tomcat/webapps/ROOT

# Copiar driver JDBC a Tomcat lib
COPY src/main/webapp/WEB-INF/lib/mysql-connector-j-8.1.0.jar /usr/local/tomcat/lib/

EXPOSE 8080

CMD ["catalina.sh", "run"]
```
---
#### index.jsp
```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
<title>Entorno Docker Java</title>
</head>
<body>
<h1>🚀 Tomcat funcionando con Docker</h1>
<p>Java: OpenJDK 17</p>
<p>Servidor: Apache Tomcat 10</p>
</body>
</html>
```
---
#### hola.jsp
```jsp
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Prueba Hola Mundo</title>
</head>
<body>
<h1>🚀 Hola Mundo JSP con Docker!</h1>

<%
    String dbUrl = "jdbc:mysql://bd-mysql:3306/appdb";
    String dbUser = "appuser";
    String dbPass = "apppass";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT * FROM prueba");

        out.println("<h2>Datos desde MySQL:</h2><ul>");
        while(rs.next()) {
            out.println("<li>" + rs.getInt("id") + " - " + rs.getString("mensaje") + "</li>");
        }
        out.println("</ul>");

        rs.close();
        stmt.close();
        conn.close();
    } catch(Exception e) {
        out.println("<p style='color:red;'>Error de conexión: " + e.getMessage() + "</p>");
    }
%>

</body>
</html>
```
---
#### init.sql
```sql
CREATE DATABASE IF NOT EXISTS appdb;

USE appdb;

CREATE TABLE IF NOT EXISTS prueba (
    id INT AUTO_INCREMENT PRIMARY KEY,
    mensaje VARCHAR(255)
);

INSERT INTO prueba (mensaje) VALUES ('Hola desde Docker!'), ('Prueba JDBC');
```

---
### 🧹 Detener y Limpiar
`docker-compose down`
Para reiniciar la base de datos:
`docker-compose down -v`

### 💡 Buenas prácticas
Mantener los JSP en src/main/webapp/

Mantener scripts SQL en db/init.sql

Usar bd-mysql como host en Java, no localhost

