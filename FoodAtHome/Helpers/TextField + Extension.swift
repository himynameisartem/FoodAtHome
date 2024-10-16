//
//  TextFieldExtension.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 26.08.2023.
//

import UIKit

extension UITextField {
    
    func addDoneButtonToKeyboard() {
        
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,
            target: nil,
            action: nil
        )
        let done: UIBarButtonItem = UIBarButtonItem(
            title: "Done".localized(),
            style: UIBarButtonItem.Style.done,
            target: self,
            action: #selector(self.doneButtonAction)
        )
        done.tintColor = .black
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        self.resignFirstResponder()
    }
}
