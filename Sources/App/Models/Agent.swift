//
//  Agent.swift
//  App
//
//  Created by Belkahdir Anas on 5/27/18.
//

import Foundation

struct Agent: Decodable, Encodable {
    var nom: String
    var prenom: String
    var dateVerbalisation: Date
    var montantAmende: Double
}
