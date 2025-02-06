//
//  JWTHeader.swift
//  MIOJWT
//
//  Created by Javier Segura Perez on 6/2/25.
//

public struct JWTHeader: Codable
{
    let alg:String
    let typ:String
    let kid:String
    
    init(kid: String, alg:String, typ:String) {
        self.kid = kid
        self.alg = alg
        self.typ = typ
    }
}
