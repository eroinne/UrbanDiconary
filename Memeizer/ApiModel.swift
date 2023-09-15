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
    
    
    
    
    //fonction pour fair appel a l'api
    func getURLDiconary(mots : String ){
        
        let headers = [
            "X-RapidAPI-Key": "2c547dedc7mshc15b0e663fcb86ep1cec4djsn22d426feb2fd",
            "X-RapidAPI-Host": "mashape-community-urban-dictionary.p.rapidapi.com"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://mashape-community-urban-dictionary.p.rapidapi.com/define?term=" + mots)! as URL)
        print(request)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        request.cachePolicy = .useProtocolCachePolicy
        request.timeoutInterval = 10.0
        
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse as Any)
                self.urlDiconary = httpResponse?.url
            
                
                
            }
        })
        
        dataTask.resume()
        
    }
    
    //function utiliser pour etre sur que les fonction sois apler dans le bonne ordre
    func getDescriptionAfterURL(mots : String) async throws {
        Task {
                do {
                    try await getURLDiconary(mots : mots)
                    try await getDescription()
                    
                    
                } catch {
                    print("Erreur : \(error)")
                }
            }
    
    }
    
    //recuperte toute les decpriton est le stock dans une variable
    
    @Sendable func getDescription() async throws {
        if let url = urlDiconary {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let decoder = JSONDecoder()
                let result = try decoder.decode(Description.self, from: data)
                allDescirption = result
            } catch {
                print("Erreur lors de la récupération des données : \(error)")
            }
        } else {
            print("L'URL est nulle")
        }
        
    }
    
    //recuper la premier definition
    func getFirstDeinition()-> String {
        // renvois la definition , en utilisan la preiemr definition du json trouver
        return allDescirption?.definitionList.first?.definition ?? "No definition found"
    }
    
    
}
    
    
    struct Description: Codable {
        //recuper la list du json
        let definitionList : [Definition]
        
        
    }
    
    struct Definition: Codable {
        //recuper la definition du json
        let definition : String
        
        
    }
    
    
    
    
