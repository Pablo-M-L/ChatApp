//
//  ViewController.swift
//  ChatApp
//
//  Created by admin on 04/05/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func loginPressed(_ sender: UIButton) {
        
        if emailTextField.text != "" && passwordTextField.text != "" {
            
            guard let email = emailTextField.text else {
                print("fallo en el campo de email")
                return
            }
            guard let pass = passwordTextField.text else{
                print("fallo en el campo password")
                return
            }
            SVProgressHUD.show()
            Auth.auth().signIn(withEmail: email, password: pass){
                (user, error) in
                if error == nil {
                    print("acceso usuario correcto")
                    SVProgressHUD.dismiss()
                    
                    self.performSegue(withIdentifier: "FromLoginToChat", sender: self)
                }
                else {
                    let alertaController = UIAlertController(title: "fallo login", message: """
                                fallo en el login.
                                \(error?.localizedDescription)
                                """, preferredStyle: UIAlertController.Style.alert)
                    
                    //botones alert
                    let btnAction = UIAlertAction(title: "OK", style: .default, handler: {(alert: UIAlertAction!) in return})
                    
                    alertaController.addAction(btnAction)
                    
                    self.show(alertaController, sender: nil)
                }

            }
                
            
        }
       
    }
    
}

