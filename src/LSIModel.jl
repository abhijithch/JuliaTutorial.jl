
function DocQuerySpace(A::Array{Float64,2},k::Int)
    (U1,S1,V1)=svd(A)
    U=U1[:,1:k]
    S=diagm(S1[1:k])
    Vt=V1'
    V=Vt[1:k,:]
    return S*V,U
end

T=PrepTest()

function SVDModel(A::Array{Float64,2},nq::Int,rank::Int)
    DQ=NewDataMatrix()
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
    LSI_TDM_Result=TMResults()
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

function SVDModel(Q_C::Corpus,D_C::Corpus,rank::Int)
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

function SVDModel(QueryNum::Int,A::Array{Float64,2},NumQueries::Int,rank::Int)
    DQ=NewDataMatrix()
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
    LSI_1Query_Result=TMResults()
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


function TrySVD(A::Array{Float64,2},k::Int)
    (U,S,V)=svd(A)
    A_k::Array{Float64,2}
    V_t=diagm(S)*V'
    A_k=U[:,1:k]*V_t[1:k,:]
    #Check the Frobenius norm Between A and A_k
    #FN=vec_norm(A-A_k)
    FN=norm(A-A_k)
    return FN
end
