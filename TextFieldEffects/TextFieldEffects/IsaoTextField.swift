//
//  IsaoTextField.swift
//  TextFieldEffects
//
//  Created by Raúl Riera on 29/01/2015.
//  Copyright (c) 2015 Raul Riera. All rights reserved.
//

import UIKit

/**
 An IsaoTextField is a subclass of the TextFieldEffects object, is a control that displays an UITextField with a customizable visual effect around the lower edge of the control.
 */
@IBDesignable public class IsaoTextField: TextFieldEffects {
    
    /**
     The color of the border when it has no content.
     
     This property applies a color to the lower edge of the control. The default value for this property is a clear color. This value is also applied to the placeholder color.
     */
    @IBInspectable dynamic public var inactiveColor: UIColor? {
        didSet {
            updateBorder()
        }
    }
    
    /**
     The color of the border when it has content.
     
     This property applies a color to the lower edge of the control. The default value for this property is a clear color.
     */
    @IBInspectable dynamic public var activeColor: UIColor? {
        didSet {
            updateBorder()
        }
    }
    
    /**
     The scale of the placeholder font.
     
     This property determines the size of the placeholder label relative to the font size of the text field.
     */
    @IBInspectable dynamic public var placeholderFontScale: CGFloat = 0.7 {
        didSet {
            updatePlaceholder()
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
    
    // MARK: - TextFieldsEffects
    
    override public func drawViewsForRect(rect: CGRect) {
        let frame = CGRect(origin: CGPointZero, size: CGSize(width: rect.size.width, height: rect.size.height))
        
        placeholderLabel.frame = CGRectInset(frame, placeholderInsets.x, placeholderInsets.y)
        placeholderLabel.font = placeholderFontFromFont(font!)
        
        updateBorder()
        updatePlaceholder()
        
        layer.addSublayer(borderLayer)
        addSubview(placeholderLabel)        
    }
    
    override public func animateViewsForTextEntry() {
        updateBorder()
        if let activeColor = activeColor {
            performPlacerholderAnimationWithColor(activeColor)
        }
    }
    
    override public func animateViewsForTextDisplay() {
        updateBorder()
        if let inactiveColor = inactiveColor {
            performPlacerholderAnimationWithColor(inactiveColor)
        }
    }
    
    // MARK: - Private
    
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
        let smallerFont = UIFont(name: font.fontName, size: font.pointSize * placeholderFontScale)
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
    
    private func performPlacerholderAnimationWithColor(color: UIColor) {
        
        let yOffset: CGFloat = 4
        
        UIView.animateWithDuration(0.15, animations: {
            self.placeholderLabel.transform = CGAffineTransformMakeTranslation(0, -yOffset)
            self.placeholderLabel.alpha = 0
            }) { (completed) in
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
