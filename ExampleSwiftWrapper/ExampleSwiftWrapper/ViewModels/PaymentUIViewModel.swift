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

