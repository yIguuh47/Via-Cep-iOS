//
//  CepModel.swift
//  CepAqui
//
//  Created by Virtual Machine on 11/05/22.
//

import Foundation

struct CepModel: Decodable {
    
    let cep: String
    let logradouro: String
    let complemento: String
    let bairro: String
    let localidade: String
    
}
