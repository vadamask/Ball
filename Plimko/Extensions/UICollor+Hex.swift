import UIKit

extension UIColor {
    
    public convenience init(hex: String) {
        self.init(hex: hex, alpha: 1)
    }
    
    public convenience init(hex: String, alpha: CGFloat) {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

         if cString.hasPrefix("#") {
             cString.remove(at: cString.startIndex)
         }

        if cString.count != 6 { fatalError() }

         var rgbValue: UInt64 = 0
         Scanner(string: cString).scanHexInt64(&rgbValue)
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    var htmlRGB: String {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        if getRed(&r, green: &g, blue: &b, alpha: &a) {
            return String(format: "#%02x%02x%02x", Int(r * 255), Int(g * 255), Int(b * 255))
        }
        return String(format: "#%02x%02x%02x", 0, 0, 0)
    }
}

private extension UIColor {
    static func substring(str: String, _ from: Int) -> String {
        return (str as NSString).substring(from: from)
    }
}

extension UIColor {
    static var random: UIColor {
        return .init(hue: .random(in: 0...1), saturation: 1, brightness: 1, alpha: 1)
    }
}

