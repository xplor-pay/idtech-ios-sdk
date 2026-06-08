//
//  PaymentUIFlowHome.swift
//  ExampleSwiftWrapper
//
//  Created by Manoj Baste on 28/05/26.
//
import SwiftUI
import ClearentIdtechIOSFramework

@available(iOS 14.0, *)
struct PaymentUIFlowView: View {
    
    @StateObject private var viewModel = PaymentUIViewModel()
    
    var body: some View {
        if #available(iOS 16.0, *) {
            VStack {
                Spacer()
                VStack(spacing: 30) {
                    ActionButton(title: "Charge $20.0 - Tap to Pay", backgroundColor: .blue) {
                        viewModel.startTapToPayFlow()
                    }
                    ActionButton(title: "Charge $20.0 - Card Reader", backgroundColor: .blue) {
                        viewModel.startCardReaderFlow()
                    }
                    ActionButton(title: "Charge $20.0 - Manual Entry", backgroundColor: .blue) {
                        viewModel.startManualEntryFlow()
                    }
                    ActionButton(title: "Settings", backgroundColor: .blue) {
                        viewModel.startSettingsFlow()
                    }
                }
                .padding(.horizontal, 40)
                Spacer()
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .ignoresSafeArea(.container, edges: .bottom) // optional
            .fullScreenCover(isPresented: $viewModel.shouldShowTapToPay) {
                if #available(iOS 16.4, *) {
                    TapToPayRootView(
                        paymentInfo: viewModel.paymentInfo,
                        onDismiss: { viewModel.shouldShowTapToPay = false }
                    )
                }
            }
            .fullScreenCover(isPresented: $viewModel.showPaymentSheet) {
                PaymentViewControllerWrapper(paymentInfo: viewModel.paymentInfo) { _ in
                    viewModel.showPaymentSheet = false
                }
            }
            .fullScreenCover(isPresented: $viewModel.showSettings) {
                SettingsViewContollerWrapper {
                    viewModel.showSettings = false
                }
            }
        }
    }
}

#Preview {
    if #available(iOS 16.0, *) {
        NavigationStack {
            PaymentUIFlowView()
        }
    } else {
        // Fallback on earlier versions
    }
}
