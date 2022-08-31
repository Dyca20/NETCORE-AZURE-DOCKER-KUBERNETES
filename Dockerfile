FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 5080

ENV ASPNETCORE_URLS=http://+:5080

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["NETCORE-AZURE-DOCKER-KUBERNETES.csproj", "./"]
RUN dotnet restore "NETCORE-AZURE-DOCKER-KUBERNETES.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "NETCORE-AZURE-DOCKER-KUBERNETES.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "NETCORE-AZURE-DOCKER-KUBERNETES.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "NETCORE-AZURE-DOCKER-KUBERNETES.dll"]
