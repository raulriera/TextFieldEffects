//
//  IsaoTextField.swift
//  TextFieldEffects
//
//  Created by Raúl Riera on 29/01/2015.
//  Copyright (c) 2015 Raul Riera. All rights reserved.
//

import UIKit

@IBDesignable public class IsaoTextField: TextFieldEffects {
    
    @IBInspectable public var inactiveColor: UIColor? {
        didSet {
            updateBorder()
        }
    }
    @IBInspectable public var activeColor: UIColor? {
        didSet {
            updateBorder()
        }
    }
    
    override public var placeholder: String? {
        didSet {
            updatePlaceholder()
        }
    }
    
    override public var bounds: CGRect {
        didSet {
            updateBorder()
            updatePlaceholder()
        }
    }
    
    private let borderThickness: (active: CGFloat, inactive: CGFloat) = (4, 2)
    private let placeholderInsets = CGPoint(x: 6, y: 6)
    private let textFieldInsets = CGPoint(x: 6, y: 6)
    private let borderLayer = CALayer()
    
    // MARK: - TextFieldsEffectsProtocol
    
    override func drawViewsForRect(rect: CGRect) {
        let frame = CGRect(origin: CGPointZero, size: CGSize(width: rect.size.width, height: rect.size.height))
        
        placeholderLabel.frame = CGRectInset(frame, placeholderInsets.x, placeholderInsets.y)
        placeholderLabel.font = placeholderFontFromFont(font!)
        
        updateBorder()
        updatePlaceholder()
        
        layer.addSublayer(borderLayer)
        addSubview(placeholderLabel)        
    }
    
    private func updateBorder() {
        borderLayer.frame = rectForBorder(frame)
        borderLayer.backgroundColor = isFirstResponder() ? activeColor?.CGColor : inactiveColor?.CGColor
    }
    
    private func updatePlaceholder() {
        placeholderLabel.text = placeholder
        placeholderLabel.textColor = inactiveColor
        placeholderLabel.sizeToFit()
        layoutPlaceholderInTextRect()
        
        if isFirstResponder() {
            animateViewsForTextEntry()
        }
    }
    
    private func placeholderFontFromFont(font: UIFont) -> UIFont! {
        let smallerFont = UIFont(name: font.fontName, size: font.pointSize * 0.7)
        return smallerFont
    }
    
    private func rectForBorder(bounds: CGRect) -> CGRect {
        var newRect:CGRect
        
        if isFirstResponder() {
            newRect = CGRect(x: 0, y: bounds.size.height - font!.lineHeight + textFieldInsets.y - borderThickness.active, width: bounds.size.width, height: borderThickness.active)
        } else {
            newRect = CGRect(x: 0, y: bounds.size.height - font!.lineHeight + textFieldInsets.y - borderThickness.inactive, width: bounds.size.width, height: borderThickness.inactive)
        }
        
        return newRect
    }
    
    private func layoutPlaceholderInTextRect() {
        
        if !text!.isEmpty {
            return
        }
        
        let textRect = textRectForBounds(bounds)
        var originX = textRect.origin.x
        switch textAlignment {
        case .Center:
            originX += textRect.size.width/2 - placeholderLabel.bounds.width/2
        case .Right:
            originX += textRect.size.width - placeholderLabel.bounds.width
        default:
            break
        }
        placeholderLabel.frame = CGRect(x: originX, y: bounds.height - placeholderLabel.frame.height,
            width: placeholderLabel.frame.size.width, height: placeholderLabel.frame.size.height)
    }
    
    override func animateViewsForTextEntry() {
        updateBorder()
        if let activeColor = activeColor {
            performPlacerholderAnimationWithColor(activeColor)
        }
    }
    
    override func animateViewsForTextDisplay() {
        updateBorder()
        if let inactiveColor = inactiveColor {
            performPlacerholderAnimationWithColor(inactiveColor)
        }
    }
    
    private func performPlacerholderAnimationWithColor(color: UIColor) {
        
        let yOffset:CGFloat = 4
        
        UIView.animateWithDuration(0.15, animations: { () -> Void in
            self.placeholderLabel.transform = CGAffineTransformMakeTranslation(0, -yOffset)
            self.placeholderLabel.alpha = 0
            }) { (completed) -> Void in
                
                self.placeholderLabel.transform = CGAffineTransformIdentity
                self.placeholderLabel.transform = CGAffineTransformMakeTranslation(0, yOffset)
                
                UIView.animateWithDuration(0.15, animations: {
                    self.placeholderLabel.textColor = color
                    self.placeholderLabel.transform = CGAffineTransformIdentity
                    self.placeholderLabel.alpha = 1
                })
        }
    }
    
    // MARK: - Overrides
        
    override public func editingRectForBounds(bounds: CGRect) -> CGRect {
        let newBounds = CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height - font!.lineHeight + textFieldInsets.y)
        return CGRectInset(newBounds, textFieldInsets.x, 0)
    }
    
    override public func textRectForBounds(bounds: CGRect) -> CGRect {
        let newBounds = CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height - font!.lineHeight + textFieldInsets.y)
        
        return CGRectInset(newBounds, textFieldInsets.x, 0)
    }
    
}
