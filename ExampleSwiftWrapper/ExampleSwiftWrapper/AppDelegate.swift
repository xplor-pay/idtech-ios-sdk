//
//  AppDelegate.swift
//  ExampleSwiftWrapper
//
//  Created by Ovidiu Rotaru on 28.07.2022.
//

import UIKit
import ClearentIdtechIOSFramework

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        ClearentUIBrandConfigurator.shared.colorPalette = DemoAppColors()
        ClearentUIBrandConfigurator.shared.fonts = DemoAppFonts()
        return true
    }
}
