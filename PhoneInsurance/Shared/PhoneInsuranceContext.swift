//
//  PhoneInsuranceContext.swift
//  Smartphone
//
//  Created by Jefferson Fernandes on 30/10/24.
//  E-mail jeffersonf@ciandt.com
//


import Foundation

// MARK: - PhoneInsuranceContext

final class PhoneInsuranceContext {
    
    // MARK: - Singleton Instance
    
    static let shared = PhoneInsuranceContext()
    
    // MARK: - Init
    
    private init() { /* Intentionally unimplemented */ }
    
    // MARK: - Properties
    
    var coupon: String?
    var deviceInfo: SmartphoneDeviceInformationProtocol?
    var personData: PersonDataResponse?
    var deviceData: DeviceDataResponse?
    var cardList: [CardResponse]?
    var progressData: LoadingProgressResponse?
    var internalData: InternalResponse?
    
    // MARK: - Methods
    
    func set<T>(_ keyPath: WritableKeyPath<PhoneInsuranceContext, T>, to value: T) {
        var mutableSelf = self
        mutableSelf[keyPath: keyPath] = value
    }
    
    func get<T>(_ keyPath: KeyPath<PhoneInsuranceContext, T>) -> T {
        return self[keyPath: keyPath]
    }
    
    func resetProperties() {
        coupon = nil
        deviceInfo = nil
        personData = nil
        deviceData = nil
        cardList = nil
        progressData = nil
        internalData = nil
    }
}
