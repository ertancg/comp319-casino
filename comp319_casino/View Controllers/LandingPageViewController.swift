import Foundation
import UIKit

class LandingPageViewController: UIViewController{
    override func viewDidLoad() {
        self.tabBarController!.navigationItem.hidesBackButton = true
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
