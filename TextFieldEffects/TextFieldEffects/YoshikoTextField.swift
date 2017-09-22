//
//  YoshikoTextField.swift
//  TextFieldEffects
//
//  Created by Keenan Cassidy on 01/10/2015.
//  Copyright © 2015 Raul Riera. All rights reserved.
//

import UIKit

/**
 An YoshikoTextField is a subclass of the TextFieldEffects object, is a control that displays an UITextField with a customizable visual effect around the edges and background of the control.
 */
@IBDesignable open class YoshikoTextField: TextFieldEffects {
    private let borderLayer = CALayer()
    private let textFieldInsets = CGPoint(x: 6, y: 0)
    private let placeHolderInsets = CGPoint(x: 6, y: 0)
    
    /**
     The size of the border.
     
     This property applies a thickness to the border of the control. The default value for this property is 2 points.
     */
    @IBInspectable open var borderSize: CGFloat = 2.0 {
        didSet {
            updateBorder()
        }
    }
    
    /**
     The color of the border when it has content.
     
     This property applies a color to the edges of the control. The default value for this property is a clear color.
     */
    @IBInspectable dynamic open var activeBorderColor: UIColor = .clear {
        didSet {
            updateBorder()
            updateBackground()
            updatePlaceholder()
        }
    }
    
    /**
     The color of the border when it has no content.
     
     This property applies a color to the edges of the control. The default value for this property is a clear color.
     */
    @IBInspectable dynamic open var inactiveBorderColor: UIColor = .clear {
        didSet {
            updateBorder()
            updateBackground()
            updatePlaceholder()
        }
    }

    /**
     The color of the input's background when it has content. When it's not focused it reverts to the color of the `inactiveBorderColor`
     
     This property applies a color to the background of the input.
     */
    @IBInspectable dynamic open var activeBackgroundColor: UIColor = .clear {
        didSet {
            updateBackground()
        }
    }
    
    /**
     The color of the placeholder text.
     
     This property applies a color to the complete placeholder string. The default value for this property is a dark gray color.
     */
    @IBInspectable dynamic open var placeholderColor: UIColor = .darkGray {
        didSet {
            updatePlaceholder()
        }
    }
    
    /**
     The scale of the placeholder font.
     
     This property determines the size of the placeholder label relative to the font size of the text field.
     */
    @IBInspectable dynamic open var placeholderFontScale: CGFloat = 0.7 {
        didSet {
            updatePlaceholder()
        }
    }

    override open var placeholder: String? {
        didSet {
            updatePlaceholder()
        }
    }

    // MARK: Private 

    private func updateBorder() {
        borderLayer.frame = rectForBounds(bounds)
        borderLayer.borderWidth = borderSize
        borderLayer.borderColor = (isFirstResponder || text!.isNotEmpty) ? activeBorderColor.cgColor : inactiveBorderColor.cgColor
    }

    private func updateBackground() {
        if isFirstResponder || text!.isNotEmpty {
            borderLayer.backgroundColor = activeBackgroundColor.cgColor
        } else {
            borderLayer.backgroundColor = inactiveBorderColor.cgColor
        }
    }

    private func updatePlaceholder() {
        placeholderLabel.frame = placeholderRect(forBounds: bounds)
        placeholderLabel.text = placeholder
        placeholderLabel.textAlignment = textAlignment

        if isFirstResponder || text!.isNotEmpty {
            placeholderLabel.font = placeholderFontFromFontAndPercentageOfOriginalSize(font: font!, percentageOfOriginalSize: placeholderFontScale * 0.8)
            placeholderLabel.text = placeholder?.uppercased()
            placeholderLabel.textColor = activeBorderColor
        } else {
            placeholderLabel.font = placeholderFontFromFontAndPercentageOfOriginalSize(font: font!, percentageOfOriginalSize: placeholderFontScale)
            placeholderLabel.textColor = placeholderColor
        }
    }

    private func placeholderFontFromFontAndPercentageOfOriginalSize(font: UIFont, percentageOfOriginalSize: CGFloat) -> UIFont! {
        let smallerFont = UIFont(name: font.fontName, size: font.pointSize * percentageOfOriginalSize)
        return smallerFont
    }

    private func rectForBounds(_ bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x, y: bounds.origin.y + placeholderHeight, width: bounds.size.width, height: bounds.size.height - placeholderHeight)
    }

    private var placeholderHeight : CGFloat {
        return placeHolderInsets.y + placeholderFontFromFontAndPercentageOfOriginalSize(font: font!, percentageOfOriginalSize: placeholderFontScale).lineHeight
    }
    
    private func animateViews() {
        UIView.animate(withDuration: 0.2, animations: {
            // Prevents a "flash" in the placeholder
            if self.text!.isEmpty {
                self.placeholderLabel.alpha = 0
            }
            
            self.placeholderLabel.frame = self.placeholderRect(forBounds: self.bounds)
            
        }) { _ in
            self.updatePlaceholder()
            
            UIView.animate(withDuration: 0.3, animations: {
                self.placeholderLabel.alpha = 1
                self.updateBorder()
                self.updateBackground()
            }, completion: { _ in
                self.animationCompletionHandler?(self.isFirstResponder ? .textEntry : .textDisplay)
            })
        }
    }
    
    // MARK: - TextFieldEffects
    
    override open func animateViewsForTextEntry() {
        animateViews()
    }
    
    override open func animateViewsForTextDisplay() {
        animateViews()
    }
    
    // MARK: - Overrides

    override open var bounds: CGRect {
        didSet {
            updatePlaceholder()
            updateBorder()
            updateBackground()
        }
    }

    override open func drawViewsForRect(_ rect: CGRect) {
        updatePlaceholder()
        updateBorder()
        updateBackground()
		
		layer.insertSublayer(borderLayer, at: 0)
        addSubview(placeholderLabel)
    }
    
    open override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        if isFirstResponder || text!.isNotEmpty {
            return CGRect(x: placeHolderInsets.x, y: placeHolderInsets.y, width: bounds.width, height: placeholderHeight)
        } else {
            return textRect(forBounds: bounds)
        }
    }
    
    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.offsetBy(dx: textFieldInsets.x, dy: textFieldInsets.y + placeholderHeight / 2)
    }
    
    // MARK: - Interface Builder
    
    open override func prepareForInterfaceBuilder() {
        placeholderLabel.alpha = 1
    }
    
}
