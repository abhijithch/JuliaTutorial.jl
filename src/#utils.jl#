function GetPath()
    path=readlines(STDIN)
    return path
end

type TMResults
    Dr::Array{Float64,2}
    Dt::Array{Float64,2}
    Nr::Array{Float64,2}
    Rec::Array{Float64,2}
    Prec::Array{Float64,2}
    RecFinal::Array{Float64,1}
    PrecFinal::Array{Float64,1}    
    Results()=new()
end

type NewDataCorpus
    D_C::Corpus
    Q_C::Corpus
    NewDataCorpus()=new()
end

type NewDataMatrix
    A::Array{Float64,2}
    NumQueries::Int64
    NewDataMatrix()=new()
end

#Initializes the Results type with zeros
function InitResults!(R::Results,nq::Int64,lt::Int64)
    R.Dr=zeros(nq,lt)
    R.Dt=zeros(nq,lt)
    R.Nr=zeros(nq,lt)
    R.Rec=zeros(nq,lt)
    R.Prec=zeros(nq,lt)
    R.RecFinal=zeros(lt)
    R.PrecFinal=zeros(lt)
    return R
end

function Normalize(A::Array{Float64,2})
    At=sqrt(diag(A'*A))
    A_norm=A/(diagm(At))
    return A_norm
end

function CosTheta(q::Array{Float64,1},d::Array{Float64,1})
    return q'*d/(norm(q,2)*norm(d,2))
end

function FindResults(k::Int64,z::Int64,Costheta::Array{Float64,2},tol::Float64)
    function testf1(x)
        x>tol
    end
    ii=find(testf1,Costheta)
    function testf2(x)
        x==z
    end
    b=find(testf2,T[:,1])
    dr=length(intersect(ii,T[b,2]))
    dt=length(ii)
    nr=length(b)
    Reca = (dr/nr)*100
    Preca = (dr/dt)*100
    return dr,dt,nr,Reca,Preca
end
