//
//  UserData.swift
//  Noonee
//
//  Created by 이재은 on 2021/05/23.
//

import Foundation

struct UserData {
    static let shared = UserData()

    static var departure: String? {
        get {
            return UserDefaults.standard.value(forKey: "userDeparture") as? String
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "userDeparture")
            UserDefaults.standard.synchronize()
        }
    }

    static var departureAddress: String? {
        get {
            return UserDefaults.standard.value(forKey: "userDepartureAddress") as? String
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "userDepartureAddress")
            UserDefaults.standard.synchronize()
        }
    }

    static var destination: String? {
        get {
            return UserDefaults.standard.value(forKey: "userDestination") as? String
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "userDestination")
            UserDefaults.standard.synchronize()
        }
    }

    static var destinationAddress: String? {
        get {
            return UserDefaults.standard.value(forKey: "userDestinationAddress") as? String
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "userDestinationAddress")
            UserDefaults.standard.synchronize()
        }
    }
}
