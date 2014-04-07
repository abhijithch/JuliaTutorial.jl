function update_Rec(rec,prec)
    j=0
    i=0
    #this might be better than initialising vectors re and pr, as zeros(length(re))
    re=Array{Float64,1}
    pr=Array{Float64,1}
    re_temp=Array{Float64,1}
    pr_temp=Array{Float64,1}
    while i<length(rec)
        i=i+1
        j=j+1
        if i<length(rec) && rec[i+1]<=rec[i] 
            #Function to find 
            function testf3(x)
                x==rec[i]
            end
            ii=find(testf3,rec)
            re_temp=vcat(re_temp,rec[i])
            pr_temp=vcat(pr_temp,sum(prec[ii])/length(ii))
            i=i+length(ii)-1
        else
            re_temp=vcat(re_temp,rec[i])
            pr_temp=vcat(pr_temp,prec[i])
        end
    end
    #The tyoe returned is Array{Any,1}
    re=reverse(re_temp[2:length(re_temp)])
    pr=reverse(pr_temp[2:length(pr_temp)])
    re=convert(Array{Float64,1},re)
    pr=convert(Array{Float64,1},pr)
    return re,pr
end

#This function is used to calculate the average Recall-Precision
#

function average_RecPrec(rec1::Array{Float64,2},prec1::Array{Float64,2},kind)
    recall_Final=[5:5:90]  #Recall levels for average
    precision_Final=zeros(length(recall_Final))
    pri=zeros(length(recall_Final),length(kind))
    for j=1:length(kind)
        kk=kind[j]
        rect=Array{Float64,1}
        prect=Array{Float64,1}
        (rect,prect)=update_Rec(rec1[kk,:],prec1[kk,:])     #Modify recall
        iy=InterpIrregular(rect,prect,BCnan,InterpLinear)
        for r=1:length(recall_Final)
            pri[r,j]=iy[recall_Final[r]]
        end
    end
    for i=1:length(recall_Final)
        function testf4(x)
            x>0
        end
        jj=find(testf4,pri[i,:])
        println(jj)
        if length(jj) == 0
            precision_Final[i]=NaN
        else
            precision_Final[i]=sum(pri[i,jj])/length(jj)
        end
    end
    #plot_PR(recall_Final,precision_Final)
    return recall_Final,precision_Final
end
