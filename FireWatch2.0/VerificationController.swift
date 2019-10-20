//
//  VerificationController.swift
//  FireWatch2.0
//
//  Created by mac on 10/18/19.
//  Copyright © 2019 team. All rights reserved.
//

import UIKit
import KWVerificationCodeView
import FirebaseAuth

class VerificationController: UIViewController {

    @IBOutlet weak var userVerificationCode: KWVerificationCodeView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userVerificationCode.keyboardType = .numberPad
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func verifyPressed() {
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
        print("Verification ID: " + verificationID!)
        
        let verificationCode = userVerificationCode.getVerificationCode()
        print(verificationCode)
        
        print("hi1")
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID!,
            verificationCode: verificationCode)
        
        print("hi2")
        
        Auth.auth().signIn(with: credential) { (user, error) in
            print("hi3")
            if let error = error {
                print(error)
                return
            }
            print("hi4")
            print("User successfully signed in")
            self.performSegue(withIdentifier: "logInSegue", sender: self)

        }
    }

}
