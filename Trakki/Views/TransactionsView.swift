//
//  TransactionsView.swift
//  Trakki
//
//  Created by Putut Yusri Bahtiar on 13/07/24.
//

import SwiftUI

struct TransactionsView: View {
    @ObservedObject var viewModel: TransactionsListViewModel
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Text("Total Income")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("Rp.\(viewModel.totalIncome)")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(10)
                
                VStack {
                    Text("Total Expense")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("Rp.\(viewModel.totalExpense)")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red.opacity(0.1))
                .cornerRadius(10)
            }
            .padding(.horizontal)
            
            List {
                ForEach(viewModel.transactions) { transaction in
                    NavigationLink {
                        TransactionsDetailView(viewModel: TransactionsDetailViewModel(transaction: transaction))
                    } label: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(transaction.remarks)
                                    .fontWeight(.semibold)
                                Text(DateUtils.formatDateString(transaction.updatedAt) ?? "\(Date.now)")
                                    .font(.footnote)
                            }
                            
                            Spacer()
                            
                            Text("Rp.\(transaction.amount)")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundStyle(transaction.transaction_type == "income" ? .green : .red)
                        }
                    }
                }
                .onDelete(perform: viewModel.deleteTransactions)
            }
            .listStyle(.plain)
        }
        .onAppear {
            viewModel.fetchTransactions()
        }
    }
}

#Preview {
    TransactionsView(viewModel: TransactionsListViewModel())
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Button(action: {
                    // Action for the gear icon
                }) {
                    Image(systemName: "gear")
                        .foregroundStyle(.white)
                }
            }
            
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: {
                    // Action for the notification bell
                }) {
                    Image(systemName: "bell")
                        .foregroundStyle(.white)
                }
            }
            
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("TODAY IS")
                        .foregroundStyle(.white)
                        .font(.caption)
                    Text("Fri, 21 Jul")
                        .foregroundStyle(.white)
                        .font(.callout)
                }
            }
        }
}
