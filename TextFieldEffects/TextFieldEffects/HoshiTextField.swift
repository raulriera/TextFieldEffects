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
    
    private let borderThickness: (active: CGFloat, inactive: CGFloat) = (active: 2, inactive: 0.5)
    private let placeholderInsets = CGPoint(x: 0, y: 6)
    private let textFieldInsets = CGPoint(x: 0, y: 12)
    private let inactiveBorderLayer = CALayer()
    private let activeBorderLayer = CALayer()    
    private var activePlaceholderPoint: CGPoint = CGPoint.zero
    
    
    /**
     This UIEdgeInsets must be applied to calculated TextFieldRect and placeholderRect to avoid things like placeholderLaber appearing up or down one of these views
     */
    private var insetsBySideViews:UIEdgeInsets{
        
        if textAlignment == NSTextAlignment.center{
            if isPresentingLeftView() || isPresentingRightView(){
                return UIEdgeInsets(top: 0, left: 5, bottom: 0, right:-5)
            }
            return UIEdgeInsets.zero
        }
        
        return UIEdgeInsets(top: 0, left: isPresentingLeftView() ? 5 : 0, bottom: 0, right: isPresentingRightView() || isPresentingLeftView() ? -5 : 0)
    }

    // MARK: - TextFieldEffects
    
    override open func drawViewsForRect(_ rect: CGRect) {
        let frame = CGRect(origin: CGPoint.zero, size: CGSize(width: rect.size.width, height: rect.size.height))
        
        placeholderLabel.frame = frame.insetBy(dx: placeholderInsets.x, dy: placeholderInsets.y)
        placeholderLabel.font = placeholderFontFromFont(font!)
        
        updateBorder()
        updatePlaceholder()
        
        layer.addSublayer(inactiveBorderLayer)
        layer.addSublayer(activeBorderLayer)
        addSubview(placeholderLabel)
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

		UIView.animate(withDuration: 0.4, animations: {
			self.placeholderLabel.alpha = 1.0
		})

        activeBorderLayer.frame = rectForBorder(borderThickness.active, isFilled: true)
    }
    
    override open func animateViewsForTextDisplay() {
        if text!.isEmpty {
            UIView.animate(withDuration: 0.35, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 2.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: ({
                self.layoutPlaceholderInTextRect()
                self.placeholderLabel.alpha = 1
            }), completion: { _ in
                self.animationCompletionHandler?(.textDisplay)
            })
            
            activeBorderLayer.frame = self.rectForBorder(self.borderThickness.active, isFilled: false)
        }
    }
    
    //New methods, added to fix problems with leftView, rightView and clearButton
    open override func repositionLeftView(CurrentBounds bounds: CGRect) -> CGRect {
        return bounds.offsetBy(dx: textFieldInsets.x, dy: textFieldInsets.y)
    }
    
    open override func repositionRightView(CurrentBounds bounds: CGRect) -> CGRect {
        return bounds.offsetBy(dx: 0, dy: textFieldInsets.y)
    }
    
    open override func repositionClearButton(CurrentBounds bounds: CGRect) -> CGRect {
        return bounds.offsetBy(dx: 0, dy: textFieldInsets.y)
    }

    // MARK: - Private
    
    private func updateBorder() {
        inactiveBorderLayer.frame = rectForBorder(borderThickness.inactive, isFilled: true)
        inactiveBorderLayer.backgroundColor = borderInactiveColor?.cgColor
        
        activeBorderLayer.frame = rectForBorder(borderThickness.active, isFilled: false)
        activeBorderLayer.backgroundColor = borderActiveColor?.cgColor
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
    
    private func rectForBorder(_ thickness: CGFloat, isFilled: Bool) -> CGRect {
        if isFilled {
            return CGRect(origin: CGPoint(x: 0, y: frame.height-thickness), size: CGSize(width: frame.width, height: thickness))
        } else {
            return CGRect(origin: CGPoint(x: 0, y: frame.height-thickness), size: CGSize(width: 0, height: thickness))
        }
    }
    
    private func layoutPlaceholderInTextRect() {        
        let textRect = self.textRect(forBounds: bounds)
        var originX = textRect.origin.x
        
        var x:CGFloat = placeholderLabel.frame.origin.x

        switch self.textAlignment {
        case .natural,.justified:
            if #available(iOS 9.0, *) {
                if UIView.userInterfaceLayoutDirection(for: semanticContentAttribute) == .leftToRight {
                    x = 0
                }
                else{//rightToLeft
                    x = self.frame.width - placeholderLabel.bounds.width - insetsBySideViews.right
                    originX += textRect.size.width - placeholderLabel.bounds.width
                }
            }
        case .left:
            x = 0
        case .center:
            originX += textRect.size.width/2 - placeholderLabel.bounds.width/2
        case .right:
            originX += textRect.size.width - placeholderLabel.bounds.width
            x = self.frame.width - placeholderLabel.bounds.width
        }
        
        
        
        placeholderLabel.frame = CGRect(x: originX, y: textRect.height/2,width: placeholderLabel.bounds.width, height: placeholderLabel.bounds.height)
        
        activePlaceholderPoint = CGPoint(x: x, y: placeholderLabel.frame.origin.y - placeholderLabel.frame.size.height - placeholderInsets.y)

    }
    
    /**
     This method corrects the bounds applying insets when necessary
     */
    private func correctedRect(ForBounds fixedBounds:CGRect)->CGRect{
        let correctedOrigin = CGPoint(x: fixedBounds.origin.x + insetsBySideViews.left, y: fixedBounds.origin.y + insetsBySideViews.top)
        
        let correctedSize = CGSize(width: fixedBounds.width + insetsBySideViews.right, height: fixedBounds.height + insetsBySideViews.bottom)
        
        let correctedBounds = CGRect(origin: correctedOrigin, size:correctedSize)
        
        return correctedBounds.offsetBy(dx: textFieldInsets.x, dy: textFieldInsets.y)
    }
    
    // MARK: - Overrides
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        let fixedBounds = super.editingRect(forBounds: bounds)
        return correctedRect(ForBounds: fixedBounds)
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        let fixedBounds = super.textRect(forBounds: bounds)
        return correctedRect(ForBounds: fixedBounds)
    }
    
}
