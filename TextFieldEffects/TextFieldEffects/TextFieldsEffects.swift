//
//  TextFieldsEffects.swift
//  TextFieldEffects
//
//  Created by Raúl Riera on 24/01/2015.
//  Copyright (c) 2015 Raul Riera. All rights reserved.
//

import UIKit

extension String {
    /**
    true iff self contains characters.
    */
    public var isNotEmpty: Bool {
        return !isEmpty
    }
}

/**
A TextFieldEffects object is a control that displays editable text and contains the boilerplates to setup unique animations for text entrey and display. You typically use this class the same way you use UITextField.
*/
public class TextFieldEffects : UITextField {
    
    /**
    UILabel that holds all the placeholder information
    */
    public let placeholderLabel = UILabel()
    
    /**
    Creates all the animations that are used to leave the textfield in the "entering text" state.
    */
    public func animateViewsForTextEntry() {
        fatalError("\(__FUNCTION__) must be overridden")
    }
    
    /**
    Creates all the animations that are used to leave the textfield in the "display input text" state.
    */
    public func animateViewsForTextDisplay() {
        fatalError("\(__FUNCTION__) must be overridden")
    }
    
    /**
    Draws the receiver’s image within the passed-in rectangle.
    
    - parameter rect:	The portion of the view’s bounds that needs to be updated.
    */
    public func drawViewsForRect(rect: CGRect) {
        fatalError("\(__FUNCTION__) must be overridden")
    }
    
    public func updateViewsForBoundsChange(bounds: CGRect) {
        fatalError("\(__FUNCTION__) must be overridden")
    }
    
    // MARK: - Overrides
    
    override public func drawRect(rect: CGRect) {
        drawViewsForRect(rect)
    }
    
    override public func drawPlaceholderInRect(rect: CGRect) {
        // Don't draw any placeholders
    }
    
    override public var text: String? {
        didSet {
            if let text = text where text.isNotEmpty {
                animateViewsForTextEntry()
            } else {
                animateViewsForTextDisplay()
            }
        }
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
    
    /**
    The textfield has started an editing session.
    */
    public func textFieldDidBeginEditing() {
        animateViewsForTextEntry()
    }
    
    /**
    The textfield has ended an editing session.
    */
    public func textFieldDidEndEditing() {
        animateViewsForTextDisplay()
    }
    
    // MARK: - Interface Builder
    
    override public func prepareForInterfaceBuilder() {
        drawViewsForRect(frame)
    }
}