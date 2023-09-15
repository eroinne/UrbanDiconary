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
    @Published var desc: String? = " "
    
    
    
    
    
    
    
    
    
    //fonction pour fair appel a l'api
    func getURLDiconary(mots : String )-> String {
        AF.request("https://api.urbandictionary.com/v0/define?term=" + mots).response { response in
            switch response.result {
            case .success(let data):
                do {
                    let description = try JSONDecoder().decode(Description.self, from: data!)
                    // Handle the description as needed
                    self.allDescirption = description  // Update allDescirption with the decoded description
                    self.desc = self.getFirstDeinition(desc: description)
                  
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
        return self.desc!
    
    
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
    
    
    
