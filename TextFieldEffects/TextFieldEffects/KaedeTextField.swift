//
//  KaedeTextField.swift
//  Swish
//
//  Created by Raúl Riera on 20/01/2015.
//  Copyright (c) 2015 com.raulriera.swishapp. All rights reserved.
//

import UIKit

/**
 A KaedeTextField is a subclass of the TextFieldEffects object, is a control that displays an UITextField with a customizable visual effect around the foreground of the control.
 */
@IBDesignable open class KaedeTextField: TextFieldEffects {
    /**
     The color of the placeholder text.
     
     This property applies a color to the complete placeholder string. The default value for this property is a black color.
     */
    @IBInspectable dynamic open var placeholderColor: UIColor? {
        didSet {
            updatePlaceholder()
        }
    }
    
    /**
     The scale of the placeholder font.
     
     This property determines the size of the placeholder label relative to the font size of the text field.
     */
    @IBInspectable dynamic open var placeholderFontScale: CGFloat = 0.8 {
        didSet {
            updatePlaceholder()
        }
    }
    
    /**
     The view’s foreground color.
     
     The default value for this property is a clear color.
     */
    @IBInspectable dynamic open var foregroundColor: UIColor? {
        didSet {
            updateForegroundColor()
        }
    }
    
    override open var placeholder: String? {
        didSet {
            updatePlaceholder()
        }
    }
    
    override open var bounds: CGRect {
        didSet {
            drawViewsForRect(bounds)
        }
    }
    
    private let foregroundView = UIView()
    private let placeholderInsets = CGPoint(x: 10, y: 5)
    private let textFieldInsets = CGPoint(x: 10, y: 0)
        
    // MARK: - TextFieldEffects

    override open func drawViewsForRect(_ rect: CGRect) {
        let frame = CGRect(origin: .zero, size: CGSize(width: rect.size.width, height: rect.size.height))
        
        foregroundView.frame = frame
        foregroundView.isUserInteractionEnabled = false
        
        var leftViewOffsetX:CGFloat = 0
        if let leftView = leftView,isPresentingLeftView(){
            leftViewOffsetX = leftView.frame.width + leftView.frame.origin.x
        }

        placeholderLabel.frame = frame.insetBy(dx: placeholderInsets.x+leftViewOffsetX, dy: placeholderInsets.y)
        placeholderLabel.font = placeholderFontFromFont(font!)
        
        updateForegroundColor()
        updatePlaceholder()
        
        if text!.isNotEmpty || isFirstResponder {
            animateViewsForTextEntry()
        }
        
        addSubview(foregroundView)
        addSubview(placeholderLabel)        
    }
    
    override open func animateViewsForTextEntry() {
		let directionOverride: CGFloat

		if #available(iOS 9.0, *) {
			directionOverride = UIView.userInterfaceLayoutDirection(for: semanticContentAttribute) == .rightToLeft ? -1.0 : 1.0
		} else {
			directionOverride = 1.0
		}

        UIView.animate(withDuration: 0.35, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 2.0, options: .beginFromCurrentState, animations: ({
            self.placeholderLabel.frame.origin = CGPoint(x: self.frame.size.width * 0.65 * directionOverride, y: self.placeholderInsets.y)
        }), completion: nil)
        
        UIView.animate(withDuration: 0.45, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.5, options: .beginFromCurrentState, animations: ({
            self.foregroundView.frame.origin = CGPoint(x: self.frame.size.width * 0.6 * directionOverride, y: 0)
        }), completion: { _ in
            self.animationCompletionHandler?(.textEntry)
        })
    }
    
    override open func animateViewsForTextDisplay() {
        if text!.isEmpty {
            
            var leftViewOffsetX:CGFloat = 0
            if let leftView = leftView,isPresentingLeftView(){
                leftViewOffsetX = leftView.frame.width + leftView.frame.origin.x
            }
            
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 2.0, options: .beginFromCurrentState, animations: ({
                self.placeholderLabel.frame.origin = CGPoint(x: self.placeholderInsets.x + leftViewOffsetX, y: self.placeholderInsets.y)
            }), completion: nil)
            
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 2.0, options: .beginFromCurrentState, animations: ({
                self.foregroundView.frame.origin = CGPoint.zero
            }), completion: { _ in
                self.animationCompletionHandler?(.textDisplay)
            })
        }
    }
    
    open override func repositionClearButton(CurrentBounds bounds: CGRect) -> CGRect {
        let directionOverride: CGFloat
        
        if #available(iOS 9.0, *) {
            directionOverride = UIView.userInterfaceLayoutDirection(for: semanticContentAttribute) == .rightToLeft ? -1.0 : 1.0
        } else {
            directionOverride = 1.0
        }
        
        var rightViewOffsetX:CGFloat = 0
        if let rightView = rightView,isPresentingRightView() && rightViewMode != .unlessEditing{
            rightViewOffsetX = rightView.frame.width
        }
        
        let correctX = (self.frame.size.width * 0.6 * directionOverride) - rightViewOffsetX - bounds.width
        
        let origin = CGPoint(x: correctX, y: bounds.origin.y)
        return CGRect(origin: origin, size: bounds.size)
    }
    // MARK: - Private
    
    private func updateForegroundColor() {
        foregroundView.backgroundColor = foregroundColor
    }
    
    private func updatePlaceholder() {
        placeholderLabel.text = placeholder
        placeholderLabel.textColor = placeholderColor
    }
    
    private func placeholderFontFromFont(_ font: UIFont) -> UIFont! {
        let smallerFont = UIFont(name: font.fontName, size: font.pointSize * placeholderFontScale)
        return smallerFont
    }
    
    // MARK: - Overrides
        
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        let fixedBounds = super.editingRect(forBounds: bounds)
        
        var rightViewOffsetX:CGFloat = 0
        if let rightView = rightView,isPresentingRightView(){
            rightViewOffsetX = rightView.frame.width
        }
        
        var frame = CGRect(origin: fixedBounds.origin, size: CGSize(width: (fixedBounds.size.width + rightViewOffsetX) * 0.6, height: fixedBounds.size.height))

		if #available(iOS 9.0, *) {
			if UIView.userInterfaceLayoutDirection(for: semanticContentAttribute) == .rightToLeft {
				frame.origin = CGPoint(x: bounds.size.width - frame.size.width, y: frame.origin.y)
			}
		}

        return frame.insetBy(dx: textFieldInsets.x, dy: textFieldInsets.y)
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
		return editingRect(forBounds: bounds)
    }

}
