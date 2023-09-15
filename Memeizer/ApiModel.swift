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

    
    func getURLDiconary(mots: String, completion: @escaping (String?) -> Void) {
        AF.request("https://api.urbandictionary.com/v0/define?term=" + mots).responseJSON { response in
            switch response.result {
            case .success(let data):
                if let jsonData = try? JSONSerialization.data(withJSONObject: data, options: []) {
                    do {
                        let description = try JSONDecoder().decode(Description.self, from: jsonData)
                        let firstDefinition = self.getFirstDeinition(desc: description)
                        completion(firstDefinition)
                    } catch {
                        print("Error decoding JSON: \(error)")
                        completion(nil)
                    }
                } else {
                    print("Error converting response data to JSON")
                    completion(nil)
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
                completion(nil)
            }
        }
    }

    
    
    //recuper la premier definition
    func getFirstDeinition(desc : Description)-> String {
        // renvois la definition , en utilisan la preiemr definition du json trouver
        return desc.list.first?.definition ?? "No definition found"
    }
    
    
    
    
    
    struct Description: Codable {
        var list: [Definition]
    }

    
    struct Definition: Codable {
        //recuper la definition du json
        var definition : String
        
        
    }
    
}
    
    
    
