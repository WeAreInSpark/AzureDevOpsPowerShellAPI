# Repository structure

We have several files which relate to our code, quality testing, releases and the documentation.

This can be a bit intimidating, but every part has it's own usecase.

In this document we'll show you what each folder/document represents and how it contributes to our PowerShell module.

- .devcontainer/ <br>
  This directory contains two files related to our devcontainer setup.
  A devcontainer is a configuration environment for VSCode, containing everything you need to work on our code.

  - Dockerfile <br>
  The dockerfile contains all the specifics on what container baseimage to fetch and what to add on top of it.

  - devcontainer.json <br>
  This json file contains all VSCode configuration information. It has terminal settings, contains all the extensions to load with the container and launch setup.

- .github/ <br>
  This folder contains everything relevant for our GitHub setup. From our pipelines to our PR and issue templates.

  - CONTRIBUTING.md <br>
    This file contains guidance on how to contribute to our repository

  - ISSUE_TEMPLATE.md <br>
    This file contains our current issue templates, this prefills any issues created by a user.

  - PULL_REQUEST_TEMPLATE.md <br>
    This file contains our current pull request templates, this prefills any issues created by a user.

  - pr-labeler.yml <br>
    This file is used to label our Pull Requests based on their gitbranch.

  - release.yml <br>
    This file has specifics on how the [release documentation](https://github.com/WeAreInSpark/BRC.PS.InfrastructureAsCode/releases/) should be generated.

  - .github/workflows/ <br>
    This folder contains our pipelines. In the pipeline files is instructed what actions must be performed after events.
    - Tests.yaml <br>
      This pipeline runs after a pull request is created, it test for compatibility and sets the PR label after testing. The pipeline tests compatibility on each platform (Windows, Ubuntu and MacOS) by running `build.ps1` on each OS (and therefore running our tests). <br>
      After the tests complete running the pull-request is labeled with labels using the branch name as defined in `pr-labeler.yml`.

    - Release.yaml <br>
      This pipeline releases our PowerShell module to our Azure DevOps Artifacts NuGet Package feed. <br>
      When a file in our PowerShell module is changed, and the change is committed on main (after a pull request). <br>
      It fetches the previous tag, calculates the version (based on SemVer), creates the GitHub release and finally release to Azure DevOps.

- .vscode/ <br>
  This folder contains everything relevant for our GitHub setup. From our pipelines to our PR and issue templates.

  - extensions.json <br>
    This json file contains all our recommendations for [VSCode extensions](https://code.visualstudio.com/docs/editor/extension-marketplace).

  - launch.json <br>
    This json file contains all VSCode [debug configurations](https://code.visualstudio.com/docs/editor/debugging).

  - settings.json <br>
    This json file contains all [VSCode configuration settings](https://code.visualstudio.com/docs/getstarted/settings) with some of our code standards. <br>
    These override global settings by the user.

  - tasks.json <br>
    This json file contains all [VSCode task definitions](https://code.visualstudio.com/Docs/editor/tasks) for this repo.

- docs/ <br>
  This directory contains all our documentation, hosted in our documentation site.

- InSpark.InfrastructureAsCode/ <br>
  This folder contains all our PowerShell source code, which combined create a module.

  - InSpark.InfrastructureAsCode.psd1 <br>
    A module manifest file with the specifics what the module is, what it requires and which functions the module has. <br>
    This file normally contains all the functions you want to export, but this version is not the built version. <br>
    So you might miss entries which get filled in the build pipeline and the final module.

  - InSpark.InfrastructureAsCode.psm1 <br>
    A powershell module file, this is what makes a module a module. It enables some module sensitive options versus a script (.ps1).

  - Public/ <br>
    The definitions of the public PowerShell functions, the functions you can use in the console.

  - Private/ <br>
    The definitions of the private PowerShell functions, the functions that work supporting in the background. <br>
    You typically cannot use these functions in the console.

- tests/ <br>
  The folder with all our CI definitions and rules. With these definitions we can test our code.
  - Help.tests.ps1 <br>
    The PowerShell Pester tests, that test for function comment-based help.

  - Manifest.tests.ps1 <br>
    The PowerShell Pester tests, that test our PowerShell module manifest file (.psd1).

  - Meta.tests.ps1 <br>
    The PowerShell Pester tests, that test file encoding, and filenames.MetaFixers.psm1.

  - MetaFixers.psm1 <br>
    A PowerShell Script module, that is required for our meta.tests.ps1.

  - ScriptAnalyzerSettings.psd1 <br>
    Our PowerShell Script Analyzer rules settings Indented.ScriptAnalyzerRules.

  - Indented.ScriptAnalyzerRules/ <br>
    A module containing additional PowerShell Script Analyzer rules.

- .gitattributes <br>
  This file gives gitattributes to pathnames. In our case defines what lineendings to use.

- .gitignore <br>
  This file defines what directories/files not to integrate into source control (what is versioned in the repo).

- CHANGELOG.md <br>
  A reference to all changes we made in our module development.

- CODE_OF_CONDUCT.md <br>
  Our rules of how we should function as a team.

- LICENSE <br>
  The license of our code, what defines what you can and cannot do with it

- LICENSE <br>
  The license of our code, what defines what you can and cannot do with it

- README.md <br>
  A generic introduction into our repository

- build.ps1 <br>
  This is a script file in which we build our code.
  It installs and imports dependant modules, and kicks of our psake tooling.

- mkdocs.yml <br>
  A file with specifics on how to build our documentation site.

- psakeFile.ps1 <br>
  A psake file which references functions from the PowerShellBuild module, which is used in the build of our module.
