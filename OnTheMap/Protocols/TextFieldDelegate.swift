//
//  TextFieldDelegate.swift
//  OnTheMap
//
//  Created by João Ponte on 28/06/2023.
//

import UIKit

class TextFieldDelegate: NSObject, UITextFieldDelegate, UIGestureRecognizerDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text?.removeAll()
    }
    
    @objc func dismissKeyboard() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
}
