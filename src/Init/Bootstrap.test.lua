return function()
    local Bootstrap = require(script.Parent.Bootstrap)
    expect(Bootstrap).to.be.a("table")
    expect(Bootstrap.Init).to.be.a("function")
end
