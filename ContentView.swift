//
//  ContentView.swift
//  Neighborhood and Market Trend Analyzer
//
//  Created by Ashmit Pai on 3/29/25.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var searchText = ""
    @State private var selectedFilter = "Apartments"
    @State private var showFilters = false
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 33.42, longitude: -111.93),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    let filterOptions = ["Apartments", "Houses", "Condos", "All Properties"]
    let featuredProperties = [
        Property(
            id: 1,
            title: "Modern Downtown Apartment",
            price: "$1,850/mo",
            beds: 2,
            baths: 2,
            sqft: 1200,
            address: "35 E University Dr, Tempe, AZ 85281",
            imageNames: ["Modern", "Balcony"],
            latitude: 33.41473,
            longitude: -111.91332
        ),
        Property(
            id: 2,
            title: "Luxury High-Rise Studio",
            price: "$1,350/mo",
            beds: 1,
            baths: 1,
            sqft: 750,
            address: "709 E Apache Blvd, Tempe, AZ 85281",
            imageNames: ["ApIcon", "View"],
            latitude: 33.42195,
            longitude: -111.94354
        ),
        Property(
            id: 3,
            title: "Spacious 3BR with View",
            price: "$2,400/mo",
            beds: 3,
            baths: 2,
            sqft: 1600,
            address: "105 S Mill Ave, Tempe, AZ 85281",
            imageNames: ["View", "Modern", "Balcony"],
            latitude: 33.41919,
            longitude: -111.94333
        )
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    HStack {
                        Text("AxelR8")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                        Spacer()
                        Button(action: {}) {
                            Image(systemName: "person.circle.fill")
                                .font(.title)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search by location, zip code, or address", text: $searchText)
                        if !searchText.isEmpty {
                            Button(action: { searchText = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(filterOptions, id: \.self) { option in
                                Button(action: { selectedFilter = option }) {
                                    Text(option)
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 16)
                                        .background(selectedFilter == option ? Color.blue : Color(.systemGray6))
                                        .foregroundColor(selectedFilter == option ? .white : .primary)
                                        .cornerRadius(20)
                                }
                            }
                            Button(action: { showFilters.toggle() }) {
                                HStack {
                                    Image(systemName: "slider.horizontal.3")
                                    Text("Filters")
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(Color(.systemGray6))
                                .foregroundColor(.primary)
                                .cornerRadius(20)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    Map(coordinateRegion: $region, annotationItems: featuredProperties) { property in
                        MapMarker(coordinate: CLLocationCoordinate2D(latitude: property.latitude, longitude: property.longitude))
                    }
                    .frame(height: 200)
                    .cornerRadius(10)
                    .padding(.horizontal)
                    
                    HStack {
                        Text("Featured Apartments")
                            .font(.headline)
                        Spacer()
                        Button(action: {}) {
                            Text("View All")
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.horizontal)
                    
                    ForEach(featuredProperties) { property in
                        NavigationLink(destination: PropertyDetailView(property: property)) {
                            PropertyCard(property: property)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Recently Viewed")
                            .font(.headline)
                            .padding(.horizontal)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(featuredProperties) { property in
                                    NavigationLink(destination: PropertyDetailView(property: property)) {
                                        SmallPropertyCard(property: property)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showFilters) {
                FilterView(isPresented: $showFilters)
            }
        }
    }
}

struct FilterView: View {
    @Binding var isPresented: Bool
    @State private var lowerBoundPrice: Float = 500
    @State private var upperBoundPrice: Float = 5000
    @State private var beds = 0
    @State private var baths = 0
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Price Range")) {
                    Text("$\(Int(lowerBoundPrice)) - $\(Int(upperBoundPrice))")
                    Slider(value: $lowerBoundPrice, in: 500...5000)
                    Slider(value: $upperBoundPrice, in: 500...5000)
                }
                Section(header: Text("Bedrooms")) {
                    Picker("Minimum Beds", selection: $beds) {
                        ForEach(0..<5) { number in
                            Text(number == 0 ? "Any" : "\(number)+").tag(number)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                Section(header: Text("Bathrooms")) {
                    Picker("Minimum Baths", selection: $baths) {
                        ForEach(0..<5) { number in
                            Text(number == 0 ? "Any" : "\(number)+").tag(number)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                Section {
                    Button(action: { isPresented = false }) {
                        Text("Apply Filters")
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .navigationTitle("Filters")
            .navigationBarItems(trailing: Button("Close") { isPresented = false })
        }
    }
}

struct PropertyCard: View {
    let property: Property
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topTrailing) {
                Image(property.imageNames.first ?? "")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .clipped()
                    .cornerRadius(10)
                Button(action: {}) {
                    Image(systemName: "heart")
                        .padding(8)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(radius: 2)
                        .padding(8)
                }
            }
            VStack(alignment: .leading, spacing: 8) {
                Text(property.price)
                    .font(.title2)
                    .fontWeight(.bold)
                Text(property.title)
                    .font(.headline)
                HStack {
                    Text("\(property.beds) beds")
                    Text("•")
                    Text("\(property.baths) baths")
                    Text("•")
                    Text("\(property.sqft) sq ft")
                }
                .font(.subheadline)
                .foregroundColor(.gray)
                Text(property.address)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 10)
        }
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }
}

struct SmallPropertyCard: View {
    let property: Property
    
    var body: some View {
        VStack(alignment: .leading) {
            Image(property.imageNames.first ?? "")
                .resizable()
                .scaledToFill()
                .frame(width: 160, height: 100)
                .clipped()
                .cornerRadius(10)
            VStack(alignment: .leading, spacing: 4) {
                Text(property.price)
                    .font(.headline)
                    .fontWeight(.bold)
                Text("\(property.beds) bd • \(property.baths) ba")
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(property.address)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            .padding(.horizontal, 4)
        }
        .frame(width: 160)
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 1)
    }
}

struct Property: Identifiable {
    let id: Int
    let title: String
    let price: String
    let beds: Int
    let baths: Int
    let sqft: Int
    let address: String
    let imageNames: [String]
    let latitude: Double
    let longitude: Double
}

struct ContentView_Previews: PreviewProvider {

static var previews: some View {

    ContentView()

     }

}
