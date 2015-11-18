//
//  JiroTextField.swift
//  TextFieldEffects
//
//  Created by Raúl Riera on 24/01/2015.
//  Copyright (c) 2015 Raul Riera. All rights reserved.
//

import UIKit

/**
 A JiroTextField is a subclass of the TextFieldEffects object, is a control that displays an UITextField with a customizable visual effect around the background of the control.
 */
@IBDesignable public class JiroTextField: TextFieldEffects {
    
    /**
     The color of the border.
     
     This property applies a color to the lower edge of the control. The default value for this property is a clear color.
     */
    @IBInspectable dynamic public var borderColor: UIColor? {
        didSet {
            updateBorder()
        }
    }
    
    /**
     The color of the placeholder text.
     
     This property applies a color to the complete placeholder string. The default value for this property is a black color.
     */
    @IBInspectable dynamic public var placeholderColor: UIColor = .blackColor() {
        didSet {
            updatePlaceholder()
        }
    }
    
    /**
     The scale of the placeholder font.
     
     This property determines the size of the placeholder label relative to the font size of the text field.
     */
    @IBInspectable dynamic public var placeholderFontScale: CGFloat = 0.65 {
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
    
    private let borderThickness: CGFloat = 2
    private let placeholderInsets = CGPoint(x: 8, y: 8)
    private let textFieldInsets = CGPoint(x: 8, y: 12)
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
        borderLayer.frame.origin = CGPoint(x: 0, y: font!.lineHeight)
        
        UIView.animateWithDuration(0.2, delay: 0.3, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: .BeginFromCurrentState, animations: ({
            
            self.placeholderLabel.frame.origin = CGPoint(x: self.placeholderInsets.x, y: self.borderLayer.frame.origin.y - self.placeholderLabel.bounds.height)
            self.borderLayer.frame = self.rectForBorder(self.borderThickness, isFilled: true)
            
        }), completion:nil)
    }
    
    override public func animateViewsForTextDisplay() {
        if text!.isEmpty {
            UIView.animateWithDuration(0.35, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 2.0, options: .BeginFromCurrentState, animations: ({
                self.layoutPlaceholderInTextRect()
                self.placeholderLabel.alpha = 1
            }), completion: nil)
            
            borderLayer.frame = rectForBorder(borderThickness, isFilled: false)
        }
    }
    
    // MARK: - Private
    
    private func updateBorder() {
        borderLayer.frame = rectForBorder(borderThickness, isFilled: false)
        borderLayer.backgroundColor = borderColor?.CGColor
    }
    
    private func updatePlaceholder() {
        placeholderLabel.text = placeholder
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.sizeToFit()
        layoutPlaceholderInTextRect()
        
        if isFirstResponder() || text!.isNotEmpty {
            animateViewsForTextEntry()
        }
    }
    
    private func placeholderFontFromFont(font: UIFont) -> UIFont! {
        let smallerFont = UIFont(name: font.fontName, size: font.pointSize * placeholderFontScale)
        return smallerFont
    }
    
    private func rectForBorder(thickness: CGFloat, isFilled: Bool) -> CGRect {
        if isFilled {
            return CGRect(origin: CGPoint(x: 0, y: placeholderLabel.frame.origin.y + placeholderLabel.font.lineHeight), size: CGSize(width: CGRectGetWidth(frame), height: CGRectGetHeight(frame)))
        } else {
            return CGRect(origin: CGPoint(x: 0, y: CGRectGetHeight(frame)-thickness), size: CGSize(width: CGRectGetWidth(frame), height: thickness))
        }
    }
    
    private func layoutPlaceholderInTextRect() {
        
        if text!.isNotEmpty {
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
    
    // MARK: - Overrides
            
    override public func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectOffset(bounds, textFieldInsets.x, textFieldInsets.y)
    }
    
    override public func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectOffset(bounds, textFieldInsets.x, textFieldInsets.y)
    }

}
