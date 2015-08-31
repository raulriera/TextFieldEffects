//
//  TextFieldsEffects.swift
//  TextFieldEffects
//
//  Created by Raúl Riera on 24/01/2015.
//  Copyright (c) 2015 Raul Riera. All rights reserved.
//

import Foundation
import UIKit

extension String {
    public var isNotEmpty: Bool {
        return !isEmpty
    }
}

public class TextFieldEffects : UITextField {
    
    public let placeholderLabel = UILabel()
    
    public func animateViewsForTextEntry() {
        fatalError("\(__FUNCTION__) must be overridden")
    }
    
    public func animateViewsForTextDisplay() {
        fatalError("\(__FUNCTION__) must be overridden")
    }
    
    public func drawViewsForRect(rect: CGRect) {
        fatalError("\(__FUNCTION__) must be overridden")
    }
    
    public func updateViewsForBoundsChange(bounds: CGRect) {
        fatalError("\(__FUNCTION__) must be overridden")
    }
    
    override public func prepareForInterfaceBuilder() {
        drawViewsForRect(frame)
    }
    
    // MARK: - Overrides
    
    override public func drawRect(rect: CGRect) {
        drawViewsForRect(rect)
    }
    
    override public func drawPlaceholderInRect(rect: CGRect) {
        // Don't draw any placeholders
    }
    
    // MARK: - UITextField Observing
    
    override public func willMoveToSuperview(newSuperview: UIView!) {
        if newSuperview != nil {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "textFieldDidEndEditing", name:UITextFieldTextDidEndEditingNotification, object: self)
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "textFieldDidBeginEditing", name:UITextFieldTextDidBeginEditingNotification, object: self)
        } else {
            NSNotificationCenter.defaultCenter().removeObserver(self)
        }
    }
    
    public func textFieldDidBeginEditing() {
        animateViewsForTextEntry()
    }
    
    public func textFieldDidEndEditing() {
        animateViewsForTextDisplay()
    }
    
}