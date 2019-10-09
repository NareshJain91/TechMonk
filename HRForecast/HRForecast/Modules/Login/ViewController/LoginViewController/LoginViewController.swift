//
//  LoginViewController.swift
//  HRForecast
//
//  Created by Naresh Jain on 09/10/19.
//  Copyright © 2019 Sapient. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import CodableFirebase


class LoginViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
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
    
    @IBOutlet weak var SignUpButton: UIButton!
    @IBOutlet weak var signupPicker: UIPickerView!
    
    var reference: DatabaseReference?
    
    var profiles: [String] = []
    
    lazy var loginViewModel = LoginViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        reference = Database.database().reference()
        signupPicker.delegate = self
        signupPicker.dataSource = self
        self.reference!.child("profiles").observe(.value, with: { (snapshot) in
            guard let value = snapshot.value else { return }
            do {
                let person = try FirebaseDecoder().decode([String].self, from: value)
                self.profiles = (person)
                self.signupPicker.reloadAllComponents()
            } catch let error {
                print(error)
            }
        })
        
        // Do any additional setup after loading the view.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
        
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return profiles.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return profiles[row]
    }
    @IBAction func signUpButtonAction(_ sender: Any) {
        
        
    Auth.auth().createUser(withEmail:usernameTextfield.text!, password: passwordTextfield.text!) { [weak self] user, error in
            guard let strongSelf = self else { return }
        
                    guard let firebaseUser = user?.user else {return}
        
                    var fullNameArr = firebaseUser.email?.components(separatedBy: "@")
                    var firstName: String = fullNameArr![0]
                    var lastName: String? = fullNameArr!.count > 1 ? fullNameArr![1] : nil
        let user = User(username: firstName, email: firebaseUser.email!, type: self!.profiles[strongSelf.signupPicker.selectedRow(inComponent: 0)])
                   
        let data = try! FirebaseEncoder().encode(user)
        self!.reference!.child("users").child(firebaseUser.uid).setValue(data);
        let alert = UIAlertController(title: "SignUp Success", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self!.present(alert, animated: true, completion: nil)
        
}
    
    }
    
    @IBAction func signInButtonAction(_ sender: UIButton) {
        
//        Signin
    
        Auth.auth().signIn(withEmail: usernameTextfield.text!, password: passwordTextfield.text!) { [weak self] user, error in
        guard let strongSelf = self else { return }

            let alert = UIAlertController(title: "\(user)", message: "\(error)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Click", style: .default, handler: nil))
            strongSelf.present(alert, animated: true, completion: nil)
        }
    
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

struct User: Codable {
    let username: String!
    let email: String!
    let type: String!
}
