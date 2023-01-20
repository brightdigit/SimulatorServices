//
//  File.swift
//  
//
//  Created by Leo Dion on 1/16/23.
//

import Foundation

public struct DevicePair : Decodable {
  public struct Device : Decodable {
    let name : String
    let udid : UUID
    let state : DeviceState // Device.State
  }
  let watch : Device
  let phone : Device
  let state : PairState  // Pair.State
}


//{
//  "pairs" : {
//    "90341D00-2703-444D-AF24-39AAA6F96FE5" : {
//      "watch" : {
//        "name" : "Apple Watch Series 5 - 40mm",
//        "udid" : "330E5DDF-48C2-48DE-8D59-D4CF8667A9E0",
//        "state" : "Shutdown"
//      },
//      "phone" : {
//        "name" : "iPhone 11 Pro",
//        "udid" : "962CFC6B-B0C7-449D-A4EA-D2944A8CC84A",
//        "state" : "Shutdown"
//      },
//      "state" : "(unavailable)"
//    },
//    "67D4486E-97F8-4E0E-80CD-959514D42545" : {
//      "watch" : {
//        "name" : "Apple Watch Series 6 - 40mm",
//        "udid" : "707958AD-E091-482E-84F5-CC2818E5DB67",
//        "state" : "Shutdown"
//      },
//      "phone" : {
//        "name" : "iPhone 12",
//        "udid" : "98D15805-ACED-46F2-9D14-FBAF9E1A5F66",
//        "state" : "Shutdown"
//      },
//      "state" : "(unavailable)"
//    },
//    "63652FCB-3CAF-4D96-9D09-4F94FF541370" : {
//      "watch" : {
//        "name" : "Apple Watch Series 7 - 41mm",
//        "udid" : "0C3805AB-B103-459C-A83D-63DC5D7D898B",
//        "state" : "Shutdown"
//      },
//      "phone" : {
//        "name" : "iPhone 13 Pro Max",
//        "udid" : "DFED7114-F38E-4059-B72E-50F0477DD0DF",
//        "state" : "Shutdown"
//      },
//      "state" : "(unavailable)"
//    },
//    "7CAA7FF1-078B-412D-A6F6-9C6C62B1DDC6" : {
//      "watch" : {
//        "name" : "Apple Watch Series 7 - 45mm",
//        "udid" : "2538A89C-EFE0-4EE5-9C0C-57516647E028",
//        "state" : "Shutdown"
//      },
//      "phone" : {
//        "name" : "iPhone 14",
//        "udid" : "01DCBCE3-0F0F-4D37-8A67-94FC66CCB7D8",
//        "state" : "Shutdown"
//      },
//      "state" : "(unavailable)"
//    },
//    "48886DC4-2532-42C0-9F51-1D498828984C" : {
//      "watch" : {
//        "name" : "Apple Watch Series 6 - 44mm",
//        "udid" : "03FAE2FF-E13A-4D54-B5EE-ABF686D9076B",
//        "state" : "Shutdown"
//      },
//      "phone" : {
//        "name" : "iPhone 12 Pro Max",
//        "udid" : "333E16CA-5549-4FF7-BABD-0425643A2421",
//        "state" : "Shutdown"
//      },
//      "state" : "(unavailable)"
//    },
//    "857D9A31-C8AC-4531-BAAE-6E84DC3CD011" : {
//      "watch" : {
//        "name" : "Apple Watch Series 7 (45mm)",
//        "udid" : "110A9858-50D6-41C3-9E9F-747754130B75",
//        "state" : "Shutdown"
//      },
//      "phone" : {
//        "name" : "iPhone 14",
//        "udid" : "855AE39E-AA33-4D02-85F7-48DA013B09C4",
//        "state" : "Shutdown"
//      },
//      "state" : "(active, disconnected)"
//    },
//    "AAC21D68-B24B-43B4-A538-9740AC487FE9" : {
//      "watch" : {
//        "name" : "Apple Watch Series 7 - 41mm",
//        "udid" : "0B58798E-7769-4796-B23B-4AF0FD34CD53",
//        "state" : "Shutdown"
//      },
//      "phone" : {
//        "name" : "iPhone 13 mini",
//        "udid" : "E8A8EA8A-F341-4BE3-8BA9-FB78FEFF8E12",
//        "state" : "Shutdown"
//      },
//      "state" : "(unavailable)"
//    },
//    "CAFE2415-7B8F-43C7-BECE-E4552CB7DCAE" : {
//      "watch" : {
//        "name" : "Apple Watch Series 8 (41mm)",
//        "udid" : "EE47EC4B-BA11-46EB-B950-700FE843ECDF",
//        "state" : "Shutdown"
//      },
//      "phone" : {
//        "name" : "iPhone 14 Plus",
//        "udid" : "E26B58AC-C290-4338-8178-36232B0E1C1B",
//        "state" : "Shutdown"
//      },
//      "state" : "(active, disconnected)"
//    },
//    "618DA584-C3D4-43ED-B61F-2300F48F6062" : {
//      "watch" : {
//        "name" : "Apple Watch Series 8 (45mm)",
//        "udid" : "E822487E-B2C4-47A5-AD28-D8B8968DA3F2",
//        "state" : "Shutdown"
//      },
//      "phone" : {
//        "name" : "iPhone 14 Pro",
//        "udid" : "A8E7615F-35FA-413A-877B-B94470407AA2",
//        "state" : "Shutdown"
//      },
//      "state" : "(unavailable)"
//    },
//    "E61A340D-D529-4869-80BC-B16BBB15CFFB" : {
//      "watch" : {
//        "name" : "Apple Watch Series 5 - 44mm",
//        "udid" : "AA330DD7-A1F6-4F31-BE28-D140A18FA2AF",
//        "state" : "Shutdown"
//      },
//      "phone" : {
//        "name" : "iPhone 11 Pro Max",
//        "udid" : "67EDE85D-FED9-42F8-AA33-23FA898D0A90",
//        "state" : "Shutdown"
//      },
//      "state" : "(unavailable)"
//    },
//    "2EE3BEBB-438A-46C0-97DD-E9387D27BC38" : {
//      "watch" : {
//        "name" : "Apple Watch Series 5 - 44mm",
//        "udid" : "DADB35B3-AEC5-4148-B7EB-39B12F2A204A",
//        "state" : "Shutdown"
//      },
//      "phone" : {
//        "name" : "iPhone 12",
//        "udid" : "2D20CEE9-FF7B-4F1B-A2A2-5B78817FF7C4",
//        "state" : "Shutdown"
//      },
//      "state" : "(unavailable)"
//    },
//    "6BDF7BE9-6E1A-492C-8EF9-DA4072FACED2" : {
//      "watch" : {
//        "name" : "Apple Watch Series 5 - 40mm",
//        "udid" : "4CA4F727-8C18-4C93-BF97-5473573205C7",
//        "state" : "Shutdown"
//      },
//      "phone" : {
//        "name" : "iPhone 11 Pro",
//        "udid" : "6FC2749F-6F54-4E28-92ED-953F96672D6A",
//        "state" : "Shutdown"
//      },
//      "state" : "(unavailable)"
//    },
//    "7E2C258E-E88F-47E0-9D4F-B58A738D8E3A" : {
//      "watch" : {
//        "name" : "Apple Watch Series 7 (41mm)",
//        "udid" : "E4432449-5B57-4D5A-BCB9-8110568E7D9F",
//        "state" : "Shutdown"
//      },
//      "phone" : {
//        "name" : "iPhone 13 16.2",
//        "udid" : "ABDE5413-609B-47C6-84E0-4FE960E6D2EE",
//        "state" : "Shutdown"
//      },
//      "state" : "(active, disconnected)"
//    },
//    "7436E08F-CA70-4C60-B0F2-3B0C5B50EEF2" : {
//      "watch" : {
//        "name" : "Apple Watch Ultra (49mm)",
//        "udid" : "B8EC3199-2E94-4A7C-BE96-A14D1B2C4DBE",
//        "state" : "Shutdown"
//      },
//      "phone" : {
//        "name" : "iPhone 14 Pro Max",
//        "udid" : "AD44D04F-FE94-4B80-B14B-A374C1AE304A",
//        "state" : "Shutdown"
//      },
//      "state" : "(unavailable)"
//    },
//    "AF9F96F6-FC3F-4D45-A179-B1241BC30348" : {
//      "watch" : {
//        "name" : "Apple Watch Series 8 (45mm)",
//        "udid" : "D9C3545A-6328-4B84-B45C-68C9C8460A8C",
//        "state" : "Shutdown"
//      },
//      "phone" : {
//        "name" : "iPhone 14 Pro",
//        "udid" : "2D6C4672-F5CE-4A66-A5DE-37BD59470AB7",
//        "state" : "Booted"
//      },
//      "state" : "(active, disconnected)"
//    },
//    "4D7A74EB-5B23-4097-B8A9-626C312CB7F3" : {
//      "watch" : {
//        "name" : "Apple Watch Series 8 (41mm)",
//        "udid" : "76E8A9EE-6885-455A-9AB3-9672C8091872",
//        "state" : "Shutdown"
//      },
//      "phone" : {
//        "name" : "iPhone 14 Plus",
//        "udid" : "2FBC593B-C6D1-42BF-9C42-457E32E9EA72",
//        "state" : "Shutdown"
//      },
//      "state" : "(unavailable)"
//    },
//    "EE343C81-B2C6-4755-9822-FD6C7DCCAAA3" : {
//      "watch" : {
//        "name" : "Apple Watch Series 6 - 40mm",
//        "udid" : "FF46C687-551E-4154-AECD-F2764C1A6228",
//        "state" : "Shutdown"
//      },
//      "phone" : {
//        "name" : "iPhone 13 Pro",
//        "udid" : "C1A1B857-A93E-4FE7-B345-97CF51CB7141",
//        "state" : "Shutdown"
//      },
//      "state" : "(unavailable)"
//    },
//    "7EB3C9FC-6F40-419D-93D8-D8C6C1F9283E" : {
//      "watch" : {
//        "name" : "Apple Watch Series 6 - 44mm",
//        "udid" : "6A167283-3AF5-4197-B108-3A2B736377E6",
//        "state" : "Shutdown"
//      },
//      "phone" : {
//        "name" : "iPhone 13 Pro Max",
//        "udid" : "0920CC6D-7F24-40C3-9521-4868072C4FC0",
//        "state" : "Shutdown"
//      },
//      "state" : "(unavailable)"
//    },
//    "B4D57328-6D43-418D-BCE0-91CCF6385E82" : {
//      "watch" : {
//        "name" : "Apple Watch Series 7 - 45mm",
//        "udid" : "E177C3D4-4CDA-49C7-AF6B-EDA27D0FF7C8",
//        "state" : "Shutdown"
//      },
//      "phone" : {
//        "name" : "iPhone 13",
//        "udid" : "149FE3E0-5D18-4A1A-BB9A-A441B12A26E9",
//        "state" : "Shutdown"
//      },
//      "state" : "(unavailable)"
//    },
//    "CBCB3453-57C2-4230-80B5-7C0B316C365A" : {
//      "watch" : {
//        "name" : "Apple Watch Ultra (49mm)",
//        "udid" : "1D33295A-4870-4179-89EE-60B0CA500C8D",
//        "state" : "Shutdown"
//      },
//      "phone" : {
//        "name" : "iPhone 14 Pro Max",
//        "udid" : "40ED9300-25BE-4D04-BB04-83FB0E53629C",
//        "state" : "Shutdown"
//      },
//      "state" : "(active, disconnected)"
//    }
//  }
//}
