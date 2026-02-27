FROM mcr.microsoft.com/dotnet/sdk:10.0
RUN apt-get update && apt-get install -y time

WORKDIR /app
COPY time.sh .
COPY i-before-e/wordlist.txt .
COPY i-before-e/csharp-10.0/run.cs .
COPY i-before-e/csharp-10.0/app.csproj .

RUN dotnet build -c Release -o bin

CMD ["./time.sh","dotnet","bin/app.dll","wordlist.txt"]
