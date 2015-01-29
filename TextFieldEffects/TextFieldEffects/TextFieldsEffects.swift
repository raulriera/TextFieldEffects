//
//  TextFieldsEffects.swift
//  TextFieldEffects
//
//  Created by Raúl Riera on 24/01/2015.
//  Copyright (c) 2015 Raul Riera. All rights reserved.
//

import Foundation

protocol TextFieldsEffectsDelegate {
    func drawViewsForRect(rect: CGRect)
    func updateViewsForBoundsChange(bounds: CGRect)
    func animateViewsForTextEntry()
    func animateViewsForTextDisplay()
}

class TextFieldEffects : UITextField, UITextFieldDelegate {
    
    func animateViewsForTextEntry() {
        assertionFailure("Must be overridden")
    }
    func animateViewsForTextDisplay() {
        assertionFailure("Must be overridden")
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        animateViewsForTextEntry()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        animateViewsForTextDisplay()
    }
    
}