# Introduction
This repos is to task ACR Build Task with Azure DevOps 

## Goal
The goal of this repo is to show how you can use ACR Build Tasks, Logic Apps and Azure DevOps to refresh your Windows containers whenever Microsoft pushes patches out.

## Overview

# Build Base
* src/Dockerfile.base - A simple Dockerfile with mcr.microsoft.com/dotnet/framework/runtime:4.8-windowsservercore-ltsc2019 as the base image. 
* An ACR build task tracks changes made to mcr.microsoft.com/dotnet/framework/runtime:4.8-windowsservercore-ltsc2019 and triggers a new build if a change is detected
* The build pushes a container named {acr_name}.azurecr.io/windows/bjdbasewindows2019:ltsc2019. 
    * This should base image that all my other containers derive from. 

## Setup
* az acr build --registry bjd145 --image  windows/bjdbasewindows2019:ltsc2019 --file .\Dockerfile.base . --platform windows 

# Azure DevOps Build Pipeline
* src/Dockerfile.app - A simple Dockerfile with {acr_name}.azurecr.io/windows/bjdbasewindows2019:ltsc2019 as the base image. 
* This build pipeline creates a simple application container - Just sets an Environmental variables in a Windows container. 
* This pipeline will be triggered by a Logic App Workflow whenever the base image is updated. 
* Use the azure-pipelines.yaml to create a new Build Pipeline. 

# Logic App 
* The Logic App listens on an HTTP endpoint  and will be triggered by any push to the Azure Container Repo.
* It will check to see if there is a new push to windows/bjdbasewindows2019:ltsc2019 
* If there is a new push then it will trigger a VSTS Build for the dependent Application container. 

##  WebHook to Trigger App Container Build
 * az group create -n ACR_Build_Tasks -l southcentralus
 * az group deployment create -g ACR_Build_Tasks --template-file .\AppContainerBuild\azuredeploy.json --parameters .\AppContainerBuild\azure.parameters.prd.json
 * az acr webhook create --registry bjd145  --name PushNotification --actions push --uri {Taken from ARM Ouput}
