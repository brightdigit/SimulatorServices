public struct DeviceType : Decodable {
  let productFamily : ProductFamily // deviceType
  let bundlePath : Path // URL?
  let maxRuntimeVersion : Int
  let maxRuntimeVersionString : Version
  let identifier : DeviceTypeID // identifier
  let modelIdentifier : ModelID // model
  let minRuntimeVersionString : Version
  let minRuntimeVersion : Int
  let name : String
//  "productFamily" : "iPhone",
//  "bundlePath" : "\/Applications\/Xcode.app\/Contents\/Developer\/Platforms\/iPhoneOS.platform\/Library\/Developer\/CoreSimulator\/Profiles\/DeviceTypes\/iPhone SE (3rd generation).simdevicetype",
//  "maxRuntimeVersion" : 4294967295,
//  "maxRuntimeVersionString" : "65535.255.255",
//  "identifier" : "com.apple.CoreSimulator.SimDeviceType.iPhone-SE-3rd-generation",
//  "modelIdentifier" : "iPhone14,6",
//  "minRuntimeVersionString" : "15.4.0",
//  "minRuntimeVersion" : 984064,
//  "name" : "iPhone SE (3rd generation)"
}
