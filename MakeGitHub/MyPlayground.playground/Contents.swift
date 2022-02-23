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

print("---- range ----")
Observable.range(start: 1, count: 9)
    .subscribe(onNext: {
        print("range: 2*\($0)=\(2*$0)")
    })

print("---- dispose ----")
Observable.of(1, 2, 3)
    .subscribe {
        print("dispose: \($0)")
    }
    .dispose()

print("---- disposeBag ----")
let disposeBag = DisposeBag()

Observable.of(1, 2, 3)
    .subscribe {
        print("disposeBag: \($0)")
    }
    .disposed(by: disposeBag)

print("--- create 1 ----")
Observable<Int>.create { observer -> Disposable in
    observer.onNext(1)
    observer.onCompleted()
    observer.onNext(2)
    return Disposables.create()
}
.subscribe {
    print("create: \($0)")
}
.disposed(by: disposeBag)

print("---- create 2 ----")
enum MyError: Error {
    case anError
}

Observable<Int>.create { observer -> Disposable in
    observer.onNext(1)
    observer.onError(MyError.anError)
    observer.onCompleted()
    observer.onNext(2)
    return Disposables.create()
}
.subscribe(
    onNext: {
        print("onNext: \($0)")
    },
    onError: {
        print("onError: \($0.localizedDescription)")
    },
    onCompleted: {
        print("completed")
    },
    onDisposed: {
        print("disposed")
    }
)
.disposed(by: disposeBag)

print("---- deffered ----")
var flip: Bool = false

let factory: Observable<String> = Observable.deferred {
    flip = !flip
    
    if flip {
        return Observable.of("👆")
    } else {
        return Observable.of("👇")
    }
}

for _ in 0...3 {
    factory.subscribe(onNext: {
        print("deffered: \($0)")
    })
    .disposed(by: disposeBag)
}
