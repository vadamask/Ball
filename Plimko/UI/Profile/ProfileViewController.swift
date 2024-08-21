import Photos
import UIKit

final class ProfileViewController: BaseViewController {
    
    private let service = AchievementsService.shared
    private var achievements: [Achievement] = []
    
    private let profileBackground: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.image = UIImage(named: R.Background.midFrame.rawValue)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let profileLabel: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: R.Label.profile.rawValue)
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        button.setImage(UIImage(named: R.Button.back.rawValue), for: .normal)
        button.setImage(UIImage(named: R.Button.back.rawValue), for: .highlighted)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private lazy var profileIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: R.Icon.profile.rawValue)
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.white.cgColor
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileImageTapped)))
        return view
    }()
    
    private let name: UITextView = {
        let view = UITextView()
        view.returnKeyType = .done
        view.textAlignment = .center
        view.textContainerInset = UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 0)
        view.layer.cornerRadius = 12
        view.backgroundColor = .white
        view.textColor = UIColor(hex: "#FD7B0E")
        view.font = UIFont(name: "Moul-Regular", size: 20)
        return view
    }()
    
    private let bio: UITextView = {
        let view = UITextView()
        view.returnKeyType = .done
        view.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        view.backgroundColor = .clear
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1
        
        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle,
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "Moul-Regular", size: 15) as Any
        ]
        let attributedText = NSAttributedString(string: "Enter bio", attributes: attributes)
        view.attributedText = attributedText
        
        return view
    }()
    
    private let achivLabel: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: R.Label.achiev.rawValue)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.isPagingEnabled = true
        
        return view
    }()
    
    private lazy var leftButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        button.setImage(UIImage(named: R.Button.left.rawValue), for: .normal)
        button.setImage(UIImage(named: R.Button.left.rawValue), for: .highlighted)
        
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private lazy var rightButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        button.setImage(UIImage(named: R.Button.right.rawValue), for: .normal)
        button.setImage(UIImage(named: R.Button.right.rawValue), for: .highlighted)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private let achievementsPerPage: CGFloat = 4
    private var pagesCount: CGFloat {
        (CGFloat(achievements.count) / achievementsPerPage).rounded(.down)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        if case .notDetermined = status {
            PHPhotoLibrary.requestAuthorization(for: .readWrite, handler: {_ in})
        }
        achievements = service.getAchievements()
        setupUI()
        setupAchievements()
    }

    
    @objc private func backButtonTapped() {
        MainRouter.shared.pop(animated: false)
    }
    
    @objc private func leftButtonTapped() {
        let newPoint = CGPoint(x: scrollView.contentOffset.x - scrollView.bounds.width, y: 0)
        if newPoint.x < 0 {
            scrollView.setContentOffset(CGPoint(x: scrollView.bounds.width * pagesCount, y: 0), animated: true)
        } else {
            scrollView.setContentOffset(newPoint, animated: true)
        }
    }
    
    @objc private func rightButtonTapped() {
        let newPoint = CGPoint(x: scrollView.contentOffset.x + scrollView.bounds.width, y: 0)
        if newPoint.x > scrollView.bounds.width * 2 {
            scrollView.setContentOffset(CGPoint.zero, animated: true)
        } else {
            scrollView.setContentOffset(newPoint, animated: true)
        }
    }
}

// MARK: - UI

extension ProfileViewController {
    private func setupUI() {
        view.setDismissKeyboardOnTap()
        name.delegate = self
        name.text = UserDefaults.standard.string(forKey: "username") ?? "Player"
        
        let data = UserDefaults.standard.data(forKey: "profileImage")
        if let data {
            profileIcon.image = UIImage(data: data)
        }
        
        view.addSubview(profileBackground)
        view.addSubview(profileLabel)
        view.addSubview(backButton)
        view.addSubview(leftButton)
        view.addSubview(rightButton)
        
        profileBackground.addSubview(profileIcon)
        profileBackground.addSubview(name)
        profileBackground.addSubview(bio)
        profileBackground.addSubview(achivLabel)
        profileBackground.addSubview(scrollView)
        
        profileBackground
            .activateAnchors()
            .leadingAnchor(16)
            .trailingAnchor(-16)
            .heightAnchor(to: view.heightAnchor, multiplier: 0.45)
            .centerYToSuperview(-20)
        
        profileLabel
            .activateAnchors()
            .centerXToSuperview()
            .bottomAnchor(to: profileBackground.topAnchor, constant: -16)
            .widthAnchor(to: view.widthAnchor, multiplier: 0.9)
            .aspectRatio(width: 1, height: 3)
        
        backButton
            .activateAnchors()
            .centerXToSuperview()
            .topAnchor(to: profileBackground.bottomAnchor, constant: 10)
            .widthAnchor(to: view.widthAnchor, multiplier: 0.5)
            .heightAnchor(60)
        
        profileIcon
            .activateAnchors()
            .leadingAnchor(30)
            .topAnchor(30)
            .dimensionAnchors(width: 120, height: 120)
        
        name
            .activateAnchors()
            .topAnchor(to: profileIcon.topAnchor)
            .trailingAnchor(-30)
            .leadingAnchor(to: profileIcon.trailingAnchor, constant: 16)
            .heightAnchor(40)
        
        bio
            .activateAnchors()
            .leadingAnchor(to: name.leadingAnchor)
            .trailingAnchor(to: name.trailingAnchor)
            .topAnchor(to: name.bottomAnchor, constant: 5)
            .bottomAnchor(to: profileIcon.bottomAnchor)
        
        achivLabel
            .activateAnchors()
            .topAnchor(to: profileIcon.bottomAnchor, constant: 15)
            .centerXToSuperview()
            .widthAnchor(to: profileBackground.widthAnchor, multiplier: 0.8)
            .aspectRatio(width: 1, height: 5)
        
        scrollView
            .activateAnchors()
            .topAnchor(to: achivLabel.bottomAnchor)
            .leadingAnchor(to: leftButton.trailingAnchor, constant: 1)
            .trailingAnchor(to: rightButton.leadingAnchor, constant: -1)
            .bottomAnchor(-20)
        
        leftButton
            .activateAnchors()
            .centerYAnchor(to: scrollView.centerYAnchor)
            .leadingAnchor(to: profileBackground.leadingAnchor, constant: -10)
            .dimensionAnchors(width: 50, height: 50)
        
        rightButton
            .activateAnchors()
            .centerYAnchor(to: scrollView.centerYAnchor)
            .trailingAnchor(to: profileBackground.trailingAnchor, constant: 10)
            .dimensionAnchors(width: 50, height: 50)
    }
    
    private func setupAchievements() {
        var previousView: UIView = scrollView
        var previousAnchor = scrollView.leadingAnchor
        
        for achiev in achievements.enumerated() {
            let view = UIImageView()
            view.isUserInteractionEnabled = true
            view.contentMode = .scaleAspectFit
            view.tag = achiev.offset + 1
            view.image = UIImage(named: achiev.element.imageName)
            view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(achievementTapped)))
            
            scrollView.addSubview(view)
            view
                .activateAnchors()
                .leadingAnchor(to: previousAnchor)
                .centerYToSuperview()
                .widthAnchor(to: scrollView.widthAnchor, multiplier: 0.25)
            
            previousAnchor = view.trailingAnchor
            previousView = view
        }
        previousView.trailingAnchor(-1)
    }
    
    @objc private func achievementTapped(_ sender: UITapGestureRecognizer) {
        if let view = sender.view as? UIImageView,
           let achievement = service.achievement(by: view.tag) {
            
            if achievement.isLocked {
                let controller = UIAlertController(title: "", message: "Complete levels to unlock this achievement.", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .cancel) { _ in }
                controller.addAction(action)
                present(controller, animated:  true)
            } else {
                MainRouter.shared.showDetailAchievement(id: view.tag)
            }
        }
    }
    
    @objc private func profileImageTapped() {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .photoLibrary
        present(controller, animated:  true)
    }
}

// MARK: - Text view delegate

extension ProfileViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        UserDefaults.standard.setValue(textView.text, forKey: "username")
    }
}

// MARK: - Image picker delegate

extension ProfileViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            profileIcon.image = image
            
            let data = image.jpegData(compressionQuality: 0.5)
            UserDefaults.standard.setValue(data, forKey: "profileImage")
            
            dismiss(animated: true)
        }
    }
}
