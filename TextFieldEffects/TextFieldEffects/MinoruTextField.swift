//
//  MinoruTextField.swift
//  TextFieldEffects
//
//  Created by Raúl Riera on 27/01/2015.
//  Copyright (c) 2015 Raul Riera. All rights reserved.
//

import UIKit

@IBDesignable class MinoruTextField: UITextField, UITextFieldDelegate {
    
    @IBInspectable var placeholderColor: UIColor = UIColor(red: 106, green: 121, blue: 137, alpha: 1) {
        didSet {
            updatePlaceholder()
        }
    }
    
    override var backgroundColor: UIColor? {
        set {
            backgroundLayerColor = newValue!
        }
        get {
            return backgroundLayerColor
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
    
    private let borderThickness: CGFloat = 1
    private let placeholderLabel = UILabel()
    private let placeholderInsets = CGPoint(x: 6, y: 6)
    private let textFieldInsets = CGPoint(x: 6, y: 6)
    private let borderLayer = CALayer()
    private var backgroundLayerColor: UIColor?
    
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
        borderLayer.frame = rectForBorder(frame)
        borderLayer.backgroundColor = backgroundColor?.CGColor
    }
    
    private func updatePlaceholder() {
        placeholderLabel.text = placeholder
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.sizeToFit()
        layoutPlaceholderInTextRect()
        
        if isFirstResponder() {
            animateViewsForTextEntry()
        }
    }
    
    private func placeholderFontFromFont(font: UIFont) -> UIFont! {
        let smallerFont = UIFont(name: font.fontName, size: font.pointSize * 0.65)
        return smallerFont
    }
    
    private func rectForBorder(bounds: CGRect) -> CGRect {
        var newRect = CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height - font.lineHeight + textFieldInsets.y)
        
        return newRect
    }
    
    private func layoutPlaceholderInTextRect() {
        
        if !text.isEmpty {
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
        placeholderLabel.frame = CGRect(x: originX, y: bounds.height - placeholderLabel.frame.height,
            width: placeholderLabel.frame.size.width, height: placeholderLabel.frame.size.height)
    }
    
    private func animateViewsForTextEntry() {
        borderLayer.borderColor = textColor?.CGColor
        borderLayer.shadowOffset = CGSizeZero
        borderLayer.borderWidth = borderThickness
        borderLayer.shadowColor = textColor?.CGColor
        borderLayer.shadowOpacity = 0.5
        borderLayer.shadowRadius = 1
    }
    
    private func animateViewsForTextDisplay() {
        borderLayer.borderColor = nil
        borderLayer.shadowOffset = CGSizeZero
        borderLayer.borderWidth = 0
        borderLayer.shadowColor = nil
        borderLayer.shadowOpacity = 0
        borderLayer.shadowRadius = 0
    }
    
    // MARK: - Overrides
    
    override func drawRect(rect: CGRect) {
        drawViewsForRect(rect)
    }
    
    override func drawPlaceholderInRect(rect: CGRect) {
        // Don't draw any placeholders
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        let newBounds = rectForBorder(bounds)
        return CGRectInset(newBounds, textFieldInsets.x, 0)
    }
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        let newBounds = rectForBorder(bounds)

        return CGRectInset(newBounds, textFieldInsets.x, 0)
    }
    
    override func prepareForInterfaceBuilder() {
        drawViewsForRect(frame)
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        animateViewsForTextEntry()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        animateViewsForTextDisplay()
    }
}
