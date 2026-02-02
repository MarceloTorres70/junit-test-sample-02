Write-Host "=== INICIANDO AUTOMATIZACION DEL LABORATORIO 9 ===" -ForegroundColor Green
# 1. LIMPIEZA PREVIA
Write-Host "Paso 1: Limpiando procesos y archivos viejos..."
taskkill /F /IM java.exe 2>`$null
Remove-Item results.jtl -ErrorAction SilentlyContinue
Remove-Item report_dashboard -Recurse -Force -ErrorAction SilentlyContinue
# 2. CONFIGURAR ENTORNO
`$env:JAVA_HOME = "C:\Program Files\Java\jdk-25"
`$env:Path = "`$env:JAVA_HOME\bin;`$env:Path"
# 3. INICIAR SERVIDOR (Job en Segundo Plano)
Write-Host "Paso 2: Iniciando Servidor Spring Boot..."
`$serverProcess = Start-Process mvn -ArgumentList "spring-boot:run" -WorkingDirectory . -PassThru -NoNewWindow
# 4. ESPERA ACTIVA (Polling del Puerto 8081)
Write-Host "Paso 3: Esperando a que el puerto 8081 responda (Maximo 60s)..."
`$timeout = 60
`$timer = 0
`$portOpen = `$false
while (`$timer -lt `$timeout) {
    `$connection = Test-NetConnection -ComputerName localhost -Port 8081 -InformationLevel Quiet
    if (`$connection) {
        `$portOpen = `$true
        Write-Host "Servidor detectado y listo en el puerto 8081!" -ForegroundColor Green
        break}
    Start-Sleep -Seconds 2
    `$timer += 2
    Write-Host "." -NoNewline}
Write-Host ""
if (-not `$portOpen) {
    Write-Host "ERROR: El servidor no arranco a tiempo." -ForegroundColor Red
    Stop-Process -Id `$serverProcess.Id -ErrorAction SilentlyContinue
    exit 1
}
# 5. EJECUTAR JMETER
Write-Host "Paso 4: Ejecutando JMeter (Ataque de Carga)..."
C:\tools\apache-jmeter-5.6.3\bin\jmeter.bat -n -t load_test.jmx -l results.jtl -e -o report_dashboard
# 6. MOSTRAR RESULTADOS Y LIMPIEZA FINAL
Write-Host "Paso 5: Analizando resultados..."
Get-Content jmeter.log -Tail 20 | Select-String "Err:"
Write-Host "Paso 6: Deteniendo servidor..."
Stop-Process -Id `$serverProcess.Id -ErrorAction SilentlyContinue
Write-Host "=== EJECUCION COMPLETADA ===" -ForegroundColor Cyan
