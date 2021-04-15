//
//  ToDoTableViewCell.swift
//  CheckPlusPlus
//
//  Created by 조재흥 on 2021/04/15.
//

import UIKit

class ToDoTableViewCell: UITableViewCell {
    static let identifier = "toDoTableViewCell"

    @IBOutlet weak var toDoContentLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
}
