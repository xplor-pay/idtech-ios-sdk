//
//  HomeViewModel.swift
//  ExampleSwiftWrapper
//
//  Created by Manoj Baste on 28/05/26.
//
import Foundation
import SwiftUI
import ClearentIdtechIOSFramework

@MainActor
class PaymentUIViewModel: NSObject, ObservableObject {
    
    @Published var showPaymentSheet = false
    @Published var showSettings = false
    @Published var shouldShowTapToPay = false
    @Published var paymentInfo: PaymentInfo?
    
    override init() {
        super.init()
        configureSDK()
    }
    
    // MARK: - SDK Setup
    private func configureSDK() {
        // Initialize the SDK with needed info to work properly
        // ! Make sure you update the baseURL and apiKey with the correct values in order to test the SDK !
        let baseURL = "https://gateway-qa.clearent.net"
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
    }
    
    private func startTapToPayTransaction(paymentInfo: PaymentInfo?) {
        self.paymentInfo = paymentInfo
        self.shouldShowTapToPay = true
    }
    
    private func startCardReaderTransaction(paymentInfo: PaymentInfo?) {
        self.paymentInfo = paymentInfo
        showPaymentSheet = true
    }
    
    private func startManualTransaction(paymentInfo: PaymentInfo?) {
        self.paymentInfo = paymentInfo
        showPaymentSheet = true
    }
    
    func startSettingsFlow() {
        showSettings = true
    }
    
    func startTapToPayFlow() {
        let paymentInfo = PaymentInfo(amount: 20.00)
        startTapToPayTransaction(paymentInfo: paymentInfo)
    }
    
    func startCardReaderFlow() {
        ClearentUIManager.shared.cardReaderPaymentIsPreferred = true
        let paymentInfo = PaymentInfo(amount: 20.00)
        startCardReaderTransaction(paymentInfo: paymentInfo)
    }
    
    func startManualEntryFlow() {
        ClearentUIManager.shared.cardReaderPaymentIsPreferred = false
        let paymentInfo = PaymentInfo(amount: 20.00)
        startCardReaderTransaction(paymentInfo: paymentInfo)
    }
}

