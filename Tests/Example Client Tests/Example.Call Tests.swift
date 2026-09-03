import Example
import Example_Client
import Example_Counter
import Example_Counter_Client
import Example_Greeting
import Example_Greeting_Client
import Operation
import Optic
import Either
import Testing

@Suite
struct `Example.Call Tests` {

    @Test
    func `a leaf call is read through its derived fold`() {
        let call = Example.Counter.Call.increment(limit: .init(7))

        let increment = Example.Counter.Call.folds.increment.extract(call)
        #expect(increment?.input == .init(7))
        let greet = Example.Greeting.Call.folds.greet.extract(.greet(.init("Ada")))
        #expect(greet?.input == .init("Ada"))
    }

    @Test
    func `a leaf eliminator reaches its own branch`() {
        let eliminate = Example.Greeting.Call.Eliminator<String>(
            greet: { $0.input.underlying }
        )

        #expect(eliminate(.greet(.init("Ada"))) == "Ada")
    }

    @Test
    func `a leaf call carries its operation symbol`() {
        let _: Example.Greeting.Greet.Input.Type = Example.Greeting.Name.self
        let _: Example.Greeting.Greet.Output.Type = Example.Greeting.Message.self
        let _: Example.Greeting.Greet.Failure.Type = Swift.Never.self
        let _: Example.Counter.Increment.Input.Type = Example.Counter.Limit.self
        let _: Example.Counter.Increment.Output.Type = Example.Counter.Value.self
        let _: Example.Counter.Increment.Failure.Type = Example.Counter.Error.self
    }

    @Test
    func `the root call matches only its own case`() {
        let counterIsCounter = Example.Call.cases.counter.matches(.counter(.increment(limit: .init(3))))
        let counterIsGreeting = Example.Call.cases.greeting.matches(.counter(.increment(limit: .init(3))))
        let greetingIsGreeting = Example.Call.cases.greeting.matches(.greeting(.greet(.init("Ada"))))
        let greetingIsCounter = Example.Call.cases.counter.matches(.greeting(.greet(.init("Ada"))))

        #expect(counterIsCounter)
        #expect(!counterIsGreeting)
        #expect(greetingIsGreeting)
        #expect(!greetingIsCounter)
    }

    @Test
    func `the root eliminator is exhaustive over both subdomains`() {
        let eliminate = Example.Call.Eliminator<String>(
            greeting: { _ in "greeting" },
            counter: { _ in "counter" }
        )
        let greeting = eliminate(.greeting(.greet(.init("Ada"))))
        let counter = eliminate(.counter(.increment(limit: .init(2))))

        #expect(greeting == "greeting")
        #expect(counter == "counter")
    }
}
