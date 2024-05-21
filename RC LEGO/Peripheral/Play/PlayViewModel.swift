//
//  PlayViewModel.swift
//  RC LEGO
//
//  Created by Alex on 21.05.2024.
//

import Foundation
import CoreBluetooth

extension Bool {
    var intValue: Int {
        return self ? 1 : 0
    }
}

class PlayViewModel: ObservableObject {
    @Published var throttlePercentage: CGFloat = 0
    @Published var areHeadLightsOn: Bool = false
    @Published var areHazardLightsOn: Bool = false
    @Published var isParkingSensorOn: Bool = false
    @Published var isLightSensorOn: Bool = false

    var peripheral: CBPeripheral
    var characteristic: CBCharacteristic
    
    init(peripheral: CBPeripheral, characteristic: CBCharacteristic) {
        self.peripheral = peripheral
        self.characteristic = characteristic
    }
    
    func throttleInputChange() {
        let throttle = Int(throttlePercentage / 100 * 255)
        peripheral.writeValue("THR\(throttle)\r\n".data(using: .ascii)!, for: characteristic, type: .withoutResponse)
        print(throttle)
    }
    
    func headLightsInputChange() {
        peripheral.writeValue("HDL\(areHeadLightsOn.intValue)\r\n".data(using: .ascii)!, for: characteristic, type: .withoutResponse)
    }
    
    func hazardLightsInputChange() {
        peripheral.writeValue("HZL\(areHazardLightsOn.intValue)\r\n".data(using: .ascii)!, for: characteristic, type: .withoutResponse)
    }
    
    func parkingSensorInputChange() {
        peripheral.writeValue("PRK\(isParkingSensorOn.intValue)\r\n".data(using: .ascii)!, for: characteristic, type: .withoutResponse)
    }
        
    func lightSensorInputChange() {
        peripheral.writeValue("LIT\(isLightSensorOn.intValue)\r\n".data(using: .ascii)!, for: characteristic, type: .withoutResponse)
    }
}
