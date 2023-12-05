import Foundation
import Alamofire

struct Certificates {
    static let stackExchange =
    Certificates.certificate(filename: "stackexchange.com")
    
    private static func certificate(filename: String) -> SecCertificate {
        let filePath = Bundle.main.path(forResource: filename, ofType: "cer")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: filePath))
        let certificate = SecCertificateCreateWithData(nil, data as CFData)!
        
        return certificate
    }
}

enum Router: URLRequestConvertible {
    case users
    
    static let baseURLString = "https://api.stackexchange.com/2.2"
    
    func asURLRequest() throws -> URLRequest {
        let path: String
        switch self {
        case .users:
            path = "/users?order=desc&sort=reputation&site=stackoverflow"
        }
        
        let url = URL(string: Router.baseURLString + path)!
        return URLRequest(url: url)
    }
}

final class NetworkClient {
    
    let evaluators = [
        "api.stackexchange.com":
            PinnedCertificatesTrustEvaluator(certificates: [
                Certificates.stackExchange
            ])
    ]
    
    let session: Session
    
    // 2
    private init() {
        session = Session(
            serverTrustManager: ServerTrustManager(evaluators: evaluators)
        )
    }
    
    // MARK: - Static Definitions
    
    private static let shared = NetworkClient()
    
    static func request(_ convertible: URLRequestConvertible) -> DataRequest {
        return shared.session.request(convertible)
    }
}


