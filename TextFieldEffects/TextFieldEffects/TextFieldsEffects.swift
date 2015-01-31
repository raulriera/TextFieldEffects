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

class TextFieldEffects : UITextField, UITextFieldDelegate, TextFieldsEffectsDelegate {
    
    let placeholderLabel = UILabel()
    
    func animateViewsForTextEntry() {
        fatalError("\(__FUNCTION__) must be overridden")
    }
    
    func animateViewsForTextDisplay() {
        fatalError("\(__FUNCTION__) must be overridden")
    }
    
    func drawViewsForRect(rect: CGRect) {
        fatalError("\(__FUNCTION__) must be overridden")
    }

    func updateViewsForBoundsChange(bounds: CGRect) {
        fatalError("\(__FUNCTION__) must be overridden")
    }
    
    override func prepareForInterfaceBuilder() {
        drawViewsForRect(frame)
    }
    
    // MARK: - Overrides
    
    override func drawRect(rect: CGRect) {
        drawViewsForRect(rect)
    }
    
    override func drawPlaceholderInRect(rect: CGRect) {
        // Don't draw any placeholders
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        animateViewsForTextEntry()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        animateViewsForTextDisplay()
    }
    
}