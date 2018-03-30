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
    
    //MARK: var
    //var items = ["Pain", "Lait", "jambon"]
    var items2 = [Item]()
    var filterItems = [Item]()
    
    //MARK: var class
    class var documentDirectory : URL{
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    class var dataFileUrl : URL{
        return documentDirectory.appendingPathComponent("List").appendingPathExtension("json")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //createItems()
        searchBarTableView.delegate = self
        loadList()
    }
    
    
    //MARK: func for save and load
    func saveList(){
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let data = try encoder.encode(items2)
            try data.write(to: ListTableViewController.dataFileUrl)
        } catch {
            
        }
    }
    
    func loadList(){
        let decoder = JSONDecoder()
        do {
            let data = try String(contentsOf: ListTableViewController.dataFileUrl, encoding: .utf8).data(using: .utf8)
            items2 = try decoder.decode([Item].self, from: data!)
        } catch {
            
        }
    }
    
    
    //MARK: methods
    /*func createItems(){
        for item in items{
            let newElement = Item(name : item)
            items2.append(newElement)
        }
    }*/

    //MARK: Actions
    
    @IBAction func EditAction(_ sender: Any) {
        tableView.isEditing = !tableView.isEditing
        saveList()
    }
    
    @IBAction func addAction(_ sender: Any) {
        
        let alertController = UIAlertController(title: "DoIt", message: "New Item", preferredStyle: .alert )
        let  okAction = UIAlertAction( title:"Ok", style: .default){ (action) in
            let textField = alertController.textFields![0]
            
            if(textField.text != ""){
                let item = Item(name: textField.text!)
                self.items2.append(item)
                self.tableView.reloadData()
                self.saveList()
            }
            
        }
        
        alertController.addTextField{(textField) in
            textField.placeholder = "Name"
        }
        
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension ListTableViewController : UITableViewDataSource, UITableViewDelegate{
    
    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(filterItems.isEmpty && searchBarTableView.text == ""){
            return items2.count
        }else{
           return filterItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListViewCellIdentifier")
        
        let item : Item
        if(filterItems.isEmpty && searchBarTableView.text == ""){
            item = items2[indexPath.row]
        }else{
            item = filterItems[indexPath.row]
        }
        
        cell?.accessoryType = item.checked ? .checkmark : .none
        
        cell?.textLabel?.text = item.name
        return cell!
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let sourceItem = items2.remove(at: sourceIndexPath.row)
        
        items2.insert(sourceItem, at: destinationIndexPath.row)
    }
    
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item : Item
        if(filterItems.isEmpty && searchBarTableView.text == ""){
            item = items2[indexPath.row]
        }else{
            item = filterItems[indexPath.row]
        }
        
        item.checked = !item.checked
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
        saveList()
    }
    
    /*func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return items2.count > 1
    }*/
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if(filterItems.isEmpty){
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        items2.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        saveList()
    }
    
}

extension ListTableViewController : UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filterItems = items2.filter { (item) -> Bool in
            return item.name.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }
    
}
