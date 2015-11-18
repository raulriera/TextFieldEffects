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
@IBDesignable public class MadokaTextField: TextFieldEffects {
    
    /**
     The color of the placeholder text.
     
     This property applies a color to the complete placeholder string. The default value for this property is a black color.
     */
    @IBInspectable dynamic public var placeholderColor: UIColor = .blackColor() {
        didSet {
            updatePlaceholder()
        }
    }
    
    /**
     The color of the border.
     
     This property applies a color to the lower edge of the control. The default value for this property is a clear color.
     */
    @IBInspectable dynamic public var borderColor: UIColor? {
        didSet {
            updateBorder()
        }
    }
    
    /**
     The scale of the placeholder font.
     
     This property determines the size of the placeholder label relative to the font size of the text field.
     */
    @IBInspectable dynamic public var placeholderFontScale: CGFloat = 0.65 {
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
            updatePlaceholder()
        }
    }
    
    private let borderThickness: CGFloat = 1
    private let placeholderInsets = CGPoint(x: 6, y: 6)
    private let textFieldInsets = CGPoint(x: 6, y: 6)
    private let borderLayer = CAShapeLayer()
    private var backgroundLayerColor: UIColor?
    
    // MARK: - TextFieldsEffects
    
    override public func drawViewsForRect(rect: CGRect) {
        let frame = CGRect(origin: CGPointZero, size: CGSize(width: rect.size.width, height: rect.size.height))
        
        placeholderLabel.frame = CGRectInset(frame, placeholderInsets.x, placeholderInsets.y)
        placeholderLabel.font = placeholderFontFromFont(font!)
        
        updateBorder()
        updatePlaceholder()
        
        layer.addSublayer(borderLayer)
        addSubview(placeholderLabel)        
    }
    
    override public func animateViewsForTextEntry() {
        borderLayer.strokeEnd = 1
        
        UIView.animateWithDuration(0.3, animations: {
            let translate = CGAffineTransformMakeTranslation(-self.placeholderInsets.x, self.placeholderLabel.bounds.height + (self.placeholderInsets.y * 2))
            let scale = CGAffineTransformMakeScale(0.9, 0.9)
            
            self.placeholderLabel.transform = CGAffineTransformConcat(translate, scale)
        })
    }
    
    override public func animateViewsForTextDisplay() {
        if text!.isEmpty {
            borderLayer.strokeEnd = percentageForBottomBorder()
            
            UIView.animateWithDuration(0.3, animations: {
                self.placeholderLabel.transform = CGAffineTransformIdentity
            })
        }
    }
    
    // MARK: - Private
    
    private func updateBorder() {
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
        
        if isFirstResponder() || text!.isNotEmpty {
            animateViewsForTextEntry()
        }
    }
    
    private func placeholderFontFromFont(font: UIFont) -> UIFont! {
        let smallerFont = UIFont(name: font.fontName, size: font.pointSize * placeholderFontScale)
        return smallerFont
    }
    
    private func rectForBorder(bounds: CGRect) -> CGRect {
        let newRect = CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height - font!.lineHeight + textFieldInsets.y)
        
        return newRect
    }
    
    private func layoutPlaceholderInTextRect() {
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
