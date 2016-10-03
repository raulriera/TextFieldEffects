//
//  ExampleTableViewController.swift
//  TextFieldEffects
//
//  Created by Raúl Riera on 28/08/2015.
//  Copyright © 2015 Raul Riera. All rights reserved.
//

import UIKit
import TextFieldEffects

class ExampleTableViewController : UITableViewController {
    
    @IBOutlet private var textFields: [TextFieldEffects]!
    
    /**
    Set this value to true if you want to see all the "firstName"
    textFields prepopulated with the name "Raul" (for testing purposes)
    */
    let prefillTextField = false
    let centeredTextField = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if prefillTextField {
            textFields.forEach { $0.text = "Raul" }
        }
        if centeredTextField {
            textFields.forEach { $0.textAlignment = .center }
        }
    }
}
