//
//  JWT+Error.swift
//  DualLinkTokenKit
//
//  Created by Javier Segura Perez on 13/8/24.
//

enum JWTError : Error
{
    case invalidToken    
    case tokenVerificationFailed
    case invalidSignerForToken
    
}
