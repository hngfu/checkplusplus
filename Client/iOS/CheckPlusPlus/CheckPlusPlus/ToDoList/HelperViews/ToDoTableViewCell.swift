//
//  ToDoTableViewCell.swift
//  CheckPlusPlus
//
//  Created by 조재흥 on 2021/04/15.
//

import UIKit
import RxSwift

final class ToDoTableViewCell: UITableViewCell {
    
    static let identifier = "toDoTableViewCell"
    
    var disposeBag = DisposeBag()

    @IBOutlet weak var toDoContentLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
}
