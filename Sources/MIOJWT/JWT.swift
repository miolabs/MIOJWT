//
//  JWT.swift
//  
//
//  Created by Javier Segura Perez on 6/2/24.
//

import Foundation
import Crypto


final class JWT
{
    static let separation:UInt8 = Character(".").asciiValue!
    
    static func sign( kid: String, claims: JWTClaims, signer: JWTSigner ) throws -> String {
        let header = signer.newHeader( kid: kid )
        return try sign(header: header, claims: claims, signer: signer)
    }
    
    static func sign( header: JWTHeader, claims: JWTClaims, signer: JWTSigner ) throws -> String
    {
        let header_data = try JSONEncoder().encode( header )
        let header_base64 = header_data.base64URLDecodedBytes()
        
        let payload_data = try JSONEncoder().encode( claims )
        let payload_base64 = payload_data.base64URLDecodedBytes()
                        
        let input = header_base64 + [JWT.separation] + payload_base64
        
        let signature = try signer.sign(payload: Data(input))
        let bytes = input + [JWT.separation] + signature.base64URLDecodedBytes()
        return String(decoding: bytes, as: UTF8.self)
        
    }
    
    static func verify<T:JWTClaims>( token: String, verifier: JWTSigner ) throws -> T
    {
        let bytes = [UInt8](token.utf8)
        let parts = bytes.split(separator: separation)
        
        guard parts.count == 3 else { throw JWTError.invalidToken }
        
        let header_base64 = parts[0]
        let payload_base64 = parts[1]
        let signature_base64 = parts[2]

        let header = header_base64.base64URLDecodedBytes()
        let payload = payload_base64.base64URLDecodedBytes()
        
        let h = try JSONDecoder().decode( JWTHeader.self, from: Data(header) )
        if h.alg != verifier.alg || h.typ != verifier.typ { throw JWTError.invalidSignerForToken }
        
        let data = header_base64 + [separation] + payload_base64
        let signature = signature_base64.base64URLDecodedBytes()
        
        guard try verifier.verify(signature: signature, signs: data) else {
            throw JWTError.tokenVerificationFailed
        }

        let p = try JSONDecoder().decode( T.self, from: Data(payload) )
        return p
    }
}
