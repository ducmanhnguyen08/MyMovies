//
//  Utils.swift
//  MyMovies
//
import UIKit
import Foundation
import Alamofire

extension UIWindow {
    static let currentWindow = (UIApplication.shared.delegate as! AppDelegate).window
}


extension UIView {
    func setGradientBackground(firstColor: UIColor, secondColor: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
        gradientLayer.locations = [0.6, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.6, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setGradientBackgroundForTrailer(firstColor: UIColor, secondColor: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.6, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setGradientBackgroundForFavouriteIcon(firstColor: UIColor, secondColor: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
}

extension UserDefaults {
    enum UserDefaultKey: String{
        case isLoggedIn
    }
    func setUserLoggedIn(value: Bool) {
        UserDefaults.standard.set(value, forKey: UserDefaultKey.isLoggedIn.rawValue)
        UserDefaults.standard.synchronize()
    }
    func isLoggedIn() -> Bool {
        return bool(forKey: UserDefaultKey.isLoggedIn.rawValue)
    }
}


extension String: ParameterEncoding {
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
    
}

extension UILabel {
    func addCharactersSpacing(spacing:CGFloat, text:String) {
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: spacing, range: NSMakeRange(0, text.count))
        self.attributedText = attributedString
    }
}


extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }
    
    static func trailerNameBackgroundColor() -> UIColor {
        return UIColor.rgb(red: 10, green: 11, blue: 15)
    }
    
    static func trailerNameColor() -> UIColor {
        return UIColor.rgb(red: 165, green: 165, blue: 165)
    }
    
    static func movieTintColor() -> UIColor {
        return UIColor.rgb(red: 238, green: 23, blue: 87)
    }
    
    static func dimBackgroundColor() -> UIColor {
        return UIColor.rgb(red: 38, green: 45, blue: 50)
    }
    
    static func mainColor() -> UIColor {
        return UIColor.rgb(red: 22, green: 25, blue: 30)
    }
    
    static func tvShowTintColor() -> UIColor {
        return UIColor.rgb(red: 71, green: 209, blue: 243)
    }
    
    static func watchListTintColor() -> UIColor {
        return UIColor.rgb(red: 78, green: 242, blue: 192)
    }
    
    static func userProfileTintColor() -> UIColor {
        return UIColor.rgb(red: 162, green: 82, blue: 229)
    }
    
    static func tvShowCellTextColor() -> UIColor {
        return UIColor.rgb(red: 97, green: 99, blue: 107)
    }
    
    static func lowerViewBgColor() -> UIColor {
        return UIColor.rgb(red: 42, green: 42, blue: 42)
    }
    
    static func onBoardTitle() -> UIColor {
        return UIColor.rgb(red: 158, green: 158, blue: 158)
    }
    
    static func onBoardText() -> UIColor {
        return UIColor(white: 0, alpha: 0.7)
    }
    
    static func pageControlTintColor() -> UIColor {
        return UIColor.rgb(red: 204, green: 204, blue: 204)
    }
    
    static func tvShowOddCellBackgroundColor() -> UIColor {
        return UIColor.rgb(red: 17, green: 18, blue: 21)
    }
    
    static func tvShowEvenCellBackgroundColor() -> UIColor {
        return UIColor.rgb(red: 12, green: 13, blue: 15)
    }
    
    static func optionCellDividerColor() -> UIColor {
        return UIColor.rgb(red: 36, green: 36, blue: 39)
    }

}

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top {
            self.topAnchor.constraint(equalTo: top,  constant: paddingTop).isActive = true
        }
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        if let right = right {
            self.rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        if width != 0 {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if height != 0 {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
    }
}

extension UIFont {
    func sizeOfString (string: String, constrainedToWidth width: Double) -> CGSize {
        let attributes = [NSAttributedString.Key.font:self,]
        let attString = NSAttributedString(string: string,attributes: attributes)
        let framesetter = CTFramesetterCreateWithAttributedString(attString)
        return CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRange(location: 0,length: 0), nil, CGSize(width: width, height: Double.greatestFiniteMagnitude), nil)
    }
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}






