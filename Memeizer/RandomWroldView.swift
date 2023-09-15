//
//  RandomWroldView.swift
//  Memeizer
//
//  Created by Ero on 15/09/2023.
//

import SwiftUI

struct RandomWroldView: View {
    
    var api: ApiModel = ApiModel()
    var item : String
    @State private var itemDef = [String]()  // Use @State to trigger UI updates
    
    init(_ item: String) {
        self.item = item
        print(item)
    }
    
    var body: some View {
        VStack {
            Text(item)
                .font(.title)
                .bold()
                .multilineTextAlignment(.center)
                .padding()
            
            // Show loading indicator or placeholder while itemDef is empty
            if itemDef.isEmpty {
                Text("Loading...")
                    .font(.title2)
            } else {
                // Show the definitions when itemDef is ready
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(0..<itemDef.count, id: \.self) { index in
                            Text(itemDef[index])
                                .padding()
                                .font(.title2)
                        }
                    }
                }
            }
        }
        .onAppear {
            // Call getURLDiconary and update itemDef
            api.getURLDiconary(mots: item) { description in
                DispatchQueue.main.async {
                    itemDef = api.definitions
                }
            }
        }
    }
}


struct RandomWroldView_Previews: PreviewProvider {
    static var previews: some View {
        RandomWroldView("wat")
    }
}
