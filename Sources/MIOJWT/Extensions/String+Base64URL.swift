//
//  String+Base64URL.swift
//  MIOJWT
//
//  Created by Javier Segura Perez on 6/2/25.
//
// Copy from original file: https://github.com/vapor/jwt-kit/blob/main/Sources/JWTKit/Utilities/Base64URL.swift

#if !canImport(Darwin)
    import FoundationEssentials
#else
    import Foundation
#endif

extension String {
    package func base64URLDecodedData() -> Data? {
        var base64URL = replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")

        base64URL.append(contentsOf: "===".prefix((4 - (base64URL.count & 3)) & 3))

        return Data(base64Encoded: base64URL)
    }
}
