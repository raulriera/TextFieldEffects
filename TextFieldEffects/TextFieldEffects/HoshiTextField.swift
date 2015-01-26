//
//  HoshiTextField.swift
//  TextFieldEffects
//
//  Created by Raúl Riera on 24/01/2015.
//  Copyright (c) 2015 Raul Riera. All rights reserved.
//

import UIKit

@IBDesignable class HoshiTextField: UITextField, UITextFieldDelegate {
    
    @IBInspectable var borderInactiveColor: UIColor = UIColor(red: 106, green: 121, blue: 137, alpha: 1) {
        didSet {
            updateBorder()
        }
    }
    @IBInspectable var borderActiveColor: UIColor = UIColor(red: 106, green: 121, blue: 137, alpha: 1) {
        didSet {
            updateBorder()
        }
    }
    @IBInspectable var placeholderColor: UIColor = UIColor(red: 106, green: 121, blue: 137, alpha: 1) {
        didSet {
            updatePlaceholder()
        }
    }
    
    override var placeholder: String? {
        didSet {
            updatePlaceholder()
        }
    }
    
    override var bounds: CGRect {
        didSet {
            updateBorder()
            updatePlaceholder()
        }
    }
    
    private let borderThickness: (active: CGFloat, inactive: CGFloat) = (active: 2, inactive: 0.5)
    private let placeholderLabel = UILabel()
    private let placeholderInsets = CGPoint(x: 0, y: 6)
    private let textFieldInsets = CGPoint(x: 0, y: 12)
    private let inactiveBorderLayer = CALayer()
    private let activeBorderLayer = CALayer()
    
    /**
    Draws all the requires view on top of the textfield
    
    :param: rect to based the views from
    */
    private func drawViewsForRect(rect: CGRect) {
        let frame = CGRect(origin: CGPointZero, size: CGSize(width: rect.size.width, height: rect.size.height))
        
        placeholderLabel.frame = CGRectInset(frame, placeholderInsets.x, placeholderInsets.y)
        placeholderLabel.font = placeholderFontFromFont(self.font)
        
        updateBorder()
        updatePlaceholder()
        
        layer.addSublayer(inactiveBorderLayer)
        layer.addSublayer(activeBorderLayer)
        addSubview(placeholderLabel)
        
        delegate = self
    }
    
    private func updateBorder() {
        inactiveBorderLayer.frame = rectForBorder(borderThickness.inactive, isFill: true)
        inactiveBorderLayer.backgroundColor = borderInactiveColor.CGColor
        
        activeBorderLayer.frame = rectForBorder(borderThickness.active, isFill: false)
        activeBorderLayer.backgroundColor = borderActiveColor.CGColor
    }
 
    private func updatePlaceholder() {
        placeholderLabel.text = placeholder
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.sizeToFit()
        layoutPlaceholderInTextRect()
        
        if isFirstResponder() || !text.isEmpty {
            animateViewsForTextEntry()
        }
    }
    
    private func placeholderFontFromFont(font: UIFont) -> UIFont! {
        let smallerFont = UIFont(name: font.fontName, size: font.pointSize * 0.65)
        return smallerFont
    }
    
    private func rectForBorder(thickness: CGFloat, isFill: Bool) -> CGRect {
        if isFill {
           return CGRect(origin: CGPoint(x: 0, y: CGRectGetHeight(frame)-thickness), size: CGSize(width: CGRectGetWidth(frame), height: thickness))
        } else {
           return CGRect(origin: CGPoint(x: 0, y: CGRectGetHeight(frame)-thickness), size: CGSize(width: 0, height: thickness))
        }
    }
    
    private func layoutPlaceholderInTextRect() {
        
        if !text.isEmpty {
            return
        }
        
        let textRect = textRectForBounds(bounds)
        var originX = textRect.origin.x
        switch self.textAlignment {
        case .Center:
            originX += textRect.size.width/2 - placeholderLabel.bounds.width/2
        case .Right:
            originX += textRect.size.width - placeholderLabel.bounds.width
        default:
            break
        }
        placeholderLabel.frame = CGRect(x: originX, y: textRect.size.height/2,
            width: placeholderLabel.frame.size.width, height: placeholderLabel.frame.size.height)
    }
    
    private func animateViewsForTextEntry() {
        if text.isEmpty {
            UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: ({
                self.placeholderLabel.frame.origin = CGPoint(x: 10, y: self.placeholderLabel.frame.origin.y)
                self.placeholderLabel.alpha = 0
            }), completion: { (completed) -> Void in
                
                self.layoutPlaceholderInTextRect()
                self.placeholderLabel.frame.origin = CGPoint(x: self.placeholderLabel.frame.origin.x, y: self.placeholderLabel.frame.origin.y - self.placeholderLabel.frame.size.height - self.placeholderInsets.y)
                
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.placeholderLabel.alpha = 0.5
                })
            })
        }
        
        self.activeBorderLayer.frame = self.rectForBorder(self.borderThickness.active, isFill: true)
    }
    
    private func animateViewsForTextDisplay() {
        if text.isEmpty {
            UIView.animateWithDuration(0.35, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 2.0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: ({
                self.layoutPlaceholderInTextRect()
                self.placeholderLabel.alpha = 1
            }), completion: nil)
            
            self.activeBorderLayer.frame = self.rectForBorder(self.borderThickness.active, isFill: false)
        }
    }
    
    // MARK: - Overrides
    
    override func drawRect(rect: CGRect) {
        drawViewsForRect(rect)
    }
    
    override func drawPlaceholderInRect(rect: CGRect) {
        // Don't draw any placeholders
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectOffset(bounds, textFieldInsets.x, textFieldInsets.y)
    }
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectOffset(bounds, textFieldInsets.x, textFieldInsets.y)
    }
    
    override func prepareForInterfaceBuilder() {
        drawViewsForRect(frame)
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        animateViewsForTextEntry()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        animateViewsForTextDisplay()
    }
}