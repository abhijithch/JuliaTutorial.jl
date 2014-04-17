T=PrepTest()

function VSMModel(A::Array{Float64,2},nq::Int)
    DQ=NewDataMatrix()
    DQ.A=A
    DQ.NumQueries=nq
    (ma,na)=size(DQ.A)
    D=DQ.A[:,DQ.NumQueries+1:na]
    Q=DQ.A[:,1:DQ.NumQueries]
    (md,nd)=size(D)
    (mq,nq)=size(Q)
    Costheta_VSM=zeros(nq,nd)
    #Set a tol level
    tol=linspace(0.01,0.99,20)
    lt=length(tol)
    VSM_TDM_Result=TMResults()
    VSM_TDM_Result=InitResults!(VSM_TDM_Result,nq,lt)
    qindex=zeros(nq)
    for z=1:1:nq
        qindex[z]=z
        for i=1:nd
            Costheta_VSM[z:z,i:i]=CosTheta(Q[:,z],D[:,i])
        end
        for k=1:1:lt
            (VSM_TDM_Result.Dr[z,k],
             VSM_TDM_Result.Dt[z,k],
             VSM_TDM_Result.Nr[z,k],
             VSM_TDM_Result.Rec[z,k],
             VSM_TDM_Result.Prec[z,k])=
             FindResults(k,z,Costheta_VSM[z,:],tol[k])
        end
    end
    (VSM_TDM_Result.RecFinal,VSM_TDM_Result.PrecFinal)=average_RecPrec(VSM_TDM_Result.Rec,VSM_TDM_Result.Prec,qindex)
    return VSM_TDM_Result.RecFinal,VSM_TDM_Result.PrecFinal
end

function VSMModel(Q_C::Corpus,D_C::Corpus)
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
    r=VSMModel(QD,nq)
    return r
end

function VSMModel(QueryNum::Int,A::Array{Float64,2},NumQueries::Int)
    DQ=NewDataMatrix()
    DQ.A=A
    DQ.NumQueries=NumQueries
    (ma,na)=size(DQ.A)
    D=DQ.A[:,DQ.NumQueries+1:1063]
    Q=DQ.A[:,QueryNum]
    Qt=Q'   
    (nq,mq)=size(Qt)
    (md,nd)=size(D)
    Costheta_VSM=zeros(nq,nd)
    #Set a tol level
    tol=linspace(0.01,0.99,20)
    lt=length(tol)
    VSM_1Query_Result=TMResults()
    VSM_1Query_Result=InitResults!(VSM_1Query_Result,nq,lt)
    qindex=zeros(nq)
    for z=1:1:nq
        qindex[z]=z
        for i=1:nd
            Costheta_VSM[z:z,i:i]=CosTheta(Q[:,z],D[:,i])
        end
        for k=1:1:lt
            (VSM_1Query_Result.Dr[z,k],
             VSM_1Query_Result.Dt[z,k],
             VSM_1Query_Result.Nr[z,k],
             VSM_1Query_Result.Rec[z,k],
             VSM_1Query_Result.Prec[z,k])=
             FindResults(k,z,Costheta_VSM[z,:],tol[k])
        end
    end
    (VSM_1Query_Result.RecFinal,VSM_1Query_Result.PrecFinal)=average_RecPrec(VSM_1Query_Result.Rec,VSM_1Query_Result.Prec,qindex)
    return VSM_1Query_Result
end
