using Documenter
using CSVtoDIC

makedocs(
    sitename = "CSVtoDIC",
    format = Documenter.HTML(),
    modules = [CSVtoDIC]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
#=deploydocs(
    repo = "<repository url>"
)=#

deploydocs(
    repo = "https://github.com/chenyhmitedu/CSVtoDIC.git"
)
