# Etapa de Build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copiar os arquivos .csproj e restaurar as depend�ncias
COPY GitHubRepoApp/GitHubRepoApp.csproj ./GitHubRepoApp/
COPY GitHubRepoApp.Application/GitHubRepoApp.Application.csproj ./GitHubRepoApp.Application/
COPY GitHubRepoApp.Domain/GitHubRepoApp.Domain.csproj ./GitHubRepoApp.Domain/
COPY GitHubRepoApp.Infrastructure/GitHubRepoApp.Infrastructure.csproj ./GitHubRepoApp.Infrastructure/

RUN dotnet restore ./GitHubRepoApp/GitHubRepoApp.csproj

# Copiar todo o c�digo fonte para o container
COPY . .

# Publicar a aplica��o
WORKDIR /src/GitHubRepoApp
RUN dotnet publish -c Release -o /out

# Etapa de Runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /out .
EXPOSE 80
ENTRYPOINT ["dotnet", "GitHubRepoApp.dll"]
