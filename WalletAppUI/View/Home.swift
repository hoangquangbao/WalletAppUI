//
//  Home.swift
//  WalletAppUI
//
//  Created by Quang Bao on 27/02/2022.
//

import SwiftUI

struct Home: View {
    //MARK: Animation Properties
    @State var expandCards: Bool = false
    var body: some View {
        VStack(spacing: 0){
            
                Text("Wallet")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: expandCards ? .leading : .center)
                    .overlay(alignment: .trailing) {
                        //MARK: Close Button
                        Button {
                            //Close Cards
                            withAnimation(.interactiveSpring(response: 1, dampingFraction: 0.6, blendDuration: 0.1)) {
                                expandCards = false
                            }
                        } label: {
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                                .padding(10)
                                .background(.blue, in: Circle())
                        }
                        .rotationEffect(.init(degrees: expandCards ? 45 : 0))
                        .opacity(expandCards ? 1 : 0)
                    }
                    .padding(.bottom, 15)
            
            ScrollView(.vertical, showsIndicators: false){
                
                VStack(spacing: 0) {
                    
                    ForEach(cards){ card in
                        
                        CardView(card: card)
                            .padding(.bottom, 5)
                    }
                }
                .overlay {
                    //To Avoid Scrolling
                    Rectangle()
                        .fill(.white.opacity(expandCards ? 0 : 0.01))
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.35)){
                                expandCards = true
                            }
                        }
                }
            }
            .coordinateSpace(name: "SCROLL")
            // Cái này sẽ đẩy Card trong cùng lên 20 khi animation xảy ra
            .offset(y: expandCards ? 0 : 20)
            
            //MARK: Add Button
            Button {

            } label: {
                Image(systemName: "plus")
                    .foregroundColor(.white)
                    .padding(20)
                    .background(.blue, in: Circle())
            }
            .opacity(!expandCards ? 1 : 0)
            .rotationEffect(.init(degrees: expandCards ? 180 : 0))
            .scaleEffect(expandCards ? 0.01 : 1)
//            .frame(height: expandCards ? 0 : nil)
            .padding(.bottom, expandCards ? 0 : 30)
        }
        .padding([.horizontal,.top])
    }

    //MARK: - CardView
    @ViewBuilder
    func CardView(card : Card) -> some View{
        GeometryReader { proxy in
            
            let rect = proxy.frame(in: .named("SCROLL"))
            //Let's display some Portion of each Card
            let offset = CGFloat(getIndex(Card: card) * (expandCards ? 10 : 70))
            
            VStack{
                HStack(alignment: .bottom){
                    Text("Credit")
                        .font(.body)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text(card.cardType)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 10){
                    
                    Text(card.name)
                        .fontWeight(.bold)
                    
                    Text(customCardNumber(number: card.cardNumber))
                        .font(.callout)
                        .fontWeight(.bold)
                    
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            .background(
                .linearGradient(colors: [Color(card.bgCard), .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
            )
            .cornerRadius(15)
            .shadow(color: .gray, radius: 2, y: 6)
//            .offset(y: -rect.minY)
            //Set các Card chồng lên nhau
            .offset(y: expandCards ? offset : -rect.minY + offset)
            
        }
        // MARK: Max size
        .frame(height: 200)
    }
    
    ////////////////////// 5:16
    //MARK: - Retreiving Index
    func getIndex(Card: Card) -> Int{
        return cards.firstIndex { currentCard in
            return currentCard.id == Card.id
        } ?? 0
    }
    
    // MARK: - Hidding all Number except last four
    func customCardNumber(number: String) -> String {
        
        var newValue: String = ""
        let maxCount: Int = number.count - 4
        
        number.enumerated().forEach({ value in
            
            if value.offset >= maxCount{
                
                // Display Number
                let string = String(value.element)
                newValue.append(contentsOf: string)
            } else {
                // Simply display Start
                // Avoiding space
                let string = String(value.element)
                if string == " "{
                    newValue.append(contentsOf: " ")
                } else {
                    newValue.append(contentsOf: "*")
                }
            }
        })
        
        return newValue
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
