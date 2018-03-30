//
//  DataManager.swift
//  DoIt
//
//  Created by iem on 30/03/2018.
//  Copyright © 2018 iem. All rights reserved.
//

import Foundation

class DataManager : DataManagerProtocol{
    
    static let shared = DataManager()
    
    //MARK: Var
    var items = [Item]()
    var filterItems = [Item]()
    
    //MARK: Var class
    class var documentDirectory : URL{
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    class var dataFileUrl : URL{
        return documentDirectory.appendingPathComponent("List").appendingPathExtension("json")
    }
    
    //MARK:Init
    private init() {
        loadListinFile()
    }
    
    //MARK: Func for save and load in file
    func saveListInFile(){
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let data = try encoder.encode(items)
            try data.write(to: DataManager.dataFileUrl)
        } catch {
            
        }
    }
    
    func loadListinFile(){
        let decoder = JSONDecoder()
        do {
            let data = try String(contentsOf: DataManager.dataFileUrl, encoding: .utf8).data(using: .utf8)
            items = try decoder.decode([Item].self, from: data!)
        } catch {
            
        }
    }
    
    //MARK: Method
    func AddItem (name : String){
        let item = Item(name : name)
        items.append(item)
    }
    
    func filterBy(name: String){
        filterItems = items.filter { (item) -> Bool in
            return item.name.lowercased().contains(name.lowercased())
        }
    }
    
    func moveItem(from sourceIndex: Int, To destinationIndex: Int) {
        let sourceItem = items.remove(at: sourceIndex)
        items.insert(sourceItem, at: destinationIndex)
    }
    
}

