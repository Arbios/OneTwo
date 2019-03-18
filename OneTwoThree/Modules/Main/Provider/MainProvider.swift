import Foundation

enum ProjectIKResult {
	case success(width: String, height: String)
	case failure(Error?)
}

enum SilentCalculateResult {
	case success(price: Int, date: String)
	case failure(String?)
}


protocol MainProviderProtocol {
	func getWidthAndHeight(projectId: Int, completion: @escaping (ProjectIKResult) -> Void)
	func silentCalculatePriceAndDate(projectId: Int, params: [String: Any], completion: @escaping (SilentCalculateResult) -> Void)
}

final class MainProvider: MainProviderProtocol {
	
	func getWidthAndHeight(projectId: Int, completion: @escaping (ProjectIKResult) -> Void) {
		URLSession.shared.dataTask(with: APIRequest.getProjectIk(projectId: projectId).request) { (data, response, error) in
			guard error == nil, let data = data else {
				completion(.failure(error))
				return
			}
			
			do {
				let outputJson = try JSONDecoder().decode(Output.self, from: data)
				completion(.success(width: outputJson.ik.inputs[0].value, height: outputJson.ik.inputs[1].value))
			}
			catch let error {
				completion(.failure(error))
			}
			}.resume()
	}
	
	func silentCalculatePriceAndDate(projectId: Int, params: [String: Any], completion: @escaping (SilentCalculateResult) -> Void) {
		URLSession.shared.dataTask(with: APIRequest.silentCalculate(projectId: projectId, params: params).request) { data, response, error in
			guard let data = data, error == nil else {
				completion(.failure(error?.localizedDescription))
				return
			}
			
			guard let jsonData = try? JSONSerialization.jsonObject(with: data, options: []),
				let jsonDict = jsonData as? [String: Any] else {
					completion(.failure(String(.errorParseJson)))
					return
			}
			
			let outputObject = SecondOutput(json: jsonDict)
			guard let price = outputObject.price,
				let date = outputObject.createdAt else {
					completion(.failure(String(.noPriceAndDate)))
					return
			}
			completion(.success(price: price, date: date))
			}.resume()
	}
}
