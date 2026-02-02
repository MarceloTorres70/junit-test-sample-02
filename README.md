# Laboratorio 9: Pruebas de Carga y Automatizacion con JMeter
Este proyecto implementa un servicio REST (Spring Boot) configurado para soportar pruebas de carga de alto rendimiento. Incluye scripts de automatizacion para orquestar el ciclo de vida de las pruebas (Despliegue -> Prueba -> Reporte).
## Requisitos Previos
- **Java JDK 25**
- **Apache JMeter 5.6.3** (Configurado en PATH o en `C:\tools\apache-jmeter-5.6.3`)
- **PowerShell** (para ejecutar el script de automatizacion)
## Como Ejecutar (Automatizacion)
No es necesario iniciar el servidor manualmente. El proyecto incluye un script de ingenieria que realiza la limpieza, el despliegue del backend, la espera activa del puerto y la ejecucion de JMeter automaticamente.
1. Abrir una terminal en la raiz del proyecto.
2. Ejecutar el script maestro:
```powershell
./run_lab_test.ps1
```
### Que hace este script?
- Limpia procesos zombies (Java/JMeter) y reportes antiguos.
- Inicia el servidor Spring Boot en el puerto 8081.
- Espera inteligentemente hasta que el puerto este escuchando.
- Ejecuta la carga de 50 usuarios concurrentes con JMeter.
- Genera el reporte HTML en `report_dashboard/index.html`.
## Cambios Importantes
- **Seguridad**: Se reconfiguro `SecurityConfig.java` para exponer el endpoint `/cakes` (permitAll), permitiendo auditorias de carga externas sin bloqueos 401.
- **Lombok**: Se estabilizo la dependencia a la version 1.18.36.
## Resultados Esperados
```
summary = 500 in 00:00:10 = 50.9/s Avg: 2 Min: 0 Max: 168 Err: 0 (0.00%)
```
- **Tasa de error**: 0.00%
- **Throughput**: ~50 peticiones/segundo
- **Tiempo de respuesta promedio**: 2ms
## Arquitectura
```
junit-test-sample-02/
├── src/
│   ├── main/java/epn/edu/ec/
│   │   ├── config/SecurityConfig.java    # Configuracion de seguridad
│   │   ├── controller/                   # Controladores REST
│   │   ├── model/                        # Entidades JPA
│   │   └── repository/                   # Repositorios
│   └── test/                             # Tests unitarios y de integracion
├── load_test.jmx                         # Plan de pruebas JMeter
├── run_lab_test.ps1                      # Script de automatizacion
└── pom.xml                               # Configuracion Maven
```
## Ejecucion Manual (Alternativa)
Si prefieres ejecutar manualmente cada paso:
1. **Iniciar el servidor**:
   ```bash
   mvn spring-boot:run
   ```
2. **Ejecutar JMeter** (en otra terminal):
   ```bash
   C:\tools\apache-jmeter-5.6.3\bin\jmeter -n -t load_test.jmx -l results.jtl -e -o report_dashboard
   ```
3. **Ver el reporte**:
   Abre `report_dashboard/index.html` en tu navegador.
## Tecnologias Utilizadas
- **Spring Boot 3.4.4**
- **Spring Security 6.1+**
- **Spring Data JPA**
- **H2 Database** (en memoria)
- **Lombok 1.18.36**
- **Apache JMeter 5.6.3**
- **Maven 3.9+**
## Objetivo del Laboratorio
Demostrar la capacidad de:
1. Configurar un backend REST resiliente
2. Exponer endpoints publicos para pruebas de carga
3. Automatizar el ciclo de vida de las pruebas
4. Generar reportes profesionales de rendimiento
---
**Autor**: Laboratorio 9 - Pruebas de Carga  
**Fecha**: 2026-02-02
