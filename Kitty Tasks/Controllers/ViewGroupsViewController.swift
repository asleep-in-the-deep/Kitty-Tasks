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
    
    var group: Group!
    var groups: [Group] = []
    
    var color: String?
    
    let groupViewCell = GroupViewCell()
    
    let dataManager = DataManager()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadGroups()
        self.tableView.reloadData()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true)
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
        return groups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! GroupViewCell
        let group = groups[indexPath.row]
        groupViewCell.setTaskCell(cell: cell, forGroup: group)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let editViewController = storyboard.instantiateViewController(withIdentifier: "newGroup") as! NewGroupViewController
        let navController = UINavigationController(rootViewController: editViewController)
        
        let group: Group! = groups[indexPath.row]
        editViewController.newGroup = group
        self.present(navController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let group = groups[indexPath.row]
        
        if editingStyle == .delete {
            groups.remove(at: indexPath.row)
            dataManager.deleteGroup(for: group)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // MARK: - Core data
    
    func loadGroups() {
        let context = dataManager.getContext()
        let fetchRequest: NSFetchRequest<Group> = Group.fetchRequest()

        do {
            groups = try context.fetch(fetchRequest)
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
    }

}
