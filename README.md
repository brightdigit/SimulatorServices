<p align="center">
    <img alt="SimulatorServices" title="SimulatorServices" src="Assets/logo.svg" height="200">
</p>
<h1 align="center"> SimulatorServices </h1>

Control the simulator... in Swift

[![SwiftPM](https://img.shields.io/badge/SPM-Linux%20%7C%20iOS%20%7C%20macOS%20%7C%20watchOS%20%7C%20tvOS-success?logo=swift)](https://swift.org)
[![Twitter](https://img.shields.io/badge/twitter-@brightdigit-blue.svg?style=flat)](http://twitter.com/brightdigit)
![GitHub](https://img.shields.io/github/license/brightdigit/SimulatorServices)
![GitHub issues](https://img.shields.io/github/issues/brightdigit/SimulatorServices)
![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/brightdigit/SimulatorServices/SimulatorServices.yml?label=actions&logo=github&?branch=main)

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fbrightdigit%2FSimulatorServices%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/brightdigit/SimulatorServices)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fbrightdigit%2FSimulatorServices%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/brightdigit/SimulatorServices)


[![Codecov](https://img.shields.io/codecov/c/github/brightdigit/SimulatorServices)](https://codecov.io/gh/brightdigit/SimulatorServices)
[![CodeFactor Grade](https://img.shields.io/codefactor/grade/github/brightdigit/SimulatorServices/release/0.0.1)](https://www.codefactor.io/repository/github/brightdigit/SimulatorServices)
[![codebeat badge](https://codebeat.co/badges/9b0cb8e0-7ad2-4dcc-a418-18fde060c601)](https://codebeat.co/projects/github-com-brightdigit-sublimation-main)
[![Code Climate maintainability](https://img.shields.io/codeclimate/maintainability/brightdigit/SimulatorServices)](https://codeclimate.com/github/brightdigit/SimulatorServices)
[![Code Climate technical debt](https://img.shields.io/codeclimate/tech-debt/brightdigit/SimulatorServices?label=debt)](https://codeclimate.com/github/brightdigit/SimulatorServices)
[![Code Climate issues](https://img.shields.io/codeclimate/issues/brightdigit/SimulatorServices)](https://codeclimate.com/github/brightdigit/SimulatorServices)
[![Reviewed by Hound](https://img.shields.io/badge/Reviewed_by-Hound-8E64B0.svg)](https://houndci.com)

# Table of Contents

* [Introduction](#introduction)
   * [Requirements](#requirements)
   * [Installation](#installation)
   * [What does Simulator Services provide?](#what-does-simulator-services-provide)
* [Usage](#usage)
   * [Listing Simulators](#listing-simulators)
   * [Getting App Containers](#getting-app-containers)
* [Yeah but where's...?](#yeah-but-wheres)
* [Learn more about simctl](#learn-more-about-simctl)
* [Great Simulator Apps](#great-simulator-apps)
* [License](#license)

# Introduction

**SimulatorServices** provides an easy to use API for managing, querying, and accessing simulators on your Mac.

## Requirements 

**Apple Platforms**

- Xcode 13.3 or later
- Swift 5.5.2 or later
- iOS 14 / watchOS 6 / tvOS 14 / macOS 12 or later deployment targets

**Linux**

- Ubuntu 18.04 or later
- Swift 5.5.2 or later

## Installation

Use the Swift Package Manager to install this library via the repository url:

```
https://github.com/brightdigit/SimulatorServices.git
```

Use version up to `1.0.1`.

## What does Simulator Services provide?

**SimulatorServices** allows you to execute subcommands to `simctl` directly in Swift while offering an easy to use API for parsing and passing arguments.  

# Usage

**SimulatorServices** uses the `SimCtl` object to pass subcommands. Each subcommand objects takes custom arguments or property and can parse the standard output into an easy to use Swift object. There are currently two supported subcommands: `GetAppContainers` and `List`.

## Listing Simulators

The `List` subcommand gives you the ability pull the list of devices, device types, runtimes, and device pairs. For instances let's say you want to pull all your available devices which are booted:

```swift
let simctl = SimCtl()
let list = try await self.run(List())
let devices = list.devices.values
    .flatMap { $0  }
    .filter{$0.state == "Booted"}
```

For more details on the properties available, check out the documentation on `SimulatorList`.

In this instance, we can take this a step further and find app container directories for these different simulator devices.

## Getting App Containers

With our list of device simulators, we can use the `GetAppContainer` subcommand to find specific paths. In this case, let's find the _data_ directory of our app `com.BrightDigit.Jojo.watchkitapp`:

```swift
for device in devices {
  taskGroup.addTask {
    do {
      return try await self.run(
        GetAppContainer(
          appBundleIdentifier: "com.BrightDigit.Jojo.watchkitapp", 
          container: "data", 
          // use the udid of the device to indicate which simulator to pull from
          simulator: .id(device.udid)
        )
      )
    // if the data is missing that means that device does not contain that app container
    } catch GetAppContainer.Error.missingData {
      return nil
    }
  }
}

let jojoSimulatorDataDirPaths = try await taskGroup.reduce(into: [Path]()) { paths, path in
  // essential this does a compactMap on results
  if let path {
    paths.append(path)
  }
}
```

For more details on arguments available, check out the documentation on `List`.

# Yeah but where's...?

While now this package only supports two subcommands, **however** there are two ways more subcommands can be supported:


* [add an issue](https://github.com/brightdigit/SimulatorServices/issues/new) and it will be implemented in the future by the organizers
* [add an issue](https://github.com/brightdigit/SimulatorServices/issues/new) and a [pull request](https://github.com/brightdigit/SimulatorServices/compare) which implements that `Subcommand`

For details on how to implement a new `Subcommand`, check out the code on the existing commands and take a look at the documentation of the `Subcommand` protocol.

# Learn more about `simctl`

There are some great articles out there regarding the intracacies of `simctl`. I highly recommend these articles which helped me in building this package:

* [simctl - NSHipster by @mattt](https://nshipster.com/simctl/)
* [Getting to Know the Simulator Better by @AndyIbanez](https://www.andyibanez.com/posts/getting-to-know-the-simulator-better/)

# Great Simulator Apps

Also take a look at these great app which take advantage of what `simctl` can do:

* [dataTile by @icanzlib](https://underplot.com/dataTile/)
* [RocketSim by @AvdLee](https://github.com/AvdLee/RocketSimApp)

# License 

This code is distributed under the MIT license. See the [LICENSE](https://github.com/brightdigit/SimulatorServices/LICENSE) file for more info.
