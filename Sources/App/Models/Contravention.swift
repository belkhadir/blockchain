//
//  Contravention.swift
//  App
//
//  Created by Belkhadir Anas on 5/27/18.
//

import Foundation

struct Contravention: Decodable, Encodable {
    var type: String
    var lieu: String
    var date: String
    var vitessRetenu: String
    var vitessReleve: String
}
