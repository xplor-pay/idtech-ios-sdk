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
        configureSDK()
        return true
    }
    
    // MARK: - SDK Setup
    private func configureSDK() {
        // Initialize the SDK with needed info to work properly
        // ! Make sure you update the baseURL and apiKey with the correct values in order to test the SDK !
        let baseURL = "https://gateway-qa.clearent.net"
//        let apiKey: String? =  "72db156adcf34c0eb85a410bb2588ce9"
        let apiKey: String? =  "1573dd1f92af43e6ae59a0e6e4f5f32f"
        let encryptionKeyData = Crypto.SHA256hash(data: "some_secret_here".data(using: .utf8)!)
        
        let uiManagerConfig = ClearentUIManagerConfiguration(
            baseURL: baseURL,
            apiKey: apiKey,
            publicKey: nil,
            offlineModeEncryptionKeyData: encryptionKeyData,
            enableEnhancedMessaging: true,
            softwareType: "Demo App",
            softwareTypeVersion: "1.0.0"
        )
        ClearentUIManager.shared.initialize(with: uiManagerConfig)
        
        ClearentUIBrandConfigurator.shared.colorPalette = DemoAppColors()
        ClearentUIBrandConfigurator.shared.fonts = DemoAppFonts()
    }
}
