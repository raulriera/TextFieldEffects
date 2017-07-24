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
@IBDesignable open class AkiraTextField : TextFieldEffects {
    
    private let borderSize: (active: CGFloat, inactive: CGFloat) = (1, 2)
    private let borderLayer = CALayer()
    private let textFieldInsets = CGPoint(x: 6, y: 0)
    private let placeholderInsets = CGPoint(x: 6, y: 0)
    
    /**
     The color of the border.
     
     This property applies a color to the bounds of the control. The default value for this property is a clear color.
    */
    @IBInspectable dynamic open var borderColor: UIColor? {
        didSet {
            updateBorder()
        }
    }
    
    /**
     The color of the placeholder text.
     
     This property applies a color to the complete placeholder string. The default value for this property is a black color.
     */
    @IBInspectable dynamic open var placeholderColor: UIColor = .black {
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
    
    override open var bounds: CGRect {
        didSet {
            updateBorder()
        }
    }
    
    // MARK: TextFieldEffects
    
    override open func drawViewsForRect(_ rect: CGRect) {
        updateBorder()
        updatePlaceholder()
        
        addSubview(placeholderLabel)
        layer.addSublayer(borderLayer)
    }
    
    override open func animateViewsForTextEntry() {
        UIView.animate(withDuration: 0.3, animations: {
            self.updateBorder()
            self.updatePlaceholder()
        }, completion: { _ in
            self.animationCompletionHandler?(.textEntry)
        })
    }
    
    override open func animateViewsForTextDisplay() {
        UIView.animate(withDuration: 0.3, animations: {
            self.updateBorder()
            self.updatePlaceholder()
        }, completion: { _ in
            self.animationCompletionHandler?(.textDisplay)
        })
    }
    
    open override func repositionLeftView(CurrentBounds bounds: CGRect) -> CGRect {
        let origin = CGPoint(x: bounds.origin.x + placeholderInsets.x, y: bounds.origin.y + placeholderHeight/2)
        return CGRect(origin: origin, size: bounds.size)
    }
    
    open override func repositionRightView(CurrentBounds bounds: CGRect) -> CGRect {
        let origin = CGPoint(x: bounds.origin.x - placeholderInsets.x, y: bounds.origin.y + placeholderHeight/2)
        return CGRect(origin: origin, size: bounds.size)
    }
    
    open override func repositionClearButton(CurrentBounds bounds: CGRect) -> CGRect {
        let origin = CGPoint(x: bounds.origin.x - placeholderInsets.x, y: bounds.origin.y + placeholderHeight/2)
        return CGRect(origin: origin, size: bounds.size)
    }
    
    // MARK: Private
    
    private func updatePlaceholder() {
        placeholderLabel.frame = placeholderRect(forBounds: bounds)
        placeholderLabel.text = placeholder
        placeholderLabel.font = placeholderFontFromFont(font!)
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.textAlignment = textAlignment
    }
    
    private func updateBorder() {
        borderLayer.frame = rectForBounds(bounds)
        borderLayer.borderWidth = (isFirstResponder || text!.isNotEmpty) ? borderSize.active : borderSize.inactive
        borderLayer.borderColor = borderColor?.cgColor
    }
    
    private func placeholderFontFromFont(_ font: UIFont) -> UIFont! {
        let smallerFont = UIFont(name: font.fontName, size: font.pointSize * placeholderFontScale)
        return smallerFont
    }
    
    private var placeholderHeight : CGFloat {
        return placeholderInsets.y + placeholderFontFromFont(font!).lineHeight
    }
    
    private func rectForBounds(_ bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x, y: bounds.origin.y + placeholderHeight, width: bounds.size.width, height: bounds.size.height - placeholderHeight)
    }
    
    private func correctedBounds(ForBounds bounds:CGRect)->CGRect{
        let correctedBounds = bounds.insetBy(dx: textFieldInsets.x, dy: 0)
        return correctedBounds.offsetBy(dx: 0, dy: textFieldInsets.y + placeholderHeight/2)
    }
    
    // MARK: - Overrides
    
    open override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        if isFirstResponder || text!.isNotEmpty {
            var originX:CGFloat = placeholderInsets.x
            switch textAlignment {
            case .natural,.justified:
                if #available(iOS 9.0, *) {
                    if UIView.userInterfaceLayoutDirection(for: semanticContentAttribute) == .rightToLeft {
                        originX = -originX
                    }
                }
            case .right:
                originX = -originX
            default:
                break
            }
            return CGRect(x: originX, y: placeholderInsets.x/2, width: bounds.width, height: placeholderHeight)
        } else {
            return textRect(forBounds: bounds)
        }
    }
    
    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let fixedBounds = super.editingRect(forBounds: bounds)
        return correctedBounds(ForBounds: fixedBounds)
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        let fixedBounds = super.textRect(forBounds: bounds)
        return correctedBounds(ForBounds: fixedBounds)
    }
}

