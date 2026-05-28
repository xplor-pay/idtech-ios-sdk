//
//  ReaderListView.swift
//  ExampleSwiftWrapper
//
//  Created by Manoj Baste on 28/05/26.
//
import SwiftUI

struct ReaderListView: View {
    
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        
        List(viewModel.readers, id: \.serialNumber) { reader in
            Button {
                viewModel.connectTo(reader: reader)
            } label: {
                VStack(alignment: .leading) {
                    Text(reader.readerName)
                        .font(.headline)
                }
            }
        }
    }
}
