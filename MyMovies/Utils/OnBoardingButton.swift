//
//  OnBoardingButton.swift
//  MyMovies


import Foundation
import UIKit

class OnBoaringButton: UIButton {
    override open var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? UIColor.movieTintColor() : UIColor.movieTintColor()
            if isSelected {
                setTitleColor(.white, for: .normal)
            } else {
                setTitleColor(.white, for: .normal)
            }
        }
    }
}
