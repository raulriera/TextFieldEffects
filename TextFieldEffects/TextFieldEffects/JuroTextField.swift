//
//  JuroTextField.swift
//  TextFieldEffects
//
//  Created by darktit on 15/8/6.
//  Copyright (c) 2015年 Raul Riera. All rights reserved.
//

import UIKit

@IBDesignable public class JuroTextField: TextFieldEffects {
  
  @IBInspectable public var outerColor : UIColor? {
    didSet {
      updateOuterColor()
    }
  }
  
  @IBInspectable public var placeholderColor: UIColor? {
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
      drawViewsForRect(bounds)
    }
  }
  
  private let backgroundView = UIView()
  private let innerInset : CGFloat = 6.0
  private let foregroundView = UIView()
  private let textFieldInsets = CGPoint(x: 5, y: 6)
  
  
  override func drawViewsForRect(rect: CGRect) {
    
    
    
    let frame = CGRect(origin: CGPointZero, size: CGSize(width: rect.size.width, height: rect.size.height))
    
    backgroundView.backgroundColor = outerColor
    backgroundView.frame = frame
    backgroundView.userInteractionEnabled = false
    
    foregroundView.backgroundColor = UIColor.whiteColor()
    foregroundView.frame = frame
    foregroundView.userInteractionEnabled = false
    
    
    placeholderLabel.backgroundColor = UIColor.clearColor()
    placeholderLabel.font = font
    placeholderLabel.frame = CGRectInset(frame, innerInset * 3, innerInset * 3)
    placeholderLabel.textColor = placeholderColor

    
    
    updateOuterColor()
    updatePlaceholder()
    
    if !text.isEmpty || isFirstResponder() {
      animateViewsForTextEntry()
    }
    
    addSubview(backgroundView)
    addSubview(foregroundView)
    addSubview(placeholderLabel)
    
    
  }
  
  private func placeholderFontFromFont(font: UIFont) -> UIFont! {
    let smallerFont = UIFont(name: font.fontName, size: font.pointSize * 0.6)
    return smallerFont
  }
  
  // MARK - TextFieldsEffectsProtocol
  
  override func animateViewsForTextEntry() {
    UIView.animateWithDuration(0.55, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.3, options: UIViewAnimationOptions.BeginFromCurrentState, animations: { (_) -> Void in

      self.foregroundView.frame = CGRect(origin: CGPoint(x: self.innerInset, y: CGRectGetMaxY(self.bounds) * 0.4), size: CGSize(width: self.frame.width - (self.innerInset * 2), height: (self.bounds.height * 0.6) - self.innerInset))
      self.placeholderLabel.font = self.placeholderFontFromFont(self.font)
      self.placeholderLabel.textColor = UIColor.whiteColor()
      self.placeholderLabel.frame = CGRect(origin: CGPoint(x: self.innerInset, y: self.innerInset), size: CGSize(width: self.bounds.width - (self.innerInset * 2), height: (self.bounds.height) * 0.4 - self.innerInset))
      
      
    }) { (_) -> Void in
      
    }
  }
  
  override func animateViewsForTextDisplay() {
    if text.isEmpty {
      UIView.animateWithDuration(0.55, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.3, options: UIViewAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
        self.foregroundView.frame = self.bounds
        self.placeholderLabel.font = self.font
        self.placeholderLabel.textColor = self.placeholderColor
        self.placeholderLabel.frame = CGRectInset(self.bounds, self.innerInset * 3, self.innerInset * 3)
        }) { (_) -> Void in
          
      }
    }
  }
  
  private func updateOuterColor() {
    backgroundView.backgroundColor = outerColor
  }
  
  private func updatePlaceholder() {
    placeholderLabel.text = placeholder
    placeholderLabel.textColor = placeholderColor
  }
  
  // MARK - overrides
  
  public override func textRectForBounds(bounds: CGRect) -> CGRect {
    
    let frame = CGRect(origin: CGPoint(x: innerInset, y: CGRectGetMaxY(bounds) * 0.4), size: CGSize(width: bounds.width - (innerInset * 2), height: (bounds.height * 0.6) - innerInset))

    return CGRectOffset(frame,textFieldInsets.x, textFieldInsets.y)

  }
  
  public override func editingRectForBounds(bounds: CGRect) -> CGRect {
   
    return textRectForBounds(bounds)

  }
}
