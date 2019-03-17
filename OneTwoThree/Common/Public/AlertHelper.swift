import UIKit

public class AlertHelper {
	
	public static func alertWith(title: String?, message: String?, controller: UIViewController, buttons: [String]?, completion: ((UIAlertAction, UIViewController, Int) -> Void)?) -> UIAlertController {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		if let aButtons = buttons {
			for (index, text) in aButtons.enumerated() {
				let action = UIAlertAction(title: text, style: .default, handler: { (action: UIAlertAction) in
					if completion != nil {
						completion!(action, controller, index)
					}
				})
				alert.addAction(action)
			}
		}
		else {
			let action = UIAlertAction(title: String(.ok), style: .default, handler: { (action: UIAlertAction) in
				alert.dismiss(animated: true, completion: nil)
				if( completion != nil) {
					completion!(action, controller, 0)
				}
			})
			alert.addAction(action)
		}
		return alert
	}	
}
