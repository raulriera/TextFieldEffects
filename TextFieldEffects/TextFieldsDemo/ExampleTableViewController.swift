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
    
    @IBOutlet private var textFields: [UITextField]!
    
    @IBOutlet private var emailTextFields: [UITextField]!

    /**
    Set this value to true if you want to see all the "firstName"
    textFields prepopulated with the name "Raul" (for testing purposes)
    */
    let prefillTextFields = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addEmailImg()
        
        guard prefillTextFields == true else { return }
        
        _ = textFields.map { $0.text = "Raul" }
    }
    
    private func addEmailImg(){
        
        for tf in emailTextFields{
            let emailImg = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: 25, height:25)))
            //emailImg.backgroundColor = UIColor.red
            emailImg.image = UIImage(named:"avatar")
            emailImg.clipsToBounds = true
            emailImg.contentMode = UIViewContentMode.scaleAspectFit
            
            
            //tf.textAlignment = NSTextAlignment.left
            tf.textAlignment = NSTextAlignment.natural
            //tf.textAlignment = NSTextAlignment.right
            //tf.textAlignment = NSTextAlignment.center
            
            
            tf.leftView = emailImg
            tf.leftViewMode = UITextFieldViewMode.always
            //tf.leftViewMode = UITextFieldViewMode.whileEditing
            //tf.leftViewMode = UITextFieldViewMode.unlessEditing
            //tf.leftViewMode = UITextFieldViewMode.never
            
            
            //tf.rightView = emailImg
            //tf.rightViewMode = UITextFieldViewMode.always
            //tf.rightViewMode = UITextFieldViewMode.whileEditing
            //tf.rightViewMode = UITextFieldViewMode.unlessEditing
            //tf.rightViewMode = UITextFieldViewMode.never
            
            //tf.clearButtonMode = UITextFieldViewMode.always
        }
        
    }

}
