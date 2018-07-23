//
//  UserChampionTableViewController.swift
//  fail2
//
//  Created by Guillaume Malo on 2018-07-20.
//  Copyright © 2018 Guillaume Malo. All rights reserved.
//

import UIKit

class UserChampionTableViewController: UITableViewController {
    var detailViewController: DetailViewController? = nil
    var objects = [Champion]()
    let searchController = UISearchController(searchResultsController: nil)
    var filteredObjects = [Champion]()
    var sortMode = "A-Z"
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Champion"        
        navigationItem.searchController = searchController
        definesPresentationContext = true
        updateChampionsList()
        reloadData()
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
        updateChampionsList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateChampionsList() {
        for champion in DataManager.shared.userChampionList{
            if !objects.contains {$0.name == champion.name}{
                insertChampion(champion: champion)
            }
        }
        for champion in objects{
            if !DataManager.shared.userChampionList.contains{$0.name == champion.name}{
                objects.remove(at: DataManager.shared.userChampionList.index{$0.name == champion.name}!)
            }
        }
    }
    
    func insertChampion(champion:Champion){
        let row = filteredObjects.count
        objects.insert(champion, at: row)
        let indexPath = IndexPath(row: row, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    // sort
    @IBAction func sort_button_clicked(button:UIBarButtonItem){
        if sortMode == "A-Z" {
            sortMode = "Z-A"
            button.title = "Z-A"
        } else {
            sortMode = "A-Z"
            button.title = "A-Z"
        }
        reloadData()
    }
    
    func sort(sortMode: String){
        if isFiltering(){
            if sortMode == "A-Z"{
                filteredObjects = filteredObjects.sorted(by:{$0.name < $1.name})
            } else {
                filteredObjects = filteredObjects.sorted(by:{$0.name > $1.name})
            }
        } else  {
            if sortMode == "A-Z"{
                objects = objects.sorted(by:{$0.name < $1.name})
            } else {
                objects = objects.sorted(by:{$0.name > $1.name})
            }
        }
    }
    
    // Search Bar
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String = "") {
        filteredObjects = objects.filter({( champion : Champion) -> Bool in
            return champion.name.lowercased().hasPrefix(searchText.lowercased())
        })
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object: Champion
                if isFiltering() {
                    object = filteredObjects[indexPath.row]
                } else {
                    object = objects[indexPath.row]
                }
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredObjects.count
        }
        return objects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let object: Champion
        if isFiltering() {
            object = filteredObjects[indexPath.row]
        } else {
            object = objects[indexPath.row]
        }
        cell.textLabel!.text = object.name + " " + object.title
        cell.imageView?.image = object.image
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if(isFiltering()){
                DataManager.shared.RemoveChampionFromList(champion: filteredObjects[indexPath.row])
                objects = objects.filter { $0.name != filteredObjects[indexPath.row].name }
                filteredObjects.remove(at: indexPath.row)
            } else {
                DataManager.shared.RemoveChampionFromList(champion: objects[indexPath.row])
                objects.remove(at: indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    func reloadData(){
        filterContentForSearchText(searchController.searchBar.text!)
        sort(sortMode: sortMode)
        tableView.reloadData()
    }
}

extension UserChampionTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        reloadData()
    }
}

