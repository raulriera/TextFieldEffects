//
//  MadokaTextField.swift
//  TextFieldEffects
//
//  Created by Raúl Riera on 05/02/2015.
//  Copyright (c) 2015 Raul Riera. All rights reserved.
//

import UIKit

@IBDesignable public class MadokaTextField: TextFieldEffects {
    
    @IBInspectable public var placeholderColor: UIColor? {
        didSet {
            updatePlaceholder()
        }
    }
    
    @IBInspectable public var borderColor: UIColor? {
        didSet {
            updateBorder()
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
            updatePlaceholder()
        }
    }
    
    private let borderThickness: CGFloat = 1
    private let placeholderInsets = CGPoint(x: 6, y: 6)
    private let textFieldInsets = CGPoint(x: 6, y: 6)
    private let borderLayer = CAShapeLayer()
    private var backgroundLayerColor: UIColor?
    
    // MARK: - TextFieldsEffectsProtocol
    
    override func drawViewsForRect(rect: CGRect) {
        let frame = CGRect(origin: CGPointZero, size: CGSize(width: rect.size.width, height: rect.size.height))
        
        placeholderLabel.frame = CGRectInset(frame, placeholderInsets.x, placeholderInsets.y)
        placeholderLabel.font = placeholderFontFromFont(font!)
        
        updateBorder()
        updatePlaceholder()
        
        layer.addSublayer(borderLayer)
        addSubview(placeholderLabel)        
    }
    
    private func updateBorder() {
        //let path = CGPathCreateWithRect(rectForBorder(bounds), nil)
        let rect = rectForBorder(bounds)
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: rect.origin.x + borderThickness, y: rect.height - borderThickness))
        path.addLineToPoint(CGPoint(x: rect.width - borderThickness, y: rect.height - borderThickness))
        path.addLineToPoint(CGPoint(x: rect.width - borderThickness, y: rect.origin.y + borderThickness))
        path.addLineToPoint(CGPoint(x: rect.origin.x + borderThickness, y: rect.origin.y + borderThickness))
        path.closePath()
        borderLayer.path = path.CGPath
        borderLayer.lineCap = kCALineCapSquare
        borderLayer.lineWidth = borderThickness
        borderLayer.fillColor = nil
        borderLayer.strokeColor = borderColor?.CGColor
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
        
        if isFirstResponder() || !text!.isEmpty {
            animateViewsForTextEntry()
        }
    }
    
    private func placeholderFontFromFont(font: UIFont) -> UIFont! {
        let smallerFont = UIFont(name: font.fontName, size: font.pointSize * 0.65)
        return smallerFont
    }
    
    private func rectForBorder(bounds: CGRect) -> CGRect {
        let newRect = CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height - font!.lineHeight + textFieldInsets.y)
        
        return newRect
    }
    
    private func layoutPlaceholderInTextRect() {
        
        if !text!.isEmpty {
            return
        }
        
        placeholderLabel.transform = CGAffineTransformIdentity
        
        let textRect = textRectForBounds(bounds)
        var originX = textRect.origin.x
        switch textAlignment {
        case .Center:
            originX += textRect.size.width/2 - placeholderLabel.bounds.width/2
        case .Right:
            originX += textRect.size.width - placeholderLabel.bounds.width
        default:
            break
        }
        
        placeholderLabel.frame = CGRect(x: originX, y: textRect.height - placeholderLabel.bounds.height - placeholderInsets.y,
            width: placeholderLabel.bounds.width, height: placeholderLabel.bounds.height)
    }
    
    override func animateViewsForTextEntry() {
        borderLayer.strokeEnd = 1
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            let translate = CGAffineTransformMakeTranslation(-self.placeholderInsets.x, self.placeholderLabel.bounds.height + (self.placeholderInsets.y * 2))
            let scale = CGAffineTransformMakeScale(0.9, 0.9)
            
            self.placeholderLabel.transform = CGAffineTransformConcat(translate, scale)
        })
    }
    
    override func animateViewsForTextDisplay() {
        if text!.isEmpty {
            borderLayer.strokeEnd = percentageForBottomBorder()
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.placeholderLabel.transform = CGAffineTransformIdentity
            })
        }
    }
    
    // MARK: - Overrides
    
    override public func editingRectForBounds(bounds: CGRect) -> CGRect {
        let newBounds = rectForBorder(bounds)
        return CGRectInset(newBounds, textFieldInsets.x, 0)
    }
    
    override public func textRectForBounds(bounds: CGRect) -> CGRect {
        let newBounds = rectForBorder(bounds)
        
        return CGRectInset(newBounds, textFieldInsets.x, 0)
    }
    
}
