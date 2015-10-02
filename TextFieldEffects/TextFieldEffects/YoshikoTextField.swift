//
//  YoshikoTextField.swift
//  TextFieldEffects
//
//  Created by Keenan Cassidy on 01/10/2015.
//  Copyright © 2015 Raul Riera. All rights reserved.
//

import UIKit

@IBDesignable public class YoshikoTextField: TextFieldEffects {

    private let borderLayer = CALayer()
    private let textFieldInsets = CGPoint(x: 6, y: 0)
    private let placeHolderInsets = CGPoint(x: 6, y: 0)
    private let outerBackgroundView = UIView()

    @IBInspectable public var borderSize: CGFloat = 2.0 {
        didSet {
            updateBorder()
        }
    }

    @IBInspectable dynamic public var activeColor: UIColor = .blueColor() {
        didSet {
            updateBorder()
            updateBackground()
            updatePlaceholder()
        }
    }

    @IBInspectable dynamic public var inActiveColor: UIColor = .lightGrayColor() {
        didSet {
            updateBorder()
            updateBackground()
            updatePlaceholder()
        }
    }

    @IBInspectable dynamic public var outerBackgroundColor: UIColor = .lightGrayColor() {
        didSet {
            updateBorder()
            updateBackground()
            updatePlaceholder()
        }
    }

    @IBInspectable dynamic public var activeInnerBackgroundColor: UIColor = .clearColor() {
        didSet {
            updateBorder()
            updateBackground()
            updatePlaceholder()
        }
    }

    @IBInspectable dynamic public var placeholderColor: UIColor = .darkGrayColor() {
        didSet {
            updateBorder()
            updateBackground()
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
        borderLayer.borderColor = (isFirstResponder() || text!.isNotEmpty) ? activeColor.CGColor : inActiveColor.CGColor
    }

    private func updateBackground() {
        outerBackgroundView.frame = CGRect(origin: bounds.origin, size: CGSize(width: bounds.width, height: placeholderHeight))
        outerBackgroundView.backgroundColor = outerBackgroundColor

        if !subviews.contains(outerBackgroundView) {
            addSubview(outerBackgroundView)
        }

        if isFirstResponder() || text!.isNotEmpty {
            backgroundColor = activeInnerBackgroundColor
        } else {
            backgroundColor = inActiveColor
        }
    }

    private func updatePlaceholder() {
        placeholderLabel.frame = placeholderRectForBounds(bounds)
        placeholderLabel.text = placeholder
//        placeholderLabel.font = placeholderFontFromFontWithPercentageOfSize(font!, percentageOfSize: 0.7)
        placeholderLabel.textAlignment = textAlignment

        if isFirstResponder() || text!.isNotEmpty {
            placeholderLabel.textColor = activeColor
        } else {
            placeholderLabel.textColor = placeholderColor
        }
    }

    private func placeholderFontFromFontWithPercentageOfSize(font: UIFont, percentageOfSize: CGFloat) -> UIFont! {
        let smallerFont = UIFont(name: font.fontName, size: font.pointSize * percentageOfSize)
        return smallerFont
    }

    private func rectForBounds(bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x, y: bounds.origin.y + placeholderHeight, width: bounds.size.width, height: bounds.size.height - placeholderHeight)
    }

    private var placeholderHeight : CGFloat {
        return placeHolderInsets.y + placeholderFontFromFontWithPercentageOfSize(font!, percentageOfSize: 0.7).lineHeight;
    }

    // MARK: - Overrides

    override public var bounds: CGRect {
        didSet {
            updateBorder()
            updatePlaceholder()
            updateBackground()
        }
    }

    override public func drawViewsForRect(rect: CGRect) {
        updatePlaceholder()
        updateBorder()
        updateBackground()

        addSubview(placeholderLabel)
        layer.addSublayer(borderLayer)
    }

    override public func animateViewsForTextEntry() {
//        placeholderLabel.font = placeholderFontFromFontWithPercentageOfSize(font!, percentageOfSize: 0.5)
        UIView.animateWithDuration(0.3) { () -> Void in

            self.placeholderLabel.font = self.placeholderFontFromFontWithPercentageOfSize(self.font!, percentageOfSize: 0.5)
            self.updatePlaceholder()
            self.updateBorder()
            self.updateBackground()
        }
    }

    override public func animateViewsForTextDisplay() {
//        placeholderLabel.font = placeholderFontFromFontWithPercentageOfSize(font!, percentageOfSize: 0.7)
        UIView.animateWithDuration(0.3) { () -> Void in
            self.placeholderLabel.font = self.placeholderFontFromFontWithPercentageOfSize(self.font!, percentageOfSize: 0.7)
            self.updatePlaceholder()
            self.updateBorder()
            self.updateBackground()
        }
    }

    // MARK: - TextFieldEffects Overrides

    /*public override func placeholderRectForBounds(bounds: CGRect) -> CGRect {
        if isFirstResponder() || text!.isNotEmpty {
            return CGRectMake(placeHolderInsets.x, placeHolderInsets.y, bounds.width, placeholderHeight)
        } else {
            return textRectForBounds(bounds)
        }
    }*/

    public override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return textRectForBounds(bounds)
    }

    override public func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectOffset(bounds, textFieldInsets.x, textFieldInsets.y + placeholderHeight/2)
    }
}
