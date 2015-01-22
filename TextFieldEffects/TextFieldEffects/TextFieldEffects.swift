//
//  TextFieldEffects.swift
//  Swish
//
//  Created by Raúl Riera on 20/01/2015.
//  Copyright (c) 2015 com.raulriera.swishapp. All rights reserved.
//

import UIKit

@IBDesignable class TextFieldEffects: UITextField, UITextFieldDelegate {
    
    @IBInspectable var placeholderColor: UIColor = UIColor(red: 106, green: 121, blue: 137, alpha: 1) {
        didSet {
            updatePlaceholder()
        }
    }
    @IBInspectable var foregroundColor: UIColor = UIColor(red: 239, green: 239, blue: 239, alpha: 1) {
        didSet {
            updateForegroundColor()
        }
    }
    override var placeholder: String? {
        didSet {
            updatePlaceholder()
        }
    }
    private let foregroundView = UIView()
    private let placeholderLabel = UILabel()
    private let placeholderInsets = CGPoint(x: 10, y: 5)
    private let style: TextFieldEffectsStyle = TextFieldEffectsStyle.Kaede
    
    enum TextFieldEffectsStyle: Int {
        case Kaede
        case Yoko // This is hard
        case Hoshi
        case Jiro
        case Madoka
        case Isao
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        drawViewsForRect(self.frame)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        drawViewsForRect(self.frame)
    }
    
    /**
    Draws all the requires view on top of the textfield
    
    :param: rect to based the views from
    */
    private func drawViewsForRect(rect: CGRect) {
        let frame = CGRect(origin: CGPointZero, size: CGSize(width: rect.size.width, height: rect.size.height))
        
        foregroundView.frame = frame
        foregroundView.userInteractionEnabled = false
        placeholderLabel.frame = CGRectInset(frame, placeholderInsets.x, placeholderInsets.y)
        placeholderLabel.font = placeholderFontFromFont(self.font)
        
        updateForegroundColor()
        updatePlaceholder()
        
        self.addSubview(foregroundView)
        self.addSubview(placeholderLabel)
        
        self.delegate = self
    }
    
    private func updateForegroundColor() {
        foregroundView.backgroundColor = foregroundColor
    }
    
    private func updatePlaceholder() {
        placeholderLabel.text = self.placeholder
        placeholderLabel.textColor = placeholderColor
    }
    
    private func placeholderFontFromFont(font: UIFont) -> UIFont! {
        let smallerFont = UIFont(name: font.fontName, size: font.pointSize * 0.8)
        return smallerFont
    }
        
    // MARK: - Overrides
    
    override func drawPlaceholderInRect(rect: CGRect) {
        // Don't draw any placeholders
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        let frame = CGRect(origin: bounds.origin, size: CGSize(width: bounds.size.width * 0.6, height: bounds.size.height))
        
        return CGRectInset(frame, 10, 0)
    }
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        let frame = CGRect(origin: bounds.origin, size: CGSize(width: bounds.size.width * 0.6, height: bounds.size.height))
        
        return CGRectInset(frame, 10, 0)
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        UIView.animateWithDuration(0.35, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 2.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: ({
            self.placeholderLabel.frame.origin = CGPoint(x: self.frame.size.width * 0.65, y: self.placeholderInsets.y)
        }), completion: nil)
        
        UIView.animateWithDuration(0.45, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.5, options: UIViewAnimationOptions.CurveEaseInOut, animations: ({
            self.foregroundView.frame.origin = CGPoint(x: self.frame.size.width * 0.6, y: 0)
        }), completion: nil)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if self.text.isEmpty {
            UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 2.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: ({
                self.placeholderLabel.frame.origin = self.placeholderInsets
            }), completion: nil)
            
            UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 2.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: ({
                self.foregroundView.frame.origin = CGPointZero
            }), completion: nil)
        }

    }
}