//
//  TodoCellClass.swift
//  ToDoList
//
//  Created by Olivier Butler on 15/09/2017.
//  Copyright © 2017 Olivier Butler. All rights reserved.
//

import UIKit

class TodoCell: UITableViewCell{
    
    @IBOutlet weak var titleLabel: UILabel!
    var delegate: TodolistViewController?
}

protocol TodoCellDelegate {
}
