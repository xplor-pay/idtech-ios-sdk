//
//  MyAppColors.swift
//  ExampleSwiftWrapper
//
//  Created by Manoj Baste on 04/06/26.
//


import UIKit
import ClearentIdtechIOSFramework

class DemoAppColors: ClearentUIColors {

    // MARK: Loading
    var loadingViewFillColor: UIColor { .black }

    // MARK: Filled Button (primary)
    var filledBackgroundColor: UIColor { .systemOrange }
    var filledButtonTextColor: UIColor { .white }
    var filledDisabledBackgroundColor: UIColor { .lightGray }
    var filledDisabledButtonTextColor: UIColor { .white }

    // MARK: Bordered Button (secondary)
    var borderColor: UIColor { .systemBlue }
    var borderedBackgroundColor: UIColor { .white }
    var borderedButtonTextColor: UIColor { .systemBlue }

    // MARK: Hint View
    var highlightedBackgroundColor: UIColor { .systemOrange }
    var highlightedTextColor: UIColor { .white }
    var defaultTextColor: UIColor { .black }

    // MARK: Labels
    var titleLabelColor: UIColor { .black }
    var subtitleLabelColor: UIColor { .darkGray }

    // MARK: Reader cells
    var readerNameColor: UIColor { .black }
    var readerStatusLabelColor: UIColor { .gray }
    var readerNameLabelColor: UIColor { .black }
    var readerStatusConnectedIconColor: UIColor { .green }
    var readerStatusNotConnectedIconColor: UIColor { .yellow }
    var readersCellBackgroundColor: UIColor { .systemGray6 }

    // MARK: Tip checkboxes
    var checkboxSelectedBorderColor: UIColor { .systemBlue }
    var checkboxUnselectedBorderColor: UIColor { .gray }
    var tipLabelColor: UIColor { .black }

    // MARK: Text fields
    var infoLabelColor: UIColor { .black }
    var manualPaymentTitleColor: UIColor { .black }
    var manualPaymentErrorMessageColor: UIColor { .red }
    var manualPaymentTextFieldPlaceholder: UIColor { .gray }

    // MARK: Navigation / Reader Details Screen
    var navigationBarTintColor: UIColor { .black }
    var screenTitleColor: UIColor { .black }
    var removeReaderButtonBorderColor: UIColor { .red }
    var removeReaderButtonTextColor: UIColor { .red }

    // MARK: Signature view
    var signatureDescriptionMessageColor: UIColor { .black }
    
    // MARK: - Extra colors required by current SDK
    var linkButtonTextColor: UIColor { .systemBlue }
    var linkButtonDisabledTextColor: UIColor { .systemGray3 }

    var subtitleWarningLabelColor: UIColor { .systemOrange }

    var fieldValidationErrorMessageColor: UIColor { .systemRed }

    var settingOfflineStatusLabel: UIColor { .secondaryLabel }
    var settingsOfflineStatusLabelFail: UIColor { .systemRed }
    var settingsOfflineStatusLabelSuccess: UIColor { .systemGreen }

    var settingsReadersPlaceholderColor: UIColor { .placeholderText }
    var settingsReadersDescriptionColor: UIColor { .secondaryLabel }

    var errorLogKeyLabelColor: UIColor { .label }
    var errorLogValueLabelColor: UIColor { .secondaryLabel }
}
