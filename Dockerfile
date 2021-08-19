FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
RUN apt-get update -yq \
    && apt-get install curl gnupg -yq \
    && curl -sL https://deb.nodesource.com/setup_10.x | bash \
    && apt-get install nodejs -yq
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
RUN apt-get update -yq \
    && apt-get install curl gnupg -yq \
    && curl -sL https://deb.nodesource.com/setup_10.x | bash \
    && apt-get install nodejs -yq
WORKDIR /src
COPY ["WDT2020-a3/WDT2020-a3.csproj", "WDT2020-a3/"]
RUN dotnet restore "WDT2020-a3\WDT2020-a3.csproj"
COPY . .
WORKDIR "/src/WDT2020-a3"
RUN dotnet build "WDT2020-a3.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "WDT2020-a3.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "WDT2020-a3.dll"]
