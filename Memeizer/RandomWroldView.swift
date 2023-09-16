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
    @State var thumbs_up: [Int] = []
    @State private var itemDef = [String]()  // Use @State to trigger UI updates
    @State var permaLinks = [String]()
    @State var show = false

    init(_ item: String) {
        self.item = item
    }
    
    var body: some View {
        VStack(spacing:0){
            // Show the word
            Text(item)
                .bold()
                .multilineTextAlignment(.center)
                .padding()
                .font(.title)
                .frame(maxWidth: .infinity)
                .background(Color(hex: 0x1b2936))
                .foregroundStyle(.white)

            
            // Show loading indicator or placeholder while itemDef is empty
            if itemDef.isEmpty {
                Text("Loading...")
                    .font(.title2)
            } else {
                // Show the views of all definitions
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(0..<itemDef.count, id: \.self) { index in
                            Text(itemDef[index])
                                .padding()
                                .font(.title2)
                            HStack{
                                if(show){
                                    // Show the number of thumbs up + icon
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
        }
        
        .onAppear {
            // Call getUrlDictionary and update itemDef and thumbs_up
            api.getUrlDictionary(mots: item) { description in
                DispatchQueue.main.async {
                    itemDef = api.definitions
                    if(self.itemDef[0] !=  "definition not found"){
                        show = true
                        self.thumbs_up = self.api.thumbs_up
                        self.permaLinks = self.api.permaLinks
                    }else {
                        show = false
                    }
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
