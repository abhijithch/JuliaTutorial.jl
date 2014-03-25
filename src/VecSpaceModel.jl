
#type Data
#    D_Corpus::Corpus
#    Q_Corpus::Corpus
#    DocLEx::Lexicon
#    D::
#    
#end

function VecSpaceModelCorp(Q_C::Corpus,D_C::Corpus)
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
    #prepare the test data
    T=PrepTest()
    #Now calculate the cos(theta), for all the queries-documents combination
    #Loop for all the queries and find the cosine of the angle.
    (md,nd)=size(D)
    nq=length(Q_C.documents)
    Q=zeros(md,nq)
    for j=1:nq
        Q[:,j]=dtv(Q_C.documents[j],DocLex)'
    end
    Costheta=zeros(nq,nd)
    #Set a tol level
    tol=linspace(0.01,0.99,20)
    lt=length(tol)
    D_r=zeros(nq,lt)
    D_t=zeros(nq,lt)
    N_r=zeros(nq,lt)
    Prec_VSM=zeros(nq,lt)
    Reca_VSM=zeros(nq,lt)
    tempArray=Array{Int,1}
    for z=1:nq
        tempArray=vcat(tempArray,z)
        #q=Q[:,z]
        for i=1:nd
            #    #Here we calculate the angle between the query and each of the 
            #    #1033 documensts. 
            temp_cos=Q[:,z]'*D[:,i]/(norm(Q[:,z],2)*norm(D[:,i],2))
            Costheta[z:z,i:i]=temp_cos
        end
        for k=1:1:lt
            function testf1(x)
                x>tol[k]
            end
            ii=find(testf1,Costheta[z:z,:])
            function testf2(x)
                x==z
            end
            b=find(testf2,T[:,1])
            D_r[z,k]=length(intersect(ii,T[b,2]))
            D_t[z,k]=length(ii)
            N_r[z,k]=length(b)
            Prec_VSM[z,k] = (D_r[z,k]/D_t[z,k])*100;
            Reca_VSM[z,k] = (D_r[z,k]/N_r[z,k])*100;
        end
    end
    qindex=tempArray[2:nq+1]
    (RFinal,PFinal)=average_RecPrec(Reca_VSM,Prec_VSM,qindex)
    #plotNew_RecPrec(RFinal,PFinal)
    return RFinal,PFinal
end

#The following function takes in the TermDocumentMatrix directly.
#The first n columns are queries and the remaining documents. 

function VecSpaceModelTDM(A::Array{Float64,2},nq::Int)
    D=A[:,nq+1:1063]
    Q=A[:,1:nq]
    T=PrepTest()
    #Now calculate the cos(theta), for all the queries-documents combination
    #Loop for all the queries and find the cosine of the angle.
    (md,nd)=size(D)
    (mq,nq)=size(Q)
    Costheta=zeros(nq,nd)
    #Set a tol level
    tol=linspace(0.01,0.99,20)
    lt=length(tol)
    D_r=zeros(nq,lt)
    D_t=zeros(nq,lt)
    N_r=zeros(nq,lt)
    Prec_VSM=zeros(nq,lt)
    Reca_VSM=zeros(nq,lt)
    tempArray=Array{Int,1}
    qindex=zeros(nq)
    for z=1:nq
        qindex[z]=z
        println("z=",z)
        for i=1:nd
            #    #Here we calculate the angle between the query and each of the 
            #    #1033 documensts. 
            Costheta[z:z,i:i]=Q[:,z]'*D[:,i]/(norm(Q[:,z],2)*norm(D[:,i],2))
        end
        for k=1:1:lt
            function testf1(x)
                x>tol[k]
            end
            ii=find(testf1,Costheta[z:z,:])
            function testf2(x)
                x==z
            end
            b=find(testf2,T[:,1])
            D_r[z,k]=length(intersect(ii,T[b,2]))
            D_t[z,k]=length(ii)
            N_r[z,k]=length(b)
            Prec_VSM[z,k] = (D_r[z,k]/D_t[z,k])*100;
            Reca_VSM[z,k] = (D_r[z,k]/N_r[z,k])*100;
        end
    end
    (RFinal,PFinal)=average_RecPrec(Reca_VSM,Prec_VSM,qindex)
    return RFinal,PFinal
end


function VecSpaceModelQueries(qNum::Int64,A::Array{Float64,2})
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
    for i=1:nd
        Costheta[1:1,i:i]=Q[:,1]'*D[:,i]/(norm(Q[:,1],2)*norm(D[:,i],2))
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
        #Prec_VSM[z,k] = (D_r[z,k]/D_t[z,k])*100;
        #Reca_VSM[z,k] = (D_r[z,k]/N_r[z,k])*100;
    end
    Dr= vec(D_r)
    Dt=vec(D_t)
    Nr=vec(N_r)
end