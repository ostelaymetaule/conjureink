#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.
#todo: copy the Memer.Automata.Tg project files for build too?
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080

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
# install System.Drawing native dependencies
RUN apt-get update \
    && apt-get install -y --allow-unauthenticated \
        libc6-dev \
        libgdiplus \
        libx11-dev \
     && rm -rf /var/lib/apt/lists/*
     
WORKDIR /app
COPY --from=publish /app/publish .
RUN ls
ENTRYPOINT ["./LandingSite.Web"]