//
//  UInt8+Perios.swift
//  MIOJWT
//
//  Created by Javier Segura Perez on 6/2/25.
//

#if !canImport(Darwin)
    import FoundationEssentials
#else
    import Foundation
#endif


extension UInt8 {
    static var period: UInt8 {
        return Character(".").asciiValue!
    }
}
