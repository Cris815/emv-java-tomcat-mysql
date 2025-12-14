# Java&VSCode
Proyecto Java Web con Docker y Tomcat

🚀 EMV 1: Entorno de Desarrollo Java Web con Docker
Este proyecto proporciona un Entorno Mínimo Viable (EMV) para el desarrollo de aplicaciones Java web usando JSP, completamente aislado y configurable gracias a Docker y Tomcat. Incluye una base de datos MySQL para pruebas y desarrollo local.

---

## 📁 Estructura del Proyecto

Crea la siguiente estructura de carpetas:

proyecto-docker-java/
├── app/
│ ├── Dockerfile
│ └── src/
│ └── main/
│ └── webapp/
│ ├── index.jsp
│ ├── hola.jsp
│ └── WEB-INF/
│ └── lib/
│ └── mysql-connector-java-8.1.0.jar
├── db/
│ └── init.sql
├── docker-compose.yml
└── README.md

yaml
Copiar código

---

## 🛠️ Requisitos

- Docker Desktop (o Docker Engine)
- Visual Studio Code (opcional, para edición)
- Extensión VS Code: Remote - Containers (opcional, ID: ms-vscode-remote.remote-containers)

---

## ⚙️ Pasos para la Configuración y Ejecución

### 1️⃣ Clonar el Repositorio

```bash
git clone [URL_DE_TU_REPOSITORIO] proyecto-docker-java
cd proyecto-docker-java
###2️⃣ Levantar el Entorno
bash
Copiar código
docker-compose down -v       # opcional: limpia datos antiguos de MySQL
docker-compose up -d --build
--build recompila la imagen de Tomcat con el driver JDBC.

-v elimina volúmenes antiguos para que se ejecute init.sql.

###3️⃣ Acceder a Tomcat
Abre en tu navegador:

arduino
Copiar código
http://localhost:8085
###4️⃣ Acceder a MySQL
Desde tu PC (Workbench, DBeaver, etc.):

###Archivo docker-compose.yml
yaml
Copiar código
Host: localhost
Puerto: 3309
Usuario: appuser
Contraseña: apppass
Base de datos: appdb
Dentro del contenedor Java:

yaml
Copiar código
Host: bd-mysql
Puerto: 3306
Usuario: appuser
Contraseña: apppass
Base de datos: appdb
🧪 Prueba de funcionamiento (Hola Mundo JSP)
Abre el archivo app/src/main/webapp/hola.jsp

Accede en el navegador:

bash
Copiar código
http://localhost:8085/hola.jsp
Debes ver un mensaje "Hola Mundo JSP con Docker"

También se muestran los datos de la tabla prueba desde MySQL

Los cambios en los JSP se reflejan automáticamente gracias al volumen montado (./app/src:/usr/local/tomcat/webapps/ROOT).

###📄 Composición de Archivos Importantes
docker-compose.yml
Define los servicios de Tomcat (app) y MySQL (bd-mysql):

app: servidor Tomcat con driver JDBC incluido

bd-mysql: MySQL 8, puerto 3309 en host, inicializa con db/init.sql

Red interna java-net

Volumen persistente mysql_data

Dockerfile (app/Dockerfile)
Base: tomcat:10.1-jdk17-temurin

Copia la aplicación JSP y el driver JDBC (mysql-connector-java-8.1.0.jar)

Expone puerto 8080 en contenedor

Comando: catalina.sh run

db/init.sql
###Script de inicialización de MySQL:

sql
Copiar código
CREATE DATABASE IF NOT EXISTS appdb;

USE appdb;

CREATE TABLE IF NOT EXISTS prueba (
    id INT AUTO_INCREMENT PRIMARY KEY,
    mensaje VARCHAR(255)
);

INSERT INTO prueba (mensaje) VALUES ('Hola desde Docker!'), ('Prueba JDBC');
app/src/main/webapp/hola.jsp
Ejemplo de JSP que se conecta a MySQL:

###jsp
Copiar código
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
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

        out.println("<ul>");
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
###🧹 Detener y limpiar
Salir del entorno:

bash
Copiar código
docker-compose down
Limpiar volúmenes (opcional, para reiniciar la base de datos):

bash
Copiar código
docker-compose down -v
###💡 Buenas prácticas
Mantener los JSP en src/main/webapp/

Mantener scripts SQL en db/init.sql

Usar bd-mysql como host en Java, no localhost