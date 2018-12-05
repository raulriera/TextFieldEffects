//
//  HoshiTextField.swift
//  TextFieldEffects
//
//  Created by Raúl Riera on 24/01/2015.
//  Copyright (c) 2015 Raul Riera. All rights reserved.
//

import UIKit

/**
 An HoshiTextField is a subclass of the TextFieldEffects object, is a control that displays an UITextField with a customizable visual effect around the lower edge of the control.
 */
@IBDesignable open class HoshiTextField: TextFieldEffects {
    
    /**
     The color of the border when it has no content.
     
     This property applies a color to the lower edge of the control. The default value for this property is a clear color.
     */
    @IBInspectable dynamic open var borderInactiveColor: UIColor? {
        didSet {
            //  borderInactiveColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1)
            updateBorder()
        }
    }
    
    /**
     The color of the border when it has content.
     
     This property applies a color to the lower edge of the control. The default value for this property is a clear color.
     */
    @IBInspectable dynamic open var borderActiveColor: UIColor? {
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
    *///0.65
    @IBInspectable dynamic open var placeholderFontScale: CGFloat = 0.75 {
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
    
    fileprivate let borderThickness: (active: CGFloat, inactive: CGFloat) = (active: 1.2, inactive: 0.8)//0.5 inactive sachin
    fileprivate var placeholderInsets = CGPoint(x: 0, y: 10)
    fileprivate var textFieldInsets = CGPoint(x: 0, y: 20)
    fileprivate let inactiveBorderLayer = CALayer()
    fileprivate let activeBorderLayer = CALayer()    
    fileprivate var activePlaceholderPoint: CGPoint = CGPoint.zero
    @IBInspectable var isDropdownField : Bool = false
    @IBInspectable var isPasswordField : Bool = false
    @IBInspectable var isNormalField : Bool = false
    // MARK: - TextFieldsEffects
    
    override open func drawViewsForRect(_ rect: CGRect) {
        let frame = CGRect(origin: CGPoint.zero, size: CGSize(width: rect.size.width, height: rect.size.height))
        if (UI_USER_INTERFACE_IDIOM() == .pad){
            placeholderInsets = CGPoint(x: 0, y: 12)
            textFieldInsets = CGPoint(x: 0, y: 25)
        }
        if isNormalField {
            textFieldInsets = CGPoint(x: 0, y: 10)
            placeholderInsets = CGPoint(x: 0, y: -10)
            if (text?.isNotEmpty)! {
                self.placeholderLabel.isHidden = true;
            }
        }
        placeholderLabel.frame = frame.insetBy(dx: placeholderInsets.x, dy: placeholderInsets.y)
       
        placeholderLabel.font = placeholderFontFromFont(font!)
        
        updateBorder()
        updatePlaceholder()
        layer.addSublayer(inactiveBorderLayer)
        layer.addSublayer(activeBorderLayer)
        addSubview(placeholderLabel)
    }
    
    func removeBorders(){
        inactiveBorderLayer.frame = CGRect.zero
        activeBorderLayer.frame = CGRect.zero
    }
    
    override open func animateViewsForTextEntry() {
        if text!.isEmpty {
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: .beginFromCurrentState, animations: ({
                self.placeholderLabel.frame.origin = CGPoint(x: 10, y: self.placeholderLabel.frame.origin.y)
                self.placeholderLabel.alpha = 0
            }), completion: { _ in
                self.animationCompletionHandler?(.textEntry)
            })
        }
    
        layoutPlaceholderInTextRect()
        placeholderLabel.frame.origin = activePlaceholderPoint

        UIView.animate(withDuration: 0.2, animations: {
            self.placeholderLabel.alpha = 1// 0.9sachin 18 aug 2016
        })
        if textDidBigin {
            if isNormalField{
                self.placeholderLabel.isHidden = true;
            }
            activeBorderLayer.frame = rectForBorder(borderThickness.active, isFilled: true)
        }
    }
    
    override open func animateViewsForTextDisplay() {
        if text!.isEmpty {
            
            UIView.animate(withDuration: 0.35, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 2.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: ({
                self.layoutPlaceholderInTextRect()
                self.placeholderLabel.alpha = 1
            }), completion: { _ in
                self.animationCompletionHandler?(.textDisplay)
            })
            
            self.activeBorderLayer.frame = self.rectForBorder(self.borderThickness.active, isFilled: false)
        }
        if !textDidBigin {
            if isNormalField{
                self.placeholderLabel.isHidden = text!.isEmpty ? false : true;
            }
            activeBorderLayer.frame = rectForBorder(borderThickness.inactive, isFilled: false)
            
        }
    }
    
    // MARK: - Private
    
    fileprivate func updateBorder() {
        //borderInactiveColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1)
        //borderActiveColor = UIColor(red: 173/255, green: 173/255, blue: 173/255, alpha: 1)
        inactiveBorderLayer.frame = rectForBorder(borderThickness.inactive, isFilled: true)
        inactiveBorderLayer.backgroundColor = borderInactiveColor?.cgColor
        
        activeBorderLayer.frame = rectForBorder(borderThickness.active, isFilled: false)
        activeBorderLayer.backgroundColor = borderActiveColor?.cgColor
    }
    
    fileprivate func updatePlaceholder() {
        placeholderLabel.text = placeholder
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.sizeToFit()
        layoutPlaceholderInTextRect()
        
        if isFirstResponder || text!.isNotEmpty {
            animateViewsForTextEntry()
        }
    }
    
    fileprivate func placeholderFontFromFont(_ font: UIFont) -> UIFont! {
        _ = UIFont(name: font.fontName, size: font.pointSize * placeholderFontScale)
        var newSmallerFont = UIFont(name: "SourceSansPro-Semibold", size: 12)
        if (UI_USER_INTERFACE_IDIOM() == .pad){
            newSmallerFont = UIFont(name: "SourceSansPro-Semibold", size: 14)
        }
        return newSmallerFont
    }
    
    fileprivate func rectForBorder(_ thickness: CGFloat, isFilled: Bool) -> CGRect {
        if isFilled {
            return CGRect(origin: CGPoint(x: 0, y: frame.height-thickness), size: CGSize(width: frame.width, height: thickness))
        } else {
            return CGRect(origin: CGPoint(x: 0, y: frame.height-thickness), size: CGSize(width: 0, height: thickness))
        }
    }

    fileprivate func layoutPlaceholderInTextRect() {        
        let textRect = self.textRect(forBounds: bounds)
        var originX = textRect.origin.x
        switch self.textAlignment {
        case .center:
            originX += textRect.size.width/2 - placeholderLabel.bounds.width/2
        case .right:
            originX += textRect.size.width - placeholderLabel.bounds.width
        default:
            break
        }
        placeholderLabel.frame = CGRect(x: originX, y: textRect.height/2,
            width: placeholderLabel.bounds.width, height: placeholderLabel.bounds.height)
        if isNormalField{
            placeholderLabel.frame = CGRect(x: originX, y: textRect.height/3,
                                            width: placeholderLabel.bounds.width, height: placeholderLabel.bounds.height)
        }
        activePlaceholderPoint = CGPoint(x: placeholderLabel.frame.origin.x, y: placeholderLabel.frame.origin.y - placeholderLabel.frame.size.height - placeholderInsets.y)

    }
    
    // MARK: - Overrides
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        
        var Newbounds = bounds
        if isPasswordField {
            Newbounds.size.width = bounds.size.width-30
        }
        return Newbounds.offsetBy(dx: textFieldInsets.x, dy: textFieldInsets.y-1)//added 1 difference because  text touch line border
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
       var Newbounds = bounds
        if isDropdownField {
            Newbounds.size.width = bounds.size.width-20
        }else if isPasswordField {
            Newbounds.size.width = bounds.size.width-28
        }
        return Newbounds.offsetBy(dx: textFieldInsets.x, dy: textFieldInsets.y-1)
        
       
    }
    
}
