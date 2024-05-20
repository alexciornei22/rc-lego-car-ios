//
//  PeripheralView.swift
//  RC LEGO
//
//  Created by Alex on 18.05.2024.
//

import SwiftUI

struct PeripheralView: View {
    @StateObject var viewModel: PeripheralViewModel
    @ObservedObject var bluetoothManager: BluetoothManager

    var body: some View {
        VStack(alignment: .leading) {                    
            HStack(spacing: 20) {
                TextField("Enter message", text: $viewModel.textInput)
                    .textFieldStyle(.roundedBorder)
                
                Spacer()
                
                Button {
                    bluetoothManager.write(
                        string: viewModel.textInput,
                        to: viewModel.peripheral,
                        for: viewModel.characteristic!
                    )
                } label: {
                    HStack {
                        Text("Send")
                        Image(systemName: "arrow.forward")
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(!viewModel.isSendEnabled)
            }
        }
        .padding(.all)
        .navigationTitle(viewModel.peripheral.name ?? "Unknown")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                toggleConnectionButton
            }
        }
    }
    
    private var toggleConnectionButton: some View {
        Button {
            bluetoothManager.toggleConnectionTo(viewModel.peripheral)
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
}
