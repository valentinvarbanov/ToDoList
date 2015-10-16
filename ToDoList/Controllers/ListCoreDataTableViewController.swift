//
//  ListCoreDataTableViewController.swift
//  ToDoList
//
//  Created by Valentin Varbanov on 10/15/15.
//  Copyright © 2015 Valentin Varbanov. All rights reserved.
//

import UIKit
import CoreData

class ListCoreDataTableViewController: CoreDataTableViewController {

    // MARK: - ViewController Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        managedObjectContext = delegate.managedObjectContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Public Interface
    
    var managedObjectContext: NSManagedObjectContext! {
        didSet {
            let request = NSFetchRequest(entityName: List.CoreData.EntityName)
            request.sortDescriptors = [NSSortDescriptor(key: List.CoreData.SortDescriptor, ascending: true)]
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        }
    }
    
    // MARK: - Private
    
//    private var names = [String]()
    
    struct List {
        static let CellIdentifier = "ItemCell"
        struct CoreData {
            static let EntityName = "Item"
            static let SortDescriptor = "orderNumber"
        }
    }
    
    // MARK: - Outlets
    
    // MARK: - Actions
    
    @IBAction func addItem(sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Name",
            message: "Add a new name",
            preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .Default) { (action:UIAlertAction) -> Void in
            let textField = alert.textFields!.first
            if let newItem = textField?.text {
                let item = NSEntityDescription.insertNewObjectForEntityForName(List.CoreData.EntityName, inManagedObjectContext: self.managedObjectContext) as! Item
                item.name = newItem
                let lastItem = (self.fetchedResultsController!.sections![0].objects!.last) as! Item
                item.orderNumber = lastItem.orderNumber!.integerValue + 1
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
        NSLog("Number of rows: \(self.tableView(tableView, numberOfRowsInSection: 0))")
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
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(List.CellIdentifier, forIndexPath: indexPath)
        let item = fetchedResultsController?.objectAtIndexPath(indexPath)
        cell.textLabel?.text = item?.name
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            managedObjectContext.deleteObject((fetchedResultsController?.objectAtIndexPath(indexPath))! as! NSManagedObject)
        }
    }
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        
        userDrivenDataModelChange = true
        
        var list = fetchedResultsController?.fetchedObjects as! [Item]
        let itemToMove = list[sourceIndexPath.row]
        list.removeAtIndex(sourceIndexPath.row)
        list.insert(itemToMove, atIndex: destinationIndexPath.row)
        
        for (index, object) in list.enumerate() {
            let item = object 
            item.orderNumber = index
        }
        
        (UIApplication.sharedApplication().delegate as! AppDelegate).saveContext()
        
        userDrivenDataModelChange = false
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
