//
//  PaymentViewControllerWrapper.swift
//  ExampleSwiftWrapper
//
//  Created by Manoj Baste on 28/05/26.
//
import SwiftUI
import ClearentIdtechIOSFramework

struct PaymentViewControllerWrapper: UIViewControllerRepresentable {
    let paymentInfo: PaymentInfo?
    let onCompletion: (ClearentError?) -> Void

    func makeUIViewController(context: Context) -> UINavigationController {
        ClearentUIManager.shared.paymentViewController(paymentInfo: paymentInfo) { error in
            onCompletion(error)
        }
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        // No update needed
    }
}
