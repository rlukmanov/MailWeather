//
//  CustomSearchBar.swift
//  MailWeather
//
//  Created by Ruslan Lukmanov on 21.11.2020.
//

import UIKit

@IBDesignable
class CustomSearchBar: UISearchBar {
    
    @IBInspectable
    var textfieldBackgroundColor: UIColor? {
        didSet {
            if let textfield = value(forKey: "searchField") as? UITextField {
                textfield.backgroundColor = textfieldBackgroundColor
            }
        }
    }
    
    @IBInspectable
    var placeholderColor: UIColor? {
        didSet {
            if let textfield = value(forKey: "searchField") as? UITextField {
                textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : placeholderColor ?? .white])
            }
        }
    }
    
    @IBInspectable
    var imageBackgroundColor: UIColor? {
        didSet {
            if let textfield = value(forKey: "searchField") as? UITextField {
                if let leftView = textfield.leftView as? UIImageView {
                    leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
                    leftView.tintColor = imageBackgroundColor
                }
            }
        }
    }
    
    @IBInspectable
    var textColor: UIColor? {
        didSet {
            if let textField = value(forKey: "searchField") as? UITextField {
                textField.textColor = textColor
            }
        }
    }
}
