//
//  CUIymDataManager.swift
//  CUIymCreateUIcon
//
//  Created by JOJO on 2021/6/8.
//

import Foundation

struct EditToolItem: Codable {
    var thumbStr: String
    var bigStr: String
}

class CUIDataManager {
    static let `default` = CUIDataManager()
 
    func bgColorSingleList() -> [EditToolItem] {
        let item = loadJson([EditToolItem].self, name: "bgSingleColor") ?? []
        return item
    }
    func gridentList() -> [EditToolItem] {
        let item = loadJson([EditToolItem].self, name: "GridentList") ?? []
        return item
    }
    
    func icon1List() -> [EditToolItem] {
        let item = loadJson([EditToolItem].self, name: "IconList1") ?? []
        return item
    }
    func icon2List() -> [EditToolItem] {
        let item = loadJson([EditToolItem].self, name: "IconList2") ?? []
        return item
    }
    
    func colorSingleList() -> [EditToolItem] {
        let item = loadJson([EditToolItem].self, name: "colorSingle") ?? []
        return item
    }
    
    
    
}




extension CUIDataManager {
    func loadJson<T: Codable>(_:T.Type, name: String, type: String = "json") -> T? {
        if let path = Bundle.main.path(forResource: name, ofType: type) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                return try! JSONDecoder().decode(T.self, from: data)
            } catch let error as NSError {
                debugPrint(error)
            }
        }
        return nil
    }
    
    func loadJson<T: Codable>(_:T.Type, path:String) -> T? {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            do {
                return try PropertyListDecoder().decode(T.self, from: data)
            } catch let error as NSError {
                print(error)
            }
        } catch let error as NSError {
            print(error)
        }
        return nil
    }
    
    func loadPlist<T: Codable>(_:T.Type, name:String, type:String = "plist") -> T? {
        if let path = Bundle.main.path(forResource: name, ofType: type) {
            return loadJson(T.self, path: path)
        }
        return nil
    }
    
}



