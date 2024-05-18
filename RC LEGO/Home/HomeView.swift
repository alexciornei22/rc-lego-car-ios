//
//  ContentView.swift
//  RC LEGO
//
//  Created by Alex on 18.05.2024.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack {
            VStack {
                Text("Select Bluetooth Device:")
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                List(viewModel.discoveredPeripherals, id: \.identifier) { peripheral in
                    NavigationLink(value: peripheral.name ?? "Unknown") {
                        Text(peripheral.name ?? "Unknown")
                    }
                }
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: String.self) { selection in
                Text("You selected \(selection)")
            }
        }
    }
}

#Preview {
    HomeView()
}
