# JuliaTutorial

[![Build Status](https://travis-ci.org/abhijithch/JuliaTutorial.jl.png)](https://travis-ci.org/abhi123link/JuliaTutorial.jl)

This is a Julia based tutorial covering the following topics:

* Introduction to Linear Algebra
* Applications of Matrix Factorizations
* Introduction to Text Mining 
* Introduction to Recommender Systems

This package has each of the above mentioned topics as sub-modules. However as of now only Text Mining tutorial is available, and the rest are under construction. 

### Installation
This is an unregistered package, and can be installed in either of the following two ways:

```
Pkg.clone("https://github.com/abhijithch/JuliaTutorial.jl.git")
```
alternatively, this also could be directly cloned from github as follows,
```
git clone https://github.com/abhijithch/JuliaTutorial.jl.git
```
in which case the dependent packages will have to be installed. If installed through the package manager, ```Pkg.clone()``` the dependent packages would be automatically installed. 

### Usage
To start using the package, first do ```using JuliaTutorial```. Then according to the options given, include the sub-modules by ```using JuliaTutorial.TextMining``` to enable all the functions of Text Mining tutorial. 

## Text Mining


Please refer to docs/Julia_TextMining.pdf for the theoretical concepts. This Text Mining module depends on ```TextAnalysis.jl```, for most of the preprocessing and preparation of the Term Document Matrix. 

### Preparation

The first thing to do is generate a corpus from collection of textual data. In this module we work with documents as the source of textual data. These documents could be collection of research articles, HTML files etc, and the function ```PrepDocCorpus(dirname::String,DocType::Type)``` prepares a corpus, i.e., collection of all the documents under one entity. It also standardizes all the documents to a singly type, specified by ```DocType```. The types could be any of ```StringDocument```, ```TokenDocument``` or ```NGramDocument```.

The query corpus are to be obtained using the function, ```PrepQueriesCorpus(NoQueries::Int,QueryFile::String)```. The ```NoQueries``` number of queries are stored in a single text file, ```QueryFile```. Each queries are delimited by 2 blank lines. 

The ```PreProcess!(crps::Corpus)``` function does all the preprocessing like removal of articles, pronouns, prepositions and stop words.

The functions ```dtm``` or the ```tdm``` from the ```TextAnalysis``` package are used to generate the TDM(Term Document Matrix). All the models end up factoring this TDM.

### Query Matching

The proximity measure used is the cosine measure, the function ```CosTheta(q::Array{Float64,1},d::Array{Float64,1})```, returns the cosine of the angle between the query vector ```q``` and the document vector ```d```.

### Performance Modeling

Like in any information retrieval tasks, *Recall*, ```R``` and *Precision*, ```P``` model the performance. ```R=Dr/Nr```, where ```Dr``` is the number of relevant documents retrieved and ```Nr``` is the total number of relevant documents in the database, ```P=Dr/Dt``` where ```Dt``` is the total number of documents retrieved. The function ```PrepTest()``` prepares the test matrix, which is human verified list of the relevant documents for the correspoding queries. 

### VSM - Vector Space Model

This is the basic model in which the column vecotrs of the TDM constitute the Document space, of dimension equal to number of terms(keywords). A new query will also be another vector in the same space, and in the VSM model we just find the cosine similarity between the query and all the documents. A tolerance value decides the number of documents which will be returned. The performance analysis is done for various tolerance levels. 

The VSM can be tested using the function ```VSMModel()``` with constrained parmeters types. The method ```VSMModel(A::Array{Float64,2},nq::Int64)``` gives the *Precision* and *Recall* for ```nq``` queries which form the first ```nq``` columns of the ```A``` matrix. The Documents are the remaining column vectors of ```A```. 

The method ```VSMModel(Q_C::Corpus,D_C::Corpus)``` forms the TDM from the Query and Document corpus, and gives the average *Recall* and *Precision*.

The Method ```VSMModel(QueryNum::Int64,A::Array{Float64,2},nq::Int64)``` give the *Recall* and *Precision* for a single query identified by ```QueryNum```.


### Latent Semantic Indexing Model

The LSI model finds the SVD of the Term Document Matrix, and decomposes the same into *Document Space* and *Query Space*. The method ```SVDModel(A::Array{Float64,2},nq::Int64,rank::Int64)``` uses the reduced rank approximation, and returns the average *Recall* and *Precision*. The methods ```SVDModel(Q_C::Corpus,D_C::Corpus,rank::Int64)``` does the same for the Query and Document corpus. The methods ```SVDModel(QueryNum::Int64,A::Array{Float64,2},NumQueries::Int64,rank::Int64)``` gives the *Recall*
and *Precision* for the single query ```QueryNum```.

### K-Means Model

Considering the Documents to be points in ```m``` dimensional space, documents with similar content tend to be closer to each other. Hence by clustering the documents into ```K``` clusters, with the *centroid* of each each clusters representing them. Hence all these ```k``` centroid vectors as a mtrix ```C``` represent the entire Document Space. But to obtain an orthonormal basis of this space, we do QR-Factorization of ```C```, represented by ```G```. Then by projecting the Document vectors and query vectors onto this space ```G```, we find the cosine measure between the query and all of the douments. 

The method ```KMeansModel(A::Array{Float64,2},NumQueries::Int64,NumClusters::Int64)``` gives the average *Recall* and *Precision* by using ```NumClusters```. The method ```KMeansModel(QueryNum::Int64,A::Array{Float64,2},NumQueries::Int64,Clusters::Int64)``` does the same for single query ```QueryNum```. The method ```KMeansModel(Q_C::Corpus,D_C::Corpus,Clusters::Int64)``` finds the *Recall* and *Precision* for the Query and Document Corpus ```Q_C``` and ```D_C```.

### Plotting Results

The function ```plot_DrDtNr(Dr::Array{Float64,1},Dt::Array{Float64,1},Nr::Array{Float64,1},qNum::Int64,tol::Array{Float64,1})``` can be used to plot the ```Dr```, ```Dt``` and ```Nr``` for a single query ```qNum``` against the tolerance levels specified by ```tol```.

The function ```plotNew_RecPrec(Rec::Array{Float64,1},Prec::Array{Float64,1},strMethod::String)``` must be used to plot the recall and precision. The ```strMethod``` specifies the model used, e.x, VSM or LSI etc. This function generates a new figure().

By using the function ```plotAdd_RecPrec(Rec::Array{Float64,1},Prec::Array{Float64,1},strMethod::String)``` a plot can be added to an already existing figure object. The plots automatically chooses different colors and corresponding legends are created. It supports upto 7 plots of the following colors, ```Colors=["red","blue","green","black","cyan","magenta","yellow"]```. In the ```PlotResults.jl```, new colors can be added to enable more plots. 



