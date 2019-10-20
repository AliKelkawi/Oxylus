//
//  LoginController.swift
//  FireWatch2.0
//
//  Created by mac on 10/18/19.
//  Copyright © 2019 team. All rights reserved.
//

import UIKit
import CountryPicker
import Firebase
import FirebaseAuth
import CoreLocation
//import UserNotifications
//import SwiftyOnboard

class LoginController: UIViewController, CountryPickerDelegate, UITextFieldDelegate {
    
    func countryPhoneCodePicker(_ picker: CountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
        
        countryCodeText.text = phoneCode
        self.flag.image = flag
    }
    

    @IBOutlet weak var flag: UIImageView!
    
    @IBOutlet weak var phoneNumber: UITextField!
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var picker: CountryPicker!
    
    @IBOutlet weak var countryCodeText: UITextField!
    
    @IBAction func submitPressed(_ sender: UIButton) {
        
        let countryCode = countryCodeText.text
        let phoneNum = phoneNumber.text
        
        let num = countryCode! + phoneNum!
        
        print(num)
        
        Auth.auth().settings?.isAppVerificationDisabledForTesting = true
        
        PhoneAuthProvider.provider(auth: Auth.auth())
        
        
        PhoneAuthProvider.provider().verifyPhoneNumber(num, uiDelegate: nil) { (verificationID, error) in
            print(verificationID)
            if let error = error {
                print(error.localizedDescription)
                return
            }
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            self.performSegue(withIdentifier: "verificationSegue", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedAround()
        var myColor : UIColor = UIColor( red: 1, green: 0.64, blue:0, alpha: 1.0 )
        phoneNumber.keyboardType = .numberPad
        
        countryCodeText.layer.borderWidth = 2.0
        countryCodeText.layer.cornerRadius = 5.0
        
        myColor = UIColor( red: 1, green: 0, blue:0, alpha: 1.0 )
        
        countryCodeText.delegate = self
        phoneNumber.delegate = self
        
        
        picker.exeptCountriesWithCodes = ["IL"] //except country
        let theme = CountryViewTheme(countryCodeTextColor: .black, countryNameTextColor: .black, rowBackgroundColor: .white, showFlagsBorder: false)        //optional for UIPickerView theme changes
        picker.theme = theme //optional for UIPickerView theme changes
        picker.countryPickerDelegate = self
        picker.showPhoneNumbers = true
        picker.setCountry("KW")
        picker.isHidden = true
    }

}





extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

func showAlert(title: String?, message: String, parent: UIViewController) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
    alert.addAction(cancelAction)
    parent.present(alert, animated: true, completion: nil)
}
