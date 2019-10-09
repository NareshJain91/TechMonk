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
    
    @IBOutlet weak var passwordTextfield: UITextField! {
        didSet {
            passwordTextfield.layer.borderWidth = 1.0
            passwordTextfield.layer.cornerRadius = 5.0
            passwordTextfield.layer.borderColor = UIColor(red:1.00, green:0.25, blue:0.30, alpha:0.7).cgColor
        }
    }
    
    @IBOutlet weak var usernameTextfield: UITextField! {
        didSet {
            usernameTextfield.layer.borderWidth = 1.0
            usernameTextfield.layer.cornerRadius = 5.0
            usernameTextfield.layer.borderColor = UIColor(red:1.00, green:0.25, blue:0.30, alpha:0.7).cgColor
        }
    }
    
    lazy var loginViewModel = LoginViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func signInButtonAction(_ sender: UIButton) {
    
    }

}

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}
