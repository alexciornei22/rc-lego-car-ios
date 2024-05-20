//
//  BluetoothManager.swift
//  RC LEGO
//
//  Created by Alex on 19.05.2024.
//

import Foundation
import CoreBluetooth


class BluetoothConstants {
    public static let targetServiceCBUUID = CBUUID(string: "FFE0")
    public static let targetCharacteristicCBUUID = CBUUID(string: "FFE1")
}

class BluetoothManager: NSObject, CBCentralManagerDelegate, ObservableObject {
    @Published var discoveredPeripherals: [CBPeripheral] = []
    
    private var centralManager = CBCentralManager()
        
    override init() {
        super.init()
        centralManager.delegate = self
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            centralManager.scanForPeripherals(withServices: [BluetoothConstants.targetServiceCBUUID], options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !discoveredPeripherals.contains(peripheral) {
            discoveredPeripherals.append(peripheral)
            peripheral.delegate = self
        }
    }
    
    func toggleConnectionTo(_ peripheral: CBPeripheral) {
        if peripheral.state == .connected {
            centralManager.cancelPeripheralConnection(peripheral)
            return
        }
        
        if peripheral.state == .disconnected {
            centralManager.connect(peripheral)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices([BluetoothConstants.targetServiceCBUUID])
    }
}

extension BluetoothManager: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: (any Error)?) {
        for service in peripheral.services ?? [] {
            peripheral.discoverCharacteristics([BluetoothConstants.targetCharacteristicCBUUID], for: service)
        }
    }
    
    func write(string: String, to peripheral: CBPeripheral, for characteristic: CBCharacteristic) {
        peripheral.writeValue("\(string)\r\n".data(using: .ascii)!, for: characteristic, type: .withoutResponse)
    }
}
