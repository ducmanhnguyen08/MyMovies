//
//  Service.swift
//  MyMovies


import Foundation

public protocol Service {
    associatedtype output
    
    var request: Request { get }
    
    func execute(in dispatcher: Dispatcher, completionHandler: @escaping (output) -> (), failureBlock: @escaping (Int?) -> ())
}
