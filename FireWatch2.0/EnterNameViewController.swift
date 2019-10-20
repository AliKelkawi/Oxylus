//
//  EnterNameViewController.swift
//  FireWatch2.0
//
//  Created by Abdalwahab on 10/19/19.
//  Copyright © 2019 team. All rights reserved.
//

import UIKit

class EnterNameViewController: UIViewController {
    
    @IBOutlet var nameFld: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func submit() {
        if nameFld.text!.isEmpty {
            print("please enter a name")
            return
        }
        
        let name = nameFld.text
        UserDefaults.standard.set(name, forKey: "Fullname")
        
        dismiss(animated: true, completion: nil)
    }

}
