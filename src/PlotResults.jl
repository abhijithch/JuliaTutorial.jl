
function plot_DrDtNr(Dr::Array{Float64,1},Dt::Array{Float64,1},Nr::Array{Float64,1},qNum::Int64,tol::Array{Float64,1})
    fig = figure()
    p1=plot(tol,Dr,color="red",linewidth=2.0,linestyle="--")
    p2=plot(tol,Dt,color="blue",linewidth=2.0,linestyle="--")
    p3=plot(tol,Nr,color="green",linewidth=2.0,linestyle="--")
    axis("tight") # Fit the axis tightly to the plot
    ax = gca() # Get the handle of the current axis
    Title=string("Query",qNum)
    title(Title)
    xlabel("Tolerance")
    ylabel("No. of Documents")
    grid("on")
    #legend(loc="upper right",fancybox="true")
    legend([p1,p2,p3],["Dr","Dt","Nr"])
end

Colors=Array{String,1}
Colors=["red","blue","green","black","cyan","magenta","yellow"]
ColorCount=0
PlotCount=0


function plotNew_RecPrec(Rec::Array{Float64,1},Prec::Array{Float64,1},strMethod::String)
    fig = figure()
    global ColorCount+=1
    global PlotCount+=1
    p1=plot(Rec,Prec,color=Colors[ColorCount],linewidth=2.0,linestyle="--",label=strMethod)
    axis("tight") # Fit the axis tightly to the plot
    ax = gca() # Get the handle of the current axis
    Title=string("Precision Vs Recall")
    title(Title)
    xlabel("Recall")
    ylabel("Precision")
    grid("on")
    #push!(PlotIDs,string(PlotCount))
    #push!(MethodIDs,strMethod)
    legend(loc="upper right",fancybox="true")
end

function plotAdd_RecPrec(Rec::Array{Float64,1},Prec::Array{Float64,1},strMethod::String)
    global ColorCount+=1
    global PlotCount+=1
    PlotID=string("p",PlotCount)
    PlotID=plot(Rec,Prec,color=Colors[ColorCount],linewidth=2.0,linestyle="--",label=strMethod)
    #push!(PlotIDS,PlotID)
    #push!(MethodIDs,strMethod)
    #legend(PlotIDs,MethodIDs)
    legend(loc="upper right",fancybox="true")
end

