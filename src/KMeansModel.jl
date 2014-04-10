T=PrepTest()

function KMeansModel(A::Array{Float64,2},NumQueries::Int64,Clusters::Int64)
    DQ=NewDataMatrix()
    DQ.A=A
    DQ.NumQueries=NumQueries
    (ma,na)=size(DQ.A)
    D=DQ.A[:,DQ.NumQueries+1:na]
    Q=DQ.A[:,1:NumQueries]
    KM=kmeans(D,Clusters)
    C=KM.centers
    (P,R)=qr(C)
    DS = P'*D #Using the P we find the projections of the documents
    (md,nd)=size(D)
    (mq,nq)=size(Q)
    Costheta_KM=zeros(nq,nd)
    #Set a tol level
    tol=linspace(0.01,0.99,20)
    lt=length(tol)
    KM_TDM_Result=Results()
    KM_TDM_Result=InitResults!(KM_TDM_Result,nq,lt)
    qindex=zeros(nq)
    for z=1:1:nq
        qindex[z]=z
        q=P'*Q[:,z]
        for i=1:nd
            Costheta_KM[z:z,i:i]=q'*DS[:,i]/(norm(q,2)*norm(DS[:,i],2))
        end
        for k=1:1:lt
            (KM_TDM_Result.Dr[z,k],
             KM_TDM_Result.Dt[z,k],
             KM_TDM_Result.Nr[z,k],
             KM_TDM_Result.Rec[z,k],
             KM_TDM_Result.Prec[z,k])=
             FindResults(k,z,Costheta_KM[z,:],tol[k])
        end
    end
    (KM_TDM_Result.RecFinal,KM_TDM_Result.PrecFinal)=average_RecPrec(KM_TDM_Result.Rec,KM_TDM_Result.Prec,qindex)
    return KM_TDM_Result
end

function KMeansModel(QueryNum::Int64,A::Array{Float64,2},NumQueries::Int64,Clusters::Int64)
    DQ=NewDataMatrix()
    DQ.A=A
    DQ.NumQueries=NumQueries
    (ma,na)=size(DQ.A)
    D=DQ.A[:,DQ.NumQueries+1:1063]
    Q=DQ.A[:,QueryNum]
    KM=kmeans(D,50)
    C=KM.centers
    (P,R)=qr(C)
    DS = P'*D #Using the P we find the projections of the documents
    (md,nd)=size(D)
    (mq,nq)=size(Q)
    Costheta_KM=zeros(nq,nd)
    #Set a tol level
    tol=linspace(0.01,0.99,20)
    lt=length(tol)
    KM_1Query_Result=Results()
    KM_1Query_Result=InitResults!(KM_TDM_Result,nq,lt)
    qindex=zeros(nq)
    for z=1:1:nq
        qindex[z]=z
        q=P'*Q[:,z]
        for i=1:nd
            Costheta_KM[z:z,i:i]=q'*DS[:,i]/(norm(q,2)*norm(DS[:,i],2))
        end
        for k=1:1:lt
            (KM_1Query_Result.Dr[z,k],
             KM_1Query_Result.Dt[z,k],
             KM_1Query_Result.Nr[z,k],
             KM_1Query_Result.Rec[z,k],
             KM_1Query_Result.Prec[z,k])=
             FindResults(k,z,Costheta_KM[z,:],tol[k])
        end
    end
    (KM_1Query_Result.RecFinal,KM_1Query_Result.PrecFinal)=average_RecPrec(KM_1Query_Result.Rec,KM_1Query_Result.Prec,qindex)
    return KM_1Query_Result
end

function KMeansModel(Q_C::Corpus,D_C::Corpus,Clusters::Int64)
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
    r=KmeansModel(QD,nq,Clusters)
    return r
end