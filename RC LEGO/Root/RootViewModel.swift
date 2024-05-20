//
//  HomeViewModel.swift
//  RC LEGO
//
//  Created by Alex on 18.05.2024.
//

import Foundation
import CoreBluetooth

class RootViewModel: ObservableObject {
    var coordinator: AppCoordinator
    
    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
    }
    
    func goToPeripheralInteraction(peripheral: CBPeripheral) {
        coordinator.goToPeripheralInteraction(peripheral: peripheral)
    }
}
