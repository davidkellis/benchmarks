FROM mcr.microsoft.com/dotnet/sdk

RUN apt-get update && apt-get install -y time

WORKDIR /app

# keep in mind that the docker build command is being run from the benchmarks/ project's root directory
# and the context directory is being specified as the benchmarks/ root directory
COPY time.sh .
COPY fib/csharp/*.cs .
COPY fib/csharp/*.csproj .

RUN dotnet build -c Release -o bin

CMD ["./time.sh", "dotnet", "bin/fib.dll"]
