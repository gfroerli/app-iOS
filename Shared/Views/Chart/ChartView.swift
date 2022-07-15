//
//  ChartView.swift
//  iOS
//
//  Created by Marc on 18.05.21.
//

import SwiftUI

struct ChartView: View {

    @ObservedObject var temperatureAggregationsVM: TemperatureAggregationsViewModel

    var nrOfLines: Int

    @Binding var timeFrame: TimeFrame
    @Binding var minValue: Double
    @Binding var maxValue: Double

    @Binding var totalSteps: Int
    @Binding var steps: [Int]
    @Binding var minimums: [Double]
    @Binding var averages: [Double]
    @Binding var maximums: [Double]

    @Binding var selectedIndex: Int

    @State private var touchLocation: CGPoint = .zero
    @State private var positionOfClosestPoint: CGPoint = .zero
    @Binding var showIndicator: Bool

    var body: some View {

        GeometryReader { geo in

            ZStack {
                VStack(alignment: .center, spacing: 0) {
                    ForEach((0..<nrOfLines)) { index in
                        if index != 0 {Spacer()}
                        self.horizontalLine(width: geo.size.width)
                            .stroke((Color.secondary), style: StrokeStyle(lineWidth: 2, lineCap: .round))
                            .rotationEffect(.degrees(180), anchor: .center)
                            .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                            .clipped()
                            .frame(height: 1)
                    }
                }

                if temperatureAggregationsVM.loadingStateDay == .loaded && temperatureAggregationsVM.loadingStateWeek == .loaded && temperatureAggregationsVM.loadingStateMonth == .loaded {
                    LineShape(
                        temperatureAggregationsVM: temperatureAggregationsVM,
                        totalSteps: $totalSteps,
                        vector: AnimatableVector(values: minimums),
                        steps: steps,
                        minValue: $minValue,
                        maxValue: $maxValue,
                        timeFrame: $timeFrame
                    )
                    .stroke(Color.blue, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                    .animation(.linear, value: minimums)

                    LineShape(
                        temperatureAggregationsVM: temperatureAggregationsVM,
                        totalSteps: $totalSteps,
                        vector: AnimatableVector(values: averages),
                        steps: steps, minValue: $minValue,
                        maxValue: $maxValue,
                        timeFrame: $timeFrame
                    )
                    .stroke(Color.green, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                    .animation(.linear, value: averages)

                    LineShape(
                        temperatureAggregationsVM: temperatureAggregationsVM,
                        totalSteps: $totalSteps,
                        vector: AnimatableVector(values: maximums),
                        steps: steps,
                        minValue: $minValue,
                        maxValue: $maxValue,
                        timeFrame: $timeFrame
                    )
                    .stroke(Color.red, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                    .animation(.linear, value: maximums)
                    
                } else if temperatureAggregationsVM.loadingStateDay == .loading || temperatureAggregationsVM.loadingStateWeek == .loading || temperatureAggregationsVM.loadingStateMonth == .loading {
                    ProgressView()
                } else {
                    Text("No data available")
                        .foregroundColor(.secondary)
                        .padding(3)
                        .background(.thinMaterial)
                        .cornerRadius(5)
                }
                
                if showIndicator {
                    VStack {
                        self.verticalLine(height: geo.size.height, width: positionOfClosestPoint.x)
                            .stroke((Color.secondary), style: StrokeStyle(lineWidth: 2, lineCap: .round))
                            .rotationEffect(.degrees(180), anchor: .center)
                            .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                        }
                }
            }
            .contentShape(Rectangle())
            .gesture(DragGesture()
                        .onChanged({ value in
                            if [0].count != 0 {
                                self.touchLocation = value.location
                                self.showIndicator = true
                                self.positionOfClosestPoint = self.getClosestDataPoint(
                                                                                toPoint: value.location,
                                                                                width: geo.size.width,
                                                                                height: geo.size.height
                                                                            )
                            }
                        })
                        .onEnded({ _ in
                            self.showIndicator = false
                        })
            )
        }
    }

    func horizontalLine(width: CGFloat) -> Path {
        var hLine = Path()
        hLine.move(to: CGPoint(x: 0, y: 0.0))
        hLine.addLine(to: CGPoint(x: width, y: 0.0))
        return hLine
    }

    func verticalLine(height: CGFloat, width: CGFloat) -> Path {
        var hLine = Path()
        hLine.move(to: CGPoint(x: width, y: 0.0))
        hLine.addLine(to: CGPoint(x: width, y: height))
        return hLine
    }

    @discardableResult func getClosestDataPoint(toPoint: CGPoint, width: CGFloat, height: CGFloat) -> CGPoint {
        let points = self.minimums
        let steps = self.steps
        let stepWidth: CGFloat = width / CGFloat(totalSteps)
        let stepHeight: CGFloat = height / CGFloat(points.max()! + points.min()!)
        let index: Int = Int(round((toPoint.x)/stepWidth))

        if index >= 0 && index < totalSteps+1 {
            self.selectedIndex = getIndexOfStep(step: index)
            return CGPoint(x: CGFloat(steps[getIndexOfStep(step: index)])*stepWidth, y: CGFloat(1)*stepHeight)
        }
        if index < 0 {
        return .zero
        } else {
            return CGPoint(x: CGFloat(steps[getIndexOfStep(step: totalSteps)])*stepWidth, y: CGFloat(1)*stepHeight)
        }
    }

    func getIndexOfStep(step: Int) -> Int {
        let closest = steps.enumerated().min( by: { abs($0.1 - step) < abs($1.1 - step) })!
        return closest.offset
    }

    func setMinMax() {
        var allValues = [Double]()
        allValues += maximums
        allValues += minimums
        allValues += averages
        minValue = allValues.min()!
        maxValue = allValues.max()!
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(
            temperatureAggregationsVM: TemperatureAggregationsViewModel(),
            nrOfLines: 5,
            timeFrame: .constant(.day),
            minValue: .constant(0.0),
            maxValue: .constant(30.0),
            totalSteps: .constant(1),
            steps: .constant([0, 1]),
            minimums: .constant([0.0, 20.0]),
            averages: .constant([10.0, 25.0]),
            maximums: .constant([20.0, 30.0]),
            selectedIndex: .constant(0),
            showIndicator: .constant(false))
    }
}
