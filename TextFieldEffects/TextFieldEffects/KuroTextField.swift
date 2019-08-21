//
//  KuroTextField.swift
//  TextFieldEffects
//
//  Created by Rahul Mane on 20/08/19.
//  Copyright © 2019 Raul Riera. All rights reserved.
//

import UIKit

@IBDesignable open class KuroTextField: TextFieldEffects {
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
     The color of the border.
     
     This property applies a color to the lower edge of the control. The default value for this property is a clear color.
     */
    @IBInspectable dynamic open var borderColor: UIColor? {
        didSet {
            updateBorder()
        }
    }
    
    /**
     The scale of the placeholder font.
     
     This property determines the size of the placeholder label relative to the font size of the text field.
     */
    @IBInspectable dynamic open var placeholderFontScale: CGFloat = 0.65 {
        didSet {
            updatePlaceholder()
        }
    }
    
    @IBInspectable dynamic open var breakerWidth: CGFloat = 20 {
        didSet {
            updateBorder()
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
            updatePlaceholder()
        }
    }
    
    private let borderThickness: CGFloat = 1
    private let placeholderInsets = CGPoint(x: 0, y: 0)
    private let textFieldInsets = CGPoint(x: 6, y: 6)
    private let borderLayerLeftHalf = CAShapeLayer()
    private let borderLayerRightHalf = CAShapeLayer()
    private var backgroundLayerColor: UIColor?
    
    // MARK: - TextFieldEffects
    
    override open func drawViewsForRect(_ rect: CGRect) {
        let frame = CGRect(origin: CGPoint.zero, size: CGSize(width: rect.size.width, height: rect.size.height))
        
        placeholderLabel.frame = frame.insetBy(dx: placeholderInsets.x, dy: placeholderInsets.y)
        placeholderLabel.font = placeholderFontFromFont(font!)
        
        updateBorder()
        updatePlaceholder()
        
        layer.addSublayer(borderLayerLeftHalf)
        layer.addSublayer(borderLayerRightHalf)
        addSubview(placeholderLabel)
    }
    
    override open func animateViewsForTextEntry() {
        borderLayerRightHalf.position = CGPoint(x: (breakerWidth/2), y: 0)
        borderLayerLeftHalf.position = CGPoint(x: -(breakerWidth/2), y: 0)
        
        self.placeholderLabel.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            let translate = CGAffineTransform(translationX: 0, y: self.placeholderLabel.bounds.height * 2 - 10)
            self.placeholderLabel.transform = translate
            self.placeholderLabel.alpha = 1
        }) { _ in
            self.animationCompletionHandler?(.textEntry)
        }
    }
    
    override open func animateViewsForTextDisplay() {
        if text!.isEmpty {
            borderLayerRightHalf.position = CGPoint(x: 0, y: 0)
            borderLayerLeftHalf.position = CGPoint(x: 0, y: 0)
            
            UIView.animate(withDuration: 0.3, animations: {
                self.placeholderLabel.transform = .identity
            }) { _ in
                self.animationCompletionHandler?(.textDisplay)
            }
        }
    }
    
    // MARK: - Private
    
    private func updateBorder() {
        self.drawRightBorder()
        self.drawLeftBorder()
    }
    
    private func drawRightBorder(){
        let rect = rectForBorder(bounds)
        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.width/2, y: rect.height - borderThickness))
        path.addLine(to: CGPoint(x: rect.width - borderThickness, y: rect.height - borderThickness))
        path.addLine(to: CGPoint(x: rect.width - borderThickness, y: rect.origin.y + borderThickness))
        path.addLine(to: CGPoint(x: rect.width/2 + borderThickness, y: rect.origin.y + borderThickness))
        borderLayerRightHalf.path = path.cgPath
        borderLayerRightHalf.lineCap = .square
        borderLayerRightHalf.lineWidth = borderThickness
        borderLayerRightHalf.fillColor = nil
        borderLayerRightHalf.strokeColor = borderColor?.cgColor
        borderLayerRightHalf.strokeEnd = 1
    }
    
    private func drawLeftBorder(){
        let rect = rectForBorder(bounds)
        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.width/2 + borderThickness, y: rect.origin.y + borderThickness))
        path.addLine(to: CGPoint(x: rect.origin.x + borderThickness, y: rect.origin.y + borderThickness))
        path.addLine(to: CGPoint(x: rect.origin.x + borderThickness, y: rect.height - borderThickness))
        path.addLine(to: CGPoint(x: rect.width/2 + borderThickness, y: rect.height - borderThickness))
        borderLayerLeftHalf.path = path.cgPath
        borderLayerLeftHalf.lineCap = .square
        borderLayerLeftHalf.lineWidth = borderThickness
        borderLayerLeftHalf.fillColor = nil
        borderLayerLeftHalf.strokeColor = borderColor?.cgColor
        borderLayerLeftHalf.strokeEnd = 1
    }
    
    private func updatePlaceholder() {
        placeholderLabel.text = placeholder
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.sizeToFit()
        layoutPlaceholderInTextRect()
        
        if isFirstResponder || text!.isNotEmpty {
            animateViewsForTextEntry()
        }
    }
    
    private func placeholderFontFromFont(_ font: UIFont) -> UIFont! {
        let smallerFont = UIFont(name: font.fontName, size: font.pointSize * placeholderFontScale)
        return smallerFont
    }
    
    private func rectForBorder(_ bounds: CGRect) -> CGRect {
        let newRect = CGRect(x: 0 + breakerWidth, y: 0, width: bounds.size.width - breakerWidth, height: bounds.size.height - font!.lineHeight)
        
        return newRect
    }
    
    private func rectForTextfield(_ bounds: CGRect) -> CGRect {
        let newRect = CGRect(x: 0 + breakerWidth, y: 0, width: bounds.size.width - breakerWidth - textFieldInsets.x, height: bounds.size.height - font!.lineHeight + textFieldInsets.y)

        return newRect
    }
    
    private func layoutPlaceholderInTextRect() {
        placeholderLabel.transform = CGAffineTransform.identity
        
        let textRect = self.textRect(forBounds: bounds)
        let originX = self.bounds.size.width/2 - placeholderLabel.bounds.width/2

        placeholderLabel.frame = CGRect(x: originX, y: textRect.size.height/2 - placeholderLabel.bounds.height/2 - placeholderInsets.y,
                                        width: placeholderLabel.bounds.width, height: placeholderLabel.bounds.height)
    }
    
    // MARK: - Overrides
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        let newBounds = rectForTextfield(bounds)
        return newBounds.insetBy(dx: textFieldInsets.x, dy: 0)
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        let newBounds = rectForTextfield(bounds)
        return newBounds.insetBy(dx: textFieldInsets.x, dy: 0)
    }
}
