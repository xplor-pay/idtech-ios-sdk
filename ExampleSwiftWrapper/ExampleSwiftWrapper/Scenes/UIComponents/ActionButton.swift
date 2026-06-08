//
//  ActionButton.swift
//  ExampleSwiftWrapper
//
//  Created by Manoj Baste on 28/05/26.
//
import SwiftUI

struct ActionButton: View {

    let title: String
    var backgroundColor: Color
    var foregroundColor: Color = .white

    let action: () -> Void

    var body: some View {

        Button(action: action) {

            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(foregroundColor)
                .frame(maxWidth: .infinity)
                .frame(height: 45)
        }
        .background(backgroundColor)
        .clipShape(Capsule())
    }
}
