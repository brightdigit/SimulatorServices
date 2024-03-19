import SimulatorServices
import XCTest

public func XCTAssertEmpty(_ expression: @autoclosure () throws -> [Any], _ message: @autoclosure () -> String? = nil, file _: StaticString = #filePath, line _: UInt = #line) rethrows {
  if let message = message() {
    try XCTAssert(expression().isEmpty, message)
    return
  }

  let value = try expression()
  XCTAssert(value.isEmpty, "Array is not empty: \(value.map { "\($0)" }.joined(separator: ","))")
}

final class DeviceTests: XCTestCase {
  
  func testSimCtlList() async throws {
    #if os(macOS)
      let simctl = SimCtl()
      let results = try await simctl.run(List())

      var deviceTypeIDs = [DeviceTypeID]()
      var deviceStates = [DeviceState]()
      var pairStates = [PairState]()
      var platforms = [Platform]()
      var productFamilies = [ProductFamily]()

      for devices in results.devices.values {
        for device in devices {
          deviceTypeIDs.append(device.deviceTypeIdentifier)
          deviceStates.append(device.state)
        }
      }

      for devicetype in results.devicetypes {
        productFamilies.append(devicetype.productFamily)
        deviceTypeIDs.append(devicetype.identifier)
      }

      for runtime in results.runtimes {
        platforms.append(runtime.platform)
        platforms.append(runtime.identifier.platform)
        for supportedDeviceType in runtime.supportedDeviceTypes {
          deviceTypeIDs.append(supportedDeviceType.identifier)
          productFamilies.append(supportedDeviceType.productFamily)
        }
      }

      for pair in results.pairs.values {
        deviceStates.append(pair.phone.state)
        deviceStates.append(pair.watch.state)
        pairStates.append(pair.state)
      }

      let unknownDevicetypeids = deviceTypeIDs.compactMap { $0.unknownValue() }
      let unknownDevicestates = deviceStates.compactMap { $0.unknownValue() }
      let unknownPairstates = pairStates.compactMap { $0.unknownValue() }
      let unknownPlatforms = platforms.compactMap { $0.unknownValue() }
      let unknownProductfamilies = productFamilies.compactMap { $0.unknownValue() }

      XCTAssertEmpty(unknownDevicetypeids)
      XCTAssertEmpty(unknownDevicestates)
      XCTAssertEmpty(unknownPairstates)
      XCTAssertEmpty(unknownPlatforms)
      XCTAssertEmpty(unknownProductfamilies)
    #else
      throw XCTSkip("Unavailable in operating system")
    #endif
  }
}
