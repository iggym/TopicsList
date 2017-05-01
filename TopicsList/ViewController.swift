//
//  ViewController.swift
//  TopicsList
//
//  Created by Iggy  on 4/30/17.
//  Copyright © 2017 Iggy Mwangi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    // topics is the model for the table view,  a mutable array holding string values displayed by the table view.
    var topics: [String] = [] //
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "The List" //title on the navigation bar
        
        //register the UITableViewCell class with the table view.
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "Cell")
    }

    @IBAction func addTopic(_ sender: UIBarButtonItem) {
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
            
            let cell =
                tableView.dequeueReusableCell(withIdentifier: "Cell",
                                              for: indexPath)
            cell.textLabel?.text = topics[indexPath.row]
            return cell
    }
}

