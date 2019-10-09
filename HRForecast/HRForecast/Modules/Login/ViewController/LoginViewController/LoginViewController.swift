//
//  LoginViewController.swift
//  HRForecast
//
//  Created by Naresh Jain on 09/10/19.
//  Copyright © 2019 Sapient. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBOutlet weak var usernameTextfield: UITextField!
    
    lazy var loginViewModel = LoginViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func signInButtonAction(_ sender: UIButton) {
    
    }

}

