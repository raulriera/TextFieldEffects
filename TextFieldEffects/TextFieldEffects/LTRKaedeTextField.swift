//
//  LTRKaedeTextField.swift
//  UserScreen
//
//  Created by me on 10/10/16.
//  Copyright © 2016 Matloub. All rights reserved.
//


import UIKit

/**
 A KaedeTextField is a subclass of the TextFieldEffects object, is a control that displays an UITextField with a customizable visual effect around the foreground of the control.
 */
@IBDesignable open class LTRKaedeTextField: TextFieldEffects {
    
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
    
    override open var bounds: CGRect {
        didSet {
            drawViewsForRect(bounds)
        }
    }
    
    private let foregroundView = UIView()
    private let placeholderInsets = CGPoint(x: 10, y: 5)
    private let textFieldInsets = CGPoint(x: 10, y: 0)
    
    // MARK: - TextFieldsEffects
    
    override open func drawViewsForRect(_ rect: CGRect) {
        let frame = CGRect(origin: CGPoint.zero, size: CGSize(width: rect.size.width, height: rect.size.height))
        
        foregroundView.frame = frame
        foregroundView.isUserInteractionEnabled = false
        placeholderLabel.frame = frame.insetBy(dx: placeholderInsets.x, dy: placeholderInsets.y)
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
        UIView.animate(withDuration: 0.35, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 2.0, options: .beginFromCurrentState, animations: ({
            
            self.placeholderLabel.frame.size.width = self.frame.size.width * 0.25
            
        }), completion: nil)
        
        UIView.animate(withDuration: 0.45, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.5, options: .beginFromCurrentState, animations: ({
            
            self.foregroundView.frame.size.width = self.frame.size.width * 0.3
            
        }), completion: { _ in
            self.animationCompletionHandler?(.textEntry)
        })
    }
    
    override open func animateViewsForTextDisplay() {
        if text!.isEmpty {
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 2.0, options: .beginFromCurrentState, animations: ({
                self.placeholderLabel.frame.size.width = self.frame.size.width
                //                self.placeholderLabel.frame.origin = self.placeholderInsets
            }), completion: nil)
            
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 2.0, options: .beginFromCurrentState, animations: ({
                self.foregroundView.frame.size.width=self.frame.size.width
                //                self.foregroundView.frame.origin = CGPointZero
            }), completion: { _ in
                
                self.animationCompletionHandler?(.textDisplay)
            })
        }
        
    }
    
    // MARK: - Private
    
    private func updateForegroundColor() {
        foregroundView.backgroundColor = foregroundColor
    }
    
    internal override func updatePlaceholder() {
        super.updatePlaceholder()
        
        placeholderLabel.text = _placeholder
        placeholderLabel.textColor = placeholderColor
    }
    
    private func placeholderFontFromFont(_ font: UIFont) -> UIFont! {
        let smallerFont = UIFont(name: font.fontName, size: font.pointSize * placeholderFontScale)
        return smallerFont
    }
    
    // MARK: - Overrides
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        var b = bounds
        b.origin.x += self.placeholderLabel.frame.size.width + 10
        
        let frame = CGRect(origin: b.origin, size: CGSize(width: bounds.size.width * 0.6, height: bounds.size.height))
        
        
        //        self.alignmentRectInsets.left
        let start = self.textFieldInsets.x
        return frame.insetBy(dx: start , dy: self.textFieldInsets.y)
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        var b = bounds
        b.origin.x += self.placeholderLabel.frame.size.width + 10
        
        let frame = CGRect(origin: b.origin, size: CGSize(width: bounds.size.width * 0.6, height: bounds.size.height))
        
        let start = self.textFieldInsets.x
        return frame.insetBy(dx: start, dy: self.textFieldInsets.y)
    }
}

/*
//////////////////////////////////////////////////////////////////////

class LTRKaedeTextField: KaedeTextField {
    
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    
    
    
    override  func animateViewsForTextEntry() {
        UIView.animate(withDuration: 0.35, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 2.0, options: .beginFromCurrentState, animations: ({
            
            self.placeholderLabel.frame.size.width = self.frame.size.width * 0.25
            
        }), completion: nil)
        
        UIView.animateWithDuration(0.45, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.5, options: .BeginFromCurrentState, animations: ({
            
            self.foregroundView.frame.size.width = self.frame.size.width * 0.3
            
        }), completion: { _ in
            self.animationCompletionHandler?(type: .TextEntry)
        })
    }
    
    override  func animateViewsForTextDisplay() {
        if text!.isEmpty {
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 2.0, options: .beginFromCurrentState, animations: ({
                self.placeholderLabel.frame.size.width = self.frame.size.width
                //                self.placeholderLabel.frame.origin = self.placeholderInsets
            }), completion: nil)
            
            UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 2.0, options: .BeginFromCurrentState, animations: ({
                self.getForgroundView().frame.size.width=self.frame.size.width
                //                self.foregroundView.frame.origin = CGPointZero
            }), completion: { _ in
                
                self.animationCompletionHandler?(type: .TextDisplay)
            })
        }
    }
    
    override  func editingRect(forBounds bounds: CGRect) -> CGRect {
        var b = bounds
        b.origin.x += self.placeholderLabel.frame.size.width + 10
        
        let frame = CGRect(origin: b.origin, size: CGSize(width: bounds.size.width * 0.6, height: bounds.size.height))
        
        
//        self.alignmentRectInsets.left
        let start = self.getTextFieldInsets().x
        return CGRectInset(frame, start , self.getTextFieldInsets().y)
    }
    
    override  func textRect(forBounds bounds: CGRect) -> CGRect {
        var b = bounds
        b.origin.x += self.placeholderLabel.frame.size.width + 10
        
        let frame = CGRect(origin: b.origin, size: CGSize(width: bounds.size.width * 0.6, height: bounds.size.height))
        
        let start = self.getTextFieldInsets().x
        return CGRectInset(frame, start, self.getTextFieldInsets().y)
    }
    
}
*/
