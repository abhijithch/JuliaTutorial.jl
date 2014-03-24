#From TextAnalysis.jl Package.
function PrepCorpus(dirname::String,DocType::Type)
    # Recursive descent of directory
    # Add all non-hidden files to Corpus

    docs = {}

    function add_files(dirname::String)
        if !isdir(dirname)
            error("DirectoryCorpus() can only be called on directories")
        end

        starting_dir = pwd()

        cd(dirname)
        for filename in readdir(".")
            if isfile(filename) && !ismatch(r"^\.", filename)
                push!(docs, FileDocument(abspath(filename)))
            end
            if isdir(filename) && !islink(filename)
                add_files(filename)
            end
        end
        cd(starting_dir)
    end

    add_files(dirname)
    
    crps=Corpus(docs)
    
    standardize!(crps,DocType)
    return crps
    println(DocType)
    #return crps
end
