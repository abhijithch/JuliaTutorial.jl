
type Results
    Dr::Array{Float64,2}
    Dt::Array{Float64,2}
    Nr::Array{Float64,2}
    Rec::Array{Float64,2}
    Prec::Array{Float64,2}
    RecFinal::Array{Float64,1}
    PrecFinal::Array{Float64,1}    
    Results()=new()
end

type DataCorpus
    D_C::Corpus
    Q_C::Corpus
    DataCorpus()=new()
end

type DataMatrix
    A::Array{Float64,2}
    NumQueries::Int64
    DataMatrix()=new()
end

function DocQuerySpace(A::Array{Float64,2},k::Int64)
    (U1,S1,V1)=svd(A)
    U=U1[:,1:k]
    S=diagm(S1[1:k])
    Vt=V1'
    V=Vt[1:k,:]
    return S*V,U
end

function Normalize(A::Array{Float64,2})
    At=sqrt(diag(A'*A))
    A_norm=A/(diagm(At))
    return A_norm
end

function CosTheta(q::Array{Float64,1},d::Array{Float64,1})
    return q'*d/(norm(q,2)*norm(d,2))
end

T=PrepTest()

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

function SVDModel(A::Array{Float64,2},nq::Int64,rank::Int64)
    DQ=DataMatrix()
    DQ.A=A
    DQ.NumQueries=nq
    (ma,na)=size(DQ.A)
    D=DQ.A[:,DQ.NumQueries+1:na]
    Q=DQ.A[:,1:DQ.NumQueries]
    (md,nd)=size(D)
    (mq,nq)=size(Q)
    Costheta_SVD=zeros(nq,nd)
    #Set a tol level
    tol=linspace(0.01,0.99,20)
    lt=length(tol)
    LSI_TDM_Result=Results()
    #LSI_TDM_Result.Dr=zeros(nq,lt)
    #LSI_TDM_Result.Dt=zeros(nq,lt)
    #LSI_TDM_Result.Nr=zeros(nq,lt)
    #LSI_TDM_Result.Rec=zeros(nq,lt)
    #LSI_TDM_Result.Prec=zeros(nq,lt)
    #LSI_TDM_Result.RecFinal=zeros(lt)
    #LSI_TDM_Result.PrecFinal=zeros(lt)
    LSI_TDM_Result=InitResults!(LSI_TDM_Result,nq,lt)
    #Normalize D and Q
    D_norm=Normalize(D)
    Q_norm=Normalize(Q)
    DS,QS=DocQuerySpace(D_norm,rank)    
    qindex=zeros(nq)
    for z=1:1:nq
        #println("Z=",z)
        qindex[z]=z
        q=QS'*Q_norm[:,z]
        for i=1:nd
            Costheta_SVD[z:z,i:i]=CosTheta(q,DS[:,i])
        end
        for k=1:1:lt
            (LSI_TDM_Result.Dr[z,k],
             LSI_TDM_Result.Dt[z,k],
             LSI_TDM_Result.Nr[z,k],
             LSI_TDM_Result.Rec[z,k],
             LSI_TDM_Result.Prec[z,k])=
             FindResults(k,z,Costheta_SVD[z,:],tol[k])
        end
    end
    (LSI_TDM_Result.RecFinal,LSI_TDM_Result.PrecFinal)=average_RecPrec(LSI_TDM_Result.Rec,LSI_TDM_Result.Prec,qindex)
    return LSI_TDM_Result.RecFinal,LSI_TDM_Result.PrecFinal
    #plotNew_RecPrec(LSI_TDM_Result.RecFinal,LSI_TDM_Result.PrecFinal,"LSI")
end

function SVDModel(Q_C::Corpus,D_C::Corpus,rank::Int64)
    #Q_c and D_c are the query and Document corpuses.
    PreProcess!(Q_C)
    PreProcess!(D_C)
    #Compulsory update the lexicon, to identify the keywords
    update_lexicon!(Q_C)
    update_lexicon!(D_C)
    #Get the lexicon of the documents.
    DocLex=lexicon(D_C)
    #Cant use the above as query vectors since, the queries must also be wrt
    #Documents lexicon, and hence the dimensions will match
    D=full(tdm(D_C))
    (md,nd)=size(D)
    nq=length(Q_C.documents)
    Q=zeros(md,nq)
    for j=1:nq
        Q[:,j]=dtv(Q_C.documents[j],DocLex)'
    end
    QD=[Q D]
    r=SVDModel(QD,nq,rank)
    return r
end

function SVDModel(QueryNum::Int64,A::Array{Float64,2},NumQueries::Int64,rank::Int64)
    DQ=DataMatrix()
    DQ.A=A
    DQ.NumQueries=NumQueries
    (ma,na)=size(DQ.A)
    D=DQ.A[:,DQ.NumQueries+1:1063]
    Q=DQ.A[:,QueryNum]
    Qt=Q'   
    (nq,mq)=size(Qt)
    (md,nd)=size(D)
    Costheta_SVD=zeros(nq,nd)
    #Set a tol level
    tol=linspace(0.01,0.99,20)
    lt=length(tol)
    LSI_1Query_Result=Results()
    LSI_1Query_Result=InitResults!(LSI_1Query_Result,nq,lt)
    D_norm=Normalize(D)
    Q_norm=Normalize(Qt')
    DS,QS=DocQuerySpace(D_norm,rank)
    qindex=zeros(nq)
    for z=1:1:nq
        qindex[z]=z
        q=QS'*Q_norm[:,z]
        for i=1:nd
            Costheta_SVD[z:z,i:i]=q'*DS[:,i]/(norm(q,2)*norm(DS[:,i],2))
        end
        for k=1:1:lt
            (LSI_1Query_Result.Dr[z,k],
             LSI_1Query_Result.Dt[z,k],
             LSI_1Query_Result.Nr[z,k],
             LSI_1Query_Result.Rec[z,k],
             LSI_1Query_Result.Prec[z,k])=
            FindResults(k,z,Costheta_SVD[z,:],tol[k])
        end
    end
    (LSI_1Query_Result.RecFinal,LSI_1Query_Result.PrecFinal)=average_RecPrec(LSI_1Query_Result.Rec,LSI_1Query_Result.Prec,qindex)
    return LSI_1Query_Result
    #plotNew_RecPrec(vec(LSI_1Query_Result.Rec),vec(LSI_1Query_Result.Prec),"LSI")
end


function TrySVD(A::Array{Float64,2},k::Int64)
    (U,S,V)=svd(A)
    A_k::Array{Float64,2}
    V_t=diagm(S)*V'
    A_k=U[:,1:k]*V_t[1:k,:]
    #Check the Frobenius norm Between A and A_k
    #FN=vec_norm(A-A_k)
    FN=norm(A-A_k)
    return FN
end
