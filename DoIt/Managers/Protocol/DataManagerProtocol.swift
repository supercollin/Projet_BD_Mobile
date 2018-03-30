//
//  DataManagerProtocol.swift
//  DoIt
//
//  Created by iem on 30/03/2018.
//  Copyright © 2018 iem. All rights reserved.
//

import Foundation

protocol DataManagerProtocol : class {
    
    func saveListInFile()
    
    func loadListinFile()
    
    func AddItem(name : String)
    
    func filterBy(name : String)
    
    func moveItem(from sourceIndex : Int, To destinationIndex : Int)
    
}
