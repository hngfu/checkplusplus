//
//  PositiveFeedbackView.swift
//  CheckPlusPlus
//
//  Created by 조재흥 on 2021/04/21.
//

import UIKit
import Lottie

final class PositiveFeedbackView: UIView {
    
    func play() {
        guard Setting.shared.setting(with: .shouldShowCheeringCard) else { return }
        guard let feedback = feedbacks.randomElement() else { return }
        commentLabel.text = feedback.comment
        animationView.animation = Animation.named(feedback.animation)
        animationView.loopMode = .loop
        animationView.play()
        isHidden = false
        feedbackGenerator.notificationOccurred(.success)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) { [weak self] in
            UIView.animate(withDuration: 0.16, delay: 0, options: .curveEaseIn) {
                self?.alpha = 0
            } completion: { (_) in
                self?.isHidden = true
                self?.animationView.stop()
                self?.alpha = 1
            }
        }
    }
    
    //MARK: - Private & init
    @UsesAutoLayout
    private var animationView = AnimationView()
    @UsesAutoLayout
    private var commentLabel = UILabel()
    private let feedbackGenerator = UINotificationFeedbackGenerator()
    
    private lazy var feedbacks = { () -> [PositiveFeedback] in
        var feedbacks = [PositiveFeedback]()
        feedbacks.append((animation: "check", comment: "췤!"))
        feedbacks.append((animation: "clap-together", comment: "짝짝짝짝짝짝짝짝짝!!"))
        feedbacks.append((animation: "thumbs-up", comment: "최고!!! 굳굳굳!!!"))
        feedbacks.append((animation: "wow", comment: "당신은 멋진사람!!!!"))
        return feedbacks
    }()
    
    private func setup() {
        isHidden = true
        layer.cornerRadius = 6
        layer.borderColor = UIColor.tertiarySystemGroupedBackground.cgColor
        layer.borderWidth = 2
        addSubview(animationView)
        addSubview(commentLabel)

        animationView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        animationView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        animationView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        animationView.bottomAnchor.constraint(equalTo: commentLabel.topAnchor).isActive = true

        commentLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        commentLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        commentLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        commentLabel.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        commentLabel.textAlignment = .center
        commentLabel.font = commentLabel.font.withSize(25)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private typealias PositiveFeedback = (animation: String, comment: String)
}
