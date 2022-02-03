import Foundation
import UIKit

class RouletteViewController: UIViewController{
    
    @IBOutlet weak var rouletteWheel: UIImageView!
    

    @IBOutlet weak var betLabel: UILabel!
    @IBOutlet weak var winLabel: UILabel!
    @IBOutlet weak var winNumberLabel: UILabel!
    
    @IBOutlet weak var betValue: UITextField!
    @IBOutlet weak var betList: UIButton!
    
    
    var rouletteDataSource = RouletteDataSource.shared
    
    var currentBet: betSizes = betSizes.empty
    
    override func viewDidLoad() {
        self.hideKeyboard()
        self.betList.menu = getMenu()
        self.betList.setTitle("Choose", for: .normal)
        initializeBackground()
        self.rouletteDataSource.delegate = self
    }
    
    @IBAction func spin(_ sender: Any) {
        let rand = Int.random(in: 180...720)
        self.rouletteDataSource.spinWheel(rand)
        self.rouletteDataSource.getWinner()
        self.rouletteDataSource.calculateTotal()
        self.rouletteDataSource.removeBets()
    }
    
    @IBAction func bet(_ sender: Any) {
        if let text: String = self.betValue.text{
            if let betSize = Int(text){
                self.rouletteDataSource.placeBet(self.currentBet, value: betSize)
            }
        }else{
            self.rouletteDataSource.placeBet(betSizes.empty, value: 0)
        }
        
    }
    
    @IBAction func clear(_ sender: Any) {
        self.rouletteDataSource.removeBets()
    }
    
    @IBAction func betListButton(_ sender: Any) {
        self.betList.showsMenuAsPrimaryAction = true
    }
    
    func getMenu() -> UIMenu{
        let odd = UIAction(title: "Odd") { (action) in
            self.currentBet = .odd
            self.betList.setTitle("Odd", for: .normal)
        }
        let even = UIAction(title: "Even") { (action) in
            self.currentBet = .even
            self.betList.setTitle("Even", for: .normal)
        }
        let firstBlock = UIAction(title: "1-13") { (action) in
            self.currentBet = .firstBlock
            self.betList.setTitle("1-13", for: .normal)
        }
        let secondBlock = UIAction(title: "14-26") { (action) in
            self.currentBet = .secondBlock
            self.betList.setTitle("14-26", for: .normal)
        }
        let thirdBlock = UIAction(title: "27-35") { (action) in
            self.currentBet = .thirdBlock
            self.betList.setTitle("27-35", for: .normal)
        }
        let red = UIAction(title: "Red") { (action) in
            self.currentBet = .red
            self.betList.setTitle("Red", for: .normal)
        }
        let black = UIAction(title: "Black") { (action) in
            self.currentBet = .black
            self.betList.setTitle("Black", for: .normal)
        }
        let green = UIAction(title: "Green") { (action) in
            self.currentBet = .green
            self.betList.setTitle("Green", for: .normal)
        }
        
        return UIMenu(title: "Choose", children: [odd, even, firstBlock, secondBlock, thirdBlock, red,black,green])
    }
    func initializeBackground(){
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
extension RouletteViewController: RouletteDataSourceDelegate{
    func giveAlert(alert: String, msg: String) {
        let alert = UIAlertController(title: alert, message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func updateWinner(number: Int) {
        self.winNumberLabel.text = "Winner: \(number)"
    }
    
    func spinRouletteWheel(angle: Int) {
        self.rouletteWheel.rotateWheel(Float(angle))
    }
    
    func updateBet(value: Int){
        self.betLabel.text = "Bet: \(value)"
    }
    
    func updateWinnings(value: Int) {
        self.winLabel.text = "Win: \(value)"
    }
}

extension UIView{
    func rotateWheel(_ angle: Float){
        let rotation = CABasicAnimation(keyPath: #keyPath(CALayer.transform))
        
        rotation.duration = 2
        rotation.valueFunction = CAValueFunction(name: .rotateZ)
        rotation.fromValue = 0
        rotation.toValue = CGFloat(Float(angle) * (Float.pi/180.0))

        self.layer.add(rotation, forKey: "rotationAnimation")
        CATransaction.setDisableActions(true)
        self.layer.transform = CATransform3DMakeRotation(CGFloat(angle * (Float.pi/180.0)), 0, 0, 1)
    }
    

}


