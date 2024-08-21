import UIKit

// MARK: - FRP constraints

extension UIView {
    
    @discardableResult
    func activateAnchors() -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        return self
    }
    
    @discardableResult
    func widthAnchor(to anchor: NSLayoutDimension, multiplier: CGFloat = 1, constant: CGFloat = 0) -> Self {
        widthAnchor.constraint(equalTo: anchor, multiplier: multiplier, constant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func widthToSuperview() -> Self {
        guard let superview else { return self }
        widthAnchor.constraint(equalTo: superview.widthAnchor, multiplier: 1, constant: 0).isActive = true
        return self
    }
    
    @discardableResult
    func heightAnchor(to anchor: NSLayoutDimension, multiplier: CGFloat = 1, constant: CGFloat = 0) -> Self {
        heightAnchor.constraint(equalTo: anchor, multiplier: multiplier, constant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func heightToSuperview() -> Self {
        guard let superview else { return self }
        heightAnchor.constraint(equalTo: superview.heightAnchor, multiplier: 1, constant: 0).isActive = true
        return self
    }
    
    @discardableResult
    func topAnchor(to anchor: NSLayoutYAxisAnchor, constant: CGFloat = 0) -> Self {
        topAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func topAnchor(_ constant: CGFloat = 0) -> Self {
        guard let superview else { return self }
        topAnchor.constraint(equalTo: superview.topAnchor, constant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func leadingAnchor(to anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0) -> Self {
        leadingAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        return self
    } 
    
    @discardableResult
    func leadingAnchor(_ constant: CGFloat = 0) -> Self {
        guard let superview else { return self }
        leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func bottomAnchor(to anchor: NSLayoutYAxisAnchor, constant: CGFloat = 0) -> Self {
        bottomAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func bottomAnchor(_ constant: CGFloat = 0) -> Self {
        guard let superview else { return self }
        bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func trailingAnchor(to anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0) -> Self {
        trailingAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func trailingAnchor(_ constant: CGFloat = 0) -> Self {
        guard let superview else { return self }
        trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func widthAnchor(to anchor: NSLayoutDimension, constant: CGFloat = 0) -> Self {
        widthAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func heightAnchor(to anchor: NSLayoutDimension, constant: CGFloat = 0) -> Self {
        heightAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func widthAnchor(constant: CGFloat) -> Self {
        widthAnchor.constraint(equalToConstant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func widthAnchorLessThanOrEqualTo(to constant: CGFloat) -> Self {
        widthAnchor.constraint(lessThanOrEqualToConstant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func heightAnchor(_ constant: CGFloat) -> Self {
        heightAnchor.constraint(equalToConstant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func heightAnchorLessThanOrEqualTo(to anchor: NSLayoutDimension) -> Self {
        heightAnchor.constraint(lessThanOrEqualTo: anchor).isActive = true
        return self
    }
    
    @discardableResult
    func heightAnchorGreaterThanOrEqualTo(to constant: CGFloat) -> Self {
        heightAnchor.constraint(greaterThanOrEqualToConstant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func widthAnchorGreaterThanOrEqualTo(to constant: CGFloat) -> Self {
        widthAnchor.constraint(greaterThanOrEqualToConstant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func dimensionAnchors(width widthConstant: CGFloat, height heightConstant: CGFloat) -> Self {
        widthAnchor.constraint(equalToConstant: widthConstant).isActive = true
        heightAnchor.constraint(equalToConstant: heightConstant).isActive = true
        return self
    }
    
    @discardableResult
    func dimensionAnchors(size: CGSize) -> Self {
        widthAnchor.constraint(equalToConstant: size.width).isActive = true
        heightAnchor.constraint(equalToConstant: size.height).isActive = true
        return self
    }
    
    @discardableResult
    func centerYAnchor(to anchor: NSLayoutYAxisAnchor, constant: CGFloat = 0) -> Self {
        centerYAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func centerYToSuperview(_ constant: CGFloat = 0) -> Self {
        guard let superview else { return self }
        centerYAnchor.constraint(equalTo: superview.centerYAnchor, constant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func centerXAnchor(to anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0) -> Self {
        centerXAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func centerXToSuperview(_ constant: CGFloat = 0) -> Self {
        guard let superview else { return self }
        centerXAnchor.constraint(equalTo: superview.centerXAnchor, constant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func topAnchorLessThanOrEqualTo(to anchor: NSLayoutYAxisAnchor, constant: CGFloat = 0) -> Self {
        topAnchor.constraint(lessThanOrEqualTo: anchor, constant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func bottomAnchorLessThanOrEqualTo(to anchor: NSLayoutYAxisAnchor, constant: CGFloat = 0) -> Self {
        bottomAnchor.constraint(lessThanOrEqualTo: anchor, constant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func topAnchorGreaterThanOrEqualTo(to anchor: NSLayoutYAxisAnchor, constant: CGFloat = 0) -> Self {
        topAnchor.constraint(greaterThanOrEqualTo: anchor, constant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func bottomAnchorGreaterThanOrEqualTo(to anchor: NSLayoutYAxisAnchor, constant: CGFloat = 0) -> Self {
        bottomAnchor.constraint(greaterThanOrEqualTo: anchor, constant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func trailingAnchorGreaterThanOrEqualTo(to anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0) -> Self {
        trailingAnchor.constraint(greaterThanOrEqualTo: anchor, constant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func trailingAnchorLessThanOrEqualTo(to anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0) -> Self {
        trailingAnchor.constraint(lessThanOrEqualTo: anchor, constant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func leadingAnchorGreaterThanOrEqualTo(to anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0) -> Self {
        leadingAnchor.constraint(greaterThanOrEqualTo: anchor, constant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func leadingAnchorLessThanOrEqualTo(to anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0) -> Self {
        leadingAnchor.constraint(lessThanOrEqualTo: anchor, constant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func equalToSuperview(_ spacing: CGFloat = 0) -> Self {
        guard let superview else { return self }
        
        self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: spacing).isActive = true
        self.topAnchor.constraint(equalTo: superview.topAnchor, constant: spacing).isActive = true
        self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -spacing).isActive = true
        self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -spacing).isActive = true
        return self
    }
    
    @discardableResult
    func centerToSuperview() -> Self {
        guard let superview else { return self }
        
        self.centerXAnchor.constraint(equalTo: superview.centerXAnchor, constant: 0).isActive = true
        self.centerYAnchor.constraint(equalTo: superview.centerYAnchor, constant: 0).isActive = true
        return self
    }
    
    @discardableResult
    func aspectRatio(width: CGFloat, height: CGFloat) -> Self {
        self.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: width/height).isActive = true
        return self
    }
    
    func clearConstraints() {
        for subview in self.subviews {
            subview.clearConstraints()
        }
        self.removeConstraints(self.constraints)
    }
}

// MARK: - Gestures

extension UIView {
    private var tapGestureRecognizer: UITapGestureRecognizer {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGestureRecognizer.cancelsTouchesInView = false
        return tapGestureRecognizer
    }
    
    
    func setDismissKeyboardOnTap() {
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func dismissKeyboard() {
        endEditing(true)
    }
    
}

// MARK: - Corners

extension UIView {
    enum RoundType {
        case top
        case right
        case left
        case none
        case bottom
        case both
        case rightTop
        case leftTop
    }
    
    func round(with type: RoundType, radius: CGFloat = 5.0) {
        var corners: UIRectCorner
        
        switch type {
        case .top:
            corners = [.topLeft, .topRight]
        case .right:
            corners = [.bottomRight, .topRight]
        case .rightTop:
            corners = [.topRight]
        case .leftTop:
            corners = [.topLeft]
        case .left:
            corners = [.bottomLeft, .topLeft]
        case .none:
            corners = []
        case .bottom:
            corners = [.bottomLeft, .bottomRight]
        case .both:
            corners = [.allCorners]
        }
        
        DispatchQueue.main.async {
            self.layer.mask = nil
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
        }
    }
  
}

