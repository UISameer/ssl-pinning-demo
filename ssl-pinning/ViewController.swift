import UIKit
import Alamofire

class ViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    private var selectedUser: User?
    
    var users: [User] = [] {
        didSet {
            tableView.isHidden = false
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Stack Overflow Users"
        
        tableView.isHidden = true
        tableView.dataSource = self
        
        NetworkClient.request(Router.users)
            .responseDecodable { (response: DataResponse<UserList, AFError>) in
                switch response.result {
                case .success(let value):
                    self.users = value.users
                case .failure(let error):
                    let isServerTrustEvaluationError =
                    error.asAFError?.isServerTrustEvaluationError ?? false
                    let message: String
                    if isServerTrustEvaluationError {
                        message = "Certificate Pinning Error"
                    } else {
                        message = error.localizedDescription
                    }
                    self.presentError(withTitle: "Oops!", message: message)
                }
            }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailSegue",
           let destination = segue.destination as? DetailViewController,
           let cell = sender as? UITableViewCell,
           let indexPath = tableView.indexPath(for: cell) {
            destination.user = users[indexPath.item]
            cell.isSelected = false
        }
    }
    
    func presentError(withTitle title: String,
                      message: String,
                      actions: [UIAlertAction] = [UIAlertAction(title: "OK", style: .default)]) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        actions.forEach { action in
            alertController.addAction(action)
        }
        present(alertController, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",
                                                 for: indexPath)
        cell.textLabel?.text = users[indexPath.item].displayName
        return cell
    }
}
