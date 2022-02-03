import Foundation

protocol BlackJackDataSourceDelegate{
    func dealerDealt(_ card: Card)
    func playerDealt(_ card: Card)
    
    func updateDealerRank(_ info: String)
    func updatePlayerRank(_ info: String)
    func updateWin(_ size: Double)
    
    func clearBoard()
    func clearDealerBoard()

    func reloadPlayerHand(_ playerHand: [Card])
    func reloadDealerHand(_ dealerHand: [Card])
    func reloadBet(size: Int)
    func reloadButtons(_ status: Int)
    
    func playAgain()
    func playerBust()
    
    func giveAlert(alert: String, msg: String)
    func hideBet()
    func showBet()
}
