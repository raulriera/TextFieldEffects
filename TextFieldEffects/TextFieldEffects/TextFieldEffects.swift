//
//  TextFieldEffects.swift
//  TextFieldEffects
//
//  Created by Raúl Riera on 24/01/2015.
//  Copyright (c) 2015 Raul Riera. All rights reserved.
//

import UIKit

extension String {
    /**
    true if self contains characters.
    */
	var isNotEmpty: Bool {
        return !isEmpty
    }
}

/**
A TextFieldEffects object is a control that displays editable text and contains the boilerplates to setup unique animations for text entry and display. You typically use this class the same way you use UITextField.
*/
open class TextFieldEffects : UITextField {
    /**
     The type of animation a TextFieldEffect can perform.
     
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
    public typealias AnimationCompletionHandler = (_ type: AnimationType)->()
    
    /**
    UILabel that holds all the placeholder information
    */
    open let placeholderLabel = UILabel()
    
    /**
    Creates all the animations that are used to leave the textfield in the "entering text" state.
    */
    open func animateViewsForTextEntry() {
        fatalError("\(#function) must be overridden")
    }
    
    /**
    Creates all the animations that are used to leave the textfield in the "display input text" state.
    */
    open func animateViewsForTextDisplay() {
        fatalError("\(#function) must be overridden")
    }
    
    /**
     The animation completion handler is the best place to be notified when the text field animation has ended.
     */
    open var animationCompletionHandler: AnimationCompletionHandler?
    
    /**
    Draws the receiver’s image within the passed-in rectangle.
    
    - parameter rect:	The portion of the view’s bounds that needs to be updated.
    */
    open func drawViewsForRect(_ rect: CGRect) {
        fatalError("\(#function) must be overridden")
    }
    
    open func updateViewsForBoundsChange(_ bounds: CGRect) {
        fatalError("\(#function) must be overridden")
    }
    
        
    // MARK: - Overrides
    
    override open func draw(_ rect: CGRect) {
		// FIXME: Short-circuit if the view is currently selected. iOS 11 introduced
		// a setNeedsDisplay when you focus on a textfield, calling this method again
		// and messing up some of the effects due to the logic contained inside these
		// methods.
		// This is just a "quick fix", something better needs to come along.
		guard isFirstResponder == false else { return }
		drawViewsForRect(rect)
    }
    
    override open func drawPlaceholder(in rect: CGRect) {
        // Don't draw any placeholders
    }
    
    override open var text: String? {
        didSet {
            if let text = text, text.isNotEmpty {
                animateViewsForTextEntry()
            } else {
                animateViewsForTextDisplay()
            }
        }
    }
    
    
    open override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        let defaultRect = super.leftViewRect(forBounds: bounds)
        return repositionLeftView(CurrentBounds:defaultRect)
    }
    
    open override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let defaultRect = super.rightViewRect(forBounds: bounds)
        return repositionRightView(CurrentBounds: defaultRect)
    }
    
    open override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        let defaultRect = super.clearButtonRect(forBounds: bounds)
        return repositionClearButton(CurrentBounds:defaultRect)
    }
    
    //MARK: - LeftView and RightView methods
    
    /**
     The default implementation of this method does nothing
     You must implement this method if you want to position added leftView on a diferent position
     - parameter bounds: The current bounds of added leftView, this position is calculated by UITextField.leftViewRect(forBounds: CGRect) method
     */
    public func repositionLeftView(CurrentBounds bounds:CGRect)->CGRect{
        return bounds
    }
    
    /**
     The default implementation of this method does nothing
     You must implement this method if you want to position added rightView on a diferent position
     - parameter bounds: The current bounds of added rightView, this position is calculated by UITextField.rightViewRect(forBounds: CGRect) method
     */
    public func repositionRightView(CurrentBounds bounds:CGRect)->CGRect{
        return bounds
    }
    
    /**
     The default implementation of this method does nothing
     You must implement this method if you want to position clearButton on a diferent position
     - parameter bounds: The current bounds of added clearButton, this position is calculated by UITextField.clearButtonRect(forBounds: CGRect) method
     */
    public func repositionClearButton(CurrentBounds bounds:CGRect)->CGRect{
        return bounds
    }

    // MARK: - UITextField Observing
    
    override open func willMove(toSuperview newSuperview: UIView!) {
        if newSuperview != nil {
            NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidEndEditing), name: NSNotification.Name.UITextFieldTextDidEndEditing, object: self)
            
            NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidBeginEditing), name: NSNotification.Name.UITextFieldTextDidBeginEditing, object: self)
        } else {
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    /**
    The textfield has started an editing session.
    */
    @objc open func textFieldDidBeginEditing() {
        animateViewsForTextEntry()
    }
    
    /**
    The textfield has ended an editing session.
    */
    @objc open func textFieldDidEndEditing() {
        animateViewsForTextDisplay()
    }
    
    // MARK: - Interface Builder
    
    override open func prepareForInterfaceBuilder() {
        drawViewsForRect(frame)
    }
}
