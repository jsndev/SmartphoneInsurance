//
//  EventBus.swift
//  Smartphone
//
//  Created by Jeff on 08/11/24.
//

import Combine

class EventBus {
    static let shared = EventBus()
    
    let otherDeviceButtonTapAction = PassthroughSubject<Void, Never>()
    let editInstallments = PassthroughSubject<Void, Never>()
    
    private init() {} 
}
