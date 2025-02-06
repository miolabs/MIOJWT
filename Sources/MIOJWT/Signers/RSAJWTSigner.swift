//
//  RSAJWTSigner.swift
//  MIOJWT
//
//  Created by Javier Segura Perez on 6/2/25.
//
import Foundation
import Crypto
import _CryptoExtras

enum RSAJWTSignerError : Error
{
    case privateKeyRequired
    case publicKeyRequired
    case signFailure(_ error: Error)
    case keyInitializationFailure
    case keySizeTooSmall
}

final public class RSAJWTSigner : JWTSigner
{
    public enum DigestAlgorithm {
        case sha256
        case sha384
        case sha512
    }

    let privateKey:_RSA.Signing.PrivateKey
    let digestAlgorithm:DigestAlgorithm
    let padding: _RSA.Signing.Padding
    
    public var publicKey: _RSA.Signing.PublicKey {
        return privateKey.publicKey
    }
    
    public init(privateKey: _RSA.Signing.PrivateKey, digestAlgorithm:DigestAlgorithm, padding: _RSA.Signing.Padding = .insecurePKCS1v1_5) throws {
        guard privateKey.keySizeInBits >= 2048 else {
            throw RSAJWTSignerError.keySizeTooSmall
        }
        self.privateKey = privateKey
        self.digestAlgorithm = digestAlgorithm
        self.padding = padding
    }
    
    public convenience init( privateKey: String, digestAlgorithm:DigestAlgorithm ) throws {
        try self.init(privateKey: .init(pemRepresentation: privateKey), digestAlgorithm: digestAlgorithm)
    }
    
    public convenience init(privateKey data: some DataProtocol, digestAlgorithm:DigestAlgorithm) throws {
        let string = String(decoding: data, as: UTF8.self)
        try self.init(privateKey: string, digestAlgorithm: digestAlgorithm)
    }

    func digest(_ plaintext: some DataProtocol) throws -> any Digest {
        switch digestAlgorithm {
        case .sha256: SHA256.hash(data: plaintext)
        case .sha384: SHA384.hash(data: plaintext)
        case .sha512: SHA512.hash(data: plaintext)
        }
    }
    
    // MARK - Protocol methods    
    public func newHeader( kid: String? = nil ) -> JWTHeader {
        let alg: String = switch digestAlgorithm {
        case .sha256: "RS256"
        case .sha384: "RS384"
        case .sha512: "RS512"
        }
        return JWTHeader(kid: kid, alg: alg, typ: "JWT")
    }
    
    public func sign( payload:Data ) throws -> [UInt8] {
        let hash = try digest( payload )
        let signature = try privateKey.signature(for: hash, padding: padding)
        return [UInt8](signature.rawRepresentation)
    }
    
    public func verify( signature: some DataProtocol, header: JWTHeader, data: some DataProtocol ) throws -> Bool
    {
        if header.typ != "JWT" { return false }
        if header.alg != "RS256" && header.alg != "RS384" && header.alg != "RS512" { return false }
        
        let hash = try self.digest( data )
        let signature = _RSA.Signing.RSASignature(rawRepresentation: signature)

        return publicKey.isValidSignature(signature, for: hash, padding: padding)
    }
}
