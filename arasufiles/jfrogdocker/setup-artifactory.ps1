# PowerShell script to automate JFrog Artifactory setup

Write-Host "🔄 Stopping and Removing Existing Artifactory Containers..."
docker stop artifactory 2>$null
docker rm artifactory 2>$null

Write-Host "🧹 Deleting Old Artifactory Configuration..."
Remove-Item -Path C:\Users\lenovo\artifactory -Recurse -Force -ErrorAction SilentlyContinue

Write-Host "📂 Creating Required Directories..."
New-Item -ItemType Directory -Path C:\Users\lenovo\artifactory\etc\security -Force | Out-Null
New-Item -ItemType Directory -Path C:\Users\lenovo\artifactory\etc -Force | Out-Null

Write-Host "🔑 Generating a New Master Key..."
[System.Guid]::NewGuid().ToString("N") | Out-File -Encoding utf8 C:\Users\lenovo\artifactory\etc\security\master.key

Write-Host "📝 Creating System Configuration File..."
@"
shared:
  node:
    id: standalone-node
    haEnabled: false  # Force standalone mode
  database:
    type: derby  # Use internal DB (default)
access:
  standalone: true  # Ensure Access Service runs in standalone mode
router:
  entrypoints:
    access:
      port: 8040  # Ensure Access Service is reachable
"@ | Set-Content -Path C:\Users\lenovo\artifactory\etc\system.yaml

Write-Host "🚀 Starting JFrog Artifactory Docker Container..."
docker run --name artifactory -d -p 8082:8082 -p 8081:8081 `
    -v C:\Users\lenovo\artifactory\etc:/opt/jfrog/artifactory/var/etc `
    -v C:\Users\lenovo\artifactory\etc\security:/opt/jfrog/artifactory/var/etc/security `
    releases-docker.jfrog.io/jfrog/artifactory-oss:latest

Write-Host "📡 Monitoring Logs..."
Start-Sleep -Seconds 5
docker logs -f artifactory
