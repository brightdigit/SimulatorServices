<p align="center">
    <img alt="SimulatorServices" title="SimulatorServices" src="Assets/logo.svg" height="200">
</p>
<h1 align="center"> SimulatorServices </h1>

Control the simulator... in Swift

[![SwiftPM](https://img.shields.io/badge/SPM-Linux%20%7C%20iOS%20%7C%20macOS%20%7C%20watchOS%20%7C%20tvOS%20%7C%20visionOS-success?logo=swift)](https://swift.org)
[![Twitter](https://img.shields.io/badge/twitter-@brightdigit-blue.svg?style=flat)](http://twitter.com/brightdigit)
![GitHub](https://img.shields.io/github/license/brightdigit/SimulatorServices)
![GitHub issues](https://img.shields.io/github/issues/brightdigit/SimulatorServices)
![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/brightdigit/SimulatorServices/SimulatorServices.yml?label=actions&logo=github&?branch=main)

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fbrightdigit%2FSimulatorServices%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/brightdigit/SimulatorServices)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fbrightdigit%2FSimulatorServices%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/brightdigit/SimulatorServices)

# Table of Contents

* [Introduction](#introduction)
   * [Requirements](#requirements)
   * [Installation](#installation)
   * [What does Simulator Services provide?](#what-does-simulator-services-provide)
* [Usage](#usage)
   * [Choosing an Xcode](#choosing-an-xcode)
   * [Listing Simulators](#listing-simulators)
   * [Getting App Containers](#getting-app-containers)
   * [Listing Runtime Images](#listing-runtime-images)
   * [Deleting Runtimes and Changing Devices](#deleting-runtimes-and-changing-devices)
* [Yeah but where's...?](#yeah-but-wheres)
* [Learn more about simctl](#learn-more-about-simctl)
* [Great Simulator Apps](#great-simulator-apps)
* [License](#license)

# Introduction

**SimulatorServices** provides an easy to use API for managing, querying, and accessing simulators on your Mac.

## Requirements 

**Apple Platforms**

- Xcode 27.2 or later
- Swift 6.4 or later
- macOS 15.4 / iOS 16 / Mac Catalyst 16 / watchOS 9 / tvOS 16 / visionOS 1 or later deployment targets

**Linux**

- Ubuntu 22.04 or later
- Swift 6.4 or later

Running `simctl`, `xcode-select` and `mdfind`, and watching for Xcode installs, need macOS: `SimCtl()`, `SimCtl.find(developerDirectory:)`, `XcodeLocator` and `LiveSimCtlCommands` are only compiled there. On Linux and the other Apple platforms you still get the subcommands, the decoded models and the version parsing, for example to parse `simctl` output recorded on a Mac.

## Installation

Use the Swift Package Manager to install this library via the repository url:

```
https://github.com/brightdigit/SimulatorServices.git
```

Or add it to your `Package.swift`:

```swift
dependencies: [
  .package(url: "https://github.com/brightdigit/SimulatorServices.git", from: "1.1.0-beta.4")
],
```

and add the `SimulatorServices` product to your target's dependencies.

## What does Simulator Services provide?

**SimulatorServices** allows you to execute subcommands to `simctl` directly in Swift while offering an easy to use API for parsing and passing arguments.  

It also includes:

* `XcodeLocator`, which finds the installed Xcodes (including the one `xcode-select` points to) and streams a new snapshot when Xcodes are added, removed or selected
* `SimCtlCommands`, a protocol over the `simctl` calls with `LiveSimCtlCommands` as its live implementation, so your code can be tested without a Mac's simulators
* `SimctlSnapshot`, which holds one read of `simctl runtime list -j` and `simctl list -j` together, and `SimulatorAttribution`, which works out which simulators use which installed runtime
* `VersionNumber` and `BuildNumber`, for parsing and comparing Apple version and build strings

# Usage

**SimulatorServices** uses the `SimCtl` object to pass subcommands. Each subcommand objects takes custom arguments or property and can parse the standard output into an easy to use Swift object. The supported subcommands are `GetAppContainer`, `List`, `RuntimeList`, `RuntimeDelete`, `DeviceDelete`, `DeleteUnavailable`, `Boot`, `Shutdown` and `Erase`.

## Choosing an Xcode

By default `SimCtl` runs `xcrun simctl` with the Xcode that `xcode-select` points to. Pass `developerDirectory` to use another one. It's set as `DEVELOPER_DIR` for every call, and can be an Xcode app or its `Contents/Developer` directory:

```swift
let xcode = URL(fileURLWithPath: "/Applications/Xcode-beta.app")
let simctl = SimCtl(developerDirectory: xcode)
// or resolve simctl once with `xcrun --find simctl` and run it directly:
let resolved = try await SimCtl.find(developerDirectory: xcode)
```

## Listing Simulators

The `List` subcommand gives you the ability pull the list of devices, device types, runtimes, and device pairs. For instances let's say you want to pull all your available devices which are booted:

```swift
let simctl = SimCtl()
let list = try await simctl.run(List())
let devices = list.devices.values
    .flatMap { $0 }
    .filter { $0.state == .booted }
```

For more details on the properties available, check out the documentation on `SimulatorList`.

In this instance, we can take this a step further and find app container directories for these different simulator devices.

## Getting App Containers

With our list of device simulators, we can use the `GetAppContainer` subcommand to find specific paths. In this case, let's find the _data_ directory of our app `com.BrightDigit.Jojo.watchkitapp`:

```swift
let jojoSimulatorDataDirPaths: [Path] = await withTaskGroup(of: Path?.self) { taskGroup in
  for device in devices {
    taskGroup.addTask {
      do {
        return try await simctl.run(
          GetAppContainer(
            appBundleIdentifier: "com.BrightDigit.Jojo.watchkitapp",
            container: .data,
            // use the udid of the device to indicate which simulator to pull from
            simulator: .id(device.udid)
          )
        )
      // unreadable output means that device does not contain that app container
      } catch SimCtlError.unreadableOutput {
        return nil
      } catch {
        return nil
      }
    }
  }

  return await taskGroup.reduce(into: [Path]()) { paths, path in
    // essential this does a compactMap on results
    if let path {
      paths.append(path)
    }
  }
}
```

For more details on arguments available, check out the documentation on `GetAppContainer`.

## Listing Runtime Images

The `RuntimeList` subcommand runs `simctl runtime list -j` and returns each installed runtime image as a `RuntimeImage`, with its identifier, version, build, platform, size, state, kind and path:

```swift
let images = try await simctl.run(RuntimeList())
let deletable = images.filter(\.canDelete)
```

`canDelete` is `false` for runtimes bundled with Xcode (`deletable: false`), legacy runtimes that aren't disk images (`kind` is `Legacy Download`), and images that are already being deleted (`state` is `Deleting`).

## Deleting Runtimes and Changing Devices

`RuntimeDelete`, `DeviceDelete`, `DeleteUnavailable`, `Boot`, `Shutdown` and `Erase` change simulators and return nothing. When `simctl` fails, they throw a `SimCtlError` holding its exit status and its standard error verbatim, plus a `reason` for the failures recorded so far (an unknown device, a device in the wrong state, or no matching runtime):

```swift
do {
  try await simctl.run(RuntimeDelete(beta.identifier, otherBeta.identifier))
} catch {
  // `run` throws `SimCtlError`
  print(error.standardError ?? error.localizedDescription)
}

do {
  try await simctl.run(Boot(device.udid))
} catch where error.reason == .invalidState {
  // already booted
} catch {
  print(error.localizedDescription)
}
```

# Yeah but where's...?

While now this package only supports a few subcommands, **however** there are two ways more subcommands can be supported:


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

This code is distributed under the MIT license. See the [LICENSE](https://github.com/brightdigit/SimulatorServices/blob/main/LICENSE) file for more info.
