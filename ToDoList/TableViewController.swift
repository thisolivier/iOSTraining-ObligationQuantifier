//
//  ViewController.swift
//  ToDoList
//
//  Created by Olivier Butler on 14/09/2017.
//  Copyright © 2017 Olivier Butler. All rights reserved.
//

import UIKit
import CoreData

class TodolistViewController: UITableViewController, TodoCellDelegate, EditViewControllerDelegate {

    
    // ******************************************** //
    // Setting up core variables, initialising view //
    // ******************************************** //
    
    let appContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var allToDoListEntities = [ToDoItem]()
    
    // Actions and Outlets tied to todolist table view (initial view)
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "modalSegueToEdit", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let incomingController = segue.destination as! EditViewController
        incomingController.delegate = self
        print(incomingController)
        super.prepare(for: segue, sender: sender)
    }
    
    // Fetching existing todo entities from the CoreData
    func fetchAll(){
        let requestObject = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDoItem")
        do {
            let results = try appContext.fetch(requestObject)
            allToDoListEntities = results as! [ToDoItem]
        } catch {
            print("\(error)")
        }
    }
    
    // Basic view overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAll()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 200
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // **************** //
    // Setting up table //
    // **************** //
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allToDoListEntities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newCell = tableView.dequeueReusableCell(withIdentifier: "toDoItem") as! TodoCell
        let currentToDoEntity = allToDoListEntities[indexPath.row]
        newCell.delegate = self
        newCell.titleLabel.text = currentToDoEntity.title
        let formattedDate = formatDate(dateObj: currentToDoEntity.date!)
        newCell.dateLabel.text = formattedDate
        newCell.extendedTextItem.text = currentToDoEntity.extendedCopy
        newCell.accessoryType = currentToDoEntity.completed ? .checkmark : .none
        return newCell
    }
    
    func formatDate(dateObj : Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE MMM d, yyyy, HH:mm"
        let dateAsString = formatter.string(from: dateObj)
        return dateAsString
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let theCell = tableView.cellForRow(at: indexPath)
        let theElement = allToDoListEntities[indexPath.row]
        if theElement.completed == false {
            theElement.completed = true
            theCell!.accessoryType = .checkmark
        } else {
            theElement.completed = false
            theCell!.accessoryType = .none
        }
        do{
            try self.appContext.save()
        } catch {
            print ("Error saving completion status, didSelectRowAt")
            print (error)
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") {
            (action, indexPath) in
            let currentEntity = self.allToDoListEntities.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.appContext.delete(currentEntity)
            do {
                try self.appContext.save()
            } catch {
                print(error)
            }
        }
        
        let share = UITableViewRowAction(style: .normal, title: "Edit") {
            (action, indexPath) in
            // share item at indexPath
            self.performSegue(withIdentifier: "modalSegueToEdit", sender: indexPath)
        }
        
        share.backgroundColor = UIColor.blue
        
        return [delete, share]
    }
    
    // *********************************************** //
    // Fulfilling EditViewController delegation duties
    // *********************************************** //
    func SetupEditView(sender: EditViewController) {
        print("We're here and setup")
    }
    
    func EditViewSavePressed(sender: EditViewController) {
        let newToDoEntity = NSEntityDescription.insertNewObject(forEntityName: "ToDoItem", into: appContext) as! ToDoItem
        newToDoEntity.title = sender.entityTitleField.text
        newToDoEntity.date = sender.entityDateField.date
        newToDoEntity.extendedCopy = sender.entityExtendedTextField.text
        newToDoEntity.completed = false
        allToDoListEntities.append(newToDoEntity)
        do{
            try appContext.save()
            print("We saved our new item")
        } catch {
            print("Saving failed from EditViewSavePressed")
            print(error)
        }
        sender.dismiss(animated: true, completion: nil)
        self.tableView.reloadData()
    }
}

