import Foundation


public struct Device : Decodable {
  public let dataPath : Path // URL?
  public let dataPathSize : Int
  public let logPath: Path // URL?
  public let udid: UUID
  public let isAvailable: Bool
  public let logPathSize: Int?
  public let lastBootedAt: Date?
  public let deviceTypeIdentifier: DeviceTypeID // Identifier (Device)
  public let state : DeviceState // DeviceState
  public let name : String
//  "com.apple.CoreSimulator.SimRuntime.iOS-16-0" : [
//        {
//          "lastBootedAt" : "2022-08-18T18:41:03Z",
//          "dataPath" : "\/Users\/leo\/Library\/Developer\/CoreSimulator\/Devices\/B1CD8B99-16E1-4841-BA5F-7C38776E41F6\/data",
//          "dataPathSize" : 1723662336,
//          "logPath" : "\/Users\/leo\/Library\/Logs\/CoreSimulator\/B1CD8B99-16E1-4841-BA5F-7C38776E41F6",
//          "udid" : "B1CD8B99-16E1-4841-BA5F-7C38776E41F6",
//          "isAvailable" : false,
//          "availabilityError" : "runtime profile not found",
//          "logPathSize" : 225280,
//          "deviceTypeIdentifier" : "com.apple.CoreSimulator.SimDeviceType.iPhone-13",
//          "state" : "Shutdown",
//          "name" : "iPhone 13"
//        },
//        {
//          "availabilityError" : "runtime profile not found",
//          "dataPath" : "\/Users\/leo\/Library\/Developer\/CoreSimulator\/Devices\/9F868F6D-5AD8-4400-A564-C85CAB6C18AD\/data",
//          "dataPathSize" : 13316096,
//          "logPath" : "\/Users\/leo\/Library\/Logs\/CoreSimulator\/9F868F6D-5AD8-4400-A564-C85CAB6C18AD",
//          "udid" : "9F868F6D-5AD8-4400-A564-C85CAB6C18AD",
//          "isAvailable" : false,
//          "deviceTypeIdentifier" : "com.apple.CoreSimulator.SimDeviceType.iPhone-14",
//          "state" : "Shutdown",
//          "name" : "iPhone 14"
//        },
//        {
//          "availabilityError" : "runtime profile not found",
//          "dataPath" : "\/Users\/leo\/Library\/Developer\/CoreSimulator\/Devices\/C04A9F86-5AD6-494A-B08C-653B837AAA15\/data",
//          "dataPathSize" : 13316096,
//          "logPath" : "\/Users\/leo\/Library\/Logs\/CoreSimulator\/C04A9F86-5AD6-494A-B08C-653B837AAA15",
//          "udid" : "C04A9F86-5AD6-494A-B08C-653B837AAA15",
//          "isAvailable" : false,
//          "deviceTypeIdentifier" : "com.apple.CoreSimulator.SimDeviceType.iPhone-14-Plus",
//          "state" : "Shutdown",
//          "name" : "iPhone 14 Plus"
//        },
//        {
//          "lastBootedAt" : "2022-10-04T17:49:02Z",
//          "dataPath" : "\/Users\/leo\/Library\/Developer\/CoreSimulator\/Devices\/8BC591AD-E779-4338-9BF8-D9C7F98B4324\/data",
//          "dataPathSize" : 826007552,
//          "logPath" : "\/Users\/leo\/Library\/Logs\/CoreSimulator\/8BC591AD-E779-4338-9BF8-D9C7F98B4324",
//          "udid" : "8BC591AD-E779-4338-9BF8-D9C7F98B4324",
//          "isAvailable" : false,
//          "availabilityError" : "runtime profile not found",
//          "logPathSize" : 53248,
//          "deviceTypeIdentifier" : "com.apple.CoreSimulator.SimDeviceType.iPhone-14-Pro",
//          "state" : "Shutdown",
//          "name" : "iPhone 14 Pro"
//        },
//        {
//          "availabilityError" : "runtime profile not found",
//          "dataPath" : "\/Users\/leo\/Library\/Developer\/CoreSimulator\/Devices\/B471A1F7-6154-4E4C-A00A-537343FC8565\/data",
//          "dataPathSize" : 13316096,
//          "logPath" : "\/Users\/leo\/Library\/Logs\/CoreSimulator\/B471A1F7-6154-4E4C-A00A-537343FC8565",
//          "udid" : "B471A1F7-6154-4E4C-A00A-537343FC8565",
//          "isAvailable" : false,
//          "deviceTypeIdentifier" : "com.apple.CoreSimulator.SimDeviceType.iPhone-14-Pro-Max",
//          "state" : "Shutdown",
//          "name" : "iPhone 14 Pro Max"
//        }
//      ],
}
