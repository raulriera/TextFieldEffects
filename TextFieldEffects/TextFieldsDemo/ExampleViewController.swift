//
//  ExampleViewController.swift
//  TextFieldsDemo
//
//  Created by Sander Theeuwes on 03/08/2020.
//  Copyright © 2020 Raul Riera. All rights reserved.
//

import UIKit

class ExampleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func endEditing() {
        view.endEditing(false)
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
