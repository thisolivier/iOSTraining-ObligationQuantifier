//
//  ViewController.swift
//  ToDoList
//
//  Created by Olivier Butler on 14/09/2017.
//  Copyright © 2017 Olivier Butler. All rights reserved.
//

import UIKit
import CoreData

class TodolistViewController: UITableViewController, TodoCellDelegate {
    
    let appContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var allToDoListEntities: [ToDoItem]?
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "modalSegueToEdit", sender: self)
    }
    
    // Fetching existing todo entities from the CoreData
    func fetchAll() -> [ToDoItem]?{
        let requestObject = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDoItem")
        do {
            let results = try appContext.fetch(requestObject)
            return results as? [ToDoItem]
        } catch {
            print("\(error)")
        }
        return nil
    }
    
    // Basic view overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        allToDoListEntities = fetchAll()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Setting table creation
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allToDoListEntities?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newCell = tableView.dequeueReusableCell(withIdentifier: "toDoItem") as! TodoCell
        newCell.delegate = self
        newCell.titleLabel.text = allToDoListEntities![indexPath.row].title
        return newCell
    }


}

