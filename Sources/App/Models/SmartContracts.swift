//
//  SmartContracts.swift
//  App
//
//  Created by Belkhadir Anas on 3/23/18.
//

import Foundation

class DrivingRecordSmartContract : Codable {
    
    func apply(transaction :Transaction, allBlocks :[Block]) {
        
        allBlocks.forEach { block in
            
            block.transactions.forEach { trans in
                
                if trans.numero == transaction.numero {
                    transaction.nombreDeViolation += 1
                }
                
                if transaction.nombreDeViolation > 5 {
                    transaction.permisDeConduireSuspendu = true
                }
                
            }
            
        }
        
    }
    
}
