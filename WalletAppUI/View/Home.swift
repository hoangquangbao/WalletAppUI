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
    //MARK: Detail View Properties - 9:40
    @State var currentCard: Card?
    @State var showDetailCard: Bool = false
    @Namespace var animation
    
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
                    
                    //MARK: Card
                    ForEach(cards){ card in
                        // If you want Pure transition without this little opacity change in the sense just remove this if...else condition
                        Group {
                            if currentCard?.id == card.id && showDetailCard {
                                CardView(card: card)
                                    .opacity(0)
                            } else {
                                CardView(card: card)
                                    .matchedGeometryEffect(id: card.id, in: animation)
                                    .padding(.bottom, 5)
                            }
                        }
                        // Show Detail Card
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.25)) {
                                    currentCard = card
                                    showDetailCard = true
                                }
                            }
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
                    .font(.system(size: 30))
                    .foregroundColor(.white)
                    .padding(15)
                    .background(.blue, in: Circle())
            }
            .opacity(!expandCards ? 1 : 0)
            .rotationEffect(.init(degrees: expandCards ? 180 : 0))
            .scaleEffect(expandCards ? 0.01 : 1)
//            .frame(height: expandCards ? 0 : nil)
            .padding(.bottom, expandCards ? 0 : 30)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay {
            if let currentCard = currentCard,showDetailCard {
                DetailView(currentCard: currentCard, showDetailCard: $showDetailCard, animation: animation)
            }
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
}

// MARK: - Hidding all Number except last four
// Global Method
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

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

//MARK: - Detail View
struct DetailView: View {
    
    var currentCard: Card
    @Binding var showDetailCard: Bool
    //Matched Geometry Effect
    var animation: Namespace.ID
    var body: some View {
        
        VStack {
            CardView()
                .matchedGeometryEffect(id: currentCard.id, in: animation)
                .frame(height: 200)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
    
    @ViewBuilder
    func CardView() -> some View {
        VStack {
            HStack(alignment: .bottom){
                Text("Credit")
                    .font(.body)
                    .foregroundColor(.white)
                
                Spacer()
                
                Text(currentCard.cardType)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 10){
                
                Text(currentCard.name)
                    .fontWeight(.bold)
                
                Text(customCardNumber(number: currentCard.cardNumber))
                    .font(.callout)
                    .fontWeight(.bold)
                
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(
            .linearGradient(colors: [Color(currentCard.bgCard), .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .cornerRadius(15)
        .shadow(color: .gray, radius: 2, y: 6)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.25)) {
                showDetailCard = false
            }
        }
    }
}
