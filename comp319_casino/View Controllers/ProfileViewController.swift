import Foundation
import UIKit
import Firebase

class ProfileViewController: UIViewController{
    
    @IBOutlet weak var emailName: UILabel!
    @IBOutlet weak var walletLabel: UILabel!
    
    let player = Player.shared
    
    override func viewDidLoad() {
        emailName.text=Auth.auth().currentUser?.email
        self.player.delegate = self
        self.player.updateWallet()
        initializeBackground()
    }
    
    @IBAction func addFunds(_ sender: Any) {
        self.player.increaseFunds(50)
        self.player.updateWallet()
    }
    
    @IBAction func removeFunds(_ sender: Any) {
        self.player.decreaseFunds(50)
        self.player.updateWallet()
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

extension ProfileViewController: PlayerDelegate{
    func update(_ value: Int) {
        self.walletLabel.text = "Wallet: \(value)"
    }
    
    
}
