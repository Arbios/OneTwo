import UIKit

final class ViewController: UIViewController {
	
	private struct Constants {
		static let projectId: Int = 124472
	}
	
	//MARK: - Outlets
	
	@IBOutlet private(set) var currentProjectLabel: UILabel!
	@IBOutlet private(set) var currentProjectDateLabel: UILabel!
	@IBOutlet private(set) var currentProjectTextField: UITextField!
	@IBOutlet private(set) var resultPriceTextField: UITextField!
	@IBOutlet private(set) var resultTimeTextField: UITextField!
	@IBOutlet private(set) var newWidthTextField: UITextField!
	@IBOutlet private(set) var newHeightTextField: UITextField!
	
	
	//MARK: - Private variables
	
	private let provider: MainProviderProtocol = MainProvider()
	private let mockService: MockDataServiceProtocol = MockDataService()
	
	//MARK: - Actions
	
	@IBAction private func currentProjectAcceptButton(_ sender: UIButton) {
		view.endEditing(true)
		print(String(.error))
		guard let projectIdText = currentProjectTextField.text,
			let projectId = Int(projectIdText),
			projectId == Constants.projectId
			else {
				let alert = AlertHelper.alertWith(title: String(.error), message: "\(String(.currentProjectIsFail)) \(Constants.projectId)", controller: self, buttons: [String(.ok)], completion: nil)
				present(alert, animated: true, completion: nil)
				return
		}
		
		provider.getWidthAndHeight(projectId: projectId) { [weak self] (result) in
			guard let sSelf = self else { return }
			switch result {
			case let .success(width, height):
				sSelf.updateUIWithParameters(width: width, height: height)
			case let .failure(error):
				sSelf.showError(message: error?.localizedDescription)
			}
		}
	}
	
	@IBAction private func acceptParametersButoon(_ sender: UIButton) {
		self.view.endEditing(true)
		guard let widthText = newWidthTextField.text,
			let heightText = newHeightTextField.text,
			let width = Int(widthText),
			let height = Int(heightText) else {
				let alert = AlertHelper.alertWith(title: String(.error), message: String(.widthHeightEmpty), controller: self, buttons: [String(.ok)], completion: nil)
				present(alert, animated: true, completion: nil)
				return
		}
		
		guard let projectIdText = currentProjectTextField.text,
			let projectId = Int(projectIdText),
			projectId == Constants.projectId
			else {
				let alert = AlertHelper.alertWith(title: String(.error), message: "\(String(.currentProjectIsFail)) \(Constants.projectId)", controller: self, buttons: [String(.ok)], completion: nil)
				present(alert, animated: true, completion: nil)
				return
		}
		
		mockService.fetch(width: width, height: height) {[weak self] (result) in
			guard let sSelf = self else { return }
			switch result {
			case let .success(model):
				sSelf.provider.silentCalculatePriceAndDate(projectId: projectId, params: model, completion: { (result) in
					switch result {
					case let .success(price, date):
						sSelf.updateResultWithParameters(price: price, time: date)
					case let .failure(error):
						sSelf.showError(message: error)
					}
				})
			case let .failure(error):
				sSelf.showError(message: error)
			}
		}
		
	}
	
	private func updateUIWithParameters(width: String, height: String) {
		DispatchQueue.main.async {
			self.newWidthTextField.text = "\(width)"
			self.newHeightTextField.text = "\(height)"
			self.currentProjectLabel.text = "Текущий проект: \(Constants.projectId)"
			self.currentProjectDateLabel.text = "Дата создания: 16.03.2019"
		}
	}
	
	private func updateResultWithParameters(price: Int, time: String) {
		DispatchQueue.main.async {
			self.resultPriceTextField.text = "\(price) \(String(.currency))"
			self.resultTimeTextField.text = time
		}
	}
	
	private func showError(message: String?) {
		DispatchQueue.main.async {
			if let message = message {
				let alert = AlertHelper.alertWith(title: String(.error), message: "\(String(.serverErrorMessage)):\n \(message)", controller: self, buttons: [String(.ok)], completion: nil)
				self.present(alert, animated: true, completion: nil)
			}
			else {
				let alert = AlertHelper.alertWith(title: String(.error), message: "\(String(.serverErrorMessage))", controller: self, buttons: [String(.ok)], completion: nil)
				self.present(alert, animated: true, completion: nil)
			}
		}
	}
}
