
#K-means clustering of the documents

function KMeansTDM(A::Array{Float64,2})
    D=A[:,31:1063]
    Q=A[:,1:30]
    KM=kmeans(D,50)
    C=KM.centers
    (P,R)=qr(C)
    DS = P'*D #Using the P we find the projections of the documents 
    qindex=zeros(1,30)
    T=PrepTest()
    #Now calculate the cos(theta), for all the queries-documents combination
    #Loop for all the queries and find the cosine of the angle.
    (md,nd)=size(D)
    println(size(Q))
    (mq,nq)=size(Q)
    Costheta_KM=zeros(nq,nd)
    #Set a tol level
    tol=linspace(0.01,0.99,20)
    lt=length(tol)
    D_r=zeros(nq,lt)
    D_t=zeros(nq,lt)
    N_r=zeros(nq,lt)
    Prec_KM=zeros(nq,lt)
    Reca_KM=zeros(nq,lt)
    qindex=zeros(nq)
    for z=1:nq
        qindex[z]=z
        q=P'*Q[:,z]
        for i=1:nd
            #    #Here we calculate the angle between the query and each of the 
            #    #1033 documensts. 
            Costheta_KM[z:z,i:i]=q'*DS[:,i]/(norm(q,2)*norm(DS[:,i],2))
        end
        for k=1:1:lt
            function testf1(x)
                x>tol[k]
            end
            ii=find(testf1,Costheta_KM[z:z,:])
            function testf2(x)
                x==z
            end
            b=find(testf2,T[:,1])
            D_r[z,k]=length(intersect(ii,T[b,2]))
            D_t[z,k]=length(ii)
            N_r[z,k]=length(b)
            Prec_KM[z,k] = (D_r[z,k]/D_t[z,k])*100;
            Reca_KM[z,k] = (D_r[z,k]/N_r[z,k])*100;
        end
    end
    (RFinal,PFinal)=average_RecPrec(Reca_KM,Prec_KM,qindex)
    return RFinal,PFinal
end