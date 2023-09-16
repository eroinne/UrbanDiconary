//
//  ApiModel.swift
//  Memeizer
//
//  Created by Ero on 08/09/2023.
//
import Foundation
import Alamofire
import SwiftUI

// Class that manage and handle the api calls
class ApiModel: NSObject {
    
    @Published var desc: String?
    var definitions: [String] = []
    var thumbs_up : [Int] = []
    var permaLinks : [String] = []
    
    // Get the Json
    func getUrlDictionary(mots: String, completion: @escaping (Result<Void,Error>) -> Void) {
        let mots = mots.replacingOccurrences(of: " ", with: "%20")
        AF.request("https://api.urbandictionary.com/v0/define?term=" + mots).responseJSON { response in
            switch response.result {
            case .success(let data):
                if let jsonData = try? JSONSerialization.data(withJSONObject: data, options: []) {
                    do {
                        let description = try JSONDecoder().decode(Description.self, from: jsonData)
                        //recupere les definition
                        self.definitions = self.getAllDefinitions(desc: description);
                        //recupere les thumbs_up
                        self.thumbs_up = self.getAllThumbs_up(desc: description)
                        self.permaLinks = self.getAllPermaLinks(desc: description)
                        
                        
                        completion(.success(()))
                    } catch {
                        print("Error decoding JSON: \(error)")
                        completion(.failure(error))
                    }
                    
                }
            case .failure(_):
                completion(.failure(response.error!))
            
            }
        }
    }
    
    // Get all the definitions of the searched word
       func getAllDefinitions(desc: Description) -> [String] {
           if desc.list.isEmpty {
               return ["definition not found"]
           }
           return desc.list.enumerated().map { (index, definition) in
               "Définition n°\(index + 1)\n\n \(definition.definition)"
           }
       }
    
    // Get all the thumbs_up of the definition
       func getAllThumbs_up(desc: Description) -> [Int] {
           if desc.list.isEmpty {
               return [0]
           }
           return desc.list.enumerated().map { (index, definition) in
               definition.thumbs_up
           }
       }
    
    // Get the permalink of the definition
    func getAllPermaLinks(desc: Description) -> [String] {
        if desc.list.isEmpty {
            return ["No permaLinks found"]
        }
        return desc.list.enumerated().map { (index, definition) in
            definition.permalink
        }
    }
    
    struct Description: Codable {
        var list: [Definition]
    }
    
    struct Definition: Codable {
        //recuper la definition du json
        var definition : String
        var thumbs_up : Int
        var permalink : String
    }
}
