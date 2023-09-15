//
//  ApiModel.swift
//  Memeizer
//
//  Created by Ero on 08/09/2023.
//

import Foundation
import Alamofire
import SwiftUI



class ApiModel: NSObject {
    
    var urlDiconary: URL?
    var allDescirption : Description?
    @Published var desc: String?
    var definitions: [String] = []
    
    func getURLDiconary(mots: String, completion: @escaping (Result<Void,Error>) -> Void) {
        AF.request("https://api.urbandictionary.com/v0/define?term=" + mots).responseJSON { response in
            switch response.result {
            case .success(let data):
                if let jsonData = try? JSONSerialization.data(withJSONObject: data, options: []) {
                    do {
                        let description = try JSONDecoder().decode(Description.self, from: jsonData)
                        self.definitions = self.getAllDefinitions(desc: description);                         completion(.success(()))
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

    
    
    //recuper la premier definition
    func getFirstDeinition(desc : Description)-> String {
        // renvois la definition , en utilisan la preiemr definition du json trouver
        return desc.list.first?.definition ?? "No definition found"
    }
    
    // Recupere toute les definition du mots
       func getAllDefinitions(desc: Description) -> [String] {
           if desc.list.isEmpty {
               return ["definition not found"]
           }
           return desc.list.enumerated().map { (index, definition) in
               "Définition n°\(index + 1):\n\n \(definition.definition)"
           }
       }

    
    
    
    struct Description: Codable {
        var list: [Definition]
    }

    
    struct Definition: Codable {
        //recuper la definition du json
        var definition : String
        
        
    }
    
}
    
    
    
