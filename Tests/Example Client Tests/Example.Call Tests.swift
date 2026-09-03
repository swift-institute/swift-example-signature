import Example
import Example_Client
import Example_Counter
import Example_Counter_Client
import Example_Greeting
import Example_Greeting_Client
import Optic
import Testing

@Suite
struct `Example.Call Tests` {

    @Test
    func `a leaf call round trips through its derived prism`() {
        let call = Example.Counter.Call.increment(limit: .init(7))

        switch Example.Counter.Call.prisms.increment.match(call) {
        case .right(let application):
            #expect(application.input == .init(7))
        case .left:
            Issue.record("expected the increment prism to match")
        }
        switch Example.Greeting.Call.prisms.greet.match(.greet(.init("Ada"))) {
        case .right(let application):
            #expect(application.input == .init("Ada"))
        case .left:
            Issue.record("expected the greet prism to match")
        }
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
        let counter = Example.Call.counter(.increment(limit: .init(3)))
        let greeting = Example.Call.greeting(.greet(.init("Ada")))

        #expect(Example.Call.prisms.counter.matches(counter))
        #expect(!Example.Call.prisms.greeting.matches(counter))
        #expect(Example.Call.prisms.greeting.matches(greeting))
        #expect(!Example.Call.prisms.counter.matches(greeting))
    }

    @Test
    func `the root eliminator is exhaustive over both subdomains`() {
        let eliminate = Example.Call.Eliminator<String>(
            greeting: { _ in "greeting" },
            counter: { _ in "counter" }
        )

        #expect(eliminate(.greeting(.greet(.init("Ada")))) == "greeting")
        #expect(eliminate(.counter(.increment(limit: .init(2)))) == "counter")
    }
}
