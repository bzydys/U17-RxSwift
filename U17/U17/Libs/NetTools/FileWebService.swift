//
//  FileWebService.swift
//  Lark
//
//  Created by ZengFanyi on 2019/7/4.
//  Copyright © 2019 曾凡怡. All rights reserved.
//

import Moya
import SwiftyJSON
import Kingfisher
import CryptoSwift

enum FileWebService {
    case download(url: String, fileName: String?)
    
    var localLocation: URL {
        switch self {
        case .download(let url, let fileName):
            let fileKey: String = url.md5() // use url's md5 as local file name
            let directory: URL = FileSystem.downloadDirectory
            try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
            var filePath: URL = directory.appendingPathComponent(fileKey)
            if let name = fileName {
                // append path extension if exit
                let pathExtension: String = (name as NSString).pathExtension.lowercased()
                filePath = filePath.appendingPathExtension(pathExtension)
            }
            return filePath
        }
    }
    
    var downloadDestination: DownloadDestination {
        // `createIntermediateDirectories` will create directories in file path
        return { _, _ in return (self.localLocation, [.removePreviousFile, .createIntermediateDirectories]) }
    }
}

extension FileWebService: TargetType {
    var baseURL: URL {
        switch self {
        case .download(let url, _):
            return URL(string: url)!
        }
    }
    var path: String {
        switch self {
        case .download(_, _):
            return ""
        }
    }
    var method: Moya.Method {
        switch self {
        case .download(_, _):
            return .get
        }
    }
    var parameters: [String: Any]? {
        switch self {
        case .download:
            return nil
        }
    }
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    var task: Task {
        switch self {
        case .download(_, _):
            let destination: DownloadDestination = { _, _ in
                return (self.localLocation, [.removePreviousFile])
            }

            return .downloadDestination(destination)
        }
    }
    var sampleData: Data {
        return Data()
    }
    var headers: [String: String]? {
        return nil
    }
}

struct FileProvider {
    static let provider = MoyaProvider<FileWebService>(plugins: [NetworkLoggerPlugin(verbose: WebService.verbose)])
    
    static func request(target: FileWebService, progress: ProgressBlock?, completion: @escaping (WebService.Result) -> Void) -> Cancellable {
        return provider.request(target, progress: progress) { result in
            switch result {
            case let .success(response):
                let data = response.data
                if let json = try? JSON(data: data)  {
                    completion(.success(json))
                }else{
                    completion(.failure("download fail"))
                }
            case .failure(_):
                completion(.failure("download fail"))
            }
        }
    }
    
}

class WebService {
    
    // set false when release
    static var verbose: Bool = true
    
    // response result type
    enum Result {
        case success(JSON)
        case failure(String)
    }
}

class FileSystem {
    static let documentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.endIndex - 1]
    }()
    
    static let cacheDirectory: URL = {
        let urls = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        return urls[urls.endIndex - 1]
    }()
    
    static let downloadDirectory: URL = {
        let directory: URL = FileSystem.documentsDirectory.appendingPathComponent("Download/")
        return directory
    }()
    
}
