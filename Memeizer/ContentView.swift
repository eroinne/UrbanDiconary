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
    @State var definition: String = ""
    
    //fonction pour recuperer la definition
    func Description() {
        // Call getURLDiconary with a completion handler
        self.api.getURLDiconary(mots: forDefinition) { description in
            // Update the UI on the main thread
            DispatchQueue.main.async {
                self.definition = description ?? "No definition found"
                print(self.definition)
            }
        }
    }

    
 
    var body: some View {
     
        VStack{
            
            // entre de text pour la definition
            TextEditor(text: $forDefinition)
                .multilineTextAlignment(.center)
                .padding()
                .border(Color.black)
                .frame(width: 300, height: 80)
            //label avec ecirt definition
            
            Text("Deffinition : ")
                .padding()
                .font(.title2)
            
            //affichage de la definition
            
            Text($definition.wrappedValue)
                .padding()
                .font(.title3)
            
            //bouton pour lancer la requete
            Button("Deffinir") {
               Description()
              
            }
            
        }
        .padding()
    }

}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
    

}
