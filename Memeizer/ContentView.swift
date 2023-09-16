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
    
    //dictionnaire pour stocker les definition
    @State var AllreadyDefine = [String]()
    @State var permaLinks = [String]()
    @State var show = false
    @State private var isEditing = false
        

        //Function to get the definition
        func getDescription() {
            
            // Call getUrlDictionary with a completion handler
            self.api.getUrlDictionary(mots: forDefinition) { description in
                
                // Update the UI on the main thread
                DispatchQueue.main.async {
                    thumbs_up.removeAll()
                    permaLinks.removeAll()
                    
                    self.definitions = self.api.definitions
                    if(self.definitions[0] !=  "definition not found"){
                        show = true
                        self.thumbs_up = self.api.thumbs_up
                        self.permaLinks = self.api.permaLinks
                        if(!AllreadyDefine.contains(forDefinition)){
                            AllreadyDefine.append(forDefinition)
                        }
                    }
                    else if (forDefinition.replacingOccurrences(of: " ", with: "") == "") {
                        definitions[0] = "remplie un truck batard !"
                        show = false
                    }
                    else {
                    show = false
                    }
                    
                }
            }
        }
    
        var body: some View {
            TabView{
                
    //--------------------Searching View---------------------
                
                VStack(spacing: 0) {
                    VStack{
                        Text("Urban Word Dictionary")
                            .padding()
                            .font(.title)
                            .foregroundStyle(.white)
                        
//                      Searchbar
                        HStack {
                            TextField("Search", text: $forDefinition, onEditingChanged: { isEditing in
                                if !isEditing {
                                    // This function will be called after enter is pressed
                                    getDescription()
                                    }
                                })
                                .padding(40)
                                .frame(width: 400, height: 50)
                                .background(Color(.systemGray6))
                                .overlay(
                                    HStack{
                                        Button {
                                            getDescription()
                                        } label: {
                                            Image(systemName: "magnifyingglass")
                                        }
                                        .foregroundColor(.gray)
                                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                        .padding(.leading, 8)

                                        if isEditing {
                                            Button(action: {
                                                self.forDefinition = ""
                                            }) {
                                                Image(systemName: "multiply.circle.fill")
                                                    .foregroundColor(.gray)
                                                    .padding(.trailing, 8)
                                            }
                                        }
                                    }
                                ).cornerRadius(10)
                                .onTapGesture {
                                    self.isEditing = true
                            }
                        }.padding()
           
                    }.frame(maxWidth: .infinity)
                    .background(Color(hex: 0x1b2936))
                
                       // Show loading indicator or placeholder while definitions is empty
                       ScrollView {
                           VStack(alignment: .leading, spacing: 10) {
                               ForEach(0..<definitions.count, id: \.self) { index in
                                   Text(definitions[index])
                                       .padding()
                                       .font(.title2)
                                   HStack{
                                       if(show){
                                           Label(String(thumbs_up[index]), systemImage: "hand.thumbsup.fill")
                                               .padding()
                                           ShareLink(item: permaLinks[index], label: {
                                               Text("Partager")
                                                   .frame(alignment: .leading)
                                           })
                                       }
                                   }
                                   Divider()
                               }
                           }
                       }.frame(maxWidth: .infinity)
                        .background(Color(hex: 0xeeeeee))
                        .padding(.bottom, 10)
                   }
                
                .tabItem {
                    Label("Recherche", systemImage: "magnifyingglass")
                }
                
    //--------------------History View---------------------
                NavigationStack{
                    VStack(spacing:0){
                        Text("Historique")
                            .padding()
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .background(Color(hex: 0x1b2936))
                            .foregroundStyle(.white)
                        
                        // List of the word that have been searched
                        List(AllreadyDefine.reversed(), id: \.self) { mots in
                            NavigationLink(value: mots) {
                                Text(mots)
                            }
                        }
                        
                        // View of the definition of the word in the history
                        .navigationDestination(for: String.self){ item in
                            RandomWroldView(item)
                        }
                    }
                    .padding(.bottom, 10)
                }
                .tabItem {
                    Label("Historique", systemImage: "book")
                }
            }.onAppear(){
                UITabBar.appearance().backgroundColor = .white
            }
        }
    }

// extension to use hexadecimal color
extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}
    
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
