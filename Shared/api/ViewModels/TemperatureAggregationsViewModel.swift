//
//  TemperatureAggregationsViewModel.swift
//  Gfror.li
//
//  Created by Marc on 25.05.21.
//

import Foundation
import Combine
import SwiftUI

class TemperatureAggregationsViewModel: ObservableObject {
    
    @Published var minimumsDay = [Double]()
    @Published var averagesDay = [Double]()
    @Published var maximumsDay = [Double]()
    @Published var stepsDay = [Int]()
    @Published var loadingStateDay = NewLoadingState.loading
    
    @Published var minimumsWeek = [Double]()
    @Published var averagesWeek = [Double]()
    @Published var maximumsWeek = [Double]()
    @Published var stepsWeek = [Int]()
    @Published var loadingStateWeek = NewLoadingState.loading
    
    @Published var minimumsMonth = [Double]()
    @Published var averagesMonth = [Double]()
    @Published var maximumsMonth = [Double]()
    @Published var stepsMonth = [Int]()
    @Published var loadingStateMonth = NewLoadingState.loading
    
    @Published var isInSameDay = true
    @Published var isInSameWeek = true
    @Published var isInSameMonth = true
    
    @Published var errorMsg: LocalizedStringKey = "" { didSet { didChange.send(())}}
    
    let didChange = PassthroughSubject<Void, Never>()
    
    var dateDay: Date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: Date()))! {
        didSet {
            Task {
                await loadDays()
                checkSameDay()
            }
        }
    }
    var startDateWeek: Date = Calendar.current.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: Date()).date! {
        didSet {
            Task {
                await loadWeek()
                checkSameWeek()
            }
        }
    }
    var startDateMonth: Date = Calendar.current.dateComponents([.calendar, .month, .year], from: Date()).date! {
        didSet {
            Task {
                await loadMonth()
                checkSameMonth()
            }
        }
    }
    
    var id: Int = 0
    
    func loadDays() async {
        
        loadingStateDay = .loading
        
        let timeZoneOffsetInHours = Int(TimeZone.current.secondsFromGMT())/3600
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let start = dateFormatter.string(from: dateDay.advanced(by: -86400))
        let mid = dateFormatter.string(from: dateDay)
        let end = dateFormatter.string(from: dateDay.advanced(by: +86400))
        let url = URL(string: "https://watertemp-api.coredump.ch/api/mobile_app/sensors/\(id)/hourly_temperatures?from=\(start)&to=\(end)&limit=48")!
        var request = URLRequest(url: url)
        request.setValue(BearerToken.token, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        do {
            // Test for network connection
            if !Reachability.isConnectedToNetwork() {
                throw LoadingErrors.noConnectionError
            }
            // Send request
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // check response status code
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw LoadingErrors.fetchError
            }
            // try to decode
            guard var aggregs = try? JSONDecoder().decode([HourlyAggregation].self, from: data) else {
                throw LoadingErrors.decodeError
            }
            // update view model
            
            self.minimumsDay.removeAll()
            self.maximumsDay.removeAll()
            self.averagesDay.removeAll()
            self.stepsDay.removeAll()
            aggregs = aggregs.reversed()
            
            self.loadingStateDay = .failed

            for data in aggregs {
                if timeZoneOffsetInHours >= 0 {
                    if (data.date == start && (data.hour! + timeZoneOffsetInHours <= 23)) || (data.hour!+timeZoneOffsetInHours >= 24 && data.date == mid) || (data.date == end) {
                        continue
                    }
                    DispatchQueue.main.async {
                        self.minimumsDay.append(data.minTemp!.roundToDecimal(1))
                        self.maximumsDay.append(data.maxTemp!.roundToDecimal(1))
                        self.averagesDay.append(data.avgTemp!.roundToDecimal(1))
                        self.stepsDay.append((data.hour! + timeZoneOffsetInHours) % 24)
                        self.loadingStateDay = .loaded
                    }
                } else {
                    if (data.date == mid && (data.hour! + timeZoneOffsetInHours < 0)) || (data.date! == end && (data.hour! + timeZoneOffsetInHours > 0)) || (data.date == start) {
                        continue
                    }
                    DispatchQueue.main.async {
                        self.minimumsDay.append(data.minTemp!.roundToDecimal(1))
                        self.maximumsDay.append(data.maxTemp!.roundToDecimal(1))
                        self.averagesDay.append(data.avgTemp!.roundToDecimal(1))
                        self.stepsDay.append(self.handle(num: data.hour!+timeZoneOffsetInHours))
                        self.loadingStateDay = .loaded
                    }
                }
            }
            
        } catch {
            loadingStateDay = .failed
            switch error {
            case LoadingErrors.decodeError:
                errorMsg = "Could not decode Measurements."
            case LoadingErrors.fetchError:
                errorMsg = "Invalid server response."
            case LoadingErrors.noConnectionError:
                errorMsg = "No internet connection."
            default:
                errorMsg = LocalizedStringKey( error.localizedDescription )
            }
        }
    }
    
    func handle(num: Int) -> Int {
        if num < 0 {
            return num + 24
        }
        return num
    }
    
    public func loadWeek() async {
        
        loadingStateWeek = .loading
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let start = dateFormatter.string(from: startDateWeek)
        let end = dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: 6, to: startDateWeek)!)
        
        let url = URL(string: "https://watertemp-api.coredump.ch/api/mobile_app/sensors/\(id)/daily_temperatures?from=\(start)&to=\(end)&limit=7")!
        var request = URLRequest(url: url)
        request.setValue(BearerToken.token, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        do {
            // Test for network connection
            if !Reachability.isConnectedToNetwork() {
                throw LoadingErrors.noConnectionError
            }
            // Send request
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // check response status code
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw LoadingErrors.fetchError
            }
            // try to decode
            guard var aggregs = try? JSONDecoder().decode([DailyAggregation].self, from: data) else {
                throw LoadingErrors.decodeError
            }
            
            aggregs = aggregs.reversed()
            
            self.minimumsWeek.removeAll()
            self.maximumsWeek.removeAll()
            self.averagesWeek.removeAll()
            self.stepsWeek.removeAll()
            
            self.loadingStateWeek = .failed

            for data in aggregs {
                DispatchQueue.main.async {
                    self.minimumsWeek.append(data.minTemp!.roundToDecimal(1))
                    self.maximumsWeek.append(data.maxTemp!.roundToDecimal(1))
                    self.averagesWeek.append(data.avgTemp!.roundToDecimal(1))
                    let weekday = Calendar.current.component(.weekday, from: self.makeDateFromString(string: data.date!))
                    self.stepsWeek.append((abs(weekday+5))%7)
                    self.loadingStateWeek = .loaded
                }
            }
            
        } catch {
            loadingStateWeek = .failed
            switch error {
            case LoadingErrors.decodeError:
                errorMsg = "Could not decode Measurements."
            case LoadingErrors.fetchError:
                errorMsg = "Invalid server response."
            case LoadingErrors.noConnectionError:
                errorMsg = "No internet connection."
            default:
                errorMsg = LocalizedStringKey( error.localizedDescription )
            }
        }
    }
    
    public func loadMonth() async {
        
        DispatchQueue.main.async {
            self.loadingStateMonth = .loading
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let start = dateFormatter.string(from: startDateMonth)
        let end = dateFormatter.string(from: Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: startDateMonth)!)
        
        let url = URL(string: "https://watertemp-api.coredump.ch/api/mobile_app/sensors/\(id)/daily_temperatures?from=\(start)&to=\(end)&limit=32")!
        var request = URLRequest(url: url)
        request.setValue(BearerToken.token, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        do {
            // Test for network connection
            if !Reachability.isConnectedToNetwork() {
                throw LoadingErrors.noConnectionError
            }
            // Send request
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // check response status code
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw LoadingErrors.fetchError
            }
            // try to decode
            guard var aggregs = try? JSONDecoder().decode([DailyAggregation].self, from: data) else {
                throw LoadingErrors.decodeError
            }
            
            aggregs = aggregs.reversed()
            self.minimumsMonth.removeAll()
            self.maximumsMonth.removeAll()
            self.averagesMonth.removeAll()
            self.stepsMonth.removeAll()
            
            self.loadingStateMonth = .failed
            
            for data in aggregs {
                DispatchQueue.main.async {
                    self.minimumsMonth.append(data.minTemp!.roundToDecimal(1))
                    self.maximumsMonth.append(data.maxTemp!.roundToDecimal(1))
                    self.averagesMonth.append(data.avgTemp!.roundToDecimal(1))
                    let monthday = Calendar.current.component(.day, from: self.makeDateFromString(string: data.date!))
                    self.stepsMonth.append(monthday-1)
                    self.loadingStateMonth = .loaded
                }
            }
                        
        } catch {
            loadingStateMonth = .failed
            switch error {
            case LoadingErrors.decodeError:
                errorMsg = "Could not decode Measurements."
            case LoadingErrors.fetchError:
                errorMsg = "Invalid server response."
            case LoadingErrors.noConnectionError:
                errorMsg = "No internet connection."
            default:
                errorMsg = LocalizedStringKey( error.localizedDescription )
            }
        }
    }
    
    func makeDateFromString(string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: string)!
        return date
    }
    func addWeek() {
        startDateWeek=Calendar.current.date(byAdding: DateComponents( day: 7), to: startDateWeek)!
    }
    func subtractWeek() {
        startDateWeek=Calendar.current.date(byAdding: DateComponents( day: -7), to: startDateWeek)!
    }
    
    func addDay() {
        dateDay = Calendar.current.date(byAdding: DateComponents( day: 1), to: dateDay)!
        
    }
    func subtractDay() {
        dateDay=Calendar.current.date(byAdding: DateComponents( day: -1), to: dateDay)!
        
    }
    
    func addMonth() {
        startDateMonth = Calendar.current.date(byAdding: DateComponents(month: 1), to: startDateMonth)!
        
    }
    func subtractMonth() {
        startDateMonth = Calendar.current.date(byAdding: DateComponents(month: -1), to: startDateMonth)!
        
    }
    
    func checkSameDay() {
        let diffMonth = Calendar.current.dateComponents([.day], from: Date(), to: dateDay)
        if diffMonth.day == 0 {
            isInSameDay = true
        } else {
            isInSameDay = false
        }
    }
    
    func checkSameWeek() {
        let diffMonth = Calendar.current.dateComponents([.weekOfYear], from: Date(), to: startDateWeek)
        if diffMonth.weekOfYear == 0 {
            isInSameWeek = true
        } else {
            isInSameWeek = false
        }
    }
    
    func checkSameMonth() {
        let diffMonth = Calendar.current.dateComponents([.month], from: Date(), to: startDateMonth)
        if diffMonth.month == 0 {
            isInSameMonth = true
        } else {
            isInSameMonth = false
        }
    }
    
}

extension Double {
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
}
