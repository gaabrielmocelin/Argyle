//
//  URLSession.swift
//  Argyle
//
//  Created by Gabriel Mocelin on 07/02/23.
//

import Foundation

protocol URLSessionFactory {
    func dataTask(with: URLRequest, completionHandler: (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

//URLSession().dat
//
//extension URLSession: URLSessionFactory { }

//
//public final class URLSessionMock : URLSession {
//
//  var url: NSURL?
//  var request: NSURLRequest?
//  private let dataTaskMock: URLSessionDataTaskMock
//
//  public init(data: NSData?, response: NSURLResponse?, error: NSError?) {
//    dataTaskMock = URLSessionDataTaskMock()
//    dataTaskMock.taskResponse = (data, response, error)
//  }
//
//  public func dataTaskWithURL(url: NSURL,
//    completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
//      self.url = url
//      self.dataTaskMock.completionHandler = completionHandler
//      return self.dataTaskMock
//  }
//
//  public func dataTaskWithRequest(request: NSURLRequest,
//    completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
//      self.request = request
//      self.dataTaskMock.completionHandler = completionHandler
//      return self.dataTaskMock
//  }
//
//  final private class URLSessionDataTaskMock : NSURLSessionDataTask {
//
//    typealias CompletionHandler = (NSData!, NSURLResponse!, NSError!) -> Void
//    var completionHandler: CompletionHandler?
//    var taskResponse: (NSData?, NSURLResponse?, NSError?)?
//
//    override func resume() {
//      completionHandler?(taskResponse?.0, taskResponse?.1, taskResponse?.2)
//    }
//  }
//}
