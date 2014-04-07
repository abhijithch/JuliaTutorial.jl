module TextMining

using Clustering 
using TextAnalysis
using MAT
using Grid
using PyPlot

export PrepQueriesCorpus,PrepDocCorpus,PreProcess!,PrepTest
export SVDModel,VSMModel,TrySVD
export KMeansTDM
export plotNew_RecPrec,plotAdd_RecPrec,plot_DrDtNr
export Results, NewDataCorpus, NewDataMatrix, Normalize, CosTheta, FindResults

include("Preparation.jl")
include("utils.jl")
include("AverageRP.jl")
include("PlotResults.jl")
include("VecSpaceModel.jl")
include("LSIModel.jl")
include("KMeansModel.jl")

end