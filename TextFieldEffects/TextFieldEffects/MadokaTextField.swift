//
//  MadokaTextField.swift
//  TextFieldEffects
//
//  Created by Raúl Riera on 05/02/2015.
//  Copyright (c) 2015 Raul Riera. All rights reserved.
//

import UIKit
/**
 A MadokaTextField is a subclass of the TextFieldEffects object, is a control that displays an UITextField with a customizable visual effect around the edges of the control.
 */
@IBDesignable open class MadokaTextField: TextFieldEffects {
    
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
    private let placeholderInsets = CGPoint(x: 6, y: 6)
    private let textFieldInsets = CGPoint(x: 6, y: 6)
    private let borderLayer = CAShapeLayer()
    private var backgroundLayerColor: UIColor?
    
    // MARK: - TextFieldEffects
    
    override open func drawViewsForRect(_ rect: CGRect) {
        let frame = CGRect(origin: CGPoint.zero, size: CGSize(width: rect.size.width, height: rect.size.height))
        
        placeholderLabel.frame = frame.insetBy(dx: placeholderInsets.x, dy: placeholderInsets.y)
        placeholderLabel.font = placeholderFontFromFont(font!)
        
        updateBorder()
        updatePlaceholder()
        
        layer.addSublayer(borderLayer)
        addSubview(placeholderLabel)        
    }
    
    override open func animateViewsForTextEntry() {
        borderLayer.strokeEnd = 1
        
        var translationX:CGFloat = self.placeholderInsets.x//self.placeholderLabel.frame.origin.x
        
        switch textAlignment {
        case .natural,.justified:
            if #available(iOS 9.0, *) {
                if UIView.userInterfaceLayoutDirection(for: semanticContentAttribute) == .leftToRight {
                    if let leftView = leftView {
                        translationX += leftView.frame.width + leftView.frame.origin.x
                        if placeholderLabel.layer.position.x - translationX < 0{
                            translationX = self.placeholderInsets.x
                        }
                    }
                }
                else{//rightToLeft
                    if let rightView = rightView{
                        translationX += rightView.frame.width + rightView.frame.origin.x
                    }
                }
            }
        case .left:
            if let leftView = leftView {
                translationX += leftView.frame.width + leftView.frame.origin.x
                if placeholderLabel.layer.position.x - translationX < 0{
                    translationX = self.placeholderInsets.x
                }
            }
        case .right:
            if let rightView = rightView{
                translationX -= (self.frame.width - rightView.frame.origin.x) + placeholderInsets.x
                if placeholderLabel.layer.position.x + placeholderLabel.layer.frame.width/2 - translationX > self.frame.width{
                    translationX = -placeholderInsets.x
                }
            }
            else{
                translationX = 0
            }
        default:
            break
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            //let translate = CGAffineTransform(translationX: -translationX, y: self.placeholderLabel.bounds.height + (self.placeholderInsets.y * 2))
            let translate = CGAffineTransform(translationX: -translationX, y: self.placeholderLabel.bounds.height + self.placeholderLabel.frame.origin.y + self.placeholderInsets.y)

            let scale = CGAffineTransform(scaleX: 0.9, y: 0.9)
            
            self.placeholderLabel.transform = translate.concatenating(scale)
        }) { _ in
            self.animationCompletionHandler?(.textEntry)
        }
    }
    
    override open func animateViewsForTextDisplay() {
        if text!.isEmpty {
            borderLayer.strokeEnd = percentageForBottomBorder()
            
            UIView.animate(withDuration: 0.3, animations: {
                self.placeholderLabel.transform = CGAffineTransform.identity
            }) { _ in
                self.animationCompletionHandler?(.textDisplay)
            }
        }
    }
    
    open override func repositionLeftView(CurrentBounds bounds: CGRect) -> CGRect {
        let origin = CGPoint(x: bounds.origin.x + placeholderInsets.x, y: bounds.origin.y - 2*textFieldInsets.y)
        return CGRect(origin: origin, size: bounds.size)
    }
    
    open override func repositionRightView(CurrentBounds bounds: CGRect) -> CGRect {
        let origin = CGPoint(x: bounds.origin.x - placeholderInsets.x, y: bounds.origin.y - 2*textFieldInsets.y)
        return CGRect(origin: origin, size: bounds.size)
    }
    
    open override func repositionClearButton(CurrentBounds bounds: CGRect) -> CGRect {
        let origin = CGPoint(x: bounds.origin.x - placeholderInsets.x, y: bounds.origin.y - 2*textFieldInsets.y)
        return CGRect(origin: origin, size: bounds.size)
    }

    
    // MARK: - Private
    
    private func updateBorder() {
        let rect = rectForBorder(bounds)
        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.origin.x + borderThickness, y: rect.height - borderThickness))
        path.addLine(to: CGPoint(x: rect.width - borderThickness, y: rect.height - borderThickness))
        path.addLine(to: CGPoint(x: rect.width - borderThickness, y: rect.origin.y + borderThickness))
        path.addLine(to: CGPoint(x: rect.origin.x + borderThickness, y: rect.origin.y + borderThickness))
        path.close()
        borderLayer.path = path.cgPath
        borderLayer.lineCap = kCALineCapSquare
        borderLayer.lineWidth = borderThickness
        borderLayer.fillColor = nil
        borderLayer.strokeColor = borderColor?.cgColor
        borderLayer.strokeEnd = percentageForBottomBorder()
    }
    
    private func percentageForBottomBorder() -> CGFloat {
        let borderRect = rectForBorder(bounds)
        let sumOfSides = (borderRect.width * 2) + (borderRect.height * 2)
        return (borderRect.width * 100 / sumOfSides) / 100
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
        let newRect = CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height - font!.lineHeight + textFieldInsets.y)
        
        return newRect
    }
    
    private func layoutPlaceholderInTextRect() {
        placeholderLabel.transform = CGAffineTransform.identity
        
        let textRect = self.textRect(forBounds: bounds)
        var originX = textRect.origin.x
        switch textAlignment {
        case .natural,.justified:
            if #available(iOS 9.0, *) {
                if UIView.userInterfaceLayoutDirection(for: semanticContentAttribute) == .leftToRight {
                    //originX += textRect.size.width - placeholderLabel.bounds.width
                }
            }
        case .center:
            originX += textRect.size.width/2 - placeholderLabel.bounds.width/2
        case .right:
            originX += textRect.size.width - placeholderLabel.bounds.width
        default:
            break
        }
        
        placeholderLabel.frame = CGRect(x: originX, y: textRect.height/2 - placeholderLabel.bounds.height/2/* - placeholderInsets.y*/,
            width: placeholderLabel.bounds.width, height: placeholderLabel.bounds.height)
    }
    
    // MARK: - Overrides
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        let newBounds = rectForBorder(bounds)
        let fixedBounds = super.editingRect(forBounds: newBounds)
        return fixedBounds.insetBy(dx: textFieldInsets.x, dy: 0)
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        let newBounds = rectForBorder(bounds)
        let fixedBounds = super.textRect(forBounds: newBounds)
        return fixedBounds.insetBy(dx: textFieldInsets.x, dy: 0)
    }
    
}
