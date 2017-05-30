//
//  MemeTextFieldDelegate.swift
//  PickingImages
//
//  Created by Erik Uecke on 5/30/17.
//  Copyright © 2017 Erik Uecke. All rights reserved.
//

import Foundation
import UIKit

class MemeTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    // Initial edit clears textField
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    // Dismiss keyboard on hitting return 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
}
