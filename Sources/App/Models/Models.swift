
//: Playground - noun: a place where people can play

import Cocoa
import Vapor

class BlockchainNoeud : Codable {
    
    var address :String
    
    init?(request :Request) {
        
        guard let address = request.data["address"]?.string else {
            return nil
        }
        
        self.address = address
        
    }
    
    init(address :String) {
        self.address = address
    }
    
}

class Transaction : Codable {
    
    
    enum ViolationType: String {
        case parking = "Parking"
        case vitesse = "Vitesse"
        case sensInterdit = "sensInterdit"
        case none = "none"
    }
    
    // MARK: Agent Data
    var agentNom: String
    var agentPrenom: String
    var agentDateVerbalisation: Date
    var agentMontantAmende: Double
    
    // MARK: Contravention
    var type: String
    var lieu: String
    var date: Date
    var vitessRetenu: String
    var vitessReleve: String
    
    // MARK: Conducteur
    var conducteurNom: String
    var conducteurPrenom: String
    var conducteurAdress: String
    
    // MARK: Vehicule
    var marque: String
    var genre: String
    var numero: String
    
    var nombreDeViolation :Int = 1
    var permisDeConduireSuspendu :Bool = false
    
    
    init?(request :Request) {
        
        guard
            let type = request.data[Constant.Contravention.type]?.string,
            let lieu = request.data[Constant.Contravention.lieu]?.string,
            let date = request.data[Constant.Contravention.date]?.date,
            let vitessRetenu = request.data[Constant.Contravention.vitessRetenu]?.string,
            let vitessReleve = request.data[Constant.Contravention.vitessReleve]?.string,
            let conducteurNom = request.data[Constant.Conducteur.nom]?.string,
            let conducteurPrenom = request.data[Constant.Conducteur.prenom]?.string,
            let conducteurAdress = request.data[Constant.Conducteur.adress]?.string,
            let agentName = request.data[Constant.Agent.nom]?.string,
            let agentPrenom = request.data[Constant.Agent.prenom]?.string,
            let agentDateVerbalisation = request.data[Constant.Agent.dateVerbalisation]?.date,
            let agentMontantAmende = request.data[Constant.Agent.montantAmende]?.double,
            let marque = request.data[Constant.Vehicule.marque]?.string,
            let numero = request.data[Constant.Vehicule.numero]?.string,
            let genre = request.data[Constant.Vehicule.genre]?.string
            else {
                return nil
        }
        
        self.type = type
        self.lieu = lieu
        self.date = date
        self.vitessRetenu = vitessRetenu
        self.conducteurNom = conducteurNom
        self.conducteurPrenom = conducteurPrenom
        self.conducteurAdress = conducteurAdress
        self.vitessReleve = vitessReleve
        self.agentMontantAmende = agentMontantAmende
        self.agentNom = agentName
        self.agentPrenom = agentPrenom
        self.agentDateVerbalisation = agentDateVerbalisation
        self.marque = marque
        self.numero = numero
        self.genre = genre
    }
    
}

class Block : Codable  {
    
    var index :Int = 0
    var previousHash :String = ""
    var hash :String!
    var nonce :Int
    
    private (set) var transactions: [Transaction] = [Transaction]()
    
    var key :String {
        get {
            
            let transactionsData = try! JSONEncoder().encode(self.transactions)
            let transactionsJSONString = String(data: transactionsData, encoding: .utf8)
            
            return String(self.index) + self.previousHash + String(self.nonce) + transactionsJSONString!
        }
    }
    
    func ajouter(transaction :Transaction) {
        self.transactions.append(transaction)
    }
    
    init() {
        self.nonce = 0
    }
    
}

class Blockchain : Codable  {
    
    var blocks :[Block] = [Block]()
    var success: Bool = true
    private var drivingRecordSmartContract :DrivingRecordSmartContract = DrivingRecordSmartContract()
    
    private (set) var nodes :[BlockchainNoeud] = [BlockchainNoeud]()
    
    init(genesisBlock :Block) {
        ajouter(block: genesisBlock)
    }
    
    func ajouter(node :BlockchainNoeud) {
        self.nodes.append(node)
    }
    
    func ajouter(block :Block) {
        
        if self.blocks.isEmpty {
            block.previousHash = "0000000000000000"
            block.hash = creer(for :block)
        }
        
        self.blocks.append(block)
    }
    
    func transactions(by id :String) -> [Transaction] {
        
        var transactions = [Transaction]()
        
        self.blocks.forEach { block in
            
            block.transactions.forEach { transaction in
                
                if transaction.numero == id.sha1Hash() {
                    transactions.append(transaction)
                }
            }
        }
        
        return transactions
        
    }
    
    func blockSuivant(transactions :[Transaction]) -> Block {
        
        let block = Block()
        transactions.forEach { transaction in
            
            // applying smart contract
            self.drivingRecordSmartContract.apply(transaction: transaction, allBlocks: self.blocks)
            
            block.ajouter(transaction: transaction)
        }
        
        let previousBlock = getPrecedentBlock()
        block.index = self.blocks.count
        block.previousHash = previousBlock.hash
        block.hash = creer(for: block)
        return block
        
    }
    
    private func getPrecedentBlock() -> Block {
        return self.blocks[self.blocks.count - 1]
    }
    
    func creer(for block :Block) -> String {
        
        var hash = block.key.sha1Hash()
        
        while(!hash.hasPrefix("00")) {
            block.nonce += 1
            hash = block.key.sha1Hash()
            print(hash)
        }
        
        return hash
    }
    
}

// String Extension
extension String {
    
    func sha1Hash() -> String {
        
        let task = Process()
        task.launchPath = "/usr/bin/shasum"
        task.arguments = []
        
        let inputPipe = Pipe()
        
        inputPipe.fileHandleForWriting.write(self.data(using: String.Encoding.utf8)!)
        
        inputPipe.fileHandleForWriting.closeFile()
        
        let outputPipe = Pipe()
        task.standardOutput = outputPipe
        task.standardInput = inputPipe
        task.launch()
        
        let data = outputPipe.fileHandleForReading.readDataToEndOfFile()
        let hash = String(data: data, encoding: String.Encoding.utf8)!
        return hash.replacingOccurrences(of: "  -\n", with: "")
    }
}















