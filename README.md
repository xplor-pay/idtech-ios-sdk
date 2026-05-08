
# Clearent iOS SDK Integration

## Overview

This project demonstrates a complete integration of the Clearent iOS SDK for supporting both card-present and card-not-present payment workflows within an iOS application. The integration showcases how the SDK abstracts payment-processing complexity, Bluetooth reader communication, secure transaction handling, receipt management, signature workflows, offline transaction support, and transaction lifecycle management into a simplified delegate-driven architecture. Instead of the application directly managing lower-level payment infrastructure logic, the framework internally handles secure communication, transaction processing, reader connectivity, EMV/contactless processing, encryption, and asynchronous payment lifecycle coordination while exposing a clean and lightweight integration layer to the application.

The implementation includes support for VP3300 Bluetooth payment readers, manual card entry transactions, receipt delivery workflows, signature upload handling, offline transaction storage, and transaction status callbacks. Throughout the transaction lifecycle, the SDK continuously communicates with the application using delegate callbacks, allowing the application layer to respond to transaction events, reader connection states, user interaction requirements, transaction approvals, payment failures, offline processing events, and receipt/signature operations in real time. This architecture enables the application to remain focused primarily on transaction initiation, user interaction, and transaction state presentation while the SDK manages the underlying payment infrastructure securely and efficiently.

---

# Podfile

The Clearent iOS SDK is integrated into the application using CocoaPods dependency management. The framework dependency must be added to the application's `Podfile` before installing project dependencies. Once installed, the SDK and all required framework resources become available to the application environment.

```ruby
platform :ios, '15.0'

target 'YourProjectName' do
    use_frameworks!

    pod 'ClearentIdtechIOSFramework'
end
```

Install the dependencies using:

```bash
pod install
```

After installation completes, the generated `.xcworkspace` file should always be opened instead of the `.xcodeproj` file. This ensures all CocoaPods dependencies, framework configurations, and generated workspace references are loaded correctly during development and build execution.

---

# Required Application Permissions

The SDK requires Bluetooth permissions in order to discover, connect, and communicate with supported payment readers such as VP3300. Depending on the supported hardware being used, microphone permissions may also be required for audio-jack based payment readers. These permissions must be configured within the application's `Info.plist` file before initiating any reader discovery or payment transaction operations.

```xml
<key>NSBluetoothAlwaysUsageDescription</key>
<string>Bluetooth access is required for payment reader connectivity.</string>

<key>NSMicrophoneUsageDescription</key>
<string>Microphone access is required for audio-jack reader support.</string>
```

These permission declarations allow the framework to securely interact with payment devices while complying with iOS system-level privacy requirements related to Bluetooth communication and external hardware connectivity.

---

# SDK Initialization

Before performing any transaction processing or reader-related operations, the Clearent SDK must first be initialized with the required application configuration values. The initialization process establishes the application's authentication credentials, payment environment configuration, offline transaction encryption settings, and delegate communication layer that will be used throughout the SDK lifecycle.

```swift
let encryptionKeyData = Crypto.SHA256hash(
    data: "some_secret_here".data(using: .utf8)!
)

let configuration = ClearentWrapperConfiguration(
    baseURL: baseURL,
    apiKey: apiKey,
    publicKey: nil,
    offlineModeEncryptionKeyData: encryptionKeyData
)

ClearentWrapper.shared.initialize(with: configuration)

ClearentWrapper.shared.delegate = self
```

The `apiKey` is used to authenticate the application with backend payment services before transaction processing begins. The `baseURL` identifies the target payment environment, such as sandbox or production infrastructure. The `offlineModeEncryptionKeyData` value is used by the framework to securely encrypt locally stored offline transaction data in situations where connectivity becomes temporarily unavailable.

Before the encryption key is passed into the SDK configuration, the raw value is transformed using SHA256 hashing. This produces a secure fixed-length encrypted representation that helps strengthen offline transaction protection and prevents direct exposure of the original encryption secret within the application layer.

The application assigns itself as the SDK delegate using:

```swift
ClearentWrapper.shared.delegate = self
```

This enables the framework to asynchronously communicate reader lifecycle events, transaction status updates, payment responses, receipt handling results, signature upload responses, offline transaction notifications, and user interaction instructions back to the application layer throughout the payment lifecycle.

---

# Delegate-Driven SDK Architecture

The Clearent SDK follows a delegate-driven architecture where the application initiates SDK operations while the framework internally manages processing workflows and communicates results asynchronously using delegate callbacks. This architecture significantly reduces the amount of payment-processing complexity that must be implemented directly within the application layer.

The typical transaction lifecycle follows this sequence:

```text
Application initiates SDK operation
        ↓
SDK validates request and configuration
        ↓
SDK establishes reader/payment communication
        ↓
SDK securely processes transaction
        ↓
SDK communicates with payment services
        ↓
SDK returns asynchronous transaction callbacks
        ↓
Application updates transaction state and UI
```

The framework internally manages:
- Reader communication
- EMV/contactless processing
- Secure transaction encryption
- Payment gateway communication
- Offline transaction handling
- Receipt generation
- Signature workflows
- Transaction lifecycle coordination

This separation of concerns allows the application to remain lightweight while still receiving detailed transaction lifecycle visibility through asynchronous callbacks provided by the SDK.

---

# VP3300 Reader Flow (Card-Present Transactions)

The SDK supports card-present transaction workflows using compatible Bluetooth payment readers such as VP3300. Reader discovery begins by initiating the pairing process through the SDK, which scans for nearby compatible payment devices and returns discovered readers through delegate callbacks.

```swift
ClearentWrapper.shared.startPairing(
    reconnectIfPossible: false
)
```

As nearby devices are discovered, the SDK communicates reader information through:

```swift
func didFindReaders(
    readers: [ReaderInfo]
)
```

Each `ReaderInfo` object contains information such as:
- Reader name
- Reader serial number
- Reader connection status
- Reader battery level
- Reader identification details

Once a reader is selected, the framework internally manages the secure connection lifecycle and provides additional connection-related callbacks such as:

```swift
func startedReaderConnection(
    with reader: ReaderInfo
)
```

```swift
func didFinishPairing()
```

After the connection process completes successfully, a card-present payment transaction can be initiated using:

```swift
ClearentWrapper.shared.startTransaction(
    with: saleEntity,
    isManualTransaction: false
)
```

During the transaction lifecycle, the SDK provides real-time user guidance through delegate callbacks such as:

```swift
func userActionNeeded(
    action: UserAction
)
```

These callbacks guide the customer through transaction steps including:
- Insert card
- Tap card
- Swipe card
- Remove card

The framework internally manages Bluetooth communication, reader encryption, EMV processing, contactless transaction handling, secure payment communication, and payment gateway interaction while abstracting these responsibilities away from the application layer.

The final transaction result is delivered asynchronously through:

```swift
func didFinishTransaction(
    response: TransactionResponse?,
    error: ClearentError?
)
```

This callback provides transaction approval details, processing failures, decline responses, and transaction status information depending on the payment outcome.

---

# Manual Card Entry Flow (Card-Not-Present Transactions)

The SDK also supports manual card entry workflows for card-not-present transaction scenarios. In this flow, the application collects payment information directly from the user interface instead of using a physical payment reader.

The application gathers:
- Card Number
- Expiration Date
- CVV / CSC
- Transaction Amount

A transaction request is then created using `SaleEntity`:

```swift
let saleEntity = SaleEntity(
    amount: amountString,
    card: card,
    csc: csc,
    expirationDateMMYY: expirationDateMMYY
)
```

The transaction is initiated using:

```swift
ClearentWrapper.shared.startTransaction(
    with: saleEntity,
    isManualTransaction: true
)
```

Once initiated, the framework internally handles:
- Card validation
- Secure encryption
- Payment transport
- Gateway communication
- Transaction lifecycle management
- Error handling
- Payment processing coordination

The application does not directly manage low-level payment communication logic, allowing the SDK to maintain transaction integrity and secure payment processing internally throughout the transaction lifecycle.

---

# Receipt Handling and Signature Support

The framework provides built-in support for receipt handling and customer signature workflows. Receipt generation, delivery processing, retry handling, and offline receipt queuing are managed internally by the SDK while asynchronous status updates are communicated back to the application layer through delegate callbacks.

Receipt delivery responses are returned through:

```swift
func didFinishedSendingReceipt(
    response: ReceiptResponse?,
    error: ClearentError?
)
```

The framework also supports signature upload and transaction association workflows. After capturing a customer signature using the application's UI layer, the signature image can be uploaded using:

```swift
sendSignatureWithImage(image:)
```

The SDK securely associates the uploaded signature with the related payment transaction and communicates the upload result asynchronously through:

```swift
func didFinishedSignatureUploadWith(
    response: SignatureResponse?,
    error: ClearentError?
)
```

The framework additionally supports offline signature handling workflows when connectivity becomes temporarily unavailable.

---

# Offline Transaction Support

The SDK includes support for offline transaction processing workflows in situations where network connectivity is temporarily interrupted. During offline operation, transactions are securely encrypted, stored locally, and queued for future processing once connectivity is restored.

Offline transaction handling callbacks include:

```swift
func didAcceptOfflineTransaction(
    status: TransactionStoreStatus
)
```

```swift
func didAcceptOfflineSignature(
    status: TransactionStoreStatus,
    transactionID: String
)
```

```swift
func didAcceptOfflineEmail(
    transactionID: String
)
```

This functionality helps maintain transaction continuity while preserving transaction integrity, secure storage handling, and reliable transaction retry processing during temporary network failures.

---

# Security Overview

Security responsibilities are primarily managed internally by the Clearent SDK and supported payment reader infrastructure in order to minimize direct exposure of sensitive payment information within the application layer.

For card-present transactions, sensitive card data is captured directly by the payment reader itself. PAN and CVV values are not manually processed or persisted by the application, significantly reducing the application's exposure to sensitive payment information.

For manual card entry workflows, the framework internally manages secure transaction packaging, encryption, payment transport, gateway communication, and transaction integrity validation throughout the payment lifecycle.

The SDK manages:
- Secure reader communication
- Encrypted payment transport
- Offline transaction encryption
- Secure gateway communication
- Transaction integrity validation
- Reader security workflows
- EMV/contactless processing

Offline transaction encryption is configured during SDK initialization using:

```swift
let encryptionKeyData = Crypto.SHA256hash(
    data: "some_secret_here".data(using: .utf8)!
)
```

The application layer intentionally avoids:
- Logging PAN/CVV data
- Persisting raw payment information
- Exposing sensitive transaction data
- Managing low-level encryption workflows directly

The delegate-driven architecture further isolates transaction-processing complexity from the application while still allowing the application to receive transaction lifecycle updates, reader events, and transaction status notifications securely in real time.
