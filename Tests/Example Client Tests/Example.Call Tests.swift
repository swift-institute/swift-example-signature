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
    func `a leaf call round trips through its derived prism`() {
        let call = Example.Counter.Call.increment(limit: .init(7))

        let increment = Example.Counter.Call.prisms.increment.match(call)
        #expect(increment.right?.input == .init(7))
        let greet = Example.Greeting.Call.prisms.greet.match(.greet(.init("Ada")))
        #expect(greet.right?.input == .init("Ada"))
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
    func `the root call embeds each leaf and matches only its own case`() {
        let counterIsCounter = Example.Call.prisms.counter.matches(.counter(.increment(limit: .init(3))))
        let counterIsGreeting = Example.Call.prisms.greeting.matches(.counter(.increment(limit: .init(3))))
        let greetingIsGreeting = Example.Call.prisms.greeting.matches(.greeting(.greet(.init("Ada"))))
        let greetingIsCounter = Example.Call.prisms.counter.matches(.greeting(.greet(.init("Ada"))))

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
