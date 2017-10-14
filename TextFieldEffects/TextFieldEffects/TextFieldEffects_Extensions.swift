//
//  TextFieldEffects_Extensions.swift
//  TextFieldEffects
//
//  Created by José Lucas Souza das Chagas on 21/07/17.
//  Copyright © 2017 Raul Riera. All rights reserved.
//

import Foundation


public extension TextFieldEffects{
    
    
    /**
     Call this method to determine if leftView is being presented to user or not
     */
    public func isPresentingLeftView()->Bool{
        return isPresentingView(isLeftView: true)
    }
    
    /**
     Call this method to determine if rightView is being presented to user or not
     */
    public func isPresentingRightView()->Bool{
        return isPresentingView(isLeftView: false)
    }
    
    final private func isPresentingView(isLeftView:Bool)->Bool{
        let mode = isLeftView ? leftViewMode : rightViewMode
        let view:UIView? = isLeftView ? leftView : rightView
        
        guard let sideView = view else{
            return false
        }
        
        var isEmpty = true
        if let text = text{
            isEmpty = text.isEmpty
        }
        
        if sideView.isHidden || mode == .never{
            return false
        }
        else{
            let stepOne = self.isEditing && mode == .whileEditing
            let stepTwo = (!self.isEditing || isEmpty) && mode == .unlessEditing
            
            return stepOne || stepTwo || mode == .always
        }
        
    }
    
}
