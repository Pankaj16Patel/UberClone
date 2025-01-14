//
//  RideType.swift
//  Uber-Clone
//
//  Created by amarjeet patel on 14/01/25.
//

import Foundation

enum RideType: Int, CaseIterable , Identifiable {
    
    case uberX
    case black
    case uberXl
    
    var id: Int {return rawValue}
    
    var description: String {
        switch self{
        case .uberX: return "UberX"
        case .black: return "UberBlack"
        case .uberXl: return "UberXl"
        }
    }
    
    var imageName: String{
        switch self {
        case .uberX: return "uberX"
        case .black: return "uberBlack"
        case .uberXl: return "uberBlack"
        }
    }
    
    var baseFare: Double {
        switch self {
        case .uberX: return 5
        case .black: return 10
        case .uberXl: return 10
        }
    }
    
    func computePrice(for distanceInMeter: Double) -> Double{
        let distanceInMiles = distanceInMeter / 1600
        
        switch self {
        case .uberX: return distanceInMiles * 1.5 + baseFare
        case .black: return distanceInMiles * 2.0 + baseFare
        case .uberXl: return distanceInMiles * 1.75 + baseFare
        }
        
    }
    
}
