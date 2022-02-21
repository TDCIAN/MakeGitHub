import Foundation
import RxSwift

print("---- Just ----")
Observable<Int>.just(9)
    .subscribe(onNext: {
        print("Just: \($0)")
    })

print("---- Of 1 ----")
Observable<Int>.of(1, 2, 3, 4, 5)
    .subscribe(onNext: {
        print("Of 1: \($0)")
    })

print("---- Of 2 ----")
Observable.of([1, 2, 3, 4, 5])
    .subscribe(onNext: {
        print("Of 2: \($0)")
    })

print("---- From ----") // From은 Array만 받는다
Observable.from([1, 2, 3, 4, 5])
    .subscribe(onNext: {
        print("From: \($0)")
    })

print("---- Subscribe 1 ----")
Observable.of(1, 2, 3)
    .subscribe {
        print("Subscribe 1: \($0)")
    }

print("---- Subscribe 2 ----")
Observable.of(1, 2, 3)
    .subscribe {
        if let element = $0.element {
            print("Subscribe 2: \(element)")
        }
    }

print("---- Subscribe 3 ----")
Observable.of(1, 2, 3)
    .subscribe(onNext: {
        print("Subscribe 3: \($0)")
    })

print("---- Empty ----")
Observable<Void>.empty()
    .subscribe {
        print("Emptry: \($0)")
    }

print("---- Never ----")
Observable<Void>.never()
    .debug("never")
    .subscribe(onNext: {
        print("Never - onNext: \($0)")
    }, onCompleted: {
        print("Never - onCompleted")
    })