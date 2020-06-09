
Writ-Host "Cerating Azure ACR Build Task"

az acr task create -n base-w2k19 -r bjd145 `
    -t windows/bjdbasewindows2019:ltsc2019 `
    -f src/Dockerfile.base                 `
    --platform windows                     `
    --context https://github.com/briandenicola/acr-build-tasks.git `
    --commit-trigger-enabled false         `
    --pull-request-trigger-enabled false