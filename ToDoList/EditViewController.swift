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
    @IBOutlet weak var entityExtendedTextField: UITextField!
    @IBOutlet weak var entityDateField: UIDatePicker!
    @IBOutlet weak var entityTitleField: UITextField!
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var dateAndButtonsStackView: UIStackView!
    var existingEntity: ToDoItem?
    var delegate: TodolistViewController?
    @IBAction func CancelPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func SavePressed(_ sender: UIButton) {
        delegate?.EditViewSavePressed(sender: self)
    }
    
    override func viewDidLoad() {
        delegate?.SetupEditView(sender: self)
        if let _ = existingEntity{
            viewTitle.text = "AMMEND OBLIGATION"
            entityTitleField.text = existingEntity!.title!
            entityExtendedTextField.text = existingEntity!.extendedCopy!
            entityDateField.setDate(existingEntity!.date!, animated: true)
            self.view.backgroundColor = UIColor.darkGray
        }
    }
}

protocol EditViewControllerDelegate {
    func SetupEditView(sender: EditViewController)
    func EditViewSavePressed(sender: EditViewController)
}
