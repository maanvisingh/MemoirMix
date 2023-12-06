//
//  SignUpViewController.swift
//  MemoirMix
//
//  Created by student1 on 22/11/23.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var userTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func signUpClicked(_ sender: UIButton) {
        guard let email=userTextField.text else { return}
        guard let password=passwordTextField.text else { return}
        Auth.auth().createUser(withEmail: email, password: password) { [self] firebaseResult, error in
            if let e=error{
                print("Error")
                errorLabel.text="Password must be minimum of 6 characters"
            }
            else{
                self.performSegue(withIdentifier: "goToLogin", sender: self)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
