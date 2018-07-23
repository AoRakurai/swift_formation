//
//  MasterViewController.swift
//  fail2
//
//  Created by Guillaume Malo on 2018-07-20.
//  Copyright © 2018 Guillaume Malo. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    
    @IBOutlet var cancelButton: UIBarButtonItem!
    var detailViewController: DetailViewController? = nil
    var objects = [Champion]()
    let searchController = UISearchController(searchResultsController: nil)
    var filteredObjects = [Champion]()
    var sortMode = "A-Z"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Champion"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        navigationItem.searchController = searchController
        definesPresentationContext = true
        insertChampions()
        reloadData()
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        insertChampions()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Back button
    @IBAction func backBtnClick(button:UIBarButtonItem){
        dismiss(animated:true)
    }
    
    // Champion list management
    func setChampions(){
        var i = 0
        for champion in DataManager.shared.championList{
            if !DataManager.shared.userChampionList.contains { $0.name == champion.name }{
                objects.insert(champion, at: i)
                let indexPath = IndexPath(row: i, section: 0)
                tableView.insertRows(at: [indexPath], with: .automatic)
                i+=1
            }
        }
        //filterContentForSearchText()
    }

    func insertChampions() {
        var i = 0
        for champion in DataManager.shared.championList{
            if !(DataManager.shared.userChampionList.contains { $0.name == champion.name } || objects.contains { $0.name == champion.name }){
                objects.insert(champion, at: i)
                let indexPath = IndexPath(row: i, section: 0)
                tableView.insertRows(at: [indexPath], with: .automatic)
                i+=1
            }
        }
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
                let controller = (segue.destination as! UINavigationController).topViewController as! UserChampionTableViewController
                controller.insertChampion(champion:object)
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let object: Champion
        if isFiltering() {
            object = filteredObjects[indexPath.row]
        } else {
            object = objects[indexPath.row]
        }
        DataManager.shared.AddChampionToList(champion: object)
        dismiss(animated:true)
    }
    
    func reloadData(){
        filterContentForSearchText(searchController.searchBar.text!)
        sort(sortMode: sortMode)
        tableView.reloadData()
    }
}

extension MasterViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        reloadData()
    }
}

