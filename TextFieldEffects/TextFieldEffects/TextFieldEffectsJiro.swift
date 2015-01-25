//
//  TextFieldEffectsJiro.swift
//  TextFieldEffects
//
//  Created by Raúl Riera on 24/01/2015.
//  Copyright (c) 2015 Raul Riera. All rights reserved.
//

import UIKit

@IBDesignable class TextFieldEffectsJiro: UITextField, UITextFieldDelegate {
    
    @IBInspectable var borderColor: UIColor = UIColor(red: 106, green: 121, blue: 137, alpha: 1) {
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
    
    private let borderThickness: CGFloat = 2
    private let placeholderLabel = UILabel()
    private let placeholderInsets = CGPoint(x: 8, y: 8)
    private let borderLayer = CALayer()
    
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
        
        layer.addSublayer(borderLayer)
        addSubview(placeholderLabel)
        
        delegate = self
    }
    
    private func updateBorder() {
        borderLayer.frame = rectForBorder(borderThickness, isFill: false)
        borderLayer.backgroundColor = borderColor.CGColor
    }
    
    private func updatePlaceholder() {
        placeholderLabel.text = placeholder
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.sizeToFit()
        layoutPlaceholderInTextRect()
    }
    
    private func placeholderFontFromFont(font: UIFont) -> UIFont! {
        let smallerFont = UIFont(name: font.fontName, size: font.pointSize * 0.65)
        return smallerFont
    }
    
    private func rectForBorder(thickness: CGFloat, isFill: Bool) -> CGRect {
        if isFill {
            return CGRect(origin: CGPoint(x: 0, y: placeholderLabel.frame.origin.y + placeholderLabel.font.lineHeight), size: CGSize(width: CGRectGetWidth(frame), height: CGRectGetHeight(frame)))
        } else {
            return CGRect(origin: CGPoint(x: 0, y: CGRectGetHeight(frame)-thickness), size: CGSize(width: CGRectGetWidth(frame), height: thickness))
        }
    }
    
    private func layoutPlaceholderInTextRect() {
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
    
    override func drawRect(rect: CGRect) {
        drawViewsForRect(rect)
    }
    
    override func drawPlaceholderInRect(rect: CGRect) {
        // Don't draw any placeholders
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectOffset(bounds, 8, 12)
    }
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectOffset(bounds, 8, 12)
    }
    
    override func prepareForInterfaceBuilder() {
        drawViewsForRect(self.frame)
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if self.text.isEmpty {
            
            UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: ({
                
                self.borderLayer.frame.origin = CGPoint(x: 0, y: self.font.lineHeight)
            }), completion: { (completed) -> Void in
                
                UIView.animateWithDuration(0.2, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: ({
                    
                    self.placeholderLabel.frame.origin = CGPoint(x: self.placeholderInsets.x, y: self.borderLayer.frame.origin.y - 20)
                }), completion: { (completed) -> Void in
                    
                    UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: ({
                        
                        self.borderLayer.frame = self.rectForBorder(self.borderThickness, isFill: true)
                    }), completion: nil)
                })
                
            })
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if self.text.isEmpty {
            UIView.animateWithDuration(0.35, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 2.0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: ({
                self.layoutPlaceholderInTextRect()
                self.placeholderLabel.alpha = 1
            }), completion: nil)
            
            UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 2.0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: ({
                self.borderLayer.frame = self.rectForBorder(self.borderThickness, isFill: false)
            }), completion: nil)
        }
        
    }
}
