import Foundation

class BlackJackDataSource{
    private var deck: [Card] = [], dealerHand: [Card] = [], playerHand: [Card] = []
    private var betSize: Int = 0, dealerValue: Int = 0, playerValue:Int = 0
    private var dealer_status: status, player_status: status
    private var gameStatus: gStatus = .finished
    
    var delegate: BlackJackDataSourceDelegate?
    
    static var shared: BlackJackDataSource = BlackJackDataSource()
    
    let player = Player.shared
    
    init(){
        self.dealer_status = .dealer_hold
        self.player_status = .player_hold
    }
    
    enum gStatus{
        case started
        case finished
    }
    
    enum status{
        case player_bust
        case dealer_bust
        case player_hold
        case dealer_hold
        case dealer_blackJack
        case player_blackjack
        case dealer_21
        case player_21
    }
    
    func initializeCards(deckCount: Int){
        let suits = ["spades", "clubs", "diamonds", "hearts"]
        
        for _ in 1...deckCount{
            for suit in suits{
                for index in 1...13{
                    if(index == 1){
                        self.deck.append(Card(suit: suit, rank: index, value: 11))
                    }
                    else if(index > 10){
                        self.deck.append(Card(suit: suit, rank: index, value: 10))
                    }else{
                        self.deck.append(Card(suit: suit, rank: index, value: index))
                    }
                }
            }
        }
        shuffleCards()
    }
    
    func shuffleCards(){
        return self.deck.shuffle()
    }
    
    func startGame() -> Bool{
        if(self.betSize == 0 || self.betSize < 0){
            self.delegate?.giveAlert(alert: "Bet!", msg: "Bet cannot be 0!")
            return false
        }else{
            self.gameStatus = .started
            self.delegate?.hideBet()
            self.delegate?.clearBoard()
            self.dealerHand.removeAll()
            self.playerHand.removeAll()
            for i in 1...4{
                if(i % 2 == 0){
                    if var card = self.deck.popLast() {
                        if( i == 2){
                            self.dealerHand.append(card)
                            self.delegate?.dealerDealt(card)
                        }else{
                            card.flipCard()
                            self.dealerHand.append(card)
                            self.delegate?.dealerDealt(card)
                        }
                    }
                }else{
                    if var card = self.deck.popLast(){
                        card.flipCard()
                        self.playerHand.append(card)
                        self.delegate?.playerDealt(card)
                    }
                }
            }
            return true
        }
    }
    
    //false for dealer, true for player
    func drawCard(to: Bool){
        if var card = self.deck.popLast(){
            if(to){
                self.playerHand.append(card)
                card.flipCard()
                self.delegate?.playerDealt(card)
            }else{
                self.dealerHand.append(card)
                card.flipCard()
                self.delegate?.dealerDealt(card)
            }
        }
    }
    
    func calculateInitialDealerHand(){
        self.dealerValue = 0
        var valueInfo = ""
        for card in self.dealerHand{
            if !card.isFaceDown{
                self.dealerValue += card.value
            }
        }
        valueInfo = "\(self.dealerValue)"
        self.delegate?.updateDealerRank(valueInfo)
    }
    
    func calculateDealerHand(){
        self.dealerValue = 0
        var valueInfo = ""
        var temp: [Card] = []
        for card in self.dealerHand{
            if(card.rank == 1){
                temp.append(card)
            }else{
                self.dealerValue += card.value
                valueInfo = "\(self.dealerValue)"
            }
        }
        if(temp.isEmpty){
            valueInfo = "\(self.dealerValue)"
        }else{
            for card in temp{
                if(self.dealerValue + card.value > 21){
                    self.dealerValue += 1
                    valueInfo = "\(self.dealerValue)"
                }else{
                    self.dealerValue += card.value
                    valueInfo += " or \(self.dealerValue)"
                }
            }
            valueInfo = "\(self.dealerValue)"
        }
        if(self.dealerValue == 21 && self.dealerHand.count == 2){
            self.dealer_status = .dealer_blackJack
        }else if(self.dealerValue > 21){
            self.dealer_status = .dealer_bust
        }else if(self.dealerValue == 21 && self.dealerHand.count > 2){
            self.dealer_status = .dealer_21
        }
        self.delegate?.updateDealerRank(valueInfo)
    }
    
    func calculatePlayerHand(){
        self.playerValue = 0
        var valueInfo = ""
        var temp: [Card] = []
        for card in self.playerHand{
            if(card.rank == 1){
                temp.append(card)
            }else{
                self.playerValue += card.value
                valueInfo = "\(self.playerValue)"
            }
        }
        if(temp.isEmpty){
            valueInfo = "\(self.playerValue)"
        }else{
            for card in temp{
                if(self.playerValue + card.value > 21){
                    self.playerValue += 1
                    valueInfo = "\(self.playerValue)"
                }else{
                    valueInfo = "\(self.playerValue + 1)"
                    self.playerValue += card.value
                    valueInfo += " or \(self.playerValue)"
                }
            }
        }
        
        if(self.playerValue > 21){
            self.player_status = .player_bust
            valueInfo = "Bust!"
        }
        self.delegate?.updatePlayerRank(valueInfo)
    }
    
    func calculateInitialPlayerHand(){
        self.playerValue = 0
        var valueInfo = ""
        for card in self.playerHand{
            if !card.isFaceDown{
                self.playerValue += card.value
            }
        }
        if(self.playerValue == 21){
            valueInfo = "BlackJack!"
            self.player_status = .player_blackjack
        }else{
            valueInfo = "\(self.playerValue)"
        }
        self.delegate?.updatePlayerRank(valueInfo)
    }
    
    func getPlayerStatus() -> status{
        return self.player_status
    }
    
    func playerBust(){
        self.delegate?.playerBust()
    }
    
    func dealerPlay(){
        if(self.dealer_status == .dealer_blackJack){
            
        }else{
            while(self.dealerValue <= 16){
                drawCard(to: false)
                calculateDealerHand()
            }
        }
        self.delegate?.playAgain()
    }
    
    func flipDealerHand(){
        self.delegate?.clearDealerBoard()
        self.dealerHand[0].flipCard()
        for card in self.dealerHand{
            self.delegate?.dealerDealt(card)
        }
    }
    
    func reloadGame(){
        if(self.gameStatus == .finished){
            self.delegate?.clearBoard()
            self.delegate?.reloadPlayerHand(self.playerHand)
            self.delegate?.reloadDealerHand(self.dealerHand)
            self.delegate?.reloadBet(size: self.betSize)
            calculatePlayerHand()
            calculateDealerHand()
            self.delegate?.reloadButtons(0)
        }else{
            self.delegate?.clearBoard()
            self.delegate?.reloadPlayerHand(self.playerHand)
            self.delegate?.reloadDealerHand(self.dealerHand)
            self.delegate?.reloadBet(size: self.betSize)
            calculatePlayerHand()
            calculateDealerHand()
            self.delegate?.reloadButtons(1)
        }
    }
    
    func setBetSize(_ size: Int){
        if(size == 0 || size < 0){
            self.delegate?.reloadBet(size: 0)
            self.delegate?.giveAlert(alert: "Bet", msg: "Bet size cannot be 0!")
        }else{
            self.betSize = size
            self.player.decreaseFunds(self.betSize)
            self.delegate?.reloadBet(size: size)
        }
    }
    
    func calculateWinner(){
        let bet = Double(self.betSize)
        var win = 1.0
        switch(self.dealer_status){
            case .dealer_bust:
                if(self.player_status == .player_blackjack){
                    win = bet * 2.5
                }else if(self.player_status != .player_bust){
                    win = bet * 2.0
                }
            case .dealer_21:
                if(self.player_status == .player_blackjack){
                    win = bet * 2.5
                }else if(self.player_status == .player_bust || self.player_status == .player_hold){
                    win = bet * 0.0
                }else{
                    win = bet * 2.0
                }
            case .dealer_blackJack:
                if(self.player_status == .player_blackjack){
                    win = bet * 2.5
                }else{
                    win = bet * 0.0
                }
            case .dealer_hold:
                if(self.player_status == .player_blackjack){
                    win = bet * 2.5
                }else if(self.player_status == .player_hold){
                    if(self.playerValue > self.dealerValue){
                        win = bet * 2.0
                    }else{
                        win = bet * 0.0
                    }
                }else if(self.player_status == .player_21){
                    win = bet * 2.0
                }else{
                    win = bet * 0.0
                }
            default:
                print("default")
        }
        self.gameStatus = .finished
        self.delegate?.playAgain()
        self.delegate?.reloadBet(size: 0)
        self.betSize = 0
        self.player.increaseFunds(Int(win))
        self.delegate?.updateWin(win)
        self.delegate?.showBet()
    }
    
    func bust(){
        self.delegate?.playerBust()
    }
}
