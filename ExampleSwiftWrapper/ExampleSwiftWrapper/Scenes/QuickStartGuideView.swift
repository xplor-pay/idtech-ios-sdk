//
//  PaymentUIFlowHome.swift
//  ExampleSwiftWrapper
//
//  Created by Manoj Baste on 28/05/26.
//
import SwiftUI
import ClearentIdtechIOSFramework

@available(iOS 14.0, *)
struct QuickStartGuideView: View {
    
    @State private var showPaymentUIFlowHome = false
    @State private var showNonPaymentUIFlowHome = false
    
    // MARK: - State
    @State private var readerStatus = "Reader"
    @State private var infoText = "Info"
    
    var body: some View {
        if #available(iOS 16.0, *) {
            GeometryReader { geometry in
                VStack(alignment: .center) {
                    Spacer()
                    VStack(spacing: 30) {
        
                        Text("Quick Start Guide")
                            .font(.system(size: 32, weight: .bold))
                            .padding(.top,10)
                        
                        ActionButton(
                            title: "Payment UI",
                            backgroundColor: .blue
                        ) {
                            showPaymentUIFlowHome = true
                        }
                        ActionButton(
                            title: "Non Payment UI",
                            backgroundColor: .blue
                        ) {
                            showNonPaymentUIFlowHome = true
                        }
                    }
                    .padding(.horizontal, 40)
                    .background(Color(.systemBackground))
                    Spacer()
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .padding(.top, 20)
                .navigationDestination(isPresented: $showPaymentUIFlowHome) {
                    PaymentUIFlowView()
                }
                .navigationDestination(isPresented: $showNonPaymentUIFlowHome) {
                    NonPaymentUIFlowView()
                }
            }
        }
    }
    
}

#Preview {
    if #available(iOS 16.0, *) {
        NavigationStack {
            QuickStartGuideView()
        }
    } else {
        // Fallback on earlier versions
    }
}
