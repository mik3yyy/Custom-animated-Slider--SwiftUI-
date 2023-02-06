//
//  MainContent.swift
//  Sliding animation
//
//  Created by okpechi michaeel on 05/02/2023.
//

import SwiftUI
var height : CGFloat = UIScreen.main.bounds.height
var width : CGFloat = UIScreen.main.bounds.width

struct MainContent: View {
    @State var cards : [CardModel]  = [
   CardModel(image: "Dog", name: "Dog"),
   CardModel(image: "Dear", name: "Deer"),
   CardModel(image: "Lion", name: "Lion"),
   CardModel(image: "Rabbit", name: "Rabbit"),
   CardModel(image: "Dolphine", name: "Dolphine"),
   CardModel(image: "Elephant", name: "Elephant"),
   CardModel(image: "sheep", name: "Sheep"),
   CardModel(image: "Peacock", name: "Peacock")
    ]
    
    var body: some View {
        VStack (spacing: 10) {
            VStack (spacing: 0.5) {
                Text("Custom Slider ")
                    .font(.system(size: 40))
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                Text("...using SwiftUI")
                    .frame(width: 240, alignment: .trailing)
            }
            
            
            ZStack{
              
                ForEach (cards) { card in
                   
                    Card(card: card, cards: $cards)
            
                }
                
                
            }
            
            
        }
        .ignoresSafeArea()
        .frame(width: width, height: height)
        .foregroundColor(.orange)
        .background(Color(.black).opacity(0.8))
        .padding()
    }
}

struct MainContent_Previews: PreviewProvider {
    static var previews: some View {
        MainContent()
    }
}


struct Card : View , Identifiable{
    let  id = UUID()
    var  card : CardModel
    @Binding var cards : [CardModel]
    
    
    
    @GestureState var isAnimated = false
    @State var offsetx = 0.0
    @State var offsety = 0.0
    var body: some View {
        VStack{
            Spacer()
            Text(card.name)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .fontWidth(.expanded)
                .frame(width: 400, height: 100)
                .font(.system(size: 32))

        }
            .frame(width: 250, height: 400 )
        .background(Image(card.image).resizable())
        .cornerRadius(20)
        .rotationEffect(.degrees( getIndex() == 0 ? 0 :  0))
        .rotationEffect(.degrees( getIndex() == 1 ? 10 :  0))
        .rotationEffect(.degrees( getIndex() == 2 ? -10 :  0))
        .scaleEffect(getIndex() == 0 ? 1 : 0.9)
        .offset(x: getIndex() == 1 ? -40 : 0)
        .offset(x: getIndex() == 2 ? 40 : 0)
        

        .offset(x: isAnimated ? offsetx : 0, y: isAnimated ? offsety : 0)
        .zIndex(Double(cards.count - getIndex()))
        .gesture(
            getIndex() == 0 ?
            DragGesture()
                .updating( $isAnimated, body: { _, out, _ in
                    withAnimation(.easeInOut(duration: 2)){
                        out = true

                    }
                })
                .onChanged({ value in
                    print(value.translation.width)

                    withAnimation(.linear(duration: 0.1)){
                        offsetx = value.translation.width

                    }
                    
                })
                .onEnded({value in
                    if (offsetx >= 120 || offsetx <= -120){
                        DispatchQueue.main.async {

                            withAnimation(.easeInOut(duration: 1)){
                                cards.removeFirst()
                                cards.append(card)
                            }
                        }
                        
                        
                    } else {
                        withAnimation (.easeIn(duration: 2)) {
                            offsetx = 0
                        }
                        
                    }
                })
            : nil
        )

    }
    func getIndex() -> Int {
        let index = cards.firstIndex { card in
            return self.card.id == card.id
        } ?? 0
        
        return Int(index)
    }

}
