import Foundation

struct User : Decodable {
    var id : Int
    var name : String
    var username : String
}

// Bu yapı generic bir yapıya çevrilecek

func request (url : URL , completion : @escaping (Result<[User] , Error>) -> Void ) ->Void {
    let urlSessionTask = URLSession.shared.dataTask(with: url){(data , response , error) in
        if let error = error {
            print(error)
        }
        if let response = response as?  HTTPURLResponse {
            print(response.statusCode)
        }
        if let data = data {
            do{
                let jsonData = try JSONDecoder().decode([User].self, from: data)
                completion(.success(jsonData))
            }
            catch let error {
                completion(.failure(error))
            }
            
        }
    }
    urlSessionTask.resume()
}

let url = URL(string: "https://jsonplaceholder.typicode.com/users")!

request(url: url) { result in
    switch result {
    case .success(let jsonData):
        // Dizi içindeki her bir User verisi için döngüyü başlat
        for user in jsonData {
            print("User ID:", user.username)
        }
    case .failure(let error):
        print("Error:", error)
    }
}
