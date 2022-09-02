#escape=`
ARG BASE
FROM mcr.microsoft.com/powershell:7.2-nanoserver-$BASE as base
SHELL ["pwsh", "-Command", "$ErrorActionPreference = 'Stop';"]
USER ContainerAdministrator
ADD ["https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle", "C:\\TEMP\\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.zip" ]
RUN Expand-Archive -LiteralPath C:\TEMP\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.zip -DestinationPath C:\TEMP\winget-cli -Force
RUN move-item C:\TEMP\winget-cli\AppInstaller_x64.msix AppInstaller_x64.zip
RUN Expand-Archive -LiteralPath C:\TEMP\winget-cli\AppInstaller_x64.zip -DestinationPath C:\TEMP\winget-cli\ -Force
RUN mkdir "C:\winget-cli" 
RUN move-item "C:\TEMP\winget-cli\\AppInstallerCLI.exe" "C:\winget-cli\winget.exe" 
RUN move-item "C:\TEMP\winget-cli\\resources.pri" "C:\winget-cli\"

FROM mcr.microsoft.com/powershell:7.2-nanoserver-$BASE
COPY --from=base "C:\winget-cli\" "C:\Program Files\winget-cli\"