
function SVDModelTDM(A::Array{Float64,2})
    nq=30
    D=A[:,nq+1:1063]
    Q=A[:,1:nq]
    #println("Provide the Test data /filename:")
    #path=GetPath()
    T=PrepTest()
    #Now calculate the cos(theta), for all the queries-documents combination
    #Loop for all the queries and find the cosine of the angle.
    (md,nd)=size(D)
    (mq,nq)=size(Q)
    Costheta_SVD=zeros(nq,nd)
    #Set a tol level
    tol=linspace(0.01,0.99,20)
    lt=length(tol)
    D_r=zeros(nq,lt)
    D_t=zeros(nq,lt)
    N_r=zeros(nq,lt)
    Prec_SVD=zeros(nq,lt)
    Reca_SVD=zeros(nq,lt)
    tempArray=Array{Int,1}
    #Normalize D and Q
    Dt=sqrt(diag(D'*D))
    D_norm=D/(diagm(Dt))
    Qt=sqrt(diag(Q'*Q))
    Q_norm=Q/(diagm(Qt))
    (U1,S1,V1)=svd(D_norm)
    U=U1[:,1:100]
    S=diagm(S1[1:100])
    Vt=V1'
    V=Vt[1:100,:]
    DS=S*V
    KS=U
    qindex=zeros(nq)
    for z=1:1:nq
        #println("Z=",z)
        qindex[z]=z
        q=KS'*Q_norm[:,z]
        for i=1:nd
            Costheta_SVD[z:z,i:i]=q'*DS[:,i]/(norm(q,2)*norm(DS[:,i],2))
        end
        #println("OK")
        for k=1:1:lt
            function testf1(x)
                x>tol[k]
            end
            #println(Costheta_SVD)
            ii=find(testf1,Costheta_SVD[z:z,:])
            function testf2(x)
                x==z
            end
            b=find(testf2,T[:,1])
            D_r[z,k]=length(intersect(ii,T[b,2]))
            D_t[z,k]=length(ii)
            N_r[z,k]=length(b)
            Prec_SVD[z,k] = (D_r[z,k]/D_t[z,k])*100;
            Reca_SVD[z,k] = (D_r[z,k]/N_r[z,k])*100;
        end
    end
    (RFinal,PFinal)=average_RecPrec(Reca_SVD,Prec_SVD,qindex)
    return RFinal,PFinal
end


function SVDModelCorpus(A::Array{Float64,2})
    
end



function SVDModelQueries(qNum::Int64,A::Array{Float64,2})
    T=PrepTest()
    D=A[:,31:1063]
    Q=A[:,qNum]
    (md,nd)=size(D)
    nq=size(Q)
    println(nd)
    Costheta=zeros(1,nd)
    #Set a tol level
    tol=linspace(0.01,0.99,20)
    lt=length(tol)
    D_r=zeros(1,lt)
    D_t=zeros(1,lt)
    N_r=zeros(1,lt)
    tempArray=Array{Int,1}
    #qindex=zeros(1)
    z=qNum    
    #qindex[z]=z
    println("z=",z)
    Dt=sqrt(diag(D'*D))
    D_norm=D/(diagm(Dt))
    Qt=sqrt(diag(Q'*Q))
    Q_norm=Q/(diagm(Qt))
    (U1,S1,V1)=svd(D_norm)
    U=U1[:,1:100]
    S=diagm(S1[1:100])
    Vt=V1'
    V=Vt[1:100,:]
    DS=S*V
    KS=U
    qindex=zeros(nq)
    q=KS'*Q_norm[:,z]
    for i=1:nd
        Costheta_SVD[z:z,i:i]=q'*DS[:,i]/(norm(q,2)*norm(DS[:,i],2))
    end
    for k=1:1:lt
        function testf1(x)
            x>tol[k]
        end
        ii=find(testf1,Costheta[1:1,:])
        function testf2(x)
            x==z
        end
        b=find(testf2,T[:,1])
        D_r[1,k]=length(intersect(ii,T[b,2]))
        D_t[1,k]=length(ii)
        N_r[1,k]=length(b)
        Prec_SVD[z,k] = (D_r[z,k]/D_t[z,k])*100;
        Reca_SVD[z,k] = (D_r[z,k]/N_r[z,k])*100;
    end
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
