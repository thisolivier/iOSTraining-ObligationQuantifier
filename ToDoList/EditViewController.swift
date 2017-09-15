//
//  EditViewController.swift
//  ToDoList
//
//  Created by Olivier Butler on 15/09/2017.
//  Copyright © 2017 Olivier Butler. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {
    @IBOutlet weak var viewTitle: UILabel!
    @IBOutlet weak var entityTitleField: UITextField!
    var delegate: TodolistViewController?
    override func viewDidLoad() {
        delegate?.SetupEditView(sender: self)
    }
}

protocol EditViewControllerDelegate {
    func SetupEditView(sender: EditViewController)
}
