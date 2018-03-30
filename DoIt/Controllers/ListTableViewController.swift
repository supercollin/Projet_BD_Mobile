//
//  ViewController.swift
//  DoIt
//
//  Created by iem on 30/03/2018.
//  Copyright © 2018 iem. All rights reserved.
//

import UIKit

class ListTableViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var searchBarTableView: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: DataManager
    let dataManager : DataManager = DataManager.shared
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBarTableView.delegate = self
    }

    //MARK: Actions
    
    @IBAction func EditAction(_ sender: Any) {
        tableView.isEditing = !tableView.isEditing
        dataManager.saveListInFile()
    }
    
    @IBAction func addAction(_ sender: Any) {
        
        let alertController = UIAlertController(title: "DoIt", message: "New Item", preferredStyle: .alert )
        let  okAction = UIAlertAction( title:"Ok", style: .default){ (action) in
            
            let textField = alertController.textFields![0]
            
            if(textField.text != ""){
                self.dataManager.AddItem(name: textField.text!)
                self.tableView.reloadData()
                
                self.dataManager.saveListInFile()
            }
            
            if(self.searchBarTableView.text != ""){
                self.dataManager.filterBy(name: self.searchBarTableView.text!.lowercased())
                self.tableView.reloadData()
            }
            
        }
        
        alertController.addTextField{(textField) in
            textField.placeholder = "Name"
        }
        
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}


//MARK: Extension UITableViewDataSource, UITableViewDelegate
extension ListTableViewController : UITableViewDataSource, UITableViewDelegate{
    
    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(dataManager.filterItems.isEmpty && searchBarTableView.text == ""){
            return dataManager.items.count
        }else{
           return dataManager.filterItems.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListViewCellIdentifier")
        
        let item : Item
        if(dataManager.filterItems.isEmpty && searchBarTableView.text == ""){
            item = dataManager.items[indexPath.row]
        }else{
            item = dataManager.filterItems[indexPath.row]
        }
        
        cell?.accessoryType = item.checked ? .checkmark : .none
        
        cell?.textLabel?.text = item.name
        return cell!
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        dataManager.moveItem(from: sourceIndexPath.row, To: destinationIndexPath.row)
    }
    
    
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item : Item
        if(dataManager.filterItems.isEmpty && searchBarTableView.text == ""){
            item = dataManager.items[indexPath.row]
        }else{
            item = dataManager.filterItems[indexPath.row]
        }
        
        item.checked = !item.checked
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        dataManager.saveListInFile()
        
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        
        return dataManager.filterItems.isEmpty
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        dataManager.items.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
        dataManager.saveListInFile()
        
    }
    
}

//MARK: Extension UISearchBarDelegate
extension ListTableViewController : UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        dataManager.filterBy(name: searchText)
        tableView.reloadData()
        
    }
    
}
