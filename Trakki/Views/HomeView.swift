//
//  HomeView.swift
//  Trakki
//
//  Created by Putut Yusri Bahtiar on 10/07/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = TransactionsListViewModel()
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    AngularGradient(colors: [Color("bgGreenLight"), Color("bgGreen")], center: .bottomLeading, angle: Angle(degrees: -40))
                        .frame(height: geometry.size.height / 1.6)
                    Color.white
                        .frame(height: geometry.size.height / 2)
                }
                .edgesIgnoringSafeArea(.all)
            }
            
            VStack {
                Text("TODAY IS")
                    .foregroundStyle(.white.opacity(0.5))
                    .font(.footnote)
                
                Text(DateUtils.getCurrentDateFormatted())
                    .foregroundStyle(.white)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .padding(.bottom)
                
                Text("THIS MONTH SPEND")
                    .foregroundStyle(Color.white.opacity(0.85))
                    .font(.subheadline)
                
                Text("Rp.\(viewModel.totalExpense)")
                    .foregroundStyle(.white)
                    .font(.system(size: 40))
                    .fontWeight(.bold)
                
                HStack {
                    Image(systemName: viewModel.expenseComparisonPercentage >= 0 ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
                        .font(.callout)
                    
                    Text("\(Int(abs(viewModel.expenseComparisonPercentage)))% \(viewModel.expenseComparisonPercentage >= 0 ? "above" : "below") last month")
                        .font(.caption)
                }
                .padding(.bottom)
                .foregroundStyle(.white)
                
                ChartHome(viewModel: TransactionsListViewModel())
                
                HStack {
                    Image(systemName: "menucard")
                        .foregroundStyle(Color("bgGreen"))
                    Text("Wallet")
                        .font(.system(size: 14))
                        .fontWeight(.semibold)
                    Spacer()
                    Text("Rp.\(viewModel.totalIncome)")
                        .font(.system(size: 14))
                        .fontWeight(.semibold)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12))
                }
                .frame(maxWidth: .infinity)
                .frame(height: 55)
                .padding(.horizontal)
                .background(.white)
                .shadow(radius: 10, x: 0.0, y: 5.0)
                .padding()
                
                HStack {
                    Text("RECENT TRANSACTIONS")
                        .foregroundStyle(.gray)
                    Spacer()
                    Text("See all")
                        .foregroundStyle(Color("bgGreen"))
                }
                .padding(.horizontal)
                
                TransactionsListView(viewModel: viewModel)
                
                Spacer()
            }
            .onAppear {
                viewModel.fetchTransactions()
            }
        }
    }
}

#Preview {
    HomeView()
}
