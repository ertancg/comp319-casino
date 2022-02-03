import Foundation

class Player{
    
    static var shared = Player()
    
    private var wallet = 0
    
    var delegate: PlayerDelegate?
    
    func increaseFunds(_ value: Int){
        self.wallet += value
        updateWallet()
    }
    
    func decreaseFunds(_ value: Int){
        self.wallet -= value
        updateWallet()
    }
    
    func getWallet() -> Int{
        return self.wallet
    }
    
    func updateWallet(){
        self.delegate?.update(self.wallet)
    }
}
