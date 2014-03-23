module TextMining

using Clustering 
using TextAnalysis
using MAT
using Grid
using PyPlot

#println("You have decided to learn Text Mining using Julia. Please refer the Julia_TextMining.pdf")

#println("Let us create a corpus of documents. Use the function:")
#println("PrepDocCorpus(dirname::String,DocType::Type)")
#println("Where dirname is the directory where the documents reside and DocType must be either StringDocument, TokenDocument or NGramDocument.")

include("AverageRP.jl")
include("LSIModel.jl")
include("Preparation.jl")
include("utils.jl")
include("KMeansModel.jl")
include("PlotResults.jl")
include("VecSpaceModel.jl")

end