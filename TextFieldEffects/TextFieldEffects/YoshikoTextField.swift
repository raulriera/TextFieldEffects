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
@IBDesignable public class YoshikoTextField: TextFieldEffects {

    private let borderLayer = CALayer()
    private let textFieldInsets = CGPoint(x: 6, y: 0)
    private let placeHolderInsets = CGPoint(x: 6, y: 0)
    
    /**
     The size of the border.
     
     This property applies a thickness to the border of the control. The default value for this property is 2 points.
     */
    @IBInspectable public var borderSize: CGFloat = 2.0 {
        didSet {
            updateBorder()
        }
    }
    
    /**
     The color of the border when it has content.
     
     This property applies a color to the edges of the control. The default value for this property is a clear color.
     */
    @IBInspectable dynamic public var activeBorderColor: UIColor = .clearColor() {
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
    @IBInspectable dynamic public var inactiveBorderColor: UIColor = .clearColor() {
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
    @IBInspectable dynamic public var activeBackgroundColor: UIColor = .clearColor() {
        didSet {
            updateBackground()
        }
    }
    
    /**
     The color of the placeholder text.
     
     This property applies a color to the complete placeholder string. The default value for this property is a  black color.
     */
    @IBInspectable dynamic public var placeholderColor: UIColor = .darkGrayColor() {
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

    // MARK: Private 

    private func updateBorder() {
        borderLayer.frame = rectForBounds(bounds)
        borderLayer.borderWidth = borderSize
        borderLayer.borderColor = (isFirstResponder() || text!.isNotEmpty) ? activeBorderColor.CGColor : inactiveBorderColor.CGColor
    }

    private func updateBackground() {
        if isFirstResponder() || text!.isNotEmpty {
            borderLayer.backgroundColor = activeBackgroundColor.CGColor
        } else {
            borderLayer.backgroundColor = inactiveBorderColor.CGColor
        }
    }

    private func updatePlaceholder() {
        placeholderLabel.frame = placeholderRectForBounds(bounds)
        placeholderLabel.text = placeholder
        placeholderLabel.textAlignment = textAlignment

        if isFirstResponder() || text!.isNotEmpty {
            placeholderLabel.font = placeholderFontFromFontAndPercentageOfOriginalSize(font: font!, percentageOfOriginalSize: placeholderFontScale * 0.8)
            placeholderLabel.text = placeholder?.uppercaseString
            placeholderLabel.textColor = activeBorderColor
        } else {
            placeholderLabel.font = placeholderFontFromFontAndPercentageOfOriginalSize(font: font!, percentageOfOriginalSize: placeholderFontScale)
            placeholderLabel.textColor = placeholderColor
        }
    }

    private func placeholderFontFromFontAndPercentageOfOriginalSize(font font: UIFont, percentageOfOriginalSize: CGFloat) -> UIFont! {
        let smallerFont = UIFont(name: font.fontName, size: font.pointSize * percentageOfOriginalSize)
        return smallerFont
    }

    private func rectForBounds(bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x, y: bounds.origin.y + placeholderHeight, width: bounds.size.width, height: bounds.size.height - placeholderHeight)
    }

    private var placeholderHeight : CGFloat {
        return placeHolderInsets.y + placeholderFontFromFontAndPercentageOfOriginalSize(font: font!, percentageOfOriginalSize: placeholderFontScale).lineHeight
    }
    
    private func animateViews() {
        UIView.animateWithDuration(0.2, animations: {
            self.placeholderLabel.alpha = 0
            self.placeholderLabel.frame = self.placeholderRectForBounds(self.bounds)
            
            }) { complete in
                self.updatePlaceholder()
                UIView.animateWithDuration(0.3, animations: {
                    self.placeholderLabel.alpha = 1
                    self.updateBorder()
                    self.updateBackground()
                })
        }
    }
    
    // MARK: - TextFieldEffects
    
    override public func animateViewsForTextEntry() {
        guard text!.isEmpty else { return }
        
        animateViews()
    }
    
    override public func animateViewsForTextDisplay() {
        guard text!.isEmpty else { return }
        
        animateViews()
    }
    
    // MARK: - Overrides

    override public var bounds: CGRect {
        didSet {
            updatePlaceholder()
            updateBorder()
            updateBackground()
        }
    }

    override public func drawViewsForRect(rect: CGRect) {
        updatePlaceholder()
        updateBorder()
        updateBackground()

        layer.addSublayer(borderLayer)
        addSubview(placeholderLabel)
    }
    
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
        return CGRectOffset(bounds, textFieldInsets.x, textFieldInsets.y + placeholderHeight / 2)
    }
    
    // MARK: - Interface Builder
    
    public override func prepareForInterfaceBuilder() {
        placeholderLabel.alpha = 1
    }
    
}
