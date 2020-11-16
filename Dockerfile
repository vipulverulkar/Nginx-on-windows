FROM mcr.microsoft.com/windows/servercore:ltsc2019 
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
ENV NGINX_VERSION 1.18.0
RUN Invoke-WebRequest -Uri https://nginx.org/download/nginx-$Env:NGINX_VERSION.zip -OutFile nginx.zip ; \
    Expand-Archive nginx.zip -DestinationPath $Env:ProgramFiles ; \
    Remove-Item -Force nginx.zip ; \
    Move-Item $Env:ProgramFiles\nginx-* $Env:ProgramFiles\nginx
RUN setx /M PATH $($Env:PATH + ';' + $Env:ProgramFiles + '\nginx')
EXPOSE 80 443
WORKDIR "C:\Program Files\nginx"
COPY /dist/data \html
CMD Start-Process -NoNewWindow -FilePath nginx.exe ; \
Add-Content logs\access.log 'nginx started...' ; Get-Content -Wait logs\access.log
