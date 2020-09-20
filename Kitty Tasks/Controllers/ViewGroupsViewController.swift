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
    
    let groupsViewCell = GroupsViewCell()
    var color: String?

    override func viewDidLoad() {
        super.viewDidLoad()

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! GroupsViewCell
        let group = groups[indexPath.row]
        cell.groupTitleLabel.text = group.groupName
        cell.colorPoint.tintColor = groupsViewCell.transformStringTo(color: group.color ?? "Red")
        
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
        let context = getContext()
        let group = groups[indexPath.row]
        
        if editingStyle == .delete {
            context.delete(group)
            groups.remove(at: indexPath.row)
            
            do {
                try context.save()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // MARK: - Core data
    
    private func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let context = getContext()
        let fetchRequest: NSFetchRequest<Group> = Group.fetchRequest()

        do {
            groups = try context.fetch(fetchRequest)
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        
        self.tableView.reloadData()
    }

}
