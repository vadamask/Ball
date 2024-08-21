import UIKit

final class LevelView: UIView {
    
    let background: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let number: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(hex: "#FF6500")
        label.font = UIFont(name: "Moul", size: 40)
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ level: Level) {
        number.text = level.id.description
        number.isHidden = level.isLocked
        background.image = UIImage(named: level.isLocked ? "lockLevel" : "star\(level.rating)")
    }
    
    private func setupUI() {
        addSubview(background)
        background.addSubview(number)
        
        background
            .activateAnchors()
            .equalToSuperview()
        
        number
            .activateAnchors()
            .centerXToSuperview()
            .topAnchor()
            .heightAnchor(to: background.heightAnchor, multiplier: 0.8)
    }
}
