using Pkg; Pkg.add("Documenter")
using Documenter, ActivitySpace

makedocs(sitename="ActivitySpace.jl")

deploydocs(
    repo = "github.com/JohnPalmer/ActivitySpace.jl.git",
)
