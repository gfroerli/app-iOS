//
//  SensorOverViewGraph.swift
//  iOS
//
//  Created by Marc Kramer on 11.09.20.
//

import SwiftUI

struct SensorOverViewGraph: View {
    
    var sensorId: Int
    
    @AppStorage("showHand") private var showHand = true
    @StateObject var temperatureAggregationsVM: TemperatureAggregationsViewModel = TemperatureAggregationsViewModel()
    
    @State var animation = false
    @State var animationEnded = false
    @State var showIndicator = false
    @State var selectedIndex = 0
    @State var zoomed = true
    
    @State var pickerSelection = 0
    @State var pickerOptions = [NSLocalizedString("Day", comment: ""),
                                NSLocalizedString("Week", comment: ""),
                                NSLocalizedString("Month", comment: "")]
    
    @State var timeFrame: TimeFrame = .day
    @State var topString = ""
    
    init(sensorID: Int) {
        self.sensorId = sensorID
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .firstTextBaseline) {
                Text("History")
                    .font(.title)
                    .bold()
                Spacer()
                if showIndicator {
                    Text(topString)
                        .bold()
                        .minimumScaleFactor(0.1)
                        .lineLimit(1)
                } else {
                    Button(action: {
                        zoomed.toggle()
                    }, label: {
                        if zoomed {
                            Text(Image(systemName: "minus.magnifyingglass")).font(.title2)
                        } else {
                            Text(Image(systemName: "plus.magnifyingglass")).font(.title2)
                        }
                    })
                }
            }
            
            HStack(alignment: .center) {
                if !showIndicator {
                    Picker(selection: $pickerSelection, label: Text("")) {
                        ForEach(0..<pickerOptions.count) { index in
                            Text(self.pickerOptions[index]).tag(index)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                } else {
                    Spacer()
                    TemperaturesDetailView(
                        temperatureAggregationsVM: temperatureAggregationsVM,
                        index: $selectedIndex,
                        pickerSelection: $pickerSelection
                    ).padding(.top)
                    Spacer()
                }
            }.frame(height: 55)
            
            ZStack {
                if !animationEnded && temperatureAggregationsVM.stepsDay.count != 0  && showHand{
                    Image(systemName: "hand.draw.fill")
                        .resizable()
                        .font(.largeTitle)
                        .foregroundColor(.secondary)
                        .frame(width: 100, height: 100, alignment: .center)
                        .offset(x: self.animation ? 60 : -20)
                        .onAppear(perform: {
                            
                            self.animation = true
                            withAnimation(handAnimation) {
                                self.animation = false
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                animationEnded = true
                                showHand = false
                            }
                            
                        })
                    
                }
                
                GraphView(
                    nrOfLines: 5,
                    timeFrame: $timeFrame,
                    selectedIndex: $selectedIndex,
                    zoomed: $zoomed,
                    showIndicator: $showIndicator,
                    temperatureAggregationsVM: temperatureAggregationsVM
                )
            }
            
            HStack(alignment: .firstTextBaseline) {
                Label("Minimum", systemImage: "circle.fill").foregroundColor(.blue)
                Spacer()
                Label("Average", systemImage: "circle.fill").foregroundColor(.green)
                Spacer()
                Label("Maximum", systemImage: "circle.fill").foregroundColor(.red)
            }
            .padding([.horizontal, .bottom])
            .lineLimit(1)
            .minimumScaleFactor(0.1)
            
            HStack(alignment: .center) {
                Spacer()
                Button(action: {
                    stepBack()
                }, label: {
                    Image(systemName: "arrow.left.circle").imageScale(.large)
                })
                Spacer()
                Text(getLabel())
                Spacer()
                Button(action: {
                    stepForward()
                    
                }, label: {
                    Image(systemName: "arrow.right.circle").imageScale(.large)
                }).disabled(checkTimeFrame())
                Spacer()
            }
        }
        .padding()
        
        .onChange(of: pickerSelection, perform: { _ in
            setTimeFrame()
        })
        .onChange(of: selectedIndex, perform: { _ in
            setTopDateString()
        })
        .onAppear {
            temperatureAggregationsVM.id = sensorId
        }
    }
    
    func setTimeFrame() {
        switch pickerSelection {
        case 0:
            timeFrame = .day
        case 1:
            timeFrame = .week
        default:
            timeFrame = .month
        }
    }
    
    func stepBack() {
        switch pickerSelection {
        case 0:
            temperatureAggregationsVM.subtractDay()
        case 1:
            temperatureAggregationsVM.subtractWeek()
        default:
            temperatureAggregationsVM.subtractMonth()
        }
        checkTimeFrame()
    }
    
    func stepForward() {
        switch pickerSelection {
        case 0:
            temperatureAggregationsVM.addDay()
        case 1:
            temperatureAggregationsVM.addWeek()
        default:
            temperatureAggregationsVM.addMonth()
        }
        checkTimeFrame()
    }
    
    func getLabel() -> String {
        let dateFormatter = DateFormatter()
        
        switch pickerSelection {
        case 0:
            dateFormatter.setLocalizedDateFormatFromTemplate("dd MMM")
            return dateFormatter.string(from: temperatureAggregationsVM.dateDay)
            
        case 1:
            dateFormatter.setLocalizedDateFormatFromTemplate("dd MMM")
            return dateFormatter.string(from:
                                            temperatureAggregationsVM.startDateWeek)
            + "-"
            + dateFormatter.string(from:
                                    Calendar.current.date(byAdding: .day, value: 6, to: temperatureAggregationsVM.startDateWeek)!
            )
            
        default:
            dateFormatter.setLocalizedDateFormatFromTemplate("MMMM YYYY")
            return dateFormatter.string(from: temperatureAggregationsVM.startDateMonth)
        }
    }
    
    func setTopDateString() {
        let dateFormatter = DateFormatter()
        let calendar = Calendar.current
        
        switch pickerSelection {
        case 0:
            let date = temperatureAggregationsVM.dateDay
            var components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
            components.minute = 0
            components.hour = temperatureAggregationsVM.stepsDay[selectedIndex]
            let createdDate = calendar.date(from: components)!
            dateFormatter.setLocalizedDateFormatFromTemplate("mmHddMMMMY")
            topString =  dateFormatter.string(from: createdDate)
            
        case 1:
            let date = temperatureAggregationsVM.startDateWeek
            var components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
            components.day! += temperatureAggregationsVM.stepsWeek[selectedIndex]
            dateFormatter.setLocalizedDateFormatFromTemplate("EEEEddMMMMY")
            topString =  dateFormatter.string(from: calendar.date(from: components)!)
            
        default:
            let date = temperatureAggregationsVM.startDateMonth
            var components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
            components.day! += temperatureAggregationsVM.stepsMonth[selectedIndex]
            dateFormatter.setLocalizedDateFormatFromTemplate("dd MMMM Y")
            topString =  dateFormatter.string(from: calendar.date(from: components)!)
        }
    }
    
    private func checkTimeFrame() -> Bool {
        switch timeFrame {
        case .day:
            return temperatureAggregationsVM.isInSameDay
        case .week:
            return temperatureAggregationsVM.isInSameWeek
        default:
            return temperatureAggregationsVM.isInSameMonth
        }
    }
    
    var handAnimation: Animation {
        Animation.easeInOut(duration: 1)
            .repeatCount(3, autoreverses: true)
    }
}

struct SensorOverViewGraph_Previews: PreviewProvider {
    static var previews: some View {
        SensorOverViewGraph(sensorID: 1)
            .makePreViewModifier()
        
    }
}

struct TemperaturesDetailView: View {
    
    @ObservedObject var temperatureAggregationsVM: TemperatureAggregationsViewModel
    @Binding var index: Int
    @Binding var pickerSelection: Int
    
    var body: some View {
        
        HStack {
            Spacer()
            VStack(alignment: .center) {
                Text("Minimum").bold()
                Text(makeTemperatureString(double: getMin()))
            }
            Spacer()
            VStack(alignment: .center) {
                Text("Average").bold()
                Text(makeTemperatureString(double: getAvg()))
            }
            Spacer()
            VStack(alignment: .center) {
                Text("Maximum").bold()
                Text(makeTemperatureString(double: getMax()))
            }
            Spacer()
        }
        .minimumScaleFactor(0.1)
        .lineLimit(1)
        
    }
    
    func getMin() -> Double {
        if pickerSelection == 0 {
            return temperatureAggregationsVM.minimumsDay[index]
        } else if pickerSelection == 1 {
            return temperatureAggregationsVM.minimumsWeek[index]
        } else {
            return temperatureAggregationsVM.minimumsMonth[index]
        }
    }
    
    func getAvg() -> Double {
        if pickerSelection == 0 {
            return temperatureAggregationsVM.averagesDay[index]
        } else if pickerSelection == 1 {
            return temperatureAggregationsVM.averagesWeek[index]
        } else {
            return temperatureAggregationsVM.averagesMonth[index]
        }
    }
    
    func getMax() -> Double {
        if pickerSelection == 0 {
            return temperatureAggregationsVM.maximumsDay[index]
        } else if pickerSelection == 1 {
            return temperatureAggregationsVM.maximumsWeek[index]
        } else {
            return temperatureAggregationsVM.maximumsMonth[index]
        }
    }
}
