//
//  PeripheralDelegate.swift
//  RC LEGO
//
//  Created by Alex on 18.05.2024.
//

import Foundation
import Combine
import CoreBluetooth

class PeripheralViewModel: NSObject, ObservableObject {
    var coordinator: AppCoordinator
    var peripheral: CBPeripheral
    var centralManager: CBCentralManager

    @Published var state: CBPeripheralState = .disconnected
    @Published var service: CBService? = nil
    @Published var characteristic: CBCharacteristic? = nil
    var isSendEnabled: Bool {
        state == .connected &&
        service != nil &&
        characteristic != nil
    }
    @Published var sliderHeight: CGFloat = 0

    private var cancellables = Set<AnyCancellable>()
    
    init(coordinator: AppCoordinator, peripheral: CBPeripheral, centralManager: CBCentralManager) {
        self.coordinator = coordinator
        self.peripheral = peripheral
        self.centralManager = centralManager
        
        super.init()
        
        self.peripheral.delegate = self
        
        setUpStateSubscriber()
    }
    
    private func setUpStateSubscriber() {
        peripheral.publisher(for: \.state)
            .sink { [weak self] newState in
                guard let self else { return }
                self.state = newState
            }
            .store(in: &cancellables)
    }
    
    func toggleConnection() {
        if peripheral.state == .connected {
            centralManager.cancelPeripheralConnection(peripheral)
            service = nil
            characteristic = nil
        } else {
            centralManager.connect(peripheral)
        }
    }
}

extension PeripheralViewModel: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: (any Error)?) {
        service = peripheral.services?.first(where: {$0.uuid == BluetoothConstants.targetServiceCBUUID})
        
        if let service {
            peripheral.discoverCharacteristics([BluetoothConstants.targetCharacteristicCBUUID], for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: (any Error)?) {
        characteristic = service.characteristics?.first(where: {$0.uuid == BluetoothConstants.targetCharacteristicCBUUID})
    }
    
    func write(string: String, to peripheral: CBPeripheral, for characteristic: CBCharacteristic) {
        peripheral.writeValue("\(string)\r\n".data(using: .ascii)!, for: characteristic, type: .withoutResponse)
    }
}
