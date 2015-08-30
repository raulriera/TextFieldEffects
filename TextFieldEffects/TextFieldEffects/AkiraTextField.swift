//
//  AkiraTextField.swift
//  TextFieldEffects
//
//  Created by Mihaela Miches on 5/31/15.
//  Copyright (c) 2015 Raul Riera. All rights reserved.
//

import UIKit

@IBDesignable public class AkiraTextField : TextFieldEffects {
    
    private let borderSize : (active: CGFloat, inactive: CGFloat) = (1, 2)
    private let borderLayer = CALayer()
    private let textFieldInsets = CGPoint(x: 6, y: 0)
    private let placeHolderInsets = CGPoint(x: 6, y: 0)
    
    @IBInspectable public var borderColor: UIColor? {
        didSet {
            updateBorder()
        }
    }
    
    @IBInspectable public var placeholderColor: UIColor? {
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
        }
    }
    
    override public func drawViewsForRect(rect: CGRect) {
        updateBorder()
        updatePlaceholder()
        
        addSubview(placeholderLabel)
        layer.addSublayer(borderLayer)
    }
    
    override public func animateViewsForTextEntry() {
        UIView.animateWithDuration(0.3, animations: {
            self.updateBorder()
            self.updatePlaceholder()
        })
    }
    
    override public func animateViewsForTextDisplay() {
        UIView.animateWithDuration(0.3, animations: {
            self.updateBorder()
            self.updatePlaceholder()
        })
    }
    
    private func updatePlaceholder() {
        placeholderLabel.frame = placeholderRectForBounds(bounds)
        placeholderLabel.text = placeholder
        placeholderLabel.font = placeholderFontFromFont(font!)
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.textAlignment = textAlignment
    }
    
    private func updateBorder() {
        borderLayer.frame = rectForBounds(bounds)
        borderLayer.borderWidth = (isFirstResponder() || text!.isNotEmpty) ? borderSize.active : borderSize.inactive
        borderLayer.borderColor = borderColor?.CGColor
    }
    
    private func placeholderFontFromFont(font: UIFont) -> UIFont! {
        let smallerFont = UIFont(name: font.fontName, size: font.pointSize * 0.7)
        return smallerFont
    }
    
    private var placeholderHeight : CGFloat {
        return placeHolderInsets.y + placeholderFontFromFont(font!).lineHeight;
    }
    
    private func rectForBounds(bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x, y: bounds.origin.y + placeholderHeight, width: bounds.size.width, height: bounds.size.height - placeholderHeight)
    }
    
    public override func placeholderRectForBounds(bounds: CGRect) -> CGRect {
        if isFirstResponder() || text!.isNotEmpty {
            return CGRectMake(placeHolderInsets.x, placeHolderInsets.y, bounds.width, placeholderHeight)
        } else {
            return textRectForBounds(bounds)
        }
    }
    
    // MARK: - Overrides
    
    public override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return textRectForBounds(bounds)
    }
    
    override public func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectOffset(bounds, textFieldInsets.x, textFieldInsets.y + placeholderHeight/2)
    }
}

