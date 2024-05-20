//
//  ContentView.swift
//  RC LEGO
//
//  Created by Alex on 18.05.2024.
//

import SwiftUI
import CoreBluetooth

struct RootView: View {
    @StateObject var viewModel: RootViewModel
    @ObservedObject var bluetoothManager: BluetoothManager

    var body: some View {
        VStack {
            Text("Select Bluetooth Device:")
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            List(bluetoothManager.discoveredPeripherals, id: \.identifier) { peripheral in
                Button {
                    viewModel.goToPeripheralInteraction(peripheral: peripheral)
                } label: {
                    VStack(alignment: .leading) {
                        Text(peripheral.name ?? "Unknown")
                        Text(peripheral.identifier.uuidString)
                            .foregroundStyle(.secondary)
                    }
                }
                .foregroundStyle(.primary)
            }
            .listStyle(.grouped)
        }
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.inline)
    }
}
