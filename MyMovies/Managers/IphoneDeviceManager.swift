//
//  IphoneDeviceManager.swift
//  MyMovies


import Foundation
import UIKit

enum IphoneDevicetype: String {
    case iphoneX
    case otherIphone
}

final class IphoneDeviceManager: NSObject {
    
    // Singleton
    static let currentDevice = IphoneDeviceManager()
    
    // Initialization
    override init() {
        super.init()
        
    }
    
    func getDeviceType() -> IphoneDevicetype {
        let bounds = UIScreen.main.bounds
        let width = bounds.size.width
        let height = bounds.size.height
        
        if height == 812 && width == 375 {
            return .iphoneX
        } else {
            return .otherIphone
        }
    }
}
