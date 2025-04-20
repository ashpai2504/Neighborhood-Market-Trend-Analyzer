//
//  PropertyDetailView.swift
//  Neighborhood and Market Trend Analyzer
//
//  Created by Ashmit Pai on 3/29/25.
//

import SwiftUI
import MapKit

struct PropertyDetailView: View {
    let property: Property
    @Environment(\.presentationMode) var presentationMode
    @State private var currentImageIndex = 0
    @State private var region: MKCoordinateRegion
    
    init(property: Property) {
        self.property = property
        _region = State(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: property.latitude, longitude: property.longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        ))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                TabView(selection: $currentImageIndex) {
                    ForEach(0..<property.imageNames.count, id: \.self) { index in
                        Image(property.imageNames[index])
                            .resizable()
                            .scaledToFill()
                            .frame(height: 300)
                            .clipped()
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(height: 300)
                .overlay(
                    HStack {
                        Button(action: { presentationMode.wrappedValue.dismiss() }) {
                            Image(systemName: "chevron.left")
                                .padding(8)
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(radius: 2)
                        }
                        Spacer()
                        Button(action: {}) {
                            Image(systemName: "square.and.arrow.up")
                                .padding(8)
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(radius: 2)
                        }
                        Button(action: {}) {
                            Image(systemName: "heart")
                                .padding(8)
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(radius: 2)
                        }
                    }
                    .padding(),
                    alignment: .topLeading
                )
                
                VStack(alignment: .leading, spacing: 15) {
                    Text(property.price)
                        .font(.title)
                        .fontWeight(.bold)
                    Text(property.title)
                        .font(.title2)
                    Text(property.address)
                        .foregroundColor(.gray)
                    Divider()
                    HStack(spacing: 30) {
                        VStack {
                            Text("\(property.beds)")
                                .font(.title3)
                                .fontWeight(.bold)
                            Text("Beds")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        VStack {
                            Text("\(property.baths)")
                                .font(.title3)
                                .fontWeight(.bold)
                            Text("Baths")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        VStack {
                            Text("\(property.sqft)")
                                .font(.title3)
                                .fontWeight(.bold)
                            Text("Sq Ft")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical)
                    Divider()
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Neighborhood Insights")
                            .font(.headline)
                        HStack(spacing: 15) {
                            InsightCard(icon: "star.fill", title: "School Rating", value: "8/10")
                            InsightCard(icon: "shield.fill", title: "Crime Rate", value: "Low")
                            InsightCard(icon: "figure.walk", title: "Walk Score", value: "85/100")
                        }
                    }
                    Divider()
                    Text("Description")
                        .font(.headline)
                    Text("This beautiful apartment features modern finishes, an open floor plan, and plenty of natural light. The kitchen includes stainless steel appliances and granite countertops. Walking distance to shops, restaurants, and public transportation.")
                        .font(.body)
                        .foregroundColor(.secondary)
                    Divider()
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Location")
                            .font(.headline)
                        Map(coordinateRegion: $region, annotationItems: [property]) { _ in
                            MapMarker(
                                coordinate: CLLocationCoordinate2D(
                                    latitude: property.latitude,
                                    longitude: property.longitude
                                )
                            )
                        }
                        .frame(height: 200)
                        .cornerRadius(10)
                    }
                }
                .padding()
            }
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarHidden(true)
    }
}

struct InsightCard: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .font(.system(size: 24))
            Text(title)
                .font(.caption)
                .multilineTextAlignment(.center)
            Text(value)
                .font(.headline)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

