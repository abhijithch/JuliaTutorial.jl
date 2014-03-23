
function plot_DrDtNr(Dr::Array{Float64,1},Dt::Array{Float64,1},Nr::Array{Float64,1},qNum::Int64)
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

function plotNew_RecPrec(Rec::Array{Float64,1},Prec::Array{Float64,1},strMethod::String)
    fig = figure()
    ColorCount=1
    PlotCount=1
    p1=plot(Rec,Prec,color=Colors[ColorCount],linewidth=2.0,linestyle="--")
    axis("tight") # Fit the axis tightly to the plot
    ax = gca() # Get the handle of the current axis
    Title=string("Precision Vs Recall")
    title(Title)
    xlabel("Recall")
    ylabel("Precision")
    grid("on")
    #legend(loc="upper right",fancybox="true")
    legend([p1],[string(strMethod)])
end

function plotAdd_RecPrec{Rec::Array{Float64,1},Prec::Array{Float64,1},strMethod::String}
    ColorCount++
    PlotID=string("p",PlotCount++)
    PlotID=plot(Rec,Prec,color=Colors[ColorCount],linewidth=2.0,linestyle="--")
    legend([PlotID],[string(strMethod)])
end