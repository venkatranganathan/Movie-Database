//
//  BaseViewController.swift
//  Movie Database
//
//  Created by M_AMBIN06088 on 16/08/23.
//

import UIKit

class BaseViewController: UIViewController {
    
    @IBOutlet weak var baseTableView: UITableView!
    @IBOutlet weak var movieSearch: UISearchBar!
    let baseItems = ["Year", "Genre", "Directors", "Actors", "All Movies"]
    var hiddenSections = Set<Int>()
    var movieItems: [MovieData] = []
    var tableMovieItems: [MovieData] = []
    var baseSubItems = [[String]]()
    
    var movieManager = MovieManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        movieManager.delegate = self
        baseTableView.register(UINib(nibName: "MovieCell", bundle: nil), forCellReuseIdentifier: "MovieCell")
        
        movieManager.loadItems()
        baseSubItems = [[], [], [], [], []]
    }
    
    
}

extension BaseViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("searchText textDidChange \(searchText)")
        if(searchText == ""){
            tableMovieItems = movieItems
            baseTableView.reloadData()
            searchBar.resignFirstResponder()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchText \(searchBar.text)")
        searchBar.resignFirstResponder()
        movieSearch.text = searchBar.text?.trimmingCharacters(in: .whitespaces)
        tableMovieItems =  movieManager.searchItems(movieSearch?.text ?? "", movies: movieItems) ?? movieItems
        baseTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension BaseViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (movieSearch.text != "") ? 1 : self.baseItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (movieSearch.text != "") ? 0 : 60
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        // UIView with darkGray background for section-separators as Section Footer
        let v = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 0.1))
        v.backgroundColor = .darkGray
        return v
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        // Section Footer height
        return (movieSearch.text != "") ? 0 : 0.4
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let baseCell = tableView.dequeueReusableCell(withIdentifier: "baseItemCell")
        baseCell?.textLabel?.text = baseItems[section]
        baseCell?.tag = section
        if(baseItems[section] != "All Movies"){
            let tapGestureRecognizer = UITapGestureRecognizer(
                target: self,
                action: #selector(self.hideSection(_:))
            )
            
            baseCell?.addGestureRecognizer(tapGestureRecognizer)
        }
        else{
            let tapGestureRecognizer = UITapGestureRecognizer(
                target: self,
                action: #selector(self.showAllMovies(_:))
            )
            
            baseCell?.addGestureRecognizer(tapGestureRecognizer)
        }
        return (movieSearch.text != "") ? nil : baseCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (movieSearch.text != "") ? tableMovieItems.count : baseSubItems[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (movieSearch.text != "") ? 120 : 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(movieSearch.text == ""){
            let cell = tableView.dequeueReusableCell(withIdentifier: "baseItemCell")! as UITableViewCell
            cell.textLabel?.text = baseSubItems[indexPath.section][indexPath.row]
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
            let movieItem: MovieData = tableMovieItems[indexPath.row]
            cell.movieTitle?.text = movieItem.Title
            cell.movieLanguages?.text = movieItem.Language
            cell.movieYear?.text = movieItem.Year
            cell.moviePoster.image = UIImage(systemName: "photo.fill")
            if(movieItem.Poster != "" && movieItem.Poster != "N/A"){
                cell.moviePoster.load(urlString: movieItem.Poster)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(movieSearch.text == ""){
            movieSearch?.text = baseSubItems[indexPath.section][indexPath.row]
            movieSearch.resignFirstResponder()
            if let items = movieManager.getFilteredItems(baseItems[indexPath.section], value: baseSubItems[indexPath.section][indexPath.row], movies: movieItems) {
                self.tableMovieItems = items
                self.baseTableView.reloadData()
            }
        }
        else{
            
        }
    }
    
    @objc private func showAllMovies(_ sender: UITapGestureRecognizer?){
        movieSearch?.text = " "
        movieSearch.resignFirstResponder()
        self.tableMovieItems = self.movieItems
        self.baseTableView.reloadData()
    }
    
    @objc private func hideSection(_ sender: UITapGestureRecognizer?) {
        guard let section = sender?.view?.tag else { return }
        print("section:: \(section)")
        func dataForSection() -> [String] {
            var subItemValues = Set<String>()
            if let subItems = movieManager.getSubItems(baseItems[section], movies: movieItems) {
                print("subItems:: \(subItems)")
                for i in 0..<subItems.count {
                    let val: String = subItems[i]
                    if(val.contains(", ")){
                        let valArray = val.components(separatedBy: ", ")
                        for j in 0..<valArray.count {
                            let subVal: String = valArray[j]
                            subItemValues.insert(subVal)
                        }
                    }
                    else if(val.contains("–")){
                        let valArray = val.components(separatedBy: "–")
                        let subVal: String = valArray[0]
                        subItemValues.insert(subVal)
                    }
                    else{
                        subItemValues.insert(val)
                    }
                }
            }
            print("subItemValues:: \(subItemValues)")
            return Array(subItemValues.sorted())
        }
        
        if self.hiddenSections.contains(section) {
            self.hiddenSections.remove(section)
            self.baseSubItems[section] = []
            self.baseTableView.reloadData()
        } else {
            self.hiddenSections.insert(section)
            let values = dataForSection()
            self.baseSubItems[section] = values
            self.baseTableView.reloadData()
        }
    }
    
}

//MARK: - MovieManagerDelegate


extension BaseViewController: MovieManagerDelegate {
    func didLoadItems(_ movieManager: MovieManager, movies: [MovieData]) {
        DispatchQueue.main.async {
            self.movieItems = movies
            self.tableMovieItems = movies
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

