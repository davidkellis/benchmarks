FROM mcr.microsoft.com/dotnet/sdk:8.0
RUN apt-get update && apt-get install -y time

WORKDIR /app
COPY time.sh .
COPY binarytrees/csharp-8.0/run.cs .
COPY binarytrees/csharp-8.0/app.csproj .

RUN dotnet build -c Release -o bin

CMD ["./time.sh","dotnet","bin/app.dll","21"]
