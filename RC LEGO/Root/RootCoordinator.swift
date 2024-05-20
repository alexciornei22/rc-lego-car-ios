//
//  RootCoordinator.swift
//  RC LEGO
//
//  Created by Alex on 19.05.2024.
//

import SwiftUI
import CoreBluetooth


enum Route: Hashable, Equatable {
    case peripheralInteraction(peripheral: CBPeripheral, central: CBCentralManager)
}

protocol AppCoordinator {
    func goToPeripheralInteraction(peripheral: CBPeripheral, central: CBCentralManager)
}

struct RootCoordinatorView: View {
    @StateObject private var coordinator = Coordinator()
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            RootView(viewModel: .init(coordinator: coordinator))
            .navigationDestination(for: Route.self) { route in
                switch route {
                case let .peripheralInteraction(peripheral, central):
                    PeripheralView(viewModel: .init(
                        coordinator: coordinator,
                        peripheral: peripheral,
                        centralManager: central)
                    )
                }
            }
        }
    }
    
    private class Coordinator: AppCoordinator, ObservableObject {
        @Published var path = NavigationPath()
        
        func goToPeripheralInteraction(peripheral: CBPeripheral, central: CBCentralManager) {
            path.append(
                Route.peripheralInteraction(peripheral: peripheral, central: central)
            )
        }
    }
}

#Preview {
    RootCoordinatorView()
}
