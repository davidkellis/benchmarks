FROM microsoft/dotnet:2.1.301-sdk

RUN apt-get update && apt-get install -y time

WORKDIR /app

# keep in mind that the docker build command is being run from the benchmarks/ project's root directory
# and the context directory is being specified as the benchmarks/ root directory
COPY time.sh .
COPY matrixmultiply/csharp-dotnetcore2.1.301/*.cs .
COPY matrixmultiply/csharp-dotnetcore2.1.301/*.csproj .

RUN dotnet build -c Release

CMD ["./time.sh", "dotnet", "bin/Release/netcoreapp2.1/matmul.dll", "1000"]