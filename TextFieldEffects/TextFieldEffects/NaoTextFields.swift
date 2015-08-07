//
//  NaoTextFields.swift
//  TextFieldEffects
//
//  Created by darktit on 15/8/7.
//  Copyright (c) 2015年 Raul Riera. All rights reserved.
//

import UIKit

@IBDesignable public class NaoTextFields: TextFieldEffects {
  
  @IBInspectable public var mainColor : UIColor? {
    didSet {
      updateMainColor()
    }
  }
  
  
  override public var placeholder: String? {
    didSet {
      updatePlaceholder()
    }
  }
  
  
  private var animatePath = UIBezierPath()
  private var leftControlPoint : CGPoint?
  private var topControlPoint : CGPoint?
  private var rightControlPoint : CGPoint?
  private let innerInset : CGFloat = 5.0
  
  private lazy var displaylink: CADisplayLink = {
    let displaylink = CADisplayLink(target: self, selector: Selector("updateControlPoint"))
    displaylink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
    return displaylink
    }()
  
  
  private func updateMainColor() {
    placeholderLabel.textColor = mainColor
    mainColor?.setStroke()
    animatePath.stroke()
  }
  
  private func updateControlPoint() {
    
  }
  
  private func updatePlaceholder() {
    placeholderLabel.text = placeholder
    
  }

  
  override func drawViewsForRect(rect: CGRect) {
    let frame = CGRect(origin: CGPointZero, size: CGSize(width: rect.size.width, height: rect.size.height))
    
    animatePath.moveToPoint(CGPoint(x: 0, y: CGRectGetMaxY(frame)))
    animatePath.addLineToPoint(CGPoint(x: CGRectGetMaxX(frame), y: CGRectGetMaxY(frame)))
    
    mainColor?.setStroke()
    animatePath.lineWidth = 3.0
    animatePath.stroke()
    
    placeholderLabel.frame = CGRectOffset(frame, 0, frame.height * 0.25)
    placeholderLabel.textColor = mainColor
    placeholderLabel.font = font
    placeholderLabel.backgroundColor = UIColor.clearColor()
    addSubview(placeholderLabel)
    
  }
  
}
