import UIKit

final class SkinCell: UICollectionViewCell {
    
    private let background: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: R.Background.skin.rawValue)
        view.contentMode = .scaleToFill
        return view
    }()
    
    private let skin: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 30
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let price: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(hex: "#FF9900")
        label.font = UIFont(name: "Moul-Regular", size: 20)
        return label
    }()
    
    private let star: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: R.Icon.star.rawValue)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let checkmark: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: R.Icon.checkmark.rawValue)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with skin: Skin) {
        self.price.text = skin.price.description
        self.skin.image = UIImage(named: skin.imageName)
        if skin.isBuyed {
            price.isHidden = true
            star.isHidden = true
        } else {
            price.isHidden = false
            star.isHidden = false
        }
        checkmark.isHidden = !skin.isChoosen
    }
    
    private func setupUI() {
        
        contentView.addSubview(background)
        background.addSubview(skin)
        background.addSubview(price)
        background.addSubview(star)
        background.addSubview(checkmark)
        
        background
            .activateAnchors()
            .equalToSuperview()
        
        skin
            .activateAnchors()
            .centerXToSuperview()
            .centerYToSuperview(-15)
            .widthAnchor(to: background.widthAnchor, multiplier: 0.7)
            .aspectRatio(width: 1, height: 1)
        
        price
            .activateAnchors()
            .centerXToSuperview(-10)
            .bottomAnchor()
            .heightAnchor(to: background.heightAnchor, multiplier: 0.3)
        
        star
            .activateAnchors()
            .centerYAnchor(to: price.centerYAnchor)
            .leadingAnchor(to: price.trailingAnchor, constant: 2)
            .dimensionAnchors(width: 20, height: 20)
        
        checkmark
            .activateAnchors()
            .centerXToSuperview()
            .bottomAnchor(-5)
            .heightAnchor(to: background.heightAnchor, multiplier: 0.2)
    }
    
}
