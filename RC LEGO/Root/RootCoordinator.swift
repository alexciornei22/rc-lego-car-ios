//
//  RootCoordinator.swift
//  RC LEGO
//
//  Created by Alex on 19.05.2024.
//

import SwiftUI
import CoreBluetooth


enum Route: Hashable, Equatable {
    case peripheralInteraction(peripheral: CBPeripheral)
}

protocol AppCoordinator {
    func goToPeripheralInteraction(peripheral: CBPeripheral)
}

struct RootCoordinatorView: View {
    @StateObject private var coordinator = Coordinator()
    @StateObject private var bluetoothManager = BluetoothManager()
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            RootView(viewModel: .init(coordinator: coordinator),
                     bluetoothManager: bluetoothManager
            )
            .navigationDestination(for: Route.self) { route in
                switch route {
                case let .peripheralInteraction(peripheral):
                    PeripheralView(viewModel: .init(coordinator: coordinator,
                        peripheral: peripheral),
                        bluetoothManager: bluetoothManager)
                }
            }
        }
    }
    
    private class Coordinator: AppCoordinator, ObservableObject {
        @Published var path = NavigationPath()
        
        func goToPeripheralInteraction(peripheral: CBPeripheral) {
            path.append(
                Route.peripheralInteraction(peripheral: peripheral)
            )
        }
    }
}

#Preview {
    RootCoordinatorView()
}
