# Example usage

This example shows you how can you can add a repository to your existing Azure DevOps project, add files to it, and create pipelines from those files.

## Get Azure DevOps project

```powershell
Connect-AzAccount

$project = Get-AzDoProject -CollectionUri "https://dev.azure.com/contoso" -ProjectName "MyProject"
```

## Create a repository

```powershell
$repo = $project | New-AzDoRepo -RepoName "RepoTest"
```

## Add files to your repository

```powershell
$repo | Add-FilesToRepo -Path "C:/git/MyProject/MyRepo"
```

## Create a pipeline in your Azure DevOps Project

```powershell
$repo | New-AzDoPipeline -PipelineName "TestPipeline" -Path "/pipelines/pipeline1.yml"
```
