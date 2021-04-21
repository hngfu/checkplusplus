//
//  ToDoTableViewCell.swift
//  CheckPlusPlus
//
//  Created by 조재흥 on 2021/04/15.
//

import UIKit
import RxSwift
import Lottie

final class ToDoTableViewCell: UITableViewCell {
    
    static let identifier = "toDoTableViewCell"
    
    var disposeBag = DisposeBag()

    @IBOutlet weak var toDoContentLabel: UILabel!
    @IBOutlet weak var checkBoxAnimationView: AnimationView!
    let tapGestureRecognizer = UITapGestureRecognizer()
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    //MARK: - Private
    private func setup() {
        checkBoxAnimationView.addGestureRecognizer(tapGestureRecognizer)
    }
}
