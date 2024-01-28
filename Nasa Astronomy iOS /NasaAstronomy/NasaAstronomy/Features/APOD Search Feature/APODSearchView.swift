//
//  APODSearchView.swift
//  NasaAstronomy
//
//  Created by Bakur Khalvashi on 26.01.24.
//

import Foundation
import SwiftUI
import ComposableArchitecture
import Color_Extensions

struct SearchApodView: View {
    let store: StoreOf<APODSearchFeature>
    
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var isSheetPresented: Bool = false
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                if viewStore.isLoading {
                    ProgressView()
                } else if let apods = viewStore.apods {
                    if !apods.isEmpty {
                        List(apods) { apod in
                            ApodItemRow(store: Store(initialState: ApodItemReducer.State(),
                                                     reducer: {
                                ApodItemReducer()._printChanges()
                            }), imageUrl: apod.url, title: apod.title, description: apod.date)
                            .onTapGesture {
                                
                            }
                        }
                    } else {
                        VStack {
                            Button("Select Dates") {
                                isSheetPresented.toggle()
                            }
                            .buttonStyle(BorderedButtonStyle())
                            .padding()
                            .sheet(isPresented: $isSheetPresented) {
                                CalendarView(selectedStartDate: $startDate, selectedEndDate: $endDate)
                            }
                            
                            Button("Fetch apods by date") {
                                viewStore.send(.fetchApods(startDate: formattedDate(date: startDate), endDate: formattedDate(date: endDate)))
                            }
                            .buttonStyle(BorderedButtonStyle())
                        }
                        .padding()
                    }
                }
            }
            .background(LinearGradient(colors: [Color.Nasa.first,Color.Nasa.second,Color.Nasa.third], startPoint: .bottom, endPoint: .top))
            .preferredColorScheme(.dark)
        }
    }

    private func formattedDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
}

struct CalendarView: View {
    @Binding var selectedStartDate: Date
    @Binding var selectedEndDate: Date
    
    var body: some View {
        VStack {
            DatePicker("Start Date", selection: $selectedStartDate, in: ...Date(), displayedComponents: .date)
                .datePickerStyle(WheelDatePickerStyle())
            
            DatePicker("End Date", selection: $selectedEndDate, in: selectedStartDate...Date(), displayedComponents: .date)
                .datePickerStyle(WheelDatePickerStyle())
        }
    }
}

#Preview {
    SearchApodView(store: Store(initialState: APODSearchFeature.State(),
                                reducer: {
        APODSearchFeature()._printChanges()
    }))
}
