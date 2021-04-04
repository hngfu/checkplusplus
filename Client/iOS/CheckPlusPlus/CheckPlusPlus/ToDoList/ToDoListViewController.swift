//
//  ToDoListViewController.swift
//  CheckPlusPlus
//
//  Created by 조재흥 on 2021/04/02.
//

import UIKit

final class ToDoListViewController: UIViewController {
    
    var uid: String?

    @IBOutlet weak var uidLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uidLabel.text = uid
    }
}
