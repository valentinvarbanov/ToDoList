//
//  ListViewController.swift
//  ToDoList
//
//  Created by Valentin Varbanov on 10/6/15.
//  Copyright © 2015 Valentin Varbanov. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - ViewController Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Public Interface
    
    
    // MARK: - Private
    
    private var names = [String]()
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    struct List {
        static let CellIdentifier = "ItemCell"
    }
    
    
    // MARK: - Actions
    
    @IBAction func addItem(sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Name",
            message: "Add a new name",
            preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .Default) { (action:UIAlertAction) -> Void in
            let textField = alert.textFields!.first
            if let newItem = textField?.text {
                self.names.append(newItem)
                self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.names.indexOf(newItem)!, inSection: 0)], withRowAnimation: .Automatic)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action: UIAlertAction) -> Void in
            
        }
        
        alert.addTextFieldWithConfigurationHandler { (textField: UITextField) -> Void in
            
        }
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func editItems(sender: UIBarButtonItem) {
        tableView.setEditing(!tableView.editing, animated: true)
        switch sender.style {
        case .Plain:
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "editItems:")
            navigationItem.rightBarButtonItem?.enabled = false
        case .Bordered: fallthrough
        case .Done:
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "editItems:")
            navigationItem.rightBarButtonItem?.enabled = true
        }
        
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(List.CellIdentifier, forIndexPath: indexPath)
        
        cell.textLabel?.text = names[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let tmpStorage = names[sourceIndexPath.row]
        names.removeAtIndex(sourceIndexPath.row)
        names.insert(tmpStorage, atIndex: destinationIndexPath.row)
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            names.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    // MARK: - UITableViewDelegate
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
