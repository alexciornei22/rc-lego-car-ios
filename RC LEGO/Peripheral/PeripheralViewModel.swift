//
//  PeripheralDelegate.swift
//  RC LEGO
//
//  Created by Alex on 18.05.2024.
//

import Foundation
import Combine
import CoreBluetooth

class PeripheralViewModel: ObservableObject {
    var coordinator: AppCoordinator
    var peripheral: CBPeripheral
    
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
    
    init(coordinator: AppCoordinator, peripheral: CBPeripheral) {
        self.coordinator = coordinator
        self.peripheral = peripheral
        
        setUpStateSubscriber()
        setUpServicesSubscriber()
    }
    
    private func setUpStateSubscriber() {
        peripheral.publisher(for: \.state)
            .sink { [weak self] newState in
                guard let self = self else { return }
                self.state = newState
            }
            .store(in: &cancellables)
    }
    
    private func setUpServicesSubscriber() {
        peripheral.publisher(for: \.services)
            .sink { [weak self] newServices in
                guard let self = self else { return }
                guard let newService = newServices?.first(where: {$0.isPrimary}) else { return }
                self.service = newService
                setUpCharacteristicsSubscriber(service!)
            }
            .store(in: &cancellables)
    }
    
    private func setUpCharacteristicsSubscriber(_ service: CBService) {
        service.publisher(for: \.characteristics)
            .sink { [weak self] newCharacteristics in
                guard let self = self else { return }
                self.characteristic = newCharacteristics?.first(where: {$0.uuid == BluetoothConstants.targetCharacteristicCBUUID})
            }
            .store(in: &cancellables)
    }
}
