FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
WORKDIR /app
EXPOSE 5000

ENV ASPNETCORE_URLS=http://+:5000

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /src
COPY ["WDT2020-a3/WDT2020-a3.csproj", "WDT2020-a3/"]

RUN dotnet restore "WDT2020-a3\WDT2020-a3.csproj"
COPY . .
WORKDIR "/src/WDT2020-a3"
RUN dotnet build "WDT2020-a3.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "WDT2020-a3.csproj" -c Release -o /app/publish

#Angular build
FROM node as nodebuilder

# set working directory
RUN mkdir /usr/src/app
WORKDIR /usr/src/app

# add `/usr/src/app/node_modules/.bin` to $PATH
ENV PATH /usr/src/app/node_modules/.bin:$PATH


# install and cache app dependencies
COPY WDT2020-a3/ClientApp/package.json /usr/src/app/package.json
RUN npm install -g npm@7.20.3
RUN npm config set python C:\Users\bgfro\.windows-build-tools\python27
RUN npm install
RUN npm install -g @angular/cli@latest

# add app

COPY WDT2020-a3/ClientApp/. /usr/src/app

RUN npm run build

#End Angular build



FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
RUN mkdir -p /app/ClientApp/dist
COPY --from=nodebuilder /usr/src/app/dist/. /app/ClientApp/dist/
ENTRYPOINT ["dotnet", "WDT2020-a3.dll"]
