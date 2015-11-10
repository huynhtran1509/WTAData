//
//  OtherViewController.swift
//  WTADataExample
//
//  Created by Robert Thompson on 10/15/15.
//  Copyright © 2015 WillowTree, Inc. All rights reserved.
//

import UIKit
import CoreData

extension NSManagedObject : Fetchable
{ }

class OtherViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    private var dataController: DataController?
    
    var persistentStoreURL: NSURL?
    
    private var _fetchedResultsController: NSFetchedResultsController?
    @IBOutlet weak var tableView: UITableView!
    
    private var fetchedResultsController: NSFetchedResultsController {
        get {
            if let frc = _fetchedResultsController
            {
                return frc
            }
            else if let dataController = self.dataController
            {
                do {
                    let frc = try Entity.fetchedResultsController(dataController.context,  sortDescriptors: [NSSortDescriptor(key: "stringAttribute", ascending: true)], delegate: self)
                    _fetchedResultsController = frc
                    try frc.performFetch()
                    return frc
                }
                catch let error as NSError
                {
                    fatalError("\(error.localizedDescription)\n\(error.userInfo)")
                }
            }
            else
            {
                fatalError("Must set dataController before showing this view controller")
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        guard let url = persistentStoreURL else { return }
        let persistentStore = PersistentStore(URL: url)
        dataController = DataController(persistentStores: [persistentStore])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        guard let sections = fetchedResultsController.sections else { return 0 }
        return sections.count
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfoObjectsCount = fetchedResultsController.sections?[section].objects?.count else { return 0 }
        return sectionInfoObjectsCount
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        guard let entity = fetchedResultsController.objectAtIndexPath(indexPath) as? Entity else { return cell }
        cell.textLabel?.text = entity.stringAttribute
        
        return cell
    }

}
