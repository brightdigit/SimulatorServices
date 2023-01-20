

public struct Runtime : Decodable {
  public struct SupportedDeviceType : Decodable {
    public let bundlePath : Path // URL?
    public let name : String
    public let identifier : DeviceTypeID // identifier
    public let productFamily : ProductFamily // deviceType
  }
  public  let supportedDeviceTypes : [SupportedDeviceType]
  public  let bundlePath : Path // URL?
  public   let buildversion : String
  public  let platform : Platform // platform
  public let runtimeRoot: Path // URL?
  public let identifier : RuntimeID
  public let version : Version // version
  public let isInternal : Bool
  public let isAvailable: Bool
  public let name : String
  
//  "bundlePath" : "\/Library\/Developer\/CoreSimulator\/Profiles\/Runtimes\/iOS 14.0.simruntime",
//        "buildversion" : "18A394",
//        "platform" : "iOS",
//        "runtimeRoot" : "\/Library\/Developer\/CoreSimulator\/Profiles\/Runtimes\/iOS 14.0.simruntime\/Contents\/Resources\/RuntimeRoot",
//        "identifier" : "com.apple.CoreSimulator.SimRuntime.iOS-14-0",
//        "version" : "14.0.1",
//        "isInternal" : false,
//        "isAvailable" : true,
//        "name" : "iOS 14.0",
//        "supportedDeviceTypes" : [
//          {
//            "bundlePath" : "\/Applications\/Xcode.app\/Contents\/Developer\/Platforms\/iPhoneOS.platform\/Library\/Developer\/CoreSimulator\/Profiles\/DeviceTypes\/iPhone 6s.simdevicetype",
//            "name" : "iPhone 6s",
//            "identifier" : "com.apple.CoreSimulator.SimDeviceType.iPhone-6s",
//            "productFamily" : "iPhone"
//          },
//          {
//            "bundlePath" : "\/Applications\/Xcode.app\/Contents\/Developer\/Platforms\/iPhoneOS.platform\/Library\/Developer\/CoreSimulator\/Profiles\/DeviceTypes\/iPhone 6s Plus.simdevicetype",
//            "name" : "iPhone 6s Plus",
//            "identifier" : "com.apple.CoreSimulator.SimDeviceType.iPhone-6s-Plus",
//            "productFamily" : "iPhone"
//          },
//          {
//            "bundlePath" : "\/Applications\/Xcode.app\/Contents\/Developer\/Platforms\/iPhoneOS.platform\/Library\/Developer\/CoreSimulator\/Profiles\/DeviceTypes\/iPhone SE (1st generation).simdevicetype",
//            "name" : "iPhone SE (1st generation)",
//            "identifier" : "com.apple.CoreSimulator.SimDeviceType.iPhone-SE",
//            "productFamily" : "iPhone"
//          },
//          {
//            "bundlePath" : "\/Applications\/Xcode.app\/Contents\/Developer\/Platforms\/iPhoneOS.platform\/Library\/Developer\/CoreSimulator\/Profiles\/DeviceTypes\/iPhone 7.simdevicetype",
//            "name" : "iPhone 7",
//            "identifier" : "com.apple.CoreSimulator.SimDeviceType.iPhone-7",
//            "productFamily" : "iPhone"
//          },
//          {
//            "bundlePath" : "\/Applications\/Xcode.app\/Contents\/Developer\/Platforms\/iPhoneOS.platform\/Library\/Developer\/CoreSimulator\/Profiles\/DeviceTypes\/iPhone 7 Plus.simdevicetype",
//            "name" : "iPhone 7 Plus",
//            "identifier" : "com.apple.CoreSimulator.SimDeviceType.iPhone-7-Plus",
//            "productFamily" : "iPhone"
//          },
//          {
//            "bundlePath" : "\/Applications\/Xcode.app\/Contents\/Developer\/Platforms\/iPhoneOS.platform\/Library\/Developer\/CoreSimulator\/Profiles\/DeviceTypes\/iPhone 8.simdevicetype",
//            "name" : "iPhone 8",
//            "identifier" : "com.apple.CoreSimulator.SimDeviceType.iPhone-8",
//            "productFamily" : "iPhone"
//          },
//          {
//            "bundlePath" : "\/Applications\/Xcode.app\/Contents\/Developer\/Platforms\/iPhoneOS.platform\/Library\/Developer\/CoreSimulator\/Profiles\/DeviceTypes\/iPhone 8 Plus.simdevicetype",
//            "name" : "iPhone 8 Plus",
//            "identifier" : "com.apple.CoreSimulator.SimDeviceType.iPhone-8-Plus",
//            "productFamily" : "iPhone"
//          },
//          {
//            "bundlePath" : "\/Applications\/Xcode.app\/Contents\/Developer\/Platforms\/iPhoneOS.platform\/Library\/Developer\/CoreSimulator\/Profiles\/DeviceTypes\/iPhone X.simdevicetype",
//            "name" : "iPhone X",
//            "identifier" : "com.apple.CoreSimulator.SimDeviceType.iPhone-X",
//            "productFamily" : "iPhone"
//          },
//          {
//            "bundlePath" : "\/Applications\/Xcode.app\/Contents\/Developer\/Platforms\/iPhoneOS.platform\/Library\/Developer\/CoreSimulator\/Profiles\/DeviceTypes\/iPhone Xs.simdevicetype",
//            "name" : "iPhone Xs",
//            "identifier" : "com.apple.CoreSimulator.SimDeviceType.iPhone-XS",
//            "productFamily" : "iPhone"
//          },
//          {
//            "bundlePath" : "\/Applications\/Xcode.app\/Contents\/Developer\/Platforms\/iPhoneOS.platform\/Library\/Developer\/CoreSimulator\/Profiles\/DeviceTypes\/iPhone Xs Max.simdevicetype",
//            "name" : "iPhone Xs Max",
//            "identifier" : "com.apple.CoreSimulator.SimDeviceType.iPhone-XS-Max",
//            "productFamily" : "iPhone"
//          },
//          {
//            "bundlePath" : "\/Applications\/Xcode.app\/Contents\/Developer\/Platforms\/iPhoneOS.platform\/Library\/Developer\/CoreSimulator\/Profiles\/DeviceTypes\/iPhone Xʀ.simdevicetype",
//            "name" : "iPhone Xʀ",
//            "identifier" : "com.apple.CoreSimulator.SimDeviceType.iPhone-XR",
//            "productFamily" : "iPhone"
//          },
//          {
//            "bundlePath" : "\/Applications\/Xcode.app\/Contents\/Developer\/Platforms\/iPhoneOS.platform\/Library\/Developer\/CoreSimulator\/Profiles\/DeviceTypes\/iPhone 11.simdevicetype",
//            "name" : "iPhone 11",
//            "identifier" : "com.apple.CoreSimulator.SimDeviceType.iPhone-11",
//            "productFamily" : "iPhone"
//          },
//          {
//            "bundlePath" : "\/Applications\/Xcode.app\/Contents\/Developer\/Platforms\/iPhoneOS.platform\/Library\/Developer\/CoreSimulator\/Profiles\/DeviceTypes\/iPhone 11 Pro.simdevicetype",
//            "name" : "iPhone 11 Pro",
//            "identifier" : "com.apple.CoreSimulator.SimDeviceType.iPhone-11-Pro",
//            "productFamily" : "iPhone"
//          },
//          {
//            "bundlePath" : "\/Applications\/Xcode.app\/Contents\/Developer\/Platforms\/iPhoneOS.platform\/Library\/Developer\/CoreSimulator\/Profiles\/DeviceTypes\/iPhone 11 Pro Max.simdevicetype",
//            "name" : "iPhone 11 Pro Max",
//            "identifier" : "com.apple.CoreSimulator.SimDeviceType.iPhone-11-Pro-Max",
//            "productFamily" : "iPhone"
//          },
//          {
//            "bundlePath" : "\/Applications\/Xcode.app\/Contents\/Developer\/Platforms\/iPhoneOS.platform\/Library\/Developer\/CoreSimulator\/Profiles\/DeviceTypes\/iPhone SE (2nd generation).simdevicetype",
//            "name" : "iPhone SE (2nd generation)",
//            "identifier" : "com.apple.CoreSimulator.SimDeviceType.iPhone-SE2nd-generation-",
//            "productFamily" : "iPhone"
//          },
//          {
//            "bundlePath" : "\/Applications\/Xcode.app\/Contents\/Developer\/Platforms\/iPhoneOS.platform\/Library\/Developer\/CoreSimulator\/Profiles\/DeviceTypes\/iPod touch (7th generation).simdevicetype",
//            "name" : "iPod touch (7th generation)",
//            "identifier" : "com.apple.CoreSimulator.SimDeviceType.iPod-touch7th-generation-",
//            "productFamily" : "iPhone"
//          },
//          {
//            "bundlePath" : "\/Applications\/Xcode.app\/Contents\/Developer\/Platforms\/iPhoneOS.platform\/Library\/Developer\/CoreSimulator\/Profiles\/DeviceTypes\/iPad mini 4.simdevicetype",
//            "name" : "iPad mini 4",
//            "identifier" : "com.apple.CoreSimulator.SimDeviceType.iPad-mini-4",
//            "productFamily" : "iPad"
//          },
//          {
//            "bundlePath" : "\/Applications\/Xcode.app\/Contents\/Developer\/Platforms\/iPhoneOS.platform\/Library\/Developer\/CoreSimulator\/Profiles\/DeviceTypes\/iPad Air 2.simdevicetype",
//            "name" : "iPad Air 2",
//            "identifier" : "com.apple.CoreSimulator.SimDeviceType.iPad-Air-2",
//            "productFamily" : "iPad"
//          },
//          {
//            "bundlePath" : "\/Applications\/Xcode.app\/Contents\/Developer\/Platforms\/iPhoneOS.platform\/Library\/Developer\/CoreSimulator\/Profiles\/DeviceTypes\/iPad Pro (9.7-inch).simdevicetype",
//            "name" : "iPad Pro (9.7-inch)",
//            "identifier" : "com.apple.CoreSimulator.SimDeviceType.iPad-Pro9-7-inch-",
//            "productFamily" : "iPad"
//          },
//          {
//            "bundlePath" : "\/Applications\/Xcode.app\/Contents\/Developer\/Platforms\/iPhoneOS.platform\/Library\/Developer\/CoreSimulator\/Profiles\/DeviceTypes\/iPad Pro (12.9-inch) (1st generation).simdevicetype",
//            "name" : "iPad Pro (12.9-inch) (1st generation)",
//            "identifier" : "com.apple.CoreSimulator.SimDeviceType.iPad-Pro",
//            "productFamily" : "iPad"
//          },
//          {
//            "bundlePath" : "\/Applications\/Xcode.app\/Contents\/Developer\/Platforms\/iPhoneOS.platform\/Library\/Developer\/CoreSimulator\/Profiles\/DeviceTypes\/iPad (5th generation).simdevicetype",
//            "name" : "iPad (5th generation)",
//            "identifier" : "com.apple.CoreSimulator.SimDeviceType.iPad5th-generation-",
//            "productFamily" : "iPad"
//          },
//          {
//            "bundlePath" : "\/Applications\/Xcode.app\/Contents\/Developer\/Platforms\/iPhoneOS.platform\/Library\/Developer\/CoreSimulator\/Profiles\/DeviceTypes\/iPad Pro (12.9-inch) (2nd generation).simdevicetype",
//            "name" : "iPad Pro (12.9-inch) (2nd generation)",
//            "identifier" : "com.apple.CoreSimulator.SimDeviceType.iPad-Pro12-9-inch-2nd-generation-",
//            "productFamily" : "iPad"
//          },
//          {
//            "bundlePath" : "\/Applications\/Xcode.app\/Contents\/Developer\/Platforms\/iPhoneOS.platform\/Library\/Developer\/CoreSimulator\/Profiles\/DeviceTypes\/iPad Pro (10.5-inch).simdevicetype",
//            "name" : "iPad Pro (10.5-inch)",
//            "identifier" : "com.apple.CoreSimulator.SimDeviceType.iPad-Pro10-5-inch-",
//            "productFamily" : "iPad"
//          },
//          {
//            "bundlePath" : "\/Applications\/Xcode.app\/Contents\/Developer\/Platforms\/iPhoneOS.platform\/Library\/Developer\/CoreSimulator\/Profiles\/DeviceTypes\/iPad (6th generation).simdevicetype",
//            "name" : "iPad (6th generation)",
//            "identifier" : "com.apple.CoreSimulator.SimDeviceType.iPad6th-generation-",
//            "productFamily" : "iPad"
//          },
//          {
//            "bundlePath" : "\/Applications\/Xcode.app\/Contents\/Developer\/Platforms\/iPhoneOS.platform\/Library\/Developer\/CoreSimulator\/Profiles\/DeviceTypes\/iPad (7th generation).simdevicetype",
//            "name" : "iPad (7th generation)",
//            "identifier" : "com.apple.CoreSimulator.SimDeviceType.iPad7th-generation-",
//            "productFamily" : "iPad"
//          },
//          {
//            "bundlePath" : "\/Applications\/Xcode.app\/Contents\/Developer\/Platforms\/iPhoneOS.platform\/Library\/Developer\/CoreSimulator\/Profiles\/DeviceTypes\/iPad Pro (11-inch) (1st generation).simdevicetype",
//            "name" : "iPad Pro (11-inch) (1st generation)",
//            "identifier" : "com.apple.CoreSimulator.SimDeviceType.iPad-Pro11-inch-",
//            "productFamily" : "iPad"
//          },
//          {
//            "bundlePath" : "\/Applications\/Xcode.app\/Contents\/Developer\/Platforms\/iPhoneOS.platform\/Library\/Developer\/CoreSimulator\/Profiles\/DeviceTypes\/iPad Pro (12.9-inch) (3rd generation).simdevicetype",
//            "name" : "iPad Pro (12.9-inch) (3rd generation)",
//            "identifier" : "com.apple.CoreSimulator.SimDeviceType.iPad-Pro12-9-inch-3rd-generation-",
//            "productFamily" : "iPad"
//          },
//          {
//            "bundlePath" : "\/Applications\/Xcode.app\/Contents\/Developer\/Platforms\/iPhoneOS.platform\/Library\/Developer\/CoreSimulator\/Profiles\/DeviceTypes\/iPad Pro (11-inch) (2nd generation).simdevicetype",
//            "name" : "iPad Pro (11-inch) (2nd generation)",
//            "identifier" : "com.apple.CoreSimulator.SimDeviceType.iPad-Pro11-inch-2nd-generation-",
//            "productFamily" : "iPad"
//          },
//          {
//            "bundlePath" : "\/Applications\/Xcode.app\/Contents\/Developer\/Platforms\/iPhoneOS.platform\/Library\/Developer\/CoreSimulator\/Profiles\/DeviceTypes\/iPad Pro (12.9-inch) (4th generation).simdevicetype",
//            "name" : "iPad Pro (12.9-inch) (4th generation)",
//            "identifier" : "com.apple.CoreSimulator.SimDeviceType.iPad-Pro12-9-inch-4th-generation-",
//            "productFamily" : "iPad"
//          },
//          {
//            "bundlePath" : "\/Applications\/Xcode.app\/Contents\/Developer\/Platforms\/iPhoneOS.platform\/Library\/Developer\/CoreSimulator\/Profiles\/DeviceTypes\/iPad mini (5th generation).simdevicetype",
//            "name" : "iPad mini (5th generation)",
//            "identifier" : "com.apple.CoreSimulator.SimDeviceType.iPad-mini5th-generation-",
//            "productFamily" : "iPad"
//          },
//          {
//            "bundlePath" : "\/Applications\/Xcode.app\/Contents\/Developer\/Platforms\/iPhoneOS.platform\/Library\/Developer\/CoreSimulator\/Profiles\/DeviceTypes\/iPad Air (3rd generation).simdevicetype",
//            "name" : "iPad Air (3rd generation)",
//            "identifier" : "com.apple.CoreSimulator.SimDeviceType.iPad-Air3rd-generation-",
//            "productFamily" : "iPad"
//          },
//          {
//            "bundlePath" : "\/Applications\/Xcode.app\/Contents\/Developer\/Platforms\/iPhoneOS.platform\/Library\/Developer\/CoreSimulator\/Profiles\/DeviceTypes\/iPad (8th generation).simdevicetype",
//            "name" : "iPad (8th generation)",
//            "identifier" : "com.apple.CoreSimulator.SimDeviceType.iPad8th-generation-",
//            "productFamily" : "iPad"
//          },
//          {
//            "bundlePath" : "\/Applications\/Xcode.app\/Contents\/Developer\/Platforms\/iPhoneOS.platform\/Library\/Developer\/CoreSimulator\/Profiles\/DeviceTypes\/iPad Air (4th generation).simdevicetype",
//            "name" : "iPad Air (4th generation)",
//            "identifier" : "com.apple.CoreSimulator.SimDeviceType.iPad-Air4th-generation-",
//            "productFamily" : "iPad"
//          }
//        ]
}
