//
//  HomeViewModel.swift
//  RC LEGO
//
//  Created by Alex on 18.05.2024.
//

import Foundation
import CoreBluetooth

class RootViewModel: NSObject, ObservableObject {
    var coordinator: AppCoordinator
    @Published var discoveredPeripherals: [CBPeripheral] = []
    
    var centralManager = CBCentralManager()
    
    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
        
        super.init()
        
        centralManager.delegate = self
    }
    
    func goToPeripheralInteraction(peripheral: CBPeripheral) {
        coordinator.goToPeripheralInteraction(peripheral: peripheral, central: centralManager)
    }
}

extension RootViewModel: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            centralManager.scanForPeripherals(withServices: [BluetoothConstants.targetServiceCBUUID], options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !discoveredPeripherals.contains(peripheral) {
            discoveredPeripherals.append(peripheral)
        }
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices([BluetoothConstants.targetServiceCBUUID])
    }
}
