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
        GeometryReader { proxy in
            HStack(alignment: .center, spacing: 20) {
                Spacer()
                VStack {
                    ThrottleSliderView(sliderHeight: $viewModel.sliderHeight)
                        .frame(width: 100, height: proxy.size.height / 1.5)
                    Text("Throttle")
                        .fontWeight(.bold)
                }
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity
            )
            .padding(.all)
        }
        .navigationTitle(viewModel.peripheral.name ?? "Unknown")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                toggleConnectionButton
            }
        }
        .onReceive(viewModel.$sliderHeight.throttle(for: 0.25, scheduler: DispatchQueue.main, latest: true)) { value in
            if viewModel.isSendEnabled {
                viewModel.write(
                    string: "THR\(value.rounded())",
                    to: viewModel.peripheral,
                    for: viewModel.characteristic!
                )
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
}
