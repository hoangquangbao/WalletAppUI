//
//  Home.swift
//  WalletAppUI
//
//  Created by Quang Bao on 27/02/2022.
//

import SwiftUI

struct Home: View {
    //MARK: Animation Properties
    @State var isExpandCards: Bool = false
    //MARK: Detail View Properties - 9:40
    @State var currentCard: Card?
    @State var isShowDetailCard: Bool = false
    @Namespace var animation
    
    var body: some View {
        VStack(spacing: 0){
            
                Text("Wallet")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: isExpandCards ? .leading : .center)
                    .overlay(alignment: .trailing) {
                        //MARK: Close Button
                        Button {
                            //Close Cards
                            withAnimation(.interactiveSpring(response: 1, dampingFraction: 0.6, blendDuration: 0.1)) {
                                isExpandCards = false
                            }
                        } label: {
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                                .padding(10)
                                .background(.blue, in: Circle())
                        }
                        .rotationEffect(.init(degrees: isExpandCards ? 45 : 0))
                        .opacity(isExpandCards ? 1 : 0)
                    }
                    .padding(.bottom, 15)
            
            ScrollView(.vertical, showsIndicators: false){
                
                VStack(spacing: 0) {
                    
                    //MARK: Card
                    ForEach(cards){ card in
                        // If you want Pure transition without this little opacity change in the sense just remove this if...else condition
                        Group {
                            if currentCard?.id == card.id && isShowDetailCard {
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
                                    isShowDetailCard = true
                                }
                            }
                    }
                }
                .overlay {
                    //To Avoid Scrolling
                    Rectangle()
                        .fill(.white.opacity(isExpandCards ? 0 : 0.01))
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.35)){
                                isExpandCards = true
                            }
                        }
                }
            }
            .coordinateSpace(name: "SCROLL")
            // Cái này sẽ đẩy Card trong cùng xún 20 trước khi animation xảy ra
            .offset(y: isExpandCards ? 0 : 20)
            .overlay(
                //MARK: Add Button
                // Đặt trong Overlay để nó ko chèn lên đổ bóng của Card dưới cùng
                Button {

                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                        .padding(15)
                        .background(.blue, in: Circle())
                }
                .opacity(!isExpandCards ? 1 : 0)
                .rotationEffect(.init(degrees: isExpandCards ? 180 : 0))
                .scaleEffect(isExpandCards ? 0.01 : 1)
    //            .frame(height: expandCards ? 0 : nil)
                .padding(.bottom, isExpandCards ? 0 : 30)
                , alignment: .bottom
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding([.horizontal,.top])
        .overlay {
            if let currentCard = currentCard,isShowDetailCard {
                DetailView(currentCard: currentCard, isShowDetailCard: $isShowDetailCard, animation: animation)
            }
        }
    }

    //MARK: - CardView
    @ViewBuilder
    func CardView(card : Card) -> some View{
        GeometryReader { proxy in
            
            let rect = proxy.frame(in: .named("SCROLL"))
            //Let's display some Portion of each Card
            let offset = CGFloat(getIndex(Card: card) * (isExpandCards ? 10 : 70))
            
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
            .offset(y: isExpandCards ? offset : -rect.minY + offset)
            
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
    @Binding var isShowDetailCard: Bool
    // Matched Geometry Effect
    var animation: Namespace.ID
    
    // Delaying Expenses View
    @State var isShowExpenseView: Bool = false
    
    var body: some View {
        
        VStack {
            CardView()
                .matchedGeometryEffect(id: currentCard.id, in: animation)
                .frame(height: 200)
                .padding(.bottom)
                .onTapGesture {
                    
                    // Closing Expenses View First
                    // Closing "ExpenseView" first
                    // Closing "DetailCard" after 0.2s
                    withAnimation(.easeInOut) {
                        isShowExpenseView = false
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            isShowDetailCard = false
                        }
                    }
                }
            
            GeometryReader { proxy in
                let height = proxy.size.height + 50
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    VStack(spacing: 20){
                        
                        // Expense
                        ForEach(expense) { expense in
                            // ExpenseCardView
                            ExpenseCardView(expense: expense)
                        }
                    }
                    .padding()
                }
                .frame(maxWidth: .infinity)
                .background(
                    Color.white
                        .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                        .ignoresSafeArea()
                )
                .offset(y: isShowExpenseView ? 0 : height)
            }
//            .padding([.horizontal, .top])
//            .zIndex(-50)
        }
        .padding([.horizontal, .top])
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(
            Color("bg")
                .ignoresSafeArea()
        )
        //Khi View này xuất hiện thì set isShowExpenseView = true để show cái ScrollView trên. Ngc lại ta offset để đẩy nó xún dưới 1 đoạn = height
        .onAppear {
            withAnimation(.easeInOut.delay(0.1)) {
                isShowExpenseView = true
            }
        }
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
    }
}

// MARK: - ExpenseCardView
struct ExpenseCardView: View {
    var expense: Expense
    
    var body: some View {
        HStack(spacing: 14) {
            Image(expense.productIcon)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 8) {
                
                Text(expense.product)
                    .fontWeight(.bold)
                
                Text(expense.spendType)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 8) {
                
                Text(expense.amountSpent)
                    .fontWeight(.bold)
                
                Text(Date().formatted(date: .numeric, time: .omitted))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
}
