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
