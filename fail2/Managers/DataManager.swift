//
//  DataManager.swift
//  swift_formation
//
//  Created by Guillaume Malo on 2018-07-19.
//  Copyright © 2018 Guillaume Malo. All rights reserved.
//

import Foundation

class DataManager {
    static let shared = DataManager()
    var userChampionList: [Champion] = []
    var championList: [Champion] = []
    private let saveChampionKey = "ChampionList"
    
    func generateChampionList(){
        championList = champions_data()
    }
    
    func AddChampionToList(champion: Champion){
        if !userChampionList.contains {$0.name == champion.name}{
             userChampionList.append(champion)
        }
        saveChampionList()
    }
    
    func RemoveChampionFromList(champion: Champion){
        userChampionList = userChampionList.filter { $0.name != champion.name }
        saveChampionList()
    }
    
    func saveChampionList() {
        let jsonEncoder:JSONEncoder = JSONEncoder()
        var strList = [String]()
        for champion in userChampionList {
            let data = try! jsonEncoder.encode(champion)
            strList.append(String(data: data, encoding: .utf8)!)
        }
        
        UserDefaults.standard.set(strList, forKey: saveChampionKey)
    }
    
    func loadChampionList() {
        guard let loadedList = UserDefaults.standard.object(forKey: saveChampionKey) as? [String] else { return }
        var currentChampionList = [Champion]()
        let jsonDecoder:JSONDecoder = JSONDecoder()
        
        for str in loadedList {
            let champion:Champion = try! jsonDecoder.decode(Champion.self, from: str.data(using: .utf8)!)
            currentChampionList.append(champion)
        }
        
        if currentChampionList.count != 0 {
            userChampionList = currentChampionList
        }
    }
}

func champions_data() -> [Champion]{
    var champData: [Champion] = []
    if let path = Bundle.main.path(forResource: "champion", ofType: "json"){
        do{
            guard let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)else{ return champData }
            guard let jsonResult = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) else { return champData }
            if let jsonResult = jsonResult as? Dictionary<String, AnyObject> {
                for (champName,data) in jsonResult{
                    if let currentData = data as? [String:Any],
                        let name = currentData["name"] as? String,
                        let title = currentData["title"] as? String,
                        let lore = currentData["lore"] as? String,
                        let image = currentData["image"] as? String{
                        champData.append(Champion(name:name,title:title,lore:lore,image:image))
                    }
                    else{
                        print("fail2")
                    }
                }
                return champData
            }
            else{
                print("fail3")
            }
        }
    }
    else{
        print("fail4")
    }
    return champData
}
