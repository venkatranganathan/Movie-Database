//
//  Movie.swift
//  Movie Database
//
//  Created by M_AMBIN06088 on 16/08/23.
//

import Foundation

struct MovieData: Decodable {
    let Title: String
    let Year: String
    let Rated: String
    let Released: String
    let Runtime: String
    let Genre: String
    let Director: String
    let Writer: String
    let Actors: String
    let Plot: String
    let Language: String
    let Country: String
    let Awards: String
    let Poster: String
    let Metascore: String
    let imdbRating: String
    let imdbVotes: String
    let imdbID: String
    let `Type`: String
    let DVD: String?
    let BoxOffice: String?
    let Production: String?
    let Website: String?
    let Response: String
    let Ratings: [Ratings]
}


struct Ratings: Decodable {
    let Source: String
    let Value: String
}
