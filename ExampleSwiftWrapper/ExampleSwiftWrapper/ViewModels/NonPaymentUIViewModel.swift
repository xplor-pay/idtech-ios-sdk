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
class NonPaymentUIViewModel: NSObject, ObservableObject {
    
    @Published var readerStatus = "No reader connected"
    @Published var infoMessage = ""
    @Published var readers: [ReaderInfo] = []
    
    @Published var isLoading = false
    @Published var transactionResult: String?
    
    @Published var shouldShowTapToPay = false
    @Published var paymentInfo: PaymentInfo?
    
    override init() {
        super.init()
        configureSDK()
    }
    
    // MARK: - SDK Setup
    
    func configureSDK() {
        // Initialize the SDK with needed info to work properly
        // ! Make sure you update the baseURL and apiKey with the correct values in order to test the SDK !
        let baseURL = "https://gateway-qa.clearent.net"
        let apiKey: String? =  "1573dd1f92af43e6ae59a0e6e4f5f32f"
        let encryptionKeyData = Crypto.SHA256hash(data: "some_secret_here".data(using: .utf8)!)
        
        //Change ClearentWrapperConfiguration to ClearentUIManagerConfiguration if you want to use the default UI provided by the SDK
        let clearentWrapperConfiguration = ClearentWrapperConfiguration(
            baseURL: baseURL,
            apiKey: apiKey,
            publicKey: nil,
            offlineModeEncryptionKeyData: encryptionKeyData
        )
        ClearentWrapper.shared.initialize(with: clearentWrapperConfiguration)
        ClearentWrapper.shared.delegate = self
        
        ClearentWrapper.configuration.readerInfoReceived = { [weak self] reader in
            DispatchQueue.main.async {
                guard let self else { return }
                if reader?.isConnected == true {
                    self.readerStatus =
                    "\(reader?.readerName ?? "-")" +
                    "\nSN : \(reader?.serialNumber ?? "-")" +
                    "\nBattery Level : \(reader?.batterylevel ?? 0)"
                } else {
                    self.readerStatus = "No reader connected."
                }
            }
        }
    }
    
    func pairNewReader() {
        isLoading = true
        infoMessage = "Searching for readers..."
        ClearentWrapper.shared.startPairing(reconnectIfPossible: false)
    }
    
    func disconnectReader() {
        ClearentWrapper.shared.disconnectFromReader()
        readers.removeAll()
        readerStatus = "No reader connected"
        infoMessage = "Device disconnected"
    }
    
    func connectTo(reader: ReaderInfo) {
        infoMessage = "Connecting to \(reader.readerName)"
        ClearentWrapper.shared.connectTo(reader: reader)
    }
    
    /*
     Initiates a card-present transaction using a connected reader via the SDK.

     - This method should be called after a reader is successfully paired and connected.
     - It prepares the transaction request and delegates processing to the SDK.
     - The SDK handles card data capture directly from the reader (no manual card input required).
     - Transaction result is delivered asynchronously via delegate callbacks (e.g., `didFinishTransaction`).

     Parameter:
     - amount: The transaction amount to be charged. It is formatted to the SDK-required string before processing.

     Notes:
     - This method does not return the final transaction result immediately.
     - Ensure the reader is connected and the SDK is properly initialized before calling.
     - Sensitive card data is securely handled by the reader and SDK.
    */
    func startCardReaderTransaction(with amount: Double) {
        let amountString: String = String(format: "%f", amount)
        let saleEntity = SaleEntity(amount: amountString)
        Task{
            if let error = await ClearentWrapper.shared.startTransaction(with: saleEntity, isManualTransaction: false) {
                infoMessage = "Oops, Card Reader Transaction something went wrong, error \(error.type.rawValue)"
                print("Error:", error.localizedDescription)
                print("Code:", error.type)
            } else {
                infoMessage = "Transaction started.."
            }
        }
    }
    
    /*
     Initiates a manual (card-not-present) transaction using the SDK.

     - This method should be used when card details are entered manually instead of using a card reader.
     - It constructs the transaction request with provided card details and delegates processing to the SDK.
     - The SDK securely processes the transaction and returns the result asynchronously via delegate callbacks
       (e.g., `didFinishTransaction`).

     Parameters:
     - amount: The transaction amount to be charged. It is formatted to the SDK-required string before processing.
     - card: The card number (PAN) entered by the user. Must be valid and properly formatted.
     - csc: The card security code (CVV).
     - expirationDateMMYY: The card expiry date in MMYY format (e.g., "1226").

     Usage:
     - Call this method after collecting valid card details from the user.
     - Ensure the SDK is properly initialized before invoking this method.
     - Do not call this method for card-present (reader-based) transactions.

     Notes:
     - This method does not return the final transaction result immediately.
     - The outcome (success/failure) is delivered via SDK delegate methods.
     - Sensitive card data is handled securely and should not be logged or stored.
    */
    func startManualTransaction(with amount: Double, card: String, csc: String, expirationDateMMYY: String) {
        let amountString: String = String(format: "%f", amount)
        let saleEntity = SaleEntity(amount: amountString, card: card, csc: csc, expirationDateMMYY: expirationDateMMYY)
        Task {
            if let error =   await ClearentWrapper.shared.startTransaction(with: saleEntity, isManualTransaction: true)  {
                infoMessage = "Oops, something went wrong, error \(error.type.rawValue)"
                print("Error:", error.type.rawValue)
                print("Code:", error.type.localizedDescription)
            } else {
                infoMessage = "Transaction started.."
            }
        }
    }
}

extension NonPaymentUIViewModel: @MainActor ClearentWrapperProtocol {
    func didStartPairing() {
        infoMessage = "Searching for readers..."
    }
    
    func didFinishPairing() {
        infoMessage = "Reader Connected"
    }
    
    func didReceiveSignalStrength() {
    }
    
    func didFindReaders(readers: [ClearentIdtechIOSFramework.ReaderInfo]) {
        self.readers = readers
    }
    
    func deviceDidDisconnect() {
        infoMessage = "Device disconnected"
    }
    
    func startedReaderConnection(with reader: ClearentIdtechIOSFramework.ReaderInfo) {
        infoMessage = "Connecting to \(reader.readerName)"
    }
    
    func didFindRecentlyUsedReaders(readers: [ClearentIdtechIOSFramework.ReaderInfo]) {
    }
    
    func didBeginContinuousSearching() {
    }
    
    func didEncounteredGeneralError() {
        infoMessage = "Oops, something went wrong!"
    }
    
    func didFinishTransaction(response: ClearentIdtechIOSFramework.TransactionResponse?, error: ClearentIdtechIOSFramework.ClearentError?) {
        if (error != nil) {
            infoMessage = "Transaction successfully processed."
        } else {
            infoMessage = "Oops, something went wrong!"
        }
    }
    
    func didAcceptOfflineTransaction(status: ClearentIdtechIOSFramework.TransactionStoreStatus) async {
    }
    
    func didFinishedSignatureUploadWith(response: ClearentIdtechIOSFramework.SignatureResponse?, error: ClearentIdtechIOSFramework.ClearentError?) async {
    }
    
    func didFinishedSendingReceipt(response: ClearentIdtechIOSFramework.ReceiptResponse?, error: ClearentIdtechIOSFramework.ClearentError?) async {
    }
    
    func didAcceptOfflineSignature(status: ClearentIdtechIOSFramework.TransactionStoreStatus, transactionID: String) async {
    }
    
    func didAcceptOfflineEmail(transactionID: String) async {
    }
    
    func userActionNeeded(action: ClearentIdtechIOSFramework.UserAction) {
        infoMessage = action.rawValue
    }
    
    func showEncryptionWarning() {
    }
    
}

