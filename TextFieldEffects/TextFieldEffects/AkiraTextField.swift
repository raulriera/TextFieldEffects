//
//  AkiraTextField.swift
//  TextFieldEffects
//
//  Created by Mihaela Miches on 5/31/15.
//  Copyright (c) 2015 Raul Riera. All rights reserved.
//

import UIKit

/**
 An AkiraTextField is a subclass of the TextFieldEffects object, is a control that displays an UITextField with a customizable visual effect around the edges of the control.
 */
@IBDesignable public class AkiraTextField : TextFieldEffects {
    
    private let borderSize : (active: CGFloat, inactive: CGFloat) = (1, 2)
    private let borderLayer = CALayer()
    private let textFieldInsets = CGPoint(x: 6, y: 0)
    private let placeHolderInsets = CGPoint(x: 6, y: 0)
    
    /**
     The color of the border.
     
     This property applies a color to the bounds of the control. The default value for this property is a clear color.
    */
    @IBInspectable dynamic public var borderColor: UIColor? {
        didSet {
            updateBorder()
        }
    }
    
    /**
     The color of the placeholder text.
     
     This property applies a color to the complete placeholder string. The default value for this property is a  black color.
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
        }
    }
    
    // MARK: TextFieldEffects
    
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
    
    // MARK: Private
    
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
        let smallerFont = UIFont(name: font.fontName, size: font.pointSize * placeholderFontScale)
        return smallerFont
    }
    
    private var placeholderHeight : CGFloat {
        return placeHolderInsets.y + placeholderFontFromFont(font!).lineHeight;
    }
    
    private func rectForBounds(bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x, y: bounds.origin.y + placeholderHeight, width: bounds.size.width, height: bounds.size.height - placeholderHeight)
    }
    
    // MARK: - Overrides
    
    public override func placeholderRectForBounds(bounds: CGRect) -> CGRect {
        if isFirstResponder() || text!.isNotEmpty {
            return CGRectMake(placeHolderInsets.x, placeHolderInsets.y, bounds.width, placeholderHeight)
        } else {
            return textRectForBounds(bounds)
        }
    }
    
    public override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return textRectForBounds(bounds)
    }
    
    override public func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectOffset(bounds, textFieldInsets.x, textFieldInsets.y + placeholderHeight/2)
    }
}

