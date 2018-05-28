//
//  Key.swift
//  App
//
//  Created by Belkhadir Anas on 5/27/18.
//

import Foundation

struct Constant {
    
    struct Conducteur {
        static let nom = "conducteurNom"
        static let prenom = "conducteurPrenom"
        static let adress = "conducteurAdress"
    }
    
    struct Vehicule {
        static let marque = "marque"
        static let genre = "genre"
        static let numero = "numero"
    }
    
    struct Contravention {
        static let type = "type"
        static let lieu = "lieu"
        static let date = "date"
        static let vitessRetenu = "vitessRetenu"
        static let vitessReleve = "vitessReleve"
    }
    
    struct Agent {
        static let nom = "agentNom"
        static let prenom = "agentPrenom"
        static let dateVerbalisation = "dateVerbalisation"
        static let montantAmende = "montantAmende"
    }
    
}
