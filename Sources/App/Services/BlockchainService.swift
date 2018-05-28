//
//  BlockchainService.swift
//  App
//
//  Created by Belkhadir Anas on 1/11/18.
//

import Foundation

class BlockchainService {
    
    private (set) var blockchain :Blockchain!
    
    init() {
        self.blockchain = Blockchain(genesisBlock: Block())
    }
    
    func resolve(completion :@escaping (Blockchain) -> ()) {
        
        let nodes = blockchain.nodes
        
        for node in nodes {
            
            let url = URL(string :"http://\(node.address)/blockchain")!
            
            URLSession.shared.dataTask(with: url) { data, _, _ in
                
                if let data = data {
                    
                    let blockchain = try! JSONDecoder().decode(Blockchain.self, from: data)
                    
                    if self.blockchain.blocks.count > blockchain.blocks.count {
                        completion(self.blockchain)
                    } else {
                        self.blockchain.blocks = blockchain.blocks
                        completion(blockchain)
                    }
                    
                }
                
                
            }.resume()
            
            
        }
        
    }
    
    func enregistrer(_ node :BlockchainNoeud) {
        blockchain.ajouter(node: node)
    }
    
    func getMinedBlock(transactions :[Transaction]) -> Block {
        
        let block = blockchain.blockSuivant(transactions: transactions)
        blockchain.ajouter(block: block)
        
        return block
    }
    
    func getBlockchain() -> Blockchain {
        return self.blockchain
    }
    
}
