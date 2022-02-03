import UIKit
import Firebase

class RegisterViewController: UIViewController {

    
    @IBOutlet weak var EmailLabel: UITextField!
    
    @IBOutlet weak var PasswordLabel: UITextField!
    
    
    @IBOutlet weak var SignUpButton: UIButton!
    @IBOutlet weak var LogInButton: UIButton!
    
    @IBAction func SignUpButtonAction(_ sender: Any) {
        createUser()
    }
    
    @IBAction func LogInButtonAction(_ sender: Any) {
        login()
      
        
    }
    
    override func viewDidLoad() {
       super.viewDidLoad()
        self.hideKeyboard()
        // Do any additional setup after loading the view.
    }


    func createUser(){
        
        Auth.auth().createUser(withEmail: EmailLabel.text!, password: PasswordLabel.text!){result , error in
            print(error?.localizedDescription ?? "")
        }
    }
    
    func login(){
        Auth.auth().signIn(withEmail: EmailLabel.text!, password: PasswordLabel.text!) { result, error in
            //print(result)
            //print(Auth.auth().currentUser?.email)
            //print(error?.localizedDescription ?? "")
            //print(Auth.auth())
            //self.performSegue(withIdentifier: "logInRight", sender: nil)
            //let HomePage = TabBarViewController() // Change this to your viewcontroller name
            //self.present(HomePage, animated: true,     completion: nil)
            if error != nil {
                self.viewDidLoad()
                print(error!)
                let alert = UIAlertController(title: "Wrong Password or Email !", message: "Register again", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Enter...", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
              
                
                
            } else {
                //success
                print("LogedIn Sucessful")
                self.performSegue(withIdentifier: "logInRight", sender: self)
                self.navigationItem.hidesBackButton = true
            }
           
        
             }
        }
      
        
    }
   

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      //  DispatchQueue.main.a
        
   // }


extension UIViewController{
    func hideKeyboard(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dissmissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dissmissKeyboard(){
        view.endEditing(true)
    }
}
