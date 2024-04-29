# Use the official Microsoft .NET Core runtime as a parent image
FROM mcr.microsoft.com/dotnet/aspnet:6.0.20 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

# Use SDK image to build the project files
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY . /src
RUN dotnet restore "ShopApi/ShopApi.csproj"
WORKDIR "/src/ShopApi"
RUN dotnet build "ShopApi.csproj" -c Release -o /app/build

# Publish the project
FROM build AS publish
RUN dotnet publish "ShopApi.csproj" -c Release -o /app/publish

# Build runtime image
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "ShopApi.dll"]
