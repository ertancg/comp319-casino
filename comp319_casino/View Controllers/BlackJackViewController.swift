import Foundation
import UIKit

class BlackJackViewController: UIViewController{
    
    var blackJackDataSource = BlackJackDataSource.shared
    var screenWidth = Int(UIScreen.main.bounds.width/2 - 80)
    var dealerOffset = 0
    var playerOffset = 0
    
    
    
    @IBOutlet weak var dealerView: UIView!
    @IBOutlet weak var playerView: UIView!
    
    
    @IBOutlet weak var winLabel: UILabel!
    @IBOutlet weak var betLabel: UILabel!
    @IBOutlet weak var dealerHandValue: UILabel!
    @IBOutlet weak var playerHandValue: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var betInputField: UITextField!
    
    
    @IBOutlet weak var betButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    @IBOutlet weak var hitButton: UIButton!
    @IBOutlet weak var standButton: UIButton!
    
    override func viewDidLoad() {
        self.blackJackDataSource.delegate = self
        initalizeBackGround()
        self.blackJackDataSource.reloadGame()
        self.hideKeyboard()
    }
    
    @IBAction func startGame(_ sender: Any) {
        self.blackJackDataSource.initializeCards(deckCount: 6)
        let check = self.blackJackDataSource.startGame()
        if(check){
            self.blackJackDataSource.calculateInitialDealerHand()
            self.blackJackDataSource.calculateInitialPlayerHand()
            self.startButton.alpha = 0
            self.hitButton.alpha = 1
            self.standButton.alpha = 1
        }
    }
    
    @IBAction func hit(_ sender: Any) {
        self.blackJackDataSource.drawCard(to: true)
        self.blackJackDataSource.calculatePlayerHand()
        if(self.blackJackDataSource.getPlayerStatus() == .player_bust){
            self.blackJackDataSource.calculateWinner()
            self.blackJackDataSource.bust()
        }
    }
    
    @IBAction func stand(_ sender: Any) {
        self.blackJackDataSource.flipDealerHand()
        self.blackJackDataSource.calculateDealerHand()
        self.blackJackDataSource.dealerPlay()
        self.blackJackDataSource.calculateWinner()
        self.standButton.alpha = 0
        self.hitButton.alpha = 0
    }
    
    
    
    @IBAction func bet(_ sender: Any) {
        if let text: String = self.betInputField.text{
            if let betSize = Int(text){
                self.blackJackDataSource.setBetSize(betSize)
            }
        }else{
            self.blackJackDataSource.setBetSize(0)
        }
        
        
        
    }
    
    @IBAction func clearBet(_ sender: Any) {
        self.blackJackDataSource.setBetSize(0)
    }
    
    func initalizeBackGround(){
        let backgroundImage = UIImageView(frame: .zero)
        backgroundImage.image = UIImage(named: "background.png")
        backgroundImage.contentMode = .scaleToFill
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        self.view.insertSubview(backgroundImage, at: 0)
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
    }
    
}

extension BlackJackViewController: BlackJackDataSourceDelegate{
    func reloadPlayerHand(_ playerHand: [Card]) {
        self.playerOffset = self.screenWidth
        for var card in playerHand{
            if(card.isFaceDown){
                card.flipCard()
            }
            let cardImage = UIImage(named: card.imageName)
            let imageView = UIImageView(image: cardImage)
            imageView.frame = CGRect(x: self.playerOffset, y: 40, width: 60, height: 110)
            self.playerView.addSubview(imageView)
            self.playerOffset += 20
        }
    }
    
    func reloadDealerHand(_ dealerHand: [Card]) {
        self.dealerOffset = self.screenWidth
        for var card in dealerHand{
            let cardImage = UIImage(named: card.imageName)
            let imageView = UIImageView(image: cardImage)
            imageView.frame = CGRect(x: self.dealerOffset, y: 0, width: 60, height: 110)
            self.dealerView.addSubview(imageView)
            self.dealerOffset += 20
        }
    }
    
    func reloadBet(size: Int) {
        self.betLabel.text = "Bet: \(size)"
        self.betButton.alpha = 1
        self.clearButton.alpha = 1
    }
    
    
    
    func clearBoard() {
        self.playerView.clearAll(self.playerHandValue)
        self.playerOffset = screenWidth
        self.dealerView.clearAll(self.dealerHandValue)
        self.dealerOffset = screenWidth
    }
    func clearDealerBoard() {
        self.dealerView.clearAll(self.dealerHandValue)
        self.dealerOffset = screenWidth
    }
    func dealerDealt(_ card: Card) {
        let cardImage = UIImage(named: card.imageName)
        let imageView = UIImageView(image: cardImage)
        imageView.frame = CGRect(x: self.dealerOffset, y: 0, width: 90, height: 110)
        self.dealerView.addSubview(imageView)
        self.dealerOffset += 20
    }
    
    func playerDealt(_ card: Card) {
        let cardImage = UIImage(named: card.imageName)
        let imageView = UIImageView(image: cardImage)
        imageView.frame = CGRect(x: self.playerOffset, y: 40, width: 90, height: 110)
        self.playerView.addSubview(imageView)
        self.playerOffset += 20
        
    }
    
    func updateDealerRank(_ info: String) {
        self.dealerHandValue.text = info
    }
    
    func updatePlayerRank(_ info: String) {
        self.playerHandValue.text = info
    }
    
    func playAgain() {
        self.startButton.setTitle("Again?", for: .normal)
        self.startButton.alpha = 1
    }
    
    func playerBust() {
        self.blackJackDataSource.calculateWinner()
        self.hitButton.alpha = 0
        self.standButton.alpha = 0
    }
    
    func updateWin(_ size: Double){
        self.winLabel.text = "Win: \(Int(size))"
    }
    
    func giveAlert(alert: String, msg: String) {
        let alert = UIAlertController(title: alert, message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func hideBet() {
        self.betButton.alpha = 0
        self.clearButton.alpha = 0
    }
    
    func showBet(){
        self.betButton.alpha = 1
        self.clearButton.alpha = 1
    }
    
    //status = 1 for running, = 0 for finished
    func reloadButtons(_ status: Int) {
        if(status == 1){
            self.hitButton.alpha = 1
            self.standButton.alpha = 1
            self.startButton.alpha = 0
        }else{
            self.hitButton.alpha = 0
            self.standButton.alpha = 0
            self.startButton.alpha = 1
        }
    }
}

extension UIView{
    func clearAll(_ label: UILabel){
        for view in subviews{
            if(view != label){
                view.removeFromSuperview()
            }
        }
    }
    
}

