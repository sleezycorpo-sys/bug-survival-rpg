return function()
    local Init = require(script.Parent.Init)
    expect(Init).to.be.a("table")
    expect(Init.Start).to.be.a("function")
end
