#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.
#todo: copy the Memer.Automata.Tg project files for build too?
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["LandingSite.Web/LandingSite.Web.csproj", "LandingSite.Web/"]
RUN dotnet restore "LandingSite.Web/LandingSite.Web.csproj"
COPY . .
WORKDIR "/src/LandingSite.Web"
RUN dotnet build "LandingSite.Web.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "LandingSite.Web.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "LandingSite.Web.dll"]