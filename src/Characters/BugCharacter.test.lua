return function()
    local Bug = require(script.Parent.BugCharacter)
    local bug = Bug.New("Ant")
    expect(bug.Type).to.equal("Ant")
    expect(bug.Health).to.be.a("number")
end
