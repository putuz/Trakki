//
//  TransactionsListView.swift
//  Trakki
//
//  Created by Putut Yusri Bahtiar on 13/07/24.
//

import SwiftUI

struct TransactionsListView: View {
    @ObservedObject var viewModel: TransactionsListViewModel
    
    var body: some View {
        VStack {
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
    NavigationStack {
        TransactionsListView(viewModel: TransactionsListViewModel())
    }
}
