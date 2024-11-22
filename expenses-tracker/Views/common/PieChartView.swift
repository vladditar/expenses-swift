//
//  PieChartView.swift
//  expenses-tracker
//
//  Created by Vlad on 07/11/2024.
//

import SwiftUI
import Charts

struct ChartSliceData {
    var category: TransactionCategory
    var amount: Int
}

struct PieChartView: View {
    let data: [ChartSliceData]
    @State private var selectedAngle: Double?

    private var categoryRanges: [(category: TransactionCategory, range: Range<Double>)]
    private let totalAmount: Int

    init(data: [ChartSliceData]) {
        self.data = data
        var total = 0
        categoryRanges = data.map {
            let newTotal = total + $0.amount
            let result = (category: $0.category, range: Double(total)..<Double(newTotal))
            total = newTotal
            return result
        }
        self.totalAmount = total
    }

    private var selectedItem: ChartSliceData? {
        guard let selectedAngle else { return nil }
        if let selectedIndex = categoryRanges.firstIndex(where: { $0.range.contains(selectedAngle) }) {
            return data[selectedIndex]
        }
        return nil
    }

    private var titleView: some View {
        VStack {
                Text("\((selectedItem?.amount ?? totalAmount).formatted())€")
                .font(.title)
            Text(selectedItem?.category.displayName ?? "Total")
                .font(.callout)
        }
    }

    var body: some View {
        Chart(data, id: \.category) { item in
            SectorMark(
                angle: .value("Amount", item.amount),
                innerRadius: .ratio(0.6),
                angularInset: 2
            )
            .cornerRadius(5)
            .foregroundStyle(by: .value("Category", item.category.displayName))
            .opacity(item.category == selectedItem?.category ? 1 : 0.5)
        }
        .scaledToFit()
        .chartLegend(alignment: .center, spacing: 16)
        .chartAngleSelection(value: $selectedAngle)
        .chartBackground { chartProxy in
            GeometryReader { geometry in
                if let anchor = chartProxy.plotFrame {
                    let frame = geometry[anchor]
                    titleView
                        .position(x: frame.midX, y: frame.midY)
                }
            }
        }
        .padding()
    }
}
