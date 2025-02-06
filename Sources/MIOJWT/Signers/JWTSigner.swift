//
//  JWTAlgorithm.swift
//  DualLinkTokenKit
//
//  Created by Javier Segura Perez on 13/8/24.
//

import Foundation

public protocol JWTSigner
{
    func newHeader( kid:String? ) -> JWTHeader
    
    func sign( payload:Data ) throws -> [UInt8]
    func verify( signature: some DataProtocol, header: JWTHeader, data: some DataProtocol ) throws -> Bool
}
