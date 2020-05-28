//
//  CustomButton.swift
//  MyMovies

import UIKit

class CustomButton: UIButton {
    override open var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? UIColor.mainColor() : UIColor.clear
            if isSelected {
                setTitleColor(.white, for: .normal)
            } else {
                setTitleColor(.darkGray, for: .normal)
            }
        }
    }
}
