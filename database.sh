docker run -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=YourStrong@Passw0rd' \
   -p 1433:1433 --name sql1 \
   -v mssql_backups:/var/opt/mssql/backup \
   -d mcr.microsoft.com/mssql/server:2019-latest
