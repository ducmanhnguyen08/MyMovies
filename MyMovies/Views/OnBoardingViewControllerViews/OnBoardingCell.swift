//
//  OnBoardingCell.swift
//  MyMovies

import UIKit
import Lottie

class OnBoardingCell: UICollectionViewCell {
    
    var onboardingPage: OnboardingPage? {
        didSet {
            guard let page = onboardingPage else { return }
            animatedeLogo.setAnimation(named: page.animationName)
            animatedeLogo.animationSpeed = 1
            animatedeLogo.play()
            textLabel.attributedText = OnBoardingCell.createAttributedText(firstString: page.title + "\n\n", secondString: page.subtitle)
        }
    }
    
    let animatedeLogo: LOTAnimationView = {
        let logo = LOTAnimationView(name: "atm")
        logo.animationSpeed = 0.4
        return logo
    }()
    
    let textLabel: CustomLabel = {
        let label = CustomLabel(frame: .zero, topInset: -50, bottomInset: 0, leftInset: 0, rightInset: 0)
        label.attributedText = createAttributedText(firstString: "Easy to use!\n\n", secondString: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. ")
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews() {
        self.addSubview(animatedeLogo)
        addSubview(textLabel)
        
        animatedeLogo.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 5, paddingRight: 0, width: bounds.width, height: bounds.height / 2)
        textLabel.anchor(top: animatedeLogo.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: bounds.width, height: bounds.height  / 4)
    }
    
    fileprivate static func createAttributedText(firstString: String, secondString: String) -> NSAttributedString {
        
        let firstAttributedString = NSMutableAttributedString(string: firstString, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 25), NSAttributedString.Key.foregroundColor : UIColor.tvShowCellTextColor()])
        firstAttributedString.append(NSMutableAttributedString(string: secondString, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15), NSAttributedString.Key.foregroundColor : UIColor.white]))
        
        return firstAttributedString
    }
}
