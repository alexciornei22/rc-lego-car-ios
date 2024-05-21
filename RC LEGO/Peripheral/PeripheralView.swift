//
//  PeripheralView.swift
//  RC LEGO
//
//  Created by Alex on 18.05.2024.
//

import SwiftUI

struct PeripheralView: View {
    @StateObject var viewModel: PeripheralViewModel
    
    var body: some View {
        Group {
            if viewModel.isSendEnabled {
                PlayView(viewModel: .init(peripheral: viewModel.peripheral, characteristic: viewModel.characteristic!))
            } else {
                disconnected
            }
        }
        .navigationTitle(viewModel.peripheral.name ?? "Unknown")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                toggleConnectionButton
            }
        }
    }
    
    private var toggleConnectionButton: some View {
        Button {
            viewModel.toggleConnection()
        } label: {
            switch viewModel.state {
            case .connected:
                Text("Disconnect")
            case .disconnected:
                Text("Connect")
            default:
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
            }
        }
    }
    
    private var disconnected: some View {
        Text("The car is currently disconnected")
    }
}
