BeforeDiscovery {
  $ModuleName = 'AzureDevOpsPowerShell'
  Get-Module $ModuleName | Remove-Module -Force -ErrorAction Ignore
  $path = Join-Path -Path $PSScriptRoot -ChildPath "..\..\..\..\$ModuleName\$ModuleName.psm1" | Resolve-Path
  Import-Module -Name $path -Verbose:$false -ErrorAction Stop
}

InModuleScope $ModuleName {
  BeforeAll {
    $collectionUri = "https://dev.azure.com/AzureDevOpsPowerShell"

    $params = @{
      CollectionUri = $collectionUri
      Confirm       = $false
    }
  }

  Describe "Get-AzDoExtension" -Tag Local {
    BeforeAll {
      Mock Invoke-AzDoRestMethod {
        @{
          value = @(
            [PSCustomObject]@{
              CollectionURI            = $CollectionUri
              ExtensionCollectionURI   = $extensionCollectionUri
              ExtensionId              = 'vss-testextension'
              ExtensionName            = 'extensionTest'
              ExtensionPublisherId     = 'rbnmk'
              ExtensionPublisherName   = 'RobinM'
              ExtensionVersion         = '0.0.1'
              ExtensionBaseUri         = 'baseUri'
              ExtensionFallbackBaseUri = 'fallbackBaseUri'
            }
            [PSCustomObject]@{
              CollectionURI            = $CollectionUri
              ExtensionCollectionURI   = $extensionCollectionUri
              ExtensionId              = 'vss-testextension2'
              ExtensionName            = 'extensionTest2'
              ExtensionPublisherId     = 'rbnmk2'
              ExtensionPublisherName   = 'RobinM2'
              ExtensionVersion         = '0.0.1'
              ExtensionBaseUri         = 'baseUri2'
              ExtensionFallbackBaseUri = 'fallbackBaseUri2'
            }
            [PSCustomObject]@{
              CollectionURI            = $CollectionUri
              ExtensionCollectionURI   = $extensionCollectionUri
              ExtensionId              = 'vss-testextension3'
              ExtensionName            = 'extensionTest3'
              ExtensionPublisherId     = 'rbnmk3'
              ExtensionPublisherName   = 'RobinM3'
              ExtensionVersion         = '0.0.1'
              ExtensionBaseUri         = 'baseUri3'
              ExtensionFallbackBaseUri = 'fallbackBaseUri3'
            }
          )
        }
      }
    }

    It "It provides users with feedback via ShouldProcess when using WhatIf" {
      Get-AzDoExtension @params -WhatIf -Verbose 4>&1 | Out-String | Should -BeLike "*Calling Invoke-AzDoRestMethod with {*"
    }

    It "Outputs all extensions when no value to ExtensionName or ExtensionId was provided" {
      (Get-AzDoExtension @params | Measure-Object).Count | Should -BeGreaterThan 1
    }

    It "Outputs extension which matches the name of ExtensionName" {
      (Get-AzDoExtension @params -ExtensionName "extensionTest3").ExtensionName | Should -Be "extensionTest3"
    }

    It "Outputs extension which matches the Id of ExtensionId" {
      (Get-AzDoExtension @params -ExtensionId "vss-testextension2").ExtensionId | Should -Be "vss-testextension2"
    }

    It "Outputs extensions which matches the Id of ExtensionId AND ExtensionName" {
      (Get-AzDoExtension @params -ExtensionId "vss-testextension2" -ExtensionName "extensionTest3" | Measure-Object).count | Should -BeExactly 2
    }

  }

  Describe "New-AzDoExtension" -Tag Local {
    BeforeAll {

      $params.Add("ExtensionId", "vss-testextension")
      $params.Add("ExtensionPublisherId", "rbnmk")

      Mock Invoke-AzDoRestMethod { $null }

    }

    It "It provides users with feedback via ShouldProcess when using WhatIf" {
      New-AzDoExtension @params -WhatIf -Verbose 4>&1 | Out-String | Should -BeLike "*Calling Invoke-AzDoRestMethod with {*"
    }

    It "Installs AzDo extension when ExtensionId and ExtensionPublisherId are provided and returns null or empty" {
      (New-AzDoExtension @params) | Should -BeNullOrEmpty
    }

    It "Installs AzDo extension when ExtensionId, ExtensionPublisherId and ExtensionVersion are provided and returns null or empty" {
      $params.Add("ExtensionVersion", "0.0.1")
      (New-AzDoExtension @params) | Should -BeNullOrEmpty
    }

    It "Throws exception when ExtensionId/PublisherName is already installed" {
      Mock Invoke-AzDoRestMethod { throw "Extension already installed" }
      { New-AzDoExtension @params } | Should -Throw -Because "Extension already installed"
    }


  }

  Describe "Remove-AzDoExtension" -Tag Local {
    BeforeAll {

      Mock Invoke-AzDoRestMethod { $null }

    }

    It "It provides users with feedback via ShouldProcess when using WhatIf" {
      Remove-AzDoExtension @params -WhatIf -Verbose 4>&1 | Out-String | Should -BeLike "*Calling Invoke-AzDoRestMethod with {*"
    }

    It "Removes AzDo extension when ExtensionId and ExtensionPublisherId are provided and returns null or empty" {
      $params.Add("ExtensionId", "vss-testextension")
      $params.Add("ExtensionPublisherId", "rbnmk")
      (New-AzDoExtension @params) | Should -BeNullOrEmpty
    }
  }
}
