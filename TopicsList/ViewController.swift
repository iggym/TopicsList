//
//  ViewController.swift
//  TopicsList
//
//  Created by Iggy  on 4/30/17.
//  Copyright © 2017 Iggy Mwangi. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    // topics is the model for the table view,  a mutable array holding NSManagedObject values displayed by the table view.
    var topics: [NSManagedObject] = [] //
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "The List" //title on the navigation bar
        
        //register the UITableViewCell class with the table view.
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "Cell")
        
        loadDatafromDatabase()
    }

    @IBAction func addTopic(_ sender: UIBarButtonItem) {
        addNewTopic()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return topics.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            
            let topic = topics[indexPath.row]
            let cell =
                tableView.dequeueReusableCell(withIdentifier: "Cell",
                                              for: indexPath)
            cell.textLabel?.text =
                topic.value(forKeyPath: "title") as? String
            return cell
    }
}

// MARK: - Add a new Topic
extension ViewController {
    // Implement the addName IBAction
     func addNewTopic() {
        
        let alert = UIAlertController(title: "New Topic",
                                      message: "Add a new topic",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) {
                                        [unowned self] action in
                                        
                                        guard let textField = alert.textFields?.first,
                                            let topicToSave = textField.text else {
                                                return
                                        }
                                        
                                        //self.topics.append(nameToSave)
                                        self.save(topicTitle: topicToSave)
                                        self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func save(topicTitle: String) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // get your  NSManagedObjectContext.
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // create a new managed object and insert it into the managed object context.
        let entity =
            NSEntityDescription.entity(forEntityName: "Topic",
                                       in: managedContext)!
        
        let topic = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        //  set the title attribute using key-value coding.
        topic.setValue(topicTitle, forKeyPath: "title")
        
        // commit your changes to topics and save to disk by calling save on the managed object context.
        do {
            try managedContext.save()
            // insert the new managed object into the topics array so it shows up when the table view reloads.
            topics.append(topic)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
}
// MARK : Load data from database
extension ViewController {
    
    func loadDatafromDatabase() {
        // get the application delegate to use to get a reference to its persistent container
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        // use reference to its persistent container to get NSManagedObjectContext.
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // fetches all objects
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Topic")
        
        //managed object context returns an array of managed objects meeting the criteria specified by the fetch request
        do {
            topics = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
}

