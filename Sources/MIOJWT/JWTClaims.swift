//
//  Claims.swift
//  DualLinkTokenKit
//
//  Created by Javier Segura Perez on 13/8/24.
//
import Foundation

public protocol JWTClaims: Encodable, Decodable
{
    var iss: String { get }
    var exp: Date { get }
    var sub: String { get }
    var iat:Int64 { get }
}

extension JWTClaims {
    public var iat:Int64 { return 1516239022 }
}
