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
     The type of animatino a TextFieldEffect can perform.
     
     - TextEntry: animation that takes effect when the textfield has focus.
     - TextDisplay: animation that takes effect when the textfield loses focus.
     */
    public enum AnimationType: Int {
        case textEntry
        case textDisplay
    }
    
    /**
    Closure executed when an animation has been completed.
     */
    public typealias AnimationCompletionHandler = (type: AnimationType)->()
    
    /**
    UILabel that holds all the placeholder information
    */
    public let placeholderLabel = UILabel()
    
    /**
    Creates all the animations that are used to leave the textfield in the "entering text" state.
    */
    public func animateViewsForTextEntry() {
        fatalError("\(#function) must be overridden")
    }
    
    /**
    Creates all the animations that are used to leave the textfield in the "display input text" state.
    */
    public func animateViewsForTextDisplay() {
        fatalError("\(#function) must be overridden")
    }
    
    /**
     The animation completion handler is the best place to be notified when the text field animation has ended.
     */
    public var animationCompletionHandler: AnimationCompletionHandler?
    
    /**
    Draws the receiver’s image within the passed-in rectangle.
    
    - parameter rect:	The portion of the view’s bounds that needs to be updated.
    */
    public func drawViewsForRect(_ rect: CGRect) {
        fatalError("\(#function) must be overridden")
    }
    
    public func updateViewsForBoundsChange(_ bounds: CGRect) {
        fatalError("\(#function) must be overridden")
    }
    
    // MARK: - Overrides
    
    override public func draw(_ rect: CGRect) {
        drawViewsForRect(rect)
    }
    
    override public func drawPlaceholder(in rect: CGRect) {
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
    
    override public func willMove(toSuperview newSuperview: UIView!) {
        if newSuperview != nil {
            NotificationCenter.default().addObserver(self, selector: #selector(textFieldDidEndEditing), name: NSNotification.Name.UITextFieldTextDidEndEditing, object: self)
            
            NotificationCenter.default().addObserver(self, selector: #selector(textFieldDidBeginEditing), name: NSNotification.Name.UITextFieldTextDidBeginEditing, object: self)
        } else {
            NotificationCenter.default().removeObserver(self)
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
