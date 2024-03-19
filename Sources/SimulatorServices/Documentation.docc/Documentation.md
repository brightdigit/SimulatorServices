# ``SimulatorServices``

Control the simulator... in Swift.

## Overview

![SimulatorServices Logo](logo.png)

**SimulatorServices** provides an easy to use API for managing, querying, and accessing simulators on your Mac.

### Requirements 

**Apple Platforms**

- Xcode 15.0 or later
- Swift 5.9 or later
- iOS 16 / watchOS 9 / tvOS 16 / macOS 13 / visionOS 1 / macCatalyst 9 or later deployment targets

**Linux**

- Ubuntu 20.04 or later
- Swift 5.9 or later

### Installation

Use the Swift Package Manager to install this library via the repository url:

```
https://github.com/brightdigit/SimulatorServices.git
```

Use version up to `1.1.0`.

### What does Simulator Services provide?

**SimulatorServices** allows you to execute subcommands to `simctl` directly in Swift while offering an easy to use API for parsing and passing arguments.  

### Usage

**SimulatorServices** uses the ``SimCtl`` object to pass subcommands. Each subcommand objects takes custom arguments or property and can parse the standard output into an easy to use Swift object. There are currently two supported subcommands: ``GetAppContainers`` and ``List``.

### Listing Simulators

The ``List`` subcommand gives you the ability pull the list of devices, device types, runtimes, and device pairs. For instances let's say you want to pull all your available devices which are booted:

```swift
let simctl = SimCtl()
let list = try await simctl.run(List())
let devices = list.devices.values
    .flatMap { $0 }
    .filter{$0.state == "Booted"}
```

For more details on the properties available, check out the documentation on ``SimulatorList``.

In this instance, we can take this a step further and find app container directories for these different simulator devices.

### Getting App Containers

With our list of device simulators, we can use the ``GetAppContainer`` subcommand to find specific paths. In this case, let's find the _data_ directory of our app `com.BrightDigit.Jojo.watchkitapp`:

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
      // if the data is missing that means that device does not contain that app container
      } catch GetAppContainer.Error.missingData {
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

For more details on arguments available, check out the documentation on `List`.

## Yeah but where's...?

While now this package only supports two subcommands, **however** there are two ways more subcommands can be supported:

* [add an issue](https://github.com/brightdigit/SimulatorServices/issues/new) and it will be implemented in the future by the organizers
* [add an issue](https://github.com/brightdigit/SimulatorServices/issues/new) and a [pull request](https://github.com/brightdigit/SimulatorServices/compare) which implements that ``Subcommand``

For details on how to implement a new ``Subcommand``, check out the code on the existing commands and take a look at the documentation of the `Subcommand` protocol.

## Learn more about `simctl`

There are some great articles out there regarding the intracacies of `simctl`. I highly recommend these articles which helped me in building this package:

* [simctl - NSHipster by @mattt](https://nshipster.com/simctl/)
* [Getting to Know the Simulator Better by @AndyIbanez](https://www.andyibanez.com/posts/getting-to-know-the-simulator-better/)

## Great Simulator Apps

Also take a look at these great app which take advantage of what `simctl` can do:

* [dataTile by @icanzlib](https://underplot.com/dataTile/)
* [RocketSim by @AvdLee](https://github.com/AvdLee/RocketSimApp)

## License 

This code is distributed under the MIT license. See the [LICENSE](https://github.com/brightdigit/SimulatorServices/LICENSE) file for more info.

## Topics

### Getting Started

- ``SimCtl``

### Subcommands for `simctl`

- ``List``
- ``GetAppContainer``

### Command Arguments

- ``ContainerID``
- ``SimulatorID``

### Simulator List Data

- ``SimulatorList``
- ``Device``
- ``DevicePair``
- ``DeviceType``
- ``Path``
- ``Runtime``
- ``DeviceState``
- ``PairState``
- ``ProductFamily``
- ``Platform``
- ``Version``
- ``ModelID``
- ``DeviceTypeID``
- ``RuntimeID``
- ``Path``


### Creating your own subcommands

- ``Subcommand``
- ``ProcessError``
- ``UncaughtSignal``
- ``TerminationReason``

### Helpers and Utlities

- ``PrefixedDecodableString``
- ``RawDefined``
- ``RawReversable``
- ``PrefixMismatchError``

