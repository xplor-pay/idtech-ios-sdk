//
//  ViewController.swift
//  ExampleSwiftWrapper
//
//  Created by Ovidiu Rotaru on 28.07.2022.
//

import UIKit
import ClearentIdtechIOSFramework

class ViewController: UIViewController {

    @IBOutlet weak var readerStatusLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    
    var tableView : UITableView?
    var readers : [ReaderInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSDK()
    }
    
    // MARK: SDK Related
    /*
     Purpose:
     - Initializes the Clearent SDK with required configuration parameters for transaction processing.
    
     Parameters / Configuration:
     - baseURL: Defines the environment endpoint (e.g., sandbox or production).
     - apiKey: Authentication key required for SDK communication with backend services.
     - encryptionKeyData: Derived key used to encrypt sensitive data for offline transaction support.

     Usage:
     - This method should be called once during app initialization (e.g., in `viewDidLoad`).
     - Must be executed before performing any transaction or reader-related operation.
     - Ensure valid configuration values (baseURL, apiKey) are provided before testing.

     Notes:
     - The SDK handles secure communication and encryption internally.
     - Reader status updates are delivered asynchronously via the configured callback.
    */
     func initSDK() {
        // Initialize the SDK with needed info to work properly
        // ! Make sure you update the baseURL and apiKey with the correct values in order to test the SDK !
        let baseURL = "https://gateway-qa.clearent.net"
        let apiKey: String? =  "1573dd1f92af43e6ae59a0e6e4f5f32f" //nil
        
        let encryptionKeyData = Crypto.SHA256hash(data: "some_secret_here".data(using: .utf8)!)
        let clearentWrapperConfiguration = ClearentWrapperConfiguration(baseURL: baseURL, apiKey: apiKey, publicKey: nil, offlineModeEncryptionKeyData: encryptionKeyData)
        ClearentWrapper.shared.initialize(with: clearentWrapperConfiguration)
        ClearentWrapper.shared.delegate = self
        
        ClearentWrapper.configuration.readerInfoReceived = { [weak self] reader in
            DispatchQueue.main.async {
                if (reader?.isConnected == true) {
                    self?.readerStatusLabel.text = (reader?.readerName ?? "-") + "\nSN : \(String(describing: reader?.serialNumber))" + "\nBattery Level : \(String(describing: reader?.batterylevel))"
                } else {
                    self?.readerStatusLabel.text = "No reader connected."
                }
            }
        }
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
      public func startCardReaderTransaction(with amount: Double) {
        let amountString: String = String(format: "%f", amount)
        let saleEntity = SaleEntity(amount: amountString)
        
        Task{
            if let error = await ClearentWrapper.shared.startTransaction(with: saleEntity, isManualTransaction: false) {
                self.infoLabel?.text = "Oops, Card Reader Transaction something went wrong, error \(error.type.rawValue)"
                print("Error:", error.localizedDescription)
                print("Code:", error.type)
            } else {
                infoLabel?.text = "Transaction started.."
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
    public func startManualTransaction(with amount: Double, card: String, csc: String, expirationDateMMYY: String) {
        let amountString: String = String(format: "%f", amount)
        let saleEntity = SaleEntity(amount: amountString, card: card, csc: csc, expirationDateMMYY: expirationDateMMYY)
        Task {
            if let error =   await ClearentWrapper.shared.startTransaction(with: saleEntity, isManualTransaction: true)  {
                self.infoLabel.text = "Oops, something went wrong, error \(error.type.rawValue)"
                print("Error:", error.type.rawValue)
                print("Code:", error.type.localizedDescription)
            } else {
                infoLabel.text = "Transaction started.."
            }
        }
    }
    
    // MARK: Actions
    
    // Disconnects the currently connected card reader via the SDK.
    // Updates UI state to reflect that no reader is connected.
    @IBAction func disconnectFromReaderButtonAction(_ sender: Any) {
        // TO DO move this to deviceDisconnected method
        readerStatusLabel.text = "No reader connected"
        infoLabel.text = "Device disconnected"
        ClearentWrapper.shared.disconnectFromReader()
    }
    
    // Initiates discovery of new card readers via the SDK (fresh pairing).
    // Triggers scanning process and updates UI to reflect search state.
    @IBAction func pairNewReaderButtonAction(_ sender: Any) {
        self.infoLabel.text = "Searching for readers..."
        ClearentWrapper.shared.startPairing(reconnectIfPossible: false)
    }
    
    //   IBAction triggered by the demo UI. Kicks off a card-present transaction flow.
    //   For the demo we call `startCardReaderTransaction` with a sample amount.
    @IBAction func startCardReaderTransactionAction(_ sender: Any) {
        startCardReaderTransaction(with: 20.0)
    }
    
    // IBAction triggered by the demo UI. Kicks off a manual (card-not-present) transaction flow.
    // For the demo we call `startManualTransaction` with sample card details and amount.
    @IBAction func startManualTransactionAction(_ sender: Any) {
        startManualTransaction(with: 20.0, card: "4111111111111111", csc: "999", expirationDateMMYY: "11/99")
    }
    
    
    // MARK: Tableview helper methods
    
    // Displays the list of discovered card readers in a table view.
    // Called after the SDK returns available readers during the pairing process.
    func showReaderList(readers:[ReaderInfo]) {
        self.readers = readers
        if self.tableView == nil {
            createTableView()
        }
        self.tableView?.reloadData()
    }
    
    // Creates and configures a table view to present reader devices.
    // Used when initializing the UI for displaying discovered readers.
    func createTableView() {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = self.contentView.bounds
        self.contentView.addSubview(tableView)
        self.tableView = tableView
    }
}


extension ViewController : @MainActor ClearentWrapperProtocol {
    
    // MARK: - Reader Pairing Started

    /*
     This method is called when the SDK begins searching for available card readers.

     Key Points:
     - Initiates the device discovery process.
     - SDK scans for compatible readers (e.g., VP3300).
     - Triggered before any reader is selected or connected.

     Framework Capability:
     - Handles Bluetooth/device discovery internally.
     - Abstracts hardware scanning complexity.
     - Provides lifecycle callback when search begins.
    */
    
    func didStartPairing() {
        infoLabel.text = "Searching for readers..."
    }


    // MARK: - Reader Pairing Completed

    /*
     This method is called when the SDK successfully completes pairing
     with a card reader.

     Key Points:
     - Indicates that a reader is now connected and ready.
     - Marks completion of pairing process.

     Framework Capability:
     - Manages secure pairing and connection internally.
     - Confirms readiness of hardware for transactions.
    */
    func didFinishPairing() {
        infoLabel.text = "Reader Connected"
    }


    // MARK: - Signal Strength Update

    /*
     This method is triggered when the SDK receives signal strength updates
     from the connected reader.

     Key Points:
     - Reflects connection quality between device and reader.
     - Can be used to monitor stability.

     Framework Capability:
     - Continuously monitors connection health.
     - Provides real-time feedback about signal strength.
    */
    func didReceiveSignalStrength() {
        //
    }


    // MARK: - Reader Discovery

    /*
     This method is called when the SDK discovers available card readers.
     
     Parameters:
     - readers: An array of ReaderInfo objects representing nearby compatible readers,
                including details such as name, serial number, and connection status.

     Key Points:
     - Provides a list of nearby compatible readers.
     - Each reader includes identification details.

     Framework Capability:
     - Performs device discovery and filtering internally.
     - Returns structured reader information.
    */
    func didFindReaders(readers: [ClearentIdtechIOSFramework.ReaderInfo]) {
        showReaderList(readers: readers)
    }


    // MARK: - Device Disconnection

    /*
     This method is triggered when the connected reader is disconnected.

     Key Points:
     - Indicates loss of connection with the reader.
     - Can occur due to range, power, or manual disconnect.

     Framework Capability:
     - Detects disconnection events automatically.
     - Notifies application for appropriate handling.
    */
    func deviceDidDisconnect() {
        infoLabel.text = "Device disconnected"
    }


    // MARK: - Reader Connection Started

    /*
     This method is called when the SDK begins connecting to a selected reader.
     
     Parameters:
     - reader: A ReaderInfo object representing the selected device,
               including details such as reader name and identification.

     Key Points:
     - Indicates transition from discovery to connection phase.
     - Provides reader details being connected.

     Framework Capability:
     - Manages connection lifecycle internally.
     - Handles communication setup with selected device.
    */
    func startedReaderConnection(with reader: ClearentIdtechIOSFramework.ReaderInfo) {
        tableView?.removeFromSuperview()
        tableView = nil
        infoLabel.text = "Connecting to \(reader.readerName)"
    }


    // MARK: - Recently Used Readers

    /*
     This method is called when the SDK retrieves previously connected readers.
     Parameters:
     - readers: An array of ReaderInfo objects representing previously paired or known devices,
                including details such as name, identifier, and connection status.

     Key Points:
     - Provides a list of saved or known devices.
     - Helps prioritize faster reconnection.

     Framework Capability:
     - Maintains history of connected devices.
     - Supports quick reconnection workflows.
    */
    func didFindRecentlyUsedReaders(readers: [ClearentIdtechIOSFramework.ReaderInfo]) {
        //
    }


    // MARK: - Continuous Searching Started

    /*
     This method is triggered when the SDK begins continuous scanning
     for available readers.

     Key Points:
     - Indicates ongoing search mode.
     - Useful for dynamic discovery of devices.

     Framework Capability:
     - Supports continuous background scanning.
     - Automatically updates available device list.
    */
    func didBeginContinuousSearching() {
        //
    }
    
    // MARK: - Error messages
    
    func didEncounteredGeneralError() {
        infoLabel.text = "Oops, something went wrong!"
    }
    
    // MARK: - Transaction related callbacks
    
    // Called by SDK when transaction completes.
    // - Success: `response` contains transaction details.
    // - Failure: `error` provides failure reason.
    // - Triggered after `startTransaction(...)`.
    // - Do not call manually; invoked via delegate.
    func didFinishTransaction(response: ClearentIdtechIOSFramework.TransactionResponse?,error: ClearentIdtechIOSFramework.ClearentError?) {
        if (error != nil) {
            self.infoLabel.text = "Transaction successfully processed."
        } else {
            self.infoLabel.text = "Oops, something went wrong!"
        }
    }
    
    // Called by SDK when a transaction is accepted for offline processing.
    // - status: Indicates how the transaction was stored locally (e.g., queued, persisted).
    // - Triggered when network is unavailable and SDK stores transaction securely.
    // - Do not call manually; invoked via delegate for offline handling.
    func didAcceptOfflineTransaction(status: ClearentIdtechIOSFramework.TransactionStoreStatus) {
        //
    }
    
    // Purpose:
    //   Called by the SDK after an attempt to upload a signature for a transaction.
    //   Use this callback to confirm server acceptance, update UI, clear any pending state,
    //   or schedule retries on failure.
    //
    // Notes:
    //   - Do not log or persist raw signature image data or other sensitive cardholder data.
    //   - Update UI only with non-sensitive status information.
    //   - If you maintain a pending-transaction identifier, clear it on success and keep it on failure to allow retries.
    //
    // Parameters:
    //   - response: server response for the uploaded signature (may contain IDs/status).
    //   - error: non-nil if upload failed; inspect to present appropriate message or retry logic.
        
    func didFinishedSignatureUploadWith(response: ClearentIdtechIOSFramework.SignatureResponse?, error: ClearentIdtechIOSFramework.ClearentError?) {
        //
    }
    

    // MARK: - Receipt Handling

    /*
     This method is called by the Clearent SDK after attempting to send a receipt
     (typically via email or other configured channels).
     Parameters:
     - response: Contains receipt delivery details when the operation is successful
                 (e.g., confirmation status, delivery information).
     - error: Contains error details if the receipt delivery fails.

     Key Points:
     - The SDK manages the entire receipt delivery process.
     - This callback provides the final status of that operation.
     - `response` contains receipt delivery details if successful.
     - `error` contains failure information if the operation did not succeed.

     Framework Capability:
     - Handles receipt generation and delivery internally.
     - Provides asynchronous confirmation via delegate.
     - Ensures secure handling of transaction-related communication.
    */
    func didFinishedSendingReceipt(response: ClearentIdtechIOSFramework.ReceiptResponse?, error: ClearentIdtechIOSFramework.ClearentError?) {
        //
    }


    // MARK: - Offline Signature Handling

    /*
     This method is triggered when a transaction with a captured signature
     is accepted and stored in offline mode.
     Parameters:
     - status: Indicates the result of storing the transaction locally
               (e.g., successfully queued or failed to persist).
     - transactionID: A unique identifier assigned to the offline transaction,
                      used for tracking and reconciliation.

     Key Points:
     - The SDK stores the transaction locally when network is unavailable.
     - Signature data is securely associated with the transaction.
     - `status` indicates storage result (success/failure).
     - `transactionID` uniquely identifies the stored transaction.

     Framework Capability:
     - Supports offline transaction handling.
     - Queues transactions for later processing when connectivity is restored.
     - Maintains secure storage and integrity of signed transactions.
    */
    func didAcceptOfflineSignature(status: ClearentIdtechIOSFramework.TransactionStoreStatus,transactionID: String) {
        //
    }


    // MARK: - Offline Email Handling

    /*
     This method is called when a receipt email request is accepted in offline mode.
     Parameters:
     - transactionID: A unique identifier for the transaction associated with the receipt,
                      used to track and process the email request once connectivity is restored.

     Key Points:
     - The SDK queues the email request locally due to lack of connectivity.
     - `transactionID` links the email request to the specific transaction.
     - The receipt will be sent automatically once network is restored.

     Framework Capability:
     - Supports offline queuing of receipt delivery.
     - Automatically retries sending when connectivity is available.
     - Ensures reliable customer communication without manual intervention.
    */
    func didAcceptOfflineEmail(transactionID: String) {
        //
    }
    
    // MARK: - User Action Handling

    /*
     This method is called by the Clearent SDK when user interaction is required
     during the transaction process.
     Parameters:
      - action: An enum value representing the required user step
                (e.g., insert card, swipe card, remove card), used to guide the user.

     Key Points:
     - The SDK determines when a user action is needed (e.g., insert card, swipe, remove card).
     - `action` represents the required step in the transaction flow.
     - The value is provided as an enum and can be used to guide the user.

     Framework Capability:
     - Provides real-time instructions driven by the SDK.
     - Abstracts complex device communication into simple user actions.
     - Ensures proper transaction flow by guiding user interactions step-by-step.
    */
    func userActionNeeded(action: ClearentIdtechIOSFramework.UserAction) {
        infoLabel.text = action.rawValue
    }


    // MARK: - Encryption Warning

    /*
     This method is triggered when the SDK detects a potential issue
     related to encryption or secure communication.

     Key Points:
     - Indicates that secure encryption requirements may not be fully met.
     - Can occur due to device configuration or security conditions.
     - Requires attention before proceeding with sensitive operations.

     Framework Capability:
     - Proactively detects and reports encryption-related risks.
     - Helps maintain secure transaction standards.
     - Ensures compliance by alerting the application to potential security concerns.
    */
    func showEncryptionWarning() {
        //
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return readers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let reader = readers[indexPath.row]
        cell.textLabel?.text = reader.readerName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let reader = readers[indexPath.row]
        ClearentWrapper.shared.connectTo(reader: reader)
    }
}
