//
//  RegistrerViewController.swift
//  ChatApp
//
//  Created by admin on 05/05/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import  Firebase
import SVProgressHUD

class RegistrerViewController: UIViewController {

    @IBOutlet weak var PasswordTextField: UITextField!
    
    @IBOutlet weak var EmailTextField: UITextField!
    
    @IBOutlet weak var Password2TextField: UITextField!
    
    @IBOutlet weak var SwitchPolicity: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func RegisterPressed(_ sender: UIButton) {
        
        guard SwitchPolicity.isOn else{
            let alertaController = UIAlertController(title: "Error", message: """
                                Para continuar
                                hay que aceptar las
                                politicas de privacidad
                                """, preferredStyle: UIAlertController.Style.alert)
            
            //botones alert
            let btnAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alertaController.addAction(btnAction)
            
            present(alertaController,animated: true,completion: nil)
            //self.show(alertaController, sender: nil)
            return
        }
        
        if EmailTextField.text != "" && PasswordTextField.text != "" && Password2TextField.text != ""{
        
        guard let email = EmailTextField.text else{
            let alertaController = UIAlertController(title: "Error Email", message: """
                                Fallo email.
                                """, preferredStyle: UIAlertController.Style.alert)
            
            //botones alert
            let btnAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alertaController.addAction(btnAction)
            
            present(alertaController,animated: true, completion: nil)
            return
        }
        
        guard let pass = PasswordTextField.text else{
            let alertaController = UIAlertController(title: "Error Contraseña", message: """
                                Fallo contraseña.
                                """, preferredStyle: UIAlertController.Style.alert)
            
            //botones alert
            let btnAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alertaController.addAction(btnAction)
            
            present(alertaController, animated: true, completion: nil)
            return
        }
        
        guard PasswordTextField.text == Password2TextField.text
            else{
                let alertaController = UIAlertController(title: "Error Contraseña", message: """
                                Las contraseñas no coinciden.
                                """, preferredStyle: UIAlertController.Style.alert)
                
                //botones alert
                let btnAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                alertaController.addAction(btnAction)
                
                present(alertaController,animated: true,completion: nil)
                return
        }
            
            //empieza el proceso de registro
            //circulo progreso
            SVProgressHUD.show()
        
        Auth.auth().createUser(withEmail: email, password: pass){
            (user, error) in
            if error != nil{
                let errorText = error?.localizedDescription
                let alertaController = UIAlertController(title: "Error al crear usuario", message: "\(String(describing: errorText!))"
                                , preferredStyle: UIAlertController.Style.alert)
                
                //botones alert
                let btnAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                alertaController.addAction(btnAction)
                
                self.show(alertaController, sender: nil)
                
                print(error!)
                return
            }
            else{
                print("usuario registrado correctamente")
                SVProgressHUD.dismiss()
                let alertaController = UIAlertController(title: "Usuario registrado", message: """
                                El usuario se ha registrado
                                correctamente.
                                """, preferredStyle: UIAlertController.Style.alert)
                
                //botones alert
                let btnAction = UIAlertAction(title: "OK", style: .default, handler: {(alert: UIAlertAction!) in self.performSegue(withIdentifier: "FromRegistryToChat", sender: self)})
                
                alertaController.addAction(btnAction)
                
                self.present(alertaController, animated: true, completion: nil)
               
                self.performSegue(withIdentifier: "FromRegistryToChat", sender: self)
            }
        }
        }
        else{
            let alertaController = UIAlertController(title: "falta campos", message: """
                                Rellenar todos los campos.
                                """, preferredStyle: UIAlertController.Style.alert)
            
            //botones alert
            let btnAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alertaController.addAction(btnAction)
            
            present(alertaController,animated: true, completion: nil)
            //self.show(alertaController, sender: nil)
            
            self.performSegue(withIdentifier: "FromRegistryToChat", sender: self)
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
