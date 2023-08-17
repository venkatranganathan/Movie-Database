//
//  MovieManager.swift
//  Movie Database
//
//  Created by M_AMBIN06088 on 16/08/23.
//

import Foundation

protocol MovieManagerDelegate {
    func didLoadItems(_ movieManager: MovieManager, movies: [MovieData])
    func didFailWithError(error: Error)
}

struct MovieManager {
    
    var delegate: MovieManagerDelegate?
    
    func loadItems() {
        if let path = Bundle.main.path(forResource: "movies", ofType: "json") {
            do {
                let movieData = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                if let movies = self.parseJSON(movieData) {
                    self.delegate?.didLoadItems(self, movies: movies)
                }
            } catch {
                // handle error
                delegate?.didFailWithError(error: error)
            }
        }
    }
    
    func parseJSON(_ movieData: Data) -> [MovieData]? {
        let decoder = JSONDecoder()
        do {
            var decodedData = try decoder.decode([MovieData].self, from: movieData)
            // If we need to filter out series, please uncomment
//            decodedData = decodedData.filter({$0.Type == "movie"})
            return decodedData
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    func getSubItems(_ type: String, movies: [MovieData]) -> [String]? {
        var subItem = [String]()
        switch type {
        case "Year":
            subItem = movies.compactMap{$0.Year}
        case "Genre":
            subItem = movies.compactMap{$0.Genre}
        case "Directors":
            subItem = movies.compactMap{$0.Director}
        case "Actors":
            subItem = movies.compactMap{$0.Actors}
        default:
            subItem = []
        }
        return subItem
    }
    
    func isYearRange(_ item: MovieData, year: String) -> Bool{
        var years = item.Year.components(separatedBy: "–")
        years = years.filter{$0 != ""}
        if(years.count < 2){
            years.append(String(Calendar.current.component(.year, from: Date())))
        }
        if let a = Int(years[0]), let b = Int(year), let c = Int(years[1]){
            return a <= b || b <= c
        }
        return false
    }
    
    func getFilteredItems(_ type: String,value: String, movies: [MovieData]) -> [MovieData]? {
        var items = [MovieData]()
        switch type {
        case "Year":
            items = movies.filter{$0.Year.contains("–") ?  isYearRange($0, year: value) : $0.Year.contains(value)}
        case "Genre":
            items = movies.filter{$0.Genre.contains(value)}
        case "Directors":
            items = movies.filter{$0.Director.contains(value)}
        case "Actors":
            items = movies.filter{$0.Actors.contains(value)}
        default:
            items = []
        }
        return items
    }
    
    func searchItems(_ value: String, movies: [MovieData]) -> [MovieData]? {
        return movies.filter{($0.Year.contains("–") ?  isYearRange($0, year: value) : $0.Year.contains(value)) || ($0.Genre.contains(value)) || ($0.Director.contains(value)) || ($0.Actors.contains(value)) || ($0.Title.contains(value))} // added search by title as it will be easy for user
    }
    
}
