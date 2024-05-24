//
//  File.swift
//
//
//  Created by Marc on 25.12.2023.
//

import DeviceKit
import Foundation
import SwiftUI

public enum ScreenshotParameters {
    
    public static var name: String {
        if case let .simulator(type) = Device.current {
            switch type {
            case .iPhoneSE3:
                return "5dot5"
            case .iPhone13ProMax:
                return "sixdotfive"
            case .iPhone15ProMax:
                return "sixdotseven"
            case .iPadPro12Inch2:
                return "6dot9Old"
            case .iPadPro12Inch6:
                return "6dot9New"
            default:
                fatalError("Unsupported Device Type")
            }
        }
        fatalError("Unsupported Device Type")
    }
    
    public static var deviceFrame: Image {
        if case let .simulator(type) = Device.current {
            switch type {
            case .iPhoneSE3:
                return Image("iPhoneSE3", bundle: .module)
            case .iPhone13ProMax:
                return Image("iPhone13ProMax", bundle: .module)
            case .iPhone15ProMax:
                return Image("iPhone15ProMax", bundle: .module)
            case .iPadPro12Inch2:
                return Image("iPadPro12Inch2", bundle: .module)
            case .iPadPro12Inch6:
                return Image("iPadPro12Inch6", bundle: .module)
            default:
                fatalError("Unsupported Device Type")
            }
        }
        fatalError("Unsupported Device Type")
    }
    
    public static var frameHeight: CGFloat {
        
        if case let .simulator(type) = Device.current {
            switch type {
            case .iPhoneSE3:
                return 2208
            case .iPhone13ProMax:
                return 2778
            case .iPhone15ProMax:
                return 2796
            case .iPadPro12Inch2, .iPadPro12Inch6:
                return 2048
            default:
                fatalError("Unsupported Device Type")
            }
        }
        fatalError("Unsupported Device Type")
    }
    
    public static var frameWidth: CGFloat {
        
        if case let .simulator(type) = Device.current {
            switch type {
            case .iPhoneSE3:
                return 1242
            case .iPhone13ProMax:
                return 1284
            case .iPhone15ProMax:
                return 1290
            case .iPadPro12Inch2, .iPadPro12Inch6:
                return 2732
            default:
                fatalError("Unsupported Device Type")
            }
        }
        fatalError("Unsupported Device Type")
    }
    
    public static var imageHeight: CGFloat {
        
        if case let .simulator(type) = Device.current {
            switch type {
            case .iPhoneSE3:
                return 2208 / 1.445
            case .iPhone13ProMax:
                return 2778 / 1.31
            case .iPhone15ProMax:
                return 2796 / 1.2
            case .iPadPro12Inch2:
                return 2048 / 1.253
            case .iPadPro12Inch6:
                return 2048 / 1.195
            default:
                fatalError("Unsupported Device Type")
            }
        }
        fatalError("Unsupported Device Type")
    }
    
    public static var imageWidth: CGFloat {
         
        if case let .simulator(type) = Device.current {
            switch type {
            case .iPhoneSE3:
                return 1242 / 1.445
            case .iPhone13ProMax:
                return 1284 / 1.31
            case .iPhone15ProMax:
                return 1290 / 1.2
            case .iPadPro12Inch2:
                return 2732 / 1.253
            case .iPadPro12Inch6:
                return 2732 / 1.195
            default:
                fatalError("Unsupported Device Type")
            }
        }
        fatalError("Unsupported Device Type")
    }
    
    public static var imageCornerRadius: Double {
         
        if case let .simulator(type) = Device.current {
            switch type {
            case .iPhoneSE3:
                return 0
            case .iPhone13ProMax:
                return 0
            case .iPhone15ProMax:
                return 75
            case .iPadPro12Inch2, .iPadPro12Inch6:
                return 0
            default:
                fatalError("Unsupported Device Type")
            }
        }
        fatalError("Unsupported Device Type")
    }

    public static var additionalDeviceOffset: Double {
         
        if case let .simulator(type) = Device.current {
            switch type {
            case .iPhoneSE3:
                return 50
            case .iPhone13ProMax:
                return 0
            case .iPhone15ProMax:
                return 0
            case .iPadPro12Inch2, .iPadPro12Inch6:
                return 0
            default:
                fatalError("Unsupported Device Type")
            }
        }
        fatalError("Unsupported Device Type")
    }
}
