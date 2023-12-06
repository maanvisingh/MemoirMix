//
//  LoginViewController.swift
//  MemoirMix
//
//  Created by student1 on 22/11/23.
//

import UIKit
import Firebase
class LoginViewController: UIViewController {

    @IBOutlet weak var userTextField: UITextField!
    
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBAction func loginClicked(_ sender: UIButton) {
        guard let email=userTextField.text else { return}
        guard let password=passwordTextField.text else { return}
        
        Auth.auth().signIn(withEmail: email, password: password) { [self] firebaseResult, error in
            if let e=error{
                print("Error")
                errorLabel.text="Incorrect Username or Password."
            }
            else{
                self.performSegue(withIdentifier: "goToCal", sender: self)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? CalendarViewController{
            destinationVC.receivedUser=userTextField.text
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
