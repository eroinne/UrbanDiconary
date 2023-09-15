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
    //diconaire pour stocker les definition
    @State var AllreadyDefine = [String]()


    
    
    
    
    
    //fonction pour recuperer la definition
    func getDescription() {
        // Call getURLDiconary with a completion handler
        self.api.getURLDiconary(mots: forDefinition) { description in
            // Update the UI on the main thread
            DispatchQueue.main.async {
                self.definitions = self.api.definitions
                AllreadyDefine.append(forDefinition)
            
                
            }
        }
    }
    
    
    
    var body: some View {
        TabView{
            // vue recherche
            VStack {
                       TextEditor(text: $forDefinition)
                           .multilineTextAlignment(.center)
                           .padding()
                           .border(Color.black)
                           .frame(width: 300, height: 80)
                       
                       Text("Définitions :")
                           .padding()
                           .font(.title)
                       
                       ScrollView {
                           VStack(alignment: .leading, spacing: 10) {
                               ForEach(0..<definitions.count, id: \.self) { index in
                                   Text(definitions[index])
                                       .padding()
                                       .font(.title2)
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
                List(AllreadyDefine, id: \.self) { mots in
                    NavigationLink(value: mots) {
                        Text(mots)
                    }
                }.navigationBarTitle("Historique")
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
