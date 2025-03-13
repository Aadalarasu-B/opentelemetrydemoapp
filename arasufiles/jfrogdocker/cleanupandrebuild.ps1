# Stop and remove containers (ignore errors if not found)
docker stop artifactory, postgres 2>$null
docker rm artifactory, postgres 2>$null

# Remove specific volumes if they exist. Adjust volume names as needed.
docker volume rm artifactory_data pg_data 2>$null

# Optionally, remove all unused volumes:
docker volume prune -f

# Remove the old configuration folder
Remove-Item -Path "C:\Users\lenovo\opentelemetrydemoapp\arasufiles\jfrogdocker\artifactory-var\etc" -Recurse -Force

# Recreate necessary directories for configuration
New-Item -ItemType Directory -Path "C:\Users\lenovo\opentelemetrydemoapp\arasufiles\jfrogdocker\artifactory-var\etc\security" -Force | Out-Null

# Optionally, re-create PostgreSQL directory if you use a bind mount for it
New-Item -ItemType Directory -Path "C:\Users\lenovo\opentelemetrydemoapp\arasufiles\jfrogdocker\postgresql" -Force | Out-Null

# Generate a new Master Key using OpenSSL and save it to master.key
openssl rand -hex 32 | Out-File -Encoding utf8 "C:\Users\lenovo\opentelemetrydemoapp\arasufiles\jfrogdocker\artifactory-var\etc\security\master.key"

Write-Output "Cleanup complete and new master.key generated."

# Remove the old configuration folder
Remove-Item -Path "C:\Users\lenovo\opentelemetrydemoapp\arasufiles\jfrogdocker\jfrogconfig" -Recurse -Force

# Recreate necessary directories for configuration (make sure the path matches our docker-compose bind mount)
New-Item -ItemType Directory -Path "C:\Users\lenovo\opentelemetrydemoapp\arasufiles\jfrogdocker\jfrogconfig\etc\security" -Force | Out-Null

# (Optionally) Recreate PostgreSQL directory if you are binding it in your compose
New-Item -ItemType Directory -Path "C:\Users\lenovo\opentelemetrydemoapp\arasufiles\jfrogdocker\postgresql" -Force | Out-Null

# Generate a new Master Key using OpenSSL and save it to master.key. The file must reside at:
# jfrogconfig\etc\security\master.key
openssl rand -hex 32 | Out-File -Encoding utf8 "C:\Users\lenovo\opentelemetrydemoapp\arasufiles\jfrogdocker\jfrogconfig\etc\security\master.key"

Write-Output "Cleanup complete and new master.key generated."