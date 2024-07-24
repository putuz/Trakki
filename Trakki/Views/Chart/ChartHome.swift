//
//  ChartHome.swift
//  Trakki
//
//  Created by Putut Yusri Bahtiar on 11/07/24.
//

import SwiftUI
import Charts

struct Order: Identifiable {
    var id: String = UUID().uuidString
    var amount: Int
    var day: Int
}

struct ChartHome: View {
    @ObservedObject var viewModel: TransactionsListViewModel
    @State private var chartSelection: String?
    
    private var expenseData: [ExpenseDataPoint] {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        let grouped = Dictionary(grouping: viewModel.transactions) { transaction -> String in
            if let date = dateFormatter.date(from: transaction.updatedAt) {
                return DateFormatter.localizedString(from: date, dateStyle: .short, timeStyle: .none)
            }
            return ""
        }
        
        return grouped.map { (key, transactions) in
            let totalExpense = transactions
                .filter { $0.transaction_type.lowercased() == "expense" }
                .reduce(0) { $0 + $1.amount }
            return ExpenseDataPoint(date: key, amount: totalExpense)
        }.sorted { $0.date < $1.date }
    }
    
    private var minAmount: Int {
        expenseData.map { $0.amount }.min() ?? 0
    }
    
    private var maxAmount: Int {
        expenseData.map { $0.amount }.max() ?? 0
    }
    
    var body: some View {
        VStack {
            Chart {
                ForEach(expenseData, id: \.date) { dataPoint in
                    LineMark(
                        x: .value("Date", dataPoint.date),
                        y: .value("Expense", dataPoint.amount)
                    )
                    .foregroundStyle(.white)
                    .symbol(.circle)
                    .interpolationMethod(.linear)
                }
                
                if let chartSelection {
                    RuleMark(
                        x: .value("Selected Date", chartSelection)
                    )
                    .foregroundStyle(.white)
                    .annotation(position: .top) {
                        VStack {
                            Text(chartSelection)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                            Text("\(getAmount(for: chartSelection))")
                                .font(.caption)
                                .foregroundStyle(.primary)
                        }
                        .padding(5)
                        .background(Color.black.opacity(0.1))
                        .cornerRadius(5)
                    }
                }
            }
            .frame(height: 150)
            .chartYScale(domain: minAmount...maxAmount)
            .chartXAxis {
                AxisMarks(values: .automatic(desiredCount: 5)) { value in
                    AxisValueLabel()
                }
            }
            .chartXSelection(value: $chartSelection)
            .padding()
        }
    }
    
    private func getAmount(for date: String) -> Int {
        expenseData.first(where: { $0.date == date })?.amount ?? 0
    }
}

struct ExpenseDataPoint {
    let date: String
    let amount: Int
}

#Preview {
    ChartHome(viewModel: TransactionsListViewModel())
        .preferredColorScheme(.dark)
}
