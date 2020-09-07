//
//  ViewGroupsViewController.swift
//  Kitty Tasks
//
//  Created by Arina on 07/08/2020.
//  Copyright © 2020 Arina. All rights reserved.
//

import UIKit
import CoreData

class ViewGroupsViewController: UITableViewController {
    
//    var groups = [
//        TaskGroup(title: "Work", color: "Pink"),
//        TaskGroup(title: "Home", color: "Brown"),
//        TaskGroup(title: "Very long name with something", color: "Purple"),
//        TaskGroup(title: "Кириллическая группа", color: "Cyan"),
//        TaskGroup(title: "very very very VERY long name for group really", color: "Yellow")
//    ]
    
    var groups: [Group] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.navigationItem.leftBarButtonItem?.image = UIImage(systemName: "pencil")
    }
    
    
    @IBAction func unwindToGroupView(segue: UIStoryboardSegue) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.viewWillAppear(true)
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return groups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! GroupsViewCell
        let group = groups[indexPath.row]
        cell.groupTitleLabel.text = group.groupName
        
        return cell
    }

    private func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let context = getContext()
        let fetchRequest: NSFetchRequest<Group> = Group.fetchRequest()
        
//        let freq: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Group")
//        let deleteRequest = NSBatchDeleteRequest(fetchRequest: freq)

        do {
            groups = try context.fetch(fetchRequest)
            //try context.execute(deleteRequest)
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        
        self.tableView.reloadData()
        
    }

}
