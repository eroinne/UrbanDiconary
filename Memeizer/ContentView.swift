//
//  ContentView.swift
//  Memeizer
//
//  Created by Ero on 08/09/2023.
//
import SwiftUI
import Alamofire



struct ContentView: View {
    
    
    var api: ApiModel = ApiModel()
    @State var forDefinition: String = ""
    @State private var definitions: [String] = []
    @State var thumbs_up: [Int] = []
    //diconaire pour stocker les definition
    @State var AllreadyDefine = [String]()
    @State var permaLinks = [String]()


    
    
    
    //fonction pour recuperer la definition
    func getDescription() {
        // Call getURLDiconary with a completion handler
        self.api.getURLDiconary(mots: forDefinition) { description in
            // Update the UI on the main thread
            DispatchQueue.main.async {
                self.definitions = self.api.definitions
                self.thumbs_up = self.api.thumbs_up
                self.permaLinks = self.api.permaLinks
                AllreadyDefine.append(forDefinition)
            
                
            }
        }
    }
    
    
    
    var body: some View {
        TabView{
//--------------------Vue recherche---------------------
            
            VStack {
                    
                    Text("Urban World Dictonary")
                        .padding()
                        .font(.title)
                
                        // texte editor for search
                       
                       TextEditor(text: $forDefinition)
                           .multilineTextAlignment(.center)
                           .padding()
                           .border(Color.black)
                           .frame(width: 300, height: 80)
                
                       
                       Text("Définitions :")
                           .padding()
                           .font(.title2)
                
                       // Show loading indicator or placeholder while definitions is empty
                       ScrollView {
                           VStack(alignment: .leading, spacing: 10) {
                               ForEach(0..<definitions.count, id: \.self) { index in
                                   Text(definitions[index])
                                       .padding()
                                       .font(.title2)
                                   HStack{
                                       Label(String(thumbs_up[index]), systemImage: "hand.thumbsup.fill")
                                           .padding()
                                       ShareLink(item: permaLinks[index], label: {
                                           Text("Partager")
                                               .frame(alignment: .leading)
                                        
                                       })
                                   }
                                  
                                   
                                   Divider()
                               }
                           }
                       }
                       
                       Button("Définir") {
                           getDescription()
                       }
                   }
            
            .tabItem {
                Label("Recherche", systemImage: "magnifyingglass")
            }
//--------------------Vue historique---------------------
            NavigationStack{
                //liste des mots rechercher
                List(AllreadyDefine, id: \.self) { mots in
                    NavigationLink(value: mots) {
                        Text(mots)
                    }
                }
                .navigationBarTitle("Historique")
                //vue de la definition
                .navigationDestination(for: String.self){ item in
                    RandomWroldView(item)
                    }
            }.tabItem {
            Label("Historique", systemImage: "book")
            }
            }

        }
        
    }
    




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
    

}
