
#Creates an array of string variables, from text file, where each doc is 
#separated by 2 blank  lines. Here we have 30 queries in a single text file
#MED1. 

function PrepQueriesCorpus(NoQueries::Int,QueryFile::String)
    f = open(QueryFile,"r+")
    cnt = 0
    DocCount = 1
    newDoc = true
    Queries = Array(Any,NoQueries)
    for line in eachline(f)        
        if length(line) != 1
            if newDoc == true
                Queries[DocCount] = line
                newDoc = false
            elseif newDoc == false
                Queries[DocCount] = join([Queries[DocCount],line]," ")
            end
        elseif length(line) == 1 
            cnt=cnt+1
            if cnt == 1
                #println("firstline")
            elseif cnt == 2
                cnt = 0
                DocCount = DocCount +1 
                newDoc = true
            end
        end
    end
    m=size(Queries)
    SDArr=Array{Any,1}
    for i=1:m[1]
        SDArr=vcat(SDArr,StringDocument(Queries[i]))
    end
    return Corpus(SDArr[2:m[1]+1])
end

#This function returns a standardized corpus,to the DocType parameter. 
#The documents in form of variousl text files are picked from location dirname.

function PrepDocCorpus(dirname::String,DocType::Type)
    crps = DirectoryCorpus(dirname)
    standardize!(crps,DocType)
    return crps
end


#This function does the pre-processing tasks from TextAnalysis.jl

function PreProcess!(crps::Corpus)#,words::Array{String})
    remove_articles!(crps)
    remove_indefinite_articles!(crps)
    remove_definite_articles!(crps)
    remove_pronouns!(crps)
    remove_prepositions!(crps)
    remove_stop_words!(crps)
    #remove_words!(crps,words)
end

#The following functions prepares the Test data

function PrepTest(path::ASCIIString)
    temp=readdlm(path,' ';has_header=false)
    T=hcat(temp[:,1],temp[:,4])
    return T
end

function PrepTest()
    temp=readdlm("./test/data/Test.txt",' ';has_header=false)
    T=hcat(temp[:,1],temp[:,4])
    return T
end

