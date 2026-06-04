//
//  SettingsViewContollerWrapper.swift
//  ExampleSwiftWrapper
//
//  Created by Manoj Baste on 03/06/26.
//
import SwiftUI
import ClearentIdtechIOSFramework

struct SettingsViewContollerWrapper: UIViewControllerRepresentable {
    var onDismiss: () -> Void
    
    func makeUIViewController(context: Context) -> UINavigationController {
        let vc = ClearentUIManager.shared.settingsViewController { _ in
            onDismiss()
        }
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
}
