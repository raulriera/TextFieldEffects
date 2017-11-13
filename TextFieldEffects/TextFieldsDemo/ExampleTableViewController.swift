//
//  ExampleTableViewController.swift
//  TextFieldEffects
//
//  Created by Raúl Riera on 28/08/2015.
//  Copyright © 2015 Raul Riera. All rights reserved.
//

import UIKit
import TextFieldEffects

class ExampleTableViewController : UITableViewController, UITextFieldDelegate {

  @IBOutlet private var textFields: [TextFieldEffects]!
  @IBOutlet private var hoshiTextField: HoshiTextField?

  /**
   Set this value to true if you want to see all the "firstName"
   textFields prepopulated with the name "Raul" (for testing purposes)
   */
  let prefillTextFields = false

  override func viewDidLoad() {
    super.viewDidLoad()

    guard prefillTextFields == true else { return }

    _ = textFields.map { $0.text = "Raul" }

    hoshiTextField?.delegate = self
  }


  // MARK: - TextFieldDelegate

  func textFieldDidBeginEditing(_ textField: UITextField) {
    hoshiTextField?.hideError()
  }
  @available(iOS 10.0, *)
  func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
    hoshiTextField?.showError(message: "Bad Name!")
  }
}
