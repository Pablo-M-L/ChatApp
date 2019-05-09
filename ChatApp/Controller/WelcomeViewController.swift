//
//  WelcomeViewController.swift
//  ChatApp
//
//  Created by admin on 05/05/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "GoToChat", sender: self)
        }
        
    }

}
