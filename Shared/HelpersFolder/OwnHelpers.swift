//
//  Helpers.swift
//  Gfror.li
//
//  Created by Marc Kramer on 11.09.20.
//
import UIKit
import Foundation

enum TimeFrame: Int, Equatable {
    case day = 1
    case week
    case month
}

public func getEmailBody() -> String {
    let version = ("App-Version: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unkown")")
    let model = "Device-Model: \(machineName())"
    let systemVersion = "OS-Version: \(UIDevice.current.systemName) \(UIDevice.current.systemVersion)"
    let lang = "Language: \(Locale.current.languageCode ?? "unkown")"
    let str = NSLocalizedString("email_text", comment: "")
    return "</br></br></br></br></br>\(str)</br></br>Info:</br>\(version)</br>\(model)</br>\(systemVersion)</br>\(lang)"
}

func machineName() -> String {
  var systemInfo = utsname()
  uname(&systemInfo)
  let machineMirror = Mirror(reflecting: systemInfo.machine)
  return machineMirror.children.reduce("") { identifier, element in
    guard let value = element.value as? Int8, value != 0 else { return identifier }
    return identifier + String(UnicodeScalar(UInt8(value)))
  }
}

func makeTemperatureString(double: Double?, precision: Int = 1) -> String {
    
    guard let double = double else {
        return "-"
    }

    let formatter = MeasurementFormatter()
    formatter.numberFormatter.maximumFractionDigits = 1
    formatter.numberFormatter.minimumFractionDigits = 1
    formatter.unitStyle = .medium
    let unit = Measurement<UnitTemperature>(value: double, unit: .celsius)
    return formatter.string(from: unit)
}
