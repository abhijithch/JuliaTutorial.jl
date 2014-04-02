module TextMining

using Clustering 
using TextAnalysis
using MAT
using Grid
using PyPlot

export PrepQueriesCorpus,PrepDocCorpus,PreProcess!,PrepTest
export VecSpaceModelCorp,VecSpaceModelTDM,VecSpaceModelQueries
export SVDModel,TrySVD
export KMeansTDM
export plotNew_RecPrec,plotAdd_RecPrec

include("Preparation.jl")
include("VecSpaceModel.jl")
include("LSIModel.jl")
include("KMeansModel.jl")
include("AverageRP.jl")
include("PlotResults.jl")
include("utils.jl")

end