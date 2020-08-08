//
//  ServerManager.swift
//  Pyzap
//
//  Created by Mario Matheus on 08/08/20.
//  Copyright © 2020 Mario Code House. All rights reserved.
//

import Foundation

protocol ServerDelegate: class {
    func openCompleted()
    func errorOccurred()
    func received(message: ZapMessage)
}

class ServerManager: NSObject {

    static let shared = ServerManager()
    
    static let IP_HOST = "192.168.15.4"
    static let PORT = 9999
    
    weak var delegate: ServerDelegate?
    
    var inputStream: InputStream!
    var outputStream: OutputStream!
    
    let maxReadLenght = 2048
    
    private override init() {
        super.init()
    }
    
    func setupNetworkCommunication() {
        var readStream: Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        
        CFStreamCreatePairWithSocketToHost(
            kCFAllocatorDefault,
             ServerManager.IP_HOST as CFString,
            UInt32(ServerManager.PORT),
            &readStream,
            &writeStream
        )
        
        inputStream = readStream!.takeRetainedValue()
        outputStream = writeStream!.takeRetainedValue()
        inputStream.delegate = self
        
        inputStream.schedule(in: .current, forMode: .common)
        outputStream.schedule(in: .current, forMode: .common)
        
        inputStream.open()
        outputStream.open()
    }
    
    func send(_ data: Data) {
        _ = data.withUnsafeBytes {
            guard let pointer = $0.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
                print("Error")
                return
            }
            outputStream.write(pointer, maxLength: data.count)
        }
    }
    
    func stopChatSession() {
        inputStream.close()
        outputStream.close()
    }
    
}

extension ServerManager: StreamDelegate {
    
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case .hasBytesAvailable:
            readAvailableBytes(stream: aStream as! InputStream)
        case .endEncountered:
            stopChatSession()
        case .openCompleted:
            delegate?.openCompleted()
        case .errorOccurred:
            delegate?.errorOccurred()
        case .hasSpaceAvailable:
            print("has space available")
        default:
            print("some other event...")
        }
    }
    
    private func readAvailableBytes(stream: InputStream) {
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: maxReadLenght)
        
        while stream.hasBytesAvailable {
            let numberOfBytesRead = inputStream.read(buffer, maxLength: maxReadLenght)
            if numberOfBytesRead < 0, let error = stream.streamError {
                print(error)
                break
            }
            
            if let zapMessage = processedZapMessageData(buffer: buffer, length: numberOfBytesRead) {
                delegate?.received(message: zapMessage)
            }
        }
    }
    
    private func processedZapMessageData(buffer: UnsafeMutablePointer<UInt8>, length: Int) -> ZapMessage? {
        guard let textData = String(bytesNoCopy: buffer, length: length, encoding: .utf8, freeWhenDone: true)?.data(using: .utf8) else {
            return nil
        }
        do {
            return try JSONDecoder().decode(ZapMessage.self, from: textData)
        } catch {
            return nil
        }
        
    }
}
