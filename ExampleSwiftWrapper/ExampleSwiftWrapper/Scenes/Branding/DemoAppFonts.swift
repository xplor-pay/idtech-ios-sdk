//
//  MyAppFonts.swift
//  ExampleSwiftWrapper
//
//  Created by Manoj Baste on 04/06/26.
//


import UIKit
import ClearentIdtechIOSFramework

final class DemoAppFonts: ClearentUIFonts {

    // MARK: - Extra fonts required by newer SDK builds

    var settingsScreenTitle: UIFont { .boldSystemFont(ofSize: 20) }

    var settingsOfflineModeSubtitle: UIFont { .systemFont(ofSize: 14, weight: .medium) }

    var settingsOfflineModeProcessLabel: UIFont { .systemFont(ofSize: 14) }

    var settingsReadersPlaceholderLabel: UIFont { .systemFont(ofSize: 14) }

    var settingsReadersDescriptionLabel: UIFont { .systemFont(ofSize: 12) }

    var offlineResultItemLabelFont: UIFont { .systemFont(ofSize: 14) }

    var offlineReportFieldLabel: UIFont { .systemFont(ofSize: 12, weight: .medium) }

    // MARK: - Existing protocol fonts

    var primaryButtonTextFont: UIFont { .systemFont(ofSize: 14, weight: .semibold) }

    var hintTextFont: UIFont { .systemFont(ofSize: 14) }

    var modalTitleFont: UIFont { .boldSystemFont(ofSize: 16) }

    var modalSubtitleFont: UIFont { .systemFont(ofSize: 14) }

    var listItemTextFont: UIFont { .systemFont(ofSize: 14) }

    var readerNameTextFont: UIFont { .systemFont(ofSize: 14) }

    var statusLabelFont: UIFont { .systemFont(ofSize: 10) }

    var tipItemTextFont: UIFont { .systemFont(ofSize: 14) }

    var customNameInfoLabelFont: UIFont { .systemFont(ofSize: 12) }

    var customNameInputLabelFont: UIFont { .systemFont(ofSize: 14) }

    var signatureSubtitleFont: UIFont { .systemFont(ofSize: 12) }

    var detailScreenItemTitleFont: UIFont { .systemFont(ofSize: 14) }

    var detailScreenItemSubtitleFont: UIFont { .systemFont(ofSize: 14) }

    var detailScreenItemDescriptionFont: UIFont { .systemFont(ofSize: 10) }

    var screenTitleFont: UIFont { .boldSystemFont(ofSize: 20) }

    var paymentViewTitleLabelFont: UIFont { .systemFont(ofSize: 14) }

    var paymentFieldTitleLabelFont: UIFont { .systemFont(ofSize: 14) }

    var errorMessageLabelFont: UIFont { .systemFont(ofSize: 10) }

    var sectionTitleLabelFont: UIFont { .systemFont(ofSize: 16) }

    var textfieldPlaceholder: UIFont { .systemFont(ofSize: 14) }
}
