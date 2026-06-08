//
//  NonPaymentUIFlowHome.swift
//  ExampleSwiftWrapper
//
//  Created by Manoj Baste on 28/05/26.
//
import SwiftUI
import ClearentIdtechIOSFramework

@available(iOS 14.0, *)
struct NonPaymentUIFlowView: View {
    
    @StateObject private var viewModel = NonPaymentUIViewModel()
    
    // MARK: - State
    @State private var readerStatus = "Reader"
    @State private var infoText = "Info"
    
    var body: some View {
        
        if #available(iOS 14.0, *) {
            ScrollView {
                
                if #available(iOS 16.0, *) {
                    VStack(alignment: .leading, spacing: 20)
                    {
                        
                        // Reader Status
                        Text(viewModel.readerStatus)
                            .font(.system(size: 14))
                            .frame(maxWidth: .infinity,
                                   minHeight: 60,
                                   alignment: .leading)
                        
                        // Disconnect Button
                        ActionButton(
                            title: "Disconnect",
                            backgroundColor: .blue
                        ) {
                            viewModel.disconnectReader()
                        }
                        
                        // Pair Reader Button
                        ActionButton(
                            title: "Pair new reader",
                            backgroundColor: .gray.opacity(0.2),
                            foregroundColor: .primary
                            
                        ) {
                            viewModel.pairNewReader()
                        }
                        
                        Divider()
                        
                        // MARK: - Reader List
                        if !viewModel.readers.isEmpty {
                            ReaderListView(viewModel: viewModel)
                                .frame(height: 100)
                        }
                        
                        Spacer()
                        
                        // Content Area
                        VStack(spacing: 30) {
                            
                            Spacer()
                            
                            // Info Label
                            Text(viewModel.infoMessage)
                                .font(.system(size: 17))
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity)
                                .frame(height: 80)
                            
                            Spacer()
                            
                            // Card Reader
                            ActionButton(
                                title: "Charge $20.0 - Card Reader",
                                backgroundColor: .blue
                            ) {
                                viewModel.startCardReaderTransaction(with: 20.00)
                            }
                            
                            // Manual Entry
                            ActionButton(
                                title: "Charge $20.0 - Manual Entry",
                                backgroundColor: .blue
                            ) {
                                viewModel.startManualTransaction(
                                    with: 20.00,
                                    card: "4111111111111111",
                                    csc: "999",
                                    expirationDateMMYY: "11/99"
                                )
                            }
                        }
                        .padding(.vertical, 40)
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemBackground))
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                } else {
                    // Fallback on earlier versions
                }
            }
        } else {
            // Fallback on earlier versions
        }
        
    }
    
}

#Preview {
    if #available(iOS 16.0, *) {
        NavigationStack {
            NonPaymentUIFlowView()
        }
    } else {
        // Fallback on earlier versions
    }
}
